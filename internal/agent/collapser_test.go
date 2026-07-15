package agent

import (
	"strings"
	"testing"
)

func TestCollapser_ProjectReturnsPlaceholder(t *testing.T) {
	var c Collapser
	c.set(0, 1, "[elided]")
	msgs := []Message{{
		Role: RoleUser,
		Blocks: []ContentBlock{
			{Type: "tool_use", ID: "id1", Name: "grep"},
			{Type: "tool_result", ToolUseID: "id1", Result: strings.Repeat("a", 5000)},
		},
	}}
	c.project(msgs)
	if msgs[0].Blocks[1].Result != "[elided]" {
		t.Errorf("expected placeholder, got %q", msgs[0].Blocks[1].Result)
	}
}

func TestCollapser_ProjectLeavesUncollapsedAlone(t *testing.T) {
	var c Collapser
	msgs := []Message{{
		Role:   RoleUser,
		Blocks: []ContentBlock{{Type: "tool_result", Result: "keep me"}},
	}}
	c.project(msgs)
	if msgs[0].Blocks[0].Result != "keep me" {
		t.Error("uncollapsed block was modified")
	}
}

func TestCollapser_ClearRemovesAll(t *testing.T) {
	var c Collapser
	c.set(0, 0, "x")
	c.set(1, 2, "y")
	c.clear()
	if c.len() != 0 {
		t.Errorf("expected 0 after clear, got %d", c.len())
	}
}

func TestCollapser_RemoveRemovesMessageEntries(t *testing.T) {
	var c Collapser
	c.set(0, 0, "a")
	c.set(0, 1, "b")
	c.set(1, 0, "c")
	c.remove(0)
	if c.len() != 1 {
		t.Errorf("expected 1 after remove(0), got %d", c.len())
	}
	if _, ok := c.get(1, 0); !ok {
		t.Error("entry for msg 1 was incorrectly removed")
	}
}

func TestReclaim_WritesToCollapser(t *testing.T) {
	a := New(&summarizeFake{}, "test-model")
	for i := 0; i < 10; i++ {
		a.History.Append(Message{Role: RoleUser, Blocks: []ContentBlock{{
			Type: "tool_result", ToolUseID: "id", Result: strings.Repeat("x", 5000),
		}}})
		a.History.Append(NewAssistantMessage("ok"))
	}
	reclaimed := a.reclaimStaleToolResults()
	if reclaimed <= 0 {
		t.Fatal("expected reclaim to return tokens")
	}
	if a.History.collapser.len() == 0 {
		t.Fatal("collapser should have entries after reclaim")
	}
	snap := a.History.Snapshot()
	for _, m := range snap {
		for _, b := range m.Blocks {
			if b.Type == "tool_result" && strings.Contains(b.Result, "bytes elided") {
				return
			}
		}
	}
	t.Error("Snapshot did not contain projected placeholders")
}

func TestReclaim_ReplaceAllClearsCollapser(t *testing.T) {
	a := New(&summarizeFake{}, "test-model")
	a.History.collapser.set(0, 0, "placeholder")
	a.History.ReplaceAll([]Message{NewUserMessage("fresh")})
	if a.History.collapser.len() != 0 {
		t.Errorf("ReplaceAll should clear collapser, got %d entries", a.History.collapser.len())
	}
}

func TestReclaim_DoesNotMutateLiveHistory(t *testing.T) {
	a := New(&summarizeFake{}, "test-model")
	a.History.Append(Message{Role: RoleUser, Blocks: []ContentBlock{{
		Type: "tool_result", ToolUseID: "id", Result: strings.Repeat("x", 10000),
	}}})
	a.History.Append(NewAssistantMessage("ok"))
	for i := 0; i < 6; i++ {
		a.History.Append(Message{Role: RoleUser, Blocks: []ContentBlock{{
			Type: "tool_result", ToolUseID: "id", Result: strings.Repeat("y", 5000),
		}}})
		a.History.Append(NewAssistantMessage("ok"))
	}
	before := a.History.Snapshot()
	originalLen := len(before[0].Blocks[0].Result)

	a.reclaimStaleToolResults()

	// Swap out the collapser temporarily so Snapshot returns raw data.
	saved := a.History.collapser
	a.History.collapser = Collapser{}
	raw := a.History.Snapshot()
	a.History.collapser = saved

	if len(raw[0].Blocks[0].Result) != originalLen {
		t.Errorf("live history was mutated: expected %d bytes, got %d", originalLen, len(raw[0].Blocks[0].Result))
	}
}

func TestCollapser_SnapshotReturnsProjected(t *testing.T) {
	h := NewHistory()
	h.collapser.set(0, 0, "[collapsed]")
	h.Append(Message{Role: RoleUser, Blocks: []ContentBlock{{
		Type: "tool_result", ToolUseID: "id", Result: strings.Repeat("x", 5000),
	}}})
	snap := h.Snapshot()
	if snap[0].Blocks[0].Result != "[collapsed]" {
		t.Errorf("Snapshot should project collapsed content, got %q", snap[0].Blocks[0].Result)
	}
}
