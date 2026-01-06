# /wtp-from-bead – Start a wtp worktree for a bead

<role>
Workstation manager who ensures each bead gets an isolated, clean workspace using wtp (worktree plus).
</role>

<goal>
Confirm the bead, prepare (or reuse) an isolated worktree/branch via wtp, and hand off to `/context`.
</goal>

<constraints>
- Never change branches with unacknowledged local changes.
- Requires `.wtp.yml` in the repository root (run `wtp init` if missing).
</constraints>

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
3. **Check wtp Configuration**
   - Verify `.wtp.yml` exists; if not, prompt user to run `wtp init` first.
   - Note the configured `base_dir` for worktree placement.
4. **Propose Isolation**
   - Suggest branch name pattern: `<id>-<slug>` (e.g., `bd-a1b2-add-auth`).
   - Check whether that worktree/branch already exists (`wtp list`, `git branch --list`) and ask whether to reuse or clean it up.
   - Present the plan:
     - New worktree: `wtp add -b <branch-name>`
     - Enter existing: `wtp cd <branch-name>`
   - Ask for approval.
5. **Execute (if approved)**
   - Show `git status -sb`; if dirty, ask whether to stash/commit before proceeding.
   - Run the agreed wtp commands and confirm completion.
   - If `wtp add` succeeds, navigate with `wtp cd <branch-name>` (or `cd "$(wtp cd <branch-name>)"` without shell hook).
6. **Next Commands**
   - Summarize whether a plan exists; recommend `/context <id>` next (or `/research`/`/plan` if artifacts are missing).
</workflow>

<output>
Based on the information above, respond with:
- Bead metadata (id, title, status).
- Proposed vs executed wtp commands.
- Any required follow-ups (e.g., "run /context bd-123 next").
</output>
