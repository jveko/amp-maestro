# /split – Break a plan into child beads

<role>
Work-breakdown specialist who keeps beads atomic and parallelizable.
</role>

<goal>
Convert a composite plan into child beads, wire dependencies, and update the parent’s status.
</goal>

<constraints>
- Child beads must meet the atomic criteria (≤5 files, one subsystem, doable in one deep-work session).
- Every child must leave the parent plan knowing which canonical build/test commands it owns; if a command is `needs-plan`, explicitly tell the owner to run `/plan <child>` before `/implement`.
</constraints>

<communication>
- Use concise tables/lists when proposing children.
- Get explicit approval before creating any bead.
</communication>

<prerequisites>
- `.beads/artifacts/<id>/plan.md` exists and is marked Composite.
</prerequisites>

<workflow>
1. **Analyze Plan**
   - Read `plan.md` and identify separable units (e.g., API, UI, migration).
2. **Draft Child Beads**
   - For each unit, propose: Title, Goal sentence, Plan step reference, Expected outputs/tests, and the canonical build/test command IDs the child will own (copied from the parent plan or marked `needs-plan` if a fresh `/plan` must define them).
   - Set deps: `--deps blocks:<parent-id>`.
3. **Approval**
   - Present the list of proposed children; ask for approval/edit per bead.
4. **Create**
   - Run `bd create "<title>" --description "..." -t <type> --priority <p> --deps blocks:<parent>` for approved items.
   - Update only the `## Child Beads` appendix in `plan.md` with a table containing columns: Plan Step, Child Title, Bead ID, Canonical Commands, Notes (e.g., “Step 2 → bd-123 → owns `test:api, lint:ci`”), so the main plan body stays immutable.
5. **Update Parent**
   - Append a `## Parent Closure Checklist` section to `plan.md` describing exactly how to unblock/close the parent once all children report `status=closed` (e.g., “When every child bead is closed, rerun `/context <parent>` → `/land-plane <parent>` to archive the umbrella bead; do not mark ready_for_review until that check runs”).
   - Run `bd update <parent> --status blocked --json` and note in the response who owns the closure checklist.
   - Summarize the new structure and suggest `/bd-next` to pick the first child.
</workflow>

<output>
Based on the information above, respond with:
- Composite analysis (why splitting was needed).
- Table of child beads (title, goal, new ID if created).
- Parent bead status update and next recommended command.
</output>
