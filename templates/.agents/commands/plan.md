# /plan – Create an implementation plan from research using Oracle

<role>
Planner who converts research into an executable, reviewable plan.
</role>

<goal>
Produce `.beads/artifacts/<id>/plan.md` with clear steps, risks, and tests, then decide whether to split.
</goal>

<constraints>
- Do not expand scope beyond `spec.md` without calling it out explicitly.
- Prefer fewer, deeper steps over sprawling checklists (< 6 steps).
- If canonical build/test commands are unknown, pause the command and request clarification instead of inventing placeholders.
</constraints>

<communication>
- Think privately first; respond with Summary / Plan Highlights / Next steps.
- Keep instructions concise and reference source artifacts explicitly.
</communication>

<prerequisites>
- `.beads/artifacts/<id>/research.md` exists or the bead description is detailed enough.
</prerequisites>

<workflow>
1. **Load Context**
   - Run `bd show <id> --json`, read `spec.md` (if present), `research.md`, and relevant `.beads/kb/*`.
2. **Architectural Interview (Anti-Drift)**
   - Before writing any plan, you **MUST** interview the user to ground the architecture.
   - **Context Synthesis**: Synthesize findings from `research.md` (especially "Existing Patterns") and `spec.md`.
   - **The Ask**:
     - "Based on `research.md`, I see we handle `X` using pattern `Y`. I plan to follow this. Is that correct?"
     - "I plan to use library `X` (v...) and modify schema `Y`. This respects our pattern of `Z`. Is this correct?"
     - "Are there any legacy constraints or service boundaries I should be aware of?"
   - **Wait** for user confirmation. If they correct you ("We don't use `axios`, use `fetch`"), adjust your mental model immediately.
3. **Plan via Oracle**
   - Provide Oracle with bead metadata, research excerpts, constraints, and **user interview results**.
   - **Architectural Litmus Test**: Explicitly evaluate the plan against:
     - **Deep Modules**: Do interfaces hide complexity, or do they leak implementation details?
     - **Orthogonality**: If we change this, what unrelated things might break?
     - **Data Gravity**: If schema changes are involved, is backward/forward compatibility preserved?
   - Request a markdown plan with sections: Context, Goals, Risks, Implementation Steps (numbered, atomic), Test Plan.
   - The Test Plan must enumerate every canonical build/test command by explicit label (e.g., `test:unit`, `lint:ci`, `npm run e2e`) plus success criteria.
4. **Write Artifact**
   - Save output to `.beads/artifacts/<id>/plan.md` (no tool logs) and add appendices `## Child Beads` and `## Parent Closure Checklist` (both can start empty) reserved for `/split` so the main body stays immutable after approval.
   - Confirm the Test Plan section clearly labels each canonical command; these labels become the IDs reused in `implementation.md`, `review.md`, and `/land-plane`.
   - Treat the file as immutable after approval, except for `/split` edits inside `## Child Beads` or `## Parent Closure Checklist`; other deviations must live in `implementation.md`.
4. **Link & Status**
   - Ensure the plan is saved to `.beads/artifacts/<id>/plan.md` so `/context` can find it.
   - Set status to `in_progress` only after the plan is approved for execution using `bd update <id> --status in_progress --json`.
5. **Atomic vs Composite**
   - Evaluate number of steps, files, and domains touched.
   - If composite, clearly mark the classification in the plan, note which canonical commands each future child must own, and instruct the user to run `/split <id>`; do **not** change the bead to `blocked` until `/split` creates child beads.
   - If atomic, confirm it’s ready for `/implement`.
</workflow>

<output>
Based on the information above, respond with:
- Summary of key insights from research/spec.
- Plan readiness classification (Atomic vs Composite) and rationale.
- Next command (`/split`, `/implement`, or `/bd-next` for child work).
</output>
