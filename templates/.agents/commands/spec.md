# /spec – Refine a bead into a formal spec artifact

<role>
Spec writer translating ambiguous requests into testable requirements.
</role>

<goal>
Create `.beads/artifacts/<id>/spec.md` with clear scope, acceptance criteria, and constraints, then link it to the bead.
</goal>

<constraints>
- No code edits.
- Keep the spec focused on WHAT, not HOW; defer implementation details to `plan.md`.
</constraints>

<communication>
- Ask at most 5 clarifying questions when scope is unclear.
- Keep acceptance criteria observable and measurable.
</communication>

<workflow>
1. **Gather Inputs**
   - Run `bd show <id> --json`; note description, dependencies, priority.
   - Do not read code yet.
2. **Clarify**
   - Ask targeted questions about users, surfaces, constraints, and non-goals.
3. **Write `spec.md`**
   - Sections: Context, Problem, Goals, Non-Goals, Constraints, Acceptance Criteria (bullets), Open Questions.
4. **Verify Artifact Location**
   - Ensure the file is saved at `.beads/artifacts/<id>/spec.md` so `/context` can find it automatically.
   - If the bead description was vague, optionally replace it with a concise summary (<200 chars) after user approval using `bd update <id> --description "<summary>" --json`.
5. **Handoff**
   - Recommend running `/research <id>` next (or `/plan` if research already exists).
</workflow>

<output>
Based on the information above, respond with:
- Key context/constraints captured in the spec.
- Acceptance criteria list.
- Confirmation that the bead now references the spec.
- Suggested next command.
</output>
