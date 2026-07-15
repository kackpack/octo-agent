package agent

import "fmt"

// hotToolResults is how many of the most recent tool_result blocks reclamation
// keeps inline verbatim. Older results are candidates for eliding — the model
// rarely needs the raw bytes of a tool call it made many steps ago.
const hotToolResults = 6

// staleToolResultMinBytes is the size below which a stale tool_result is left
// alone: small results aren't worth the cache cost of a rewrite.
const staleToolResultMinBytes = 4_000

// reclaimStaleToolResults records collapsed placeholders for old, large tool_result
// blocks in the History's Collapser, freeing context without an LLM call. This is
// the cheap tier that shrinks a single huge agentic turn — the case the summarize
// path deliberately skips (one user turn holding ~150k of tool output can't be
// folded on a user-turn boundary, but its stale tool results can be elided in
// place).
//
// The most recent hotToolResults tool results are kept inline verbatim; older ones
// whose Result exceeds staleToolResultMinBytes are recorded as collapsed entries
// in the Collapser, preserving the tool_use pairing (ToolUseID/IsError) so the wire
// structure stays valid. The elided originals are regenerable by re-running the
// tool — the placeholder says so, mirroring the write-time microCompact backstop.
//
// Returns the estimated tokens reclaimed (0 if nothing changed). Unlike the old
// implementation, this no longer calls History.ReplaceAll — collapsed results stay
// in the live history and are projected at read time by History.Snapshot(), keeping
// the provider's prompt cache prefix intact.
func (a *Agent) reclaimStaleToolResults() int {
	msgs := a.History.Snapshot()

	names := map[string]string{}
	type loc struct{ mi, bi int }
	var locs []loc
	for mi := range msgs {
		for bi, b := range msgs[mi].Blocks {
			switch b.Type {
			case "tool_use":
				names[b.ID] = b.Name
			case "tool_result":
				locs = append(locs, loc{mi, bi})
			}
		}
	}
	if len(locs) <= hotToolResults {
		return 0
	}

	reclaimed := 0
	for _, l := range locs[:len(locs)-hotToolResults] {
		b := msgs[l.mi].Blocks[l.bi]
		if len(b.Result) < staleToolResultMinBytes {
			continue
		}
		name := names[b.ToolUseID]
		if name == "" {
			name = "tool"
		}
		freed := estimateText(b.Result)
		placeholder := fmt.Sprintf(
			"[%d bytes elided by octo to save context — earlier %s result; re-run the tool to view it again]",
			len(b.Result), name)
		a.History.collapser.set(l.mi, l.bi, placeholder)
		reclaimed += freed - estimateText(placeholder)
	}
	if reclaimed <= 0 {
		return 0
	}
	return reclaimed
}
