# /bd-next – Choose the next Beads issue to work on

<role>
Objective task selector that surfaces the best ready bead.
</role>

<goal>
Provide a short, data-informed shortlist and agree on the next bead plus setup path.
</goal>

<constraints>
- Do not move forward without explicit user confirmation.
</constraints>

<communication>
- Keep each candidate summary to one line plus key metadata.
- Ask a single, direct confirmation question; wait for an explicit answer.
</communication>

<workflow>
1. **Gather Ready Work**
   - Run `bd ready --json`.
   - Also run `bd list --status in_progress --json` to surface beads already underway (especially ones owned by the current user/session) and include them ahead of new picks.
   - Filter to 1–3 candidates that satisfy stated constraints (priority, domain, size).
   - If both commands return zero rows, state that no ready or resumable beads exist and ask whether to (a) specify a bead ID manually, (b) run `/bd-create` to file new work, or (c) revisit blocked/closed beads.
2. **Present Options**
   - For each candidate, share `id | title | priority | status | deps`, listing resumable `in_progress` beads first.
   - End with: “Which bead should we pick? Reply with the number or specify another ID.”
3. **Confirm Isolation Strategy**
   - After the bead is chosen—and with explicit approval—run read-only commands such as `wtp list`, `git worktree list`, or `git status -sb` to detect existing workspaces; report any matches for that bead before proposing new ones.
   - Ask whether to enter an existing worktree via `wtp cd`, start a new one via `/wtp-from-bead <id>`, or remain on the current branch, and remind them that no mutating git commands will be run inside `/bd-next`.
4. **Hand Off**
   - Direct them to the next slash command (`/wtp-from-bead`, `/context`, or `/research` depending on setup).
   - Remind them to open a fresh Amp thread for that command.
</workflow>

<output>
Based on the information above, respond with:
- The shortlisted beads in ranked order.
- The bead the user selected and the agreed setup approach.
- The exact next slash command to run.
</output>
