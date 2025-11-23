# /kb-build – Build or update shared repository knowledge

<role>
Knowledge mapper documenting reusable architecture insights.
</role>

<goal>
Create or update `.beads/kb/*.md` files so future beads can reuse architecture/context without re-discovery.
</goal>

<constraints>
- Modify only `.beads/kb/` files.
- Cite file paths or directories when describing components.
</constraints>

<communication>
- Keep write-ups high-level and evergreen.
- Use headings and bullets; avoid per-bead TODOs.
</communication>

<workflow>
1. **Scope**
   - If a scope argument is provided (`/kb-build auth`), focus there; otherwise update `architecture.md`.
   - Ask whether the repository uses subsystem tags (recommended: add `Tags: api,auth` to each bead description) so broadcast targeting stays deterministic.
2. **Review Existing KB**
   - Read `.beads/kb/architecture.md` and any scope-specific files to avoid duplication.
   - Check `git status -sb` to understand concurrent KB edits and plan merges accordingly.
3. **Explore Code**
   - Use `rg`, `ls`, or language tooling to identify entry points, data flows, key modules, and invariants.
4. **Document**
   - Ensure `.beads/kb/` exists.
   - Update or create `.beads/kb/<scope>.md` (or `architecture.md`) with sections for Purpose, Key Components, Data/Control Flow, Risks, and Extension Guidelines, appending new sections instead of rewriting shared content whenever possible.
   - Link out to relevant beads or artifacts instead of embedding per-task details.
5. **Broadcast**
   - Identify active beads affected by the new knowledge using tags or the helper command (`bd kb-targets --tag <scope>`); if neither is available, ask the user for the impacted beads and document “broadcast skipped – no targeting data” in the final report.
   - Deduplicate the target list and preview it for approval before updating anything.
   - For each approved bead, prefer adding a single durable reference in the bead’s `Context` block (for example via `bd update <id> --context-add "- KB: .beads/kb/<scope>.md" --json`) over repeating transient notes; avoid adding duplicate references if the KB link already exists. If broadcasting is skipped, record the reason explicitly.
6. **Report**
   - Summarize which files changed and the top insights (2–5 bullets).
   - State exactly which beads were updated/notified about the KB change.
</workflow>

<output>
Based on the information above, respond with:
- Scope addressed.
- Files created/updated.
- Bullet list of key takeaways.
- Recommendation on which beads should reference the updated KB.
</output>
