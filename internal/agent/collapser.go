package agent

import "strconv"

// Collapser records which tool_result blocks have been collapsed by
// reclaimStaleToolResults so Snapshot() can project the placeholder at read
// time without mutating the underlying messages array. This keeps the
// provider's prompt cache prefix valid because the stored message slice is
// never rewritten — only the returned copy carries the projection.
//
// Key format: "msgIdx:blockIdx" — two ints joined by a colon.  This is
// deliberately a string key rather than a struct to keep the zero-value useful
// (a nil map is empty and needs no initialisation).
//
// Collapser is NOT persisted across session save/load. After a restart
// reclaim will re-evaluate and re-populate entries, so the only cost is one
// turn of full tool-result visibility after restore — accepted tradeoff.
type Collapser struct {
	entry map[string]string // msgIdx:blockIdx → placeholder text
}

// set records a collapsed placeholder for message at mi, block at bi.
func (c *Collapser) set(mi, bi int, placeholder string) {
	if c.entry == nil {
		c.entry = make(map[string]string)
	}
	c.entry[c.key(mi, bi)] = placeholder
}

// get returns the placeholder and true if a collapse entry exists.
func (c *Collapser) get(mi, bi int) (string, bool) {
	if c.entry == nil {
		return "", false
	}
	s, ok := c.entry[c.key(mi, bi)]
	return s, ok
}

// remove clears collapse entries for message mi (used when that message is
// overwritten by replaceLast).
func (c *Collapser) remove(mi int) {
	if c.entry == nil {
		return
	}
	prefix := strconv.Itoa(mi) + ":"
	for k := range c.entry {
		// Fast path: prefix matches
		if len(k) > len(prefix) && k[:len(prefix)] == prefix {
			delete(c.entry, k)
		}
	}
}

// clear drops all entries.
func (c *Collapser) clear() {
	c.entry = nil
}

// len reports the number of entries (0 when never used).
func (c *Collapser) len() int {
	return len(c.entry)
}

// project replaces collapsed tool_result blocks in-place on a copy of the
// message slice (caller must own the copy — Snapshot handles this).
func (c *Collapser) project(msgs []Message) {
	for mi := range msgs {
		for bi := range msgs[mi].Blocks {
			if placeholder, ok := c.get(mi, bi); ok {
				msgs[mi].Blocks[bi].Result = placeholder
				msgs[mi].Blocks[bi].UI = nil
			}
		}
	}
}

func (c *Collapser) key(mi, bi int) string {
	return strconv.Itoa(mi) + ":" + strconv.Itoa(bi)
}
