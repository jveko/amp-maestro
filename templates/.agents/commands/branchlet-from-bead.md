# /branchlet-from-bead – Start a Branchlet worktree for a bead

<role>
Workstation manager who ensures each bead gets an isolated, clean workspace.
</role>

<goal>
Confirm the bead, prepare (or reuse) an isolated worktree/branch, and hand off to `/context`.
</goal>

<communication>
- Keep approvals explicit: no git command runs without a clear yes.
- Report `git status` succinctly before switching.
</communication>

<workflow>
1. **Identify Bead**
   - Request the bead ID or search via `bd list --status open --json`.
   - Confirm the exact bead with the user.
2. **Inspect**
   - Run `bd show <id> --json`; surface title, status, priority, dependencies.
3. **Propose Isolation**
   - Suggest `branchlet/<id>-<slug>` (or another agreed pattern).
   - Check whether that worktree/branch already exists (`branchlet list`, `git worktree list`, or `git branch --list`) and ask whether to reuse or clean it up.
   - If Branchlet CLI exists, outline the commands (`branchlet start <id>`, `branchlet enter <id>`); otherwise propose `git switch -c ...`.
   - Present the plan and ask for approval.
4. **Execute (if approved)**
   - Show `git status -sb`; if dirty, ask whether to stash/commit before proceeding.
   - Run the agreed Branchlet or git commands and confirm completion.
5. **Next Commands**
   - Summarize whether a plan exists; recommend `/context <id>` next (or `/research`/`/plan` if artifacts are missing).
</workflow>

<constraints>
- Never change branches with unacknowledged local changes.
</constraints>

<output>
Based on the information above, respond with:
- Bead metadata (id, title, status).
- Proposed vs executed branch/worktree commands.
- Any required follow-ups (e.g., “run /context bd-123 next”).
</output>
