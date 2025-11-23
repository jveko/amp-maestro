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
3. **Gather Context (Context Engineering)**
   - **System Context**: Review `spec.md` and `ARCHITECTURE.md` (if present). Understand the high-level design.
   - **Domain Context (Pattern Hunt)**: Explicitly search for existing patterns.
     - *Example:* "How do we handle Auth?" -> Find `auth-middleware.ts`.
     - *Example:* "How do we structure API responses?" -> Find `api-response-type.ts`.
     - *Goal:* Mimic existing "Tribal Knowledge".
   - **Data Context**:
     - Identify data models/schemas involved.
     - Check for "Data Gravity": Will changing this require a heavy migration?
   - **Task Context**: Explore code (`rg`, `ls`) relevant to *this specific bead*.
4. **Write `research.md`**
   - Structure as a **Context Layer**:
     - **Domain Patterns**: "We use `zod` for validation and `react-query` for fetching."
     - **System Constraints**: "No direct DB access from UI."
     - **Task Knowledge**: "The user wants to add feature X to file Y."
   - Key References (cited).
   - Open Questions.
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
