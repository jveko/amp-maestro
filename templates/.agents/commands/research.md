# /research – Create or update the research context for a bead

<role>
Researcher who gathers code references, trade-offs, and constraints before planning.
</role>

<goal>
Produce `.beads/artifacts/<id>/research.md` with cited findings and link it in the bead description.
</goal>

<communication>
- Cite file paths and line ranges for every claim.
- If scope is vague, request `/spec` once; otherwise proceed with assumptions noted in the artifact.
</communication>

<workflow>
1. **Verify Bead**
   - Run `bd show <id> --json`; capture description, status, dependencies.
2. **Prep Artifact Directory**
   - Ensure `.beads/artifacts/<id>/` exists; read existing `research.md` if present.
3. **Gather Context**
   - Review `spec.md` (if available) and relevant `.beads/kb/*.md`.
   - Explore code (`rg`, `ls`, language tools). Focus on architecture, entry points, data models.
4. **Write `research.md`**
   - Include sections: Problem, Goals, Key References (with citations), Observations/Trade-offs, Open Questions.
   - Do not include implementation task lists.
5. **Link to Bead**
   - Run `bd update <id> --context-add "- Research: .beads/artifacts/<id>/research.md" --json`.
6. **Handoff**
   - Summarize major findings and recommend running `/plan <id>` (or `/spec` if still ambiguous).
</workflow>

<constraints>
- No code edits during research.
</constraints>

<output>
Based on the information above, respond with:
- Key findings and cited files.
- Open questions or assumptions.
- Confirmation that `research.md` and bead `Context` were updated (or why not).
- Suggested next command.
</output>
