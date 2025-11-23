# /land-plane – Cleanly wrap up the session

<role>
Landing officer ensuring beads, git, and QA are in sync before ending work.
</role>

<goal>
Confirm scope, capture remaining work, run required quality gates, sync beads, and leave clear next steps.
</goal>

<communication>
- Keep inventories concise; align them to `implementation.md`.
- Request approval before every destructive or state-changing command.
</communication>

<workflow>
0. **Review Gate**
   - Confirm `.beads/artifacts/<id>/review.md` exists for every bead being landed.
   - Verify each review artifact contains a `## Decision` block marked `Go` with approver + timestamp and a `## QA Evidence` table covering every canonical command from `implementation.md`. If any field is missing or marked `No-Go`, stop and redirect to `/review` or remediation before touching git.
1. **Inventory**
   - List active bead(s), files touched, and tests run (cite `implementation.md`); call out when multiple branchlets/worktrees are open.
   - Ask user to confirm or correct and decide whether to finish beads sequentially or exit early.
2. **Per-Bead Verification**
   - For each bead in the inventory: follow the exit checklist directly inside this command—
     1. `branchlet enter <id>` (or `git worktree` switch) and show `git status -sb`.
     2. Compare `git diff` to `plan.md`/`spec.md` and `implementation.md` deviations; queue new beads for any unresolved scope.
     3. Rerun every canonical build/test command before committing (details in step 5).
     4. Confirm `review.md` still shows `Decision: Go` with all required follow-ups resolved.
     5. Commit with `Refs <id>` and push if requested.
     6. Run `branchlet delete <id>` (or remove the worktree) once the bead lands.
   - When multiple worktrees are active, complete the checklist bead-by-bead before moving on.
3. **Track Remaining Work**
   - Propose new beads for uncovered issues (`bd create ... --deps discovered-from:<id>`); seek approval before creating.
4. **Update Bead Status**
   - Preview the exact `bd update <id> --status ready_for_review|in_progress|closed --json` commands for each bead; run only after approval and log outcomes.
5. **Quality Gates**
   - Ensure `.beads/artifacts/<id>/landing.md` exists with sections `## QA Revalidation` and `## Notes`; if missing, create it and link it via `bd update <id> --context-add "- Landing: .beads/artifacts/<id>/landing.md" --json`.
   - Enumerate the canonical build/test commands from `implementation.md` (reference them by the command labels written there); request approval to rerun each.
   - Execute approved commands, capture pass/fail output, and log results **only** in `landing.md` (table keyed by command label with columns `Command | Source Landing | Result | Notes`) plus a short summary in the command response—do **not** edit `implementation.md` or `review.md` during landing so prior artifacts stay immutable.
   - If any rerun fails, halt landing, report the failure, and decide whether to fix immediately or file a new bead—never continue to commits/pushes with failing QA. If canonical commands cannot be run at all due to tool/infra outages, record the outage explicitly in `landing.md`, treat QA as incomplete, and recommend creating or updating a bead to track remediation rather than proceeding as if tests had passed.
6. **Sync Beads**
   - Explain what `bd sync` will do (per bead if necessary) and request approval before running.
7. **Git Hygiene**
   - Show `git status -sb` for the current worktree and any additional branchlets still open.
   - Propose commit message(s) (Conventional Commit + `Refs <id>`). After approval, commit and optionally push.
8. **Next Steps**
   - Suggest the next bead or slash command, referencing review capsules and unresolved follow-ups.
9. **Recap**
   - Report: beads updated, tests executed (with pass/fail state), `bd sync` result, git status/push outcome, and pending follow-ups per bead.
</workflow>

<constraints>
- Never run commands that alter state (tests, sync, git, bd) without consent.
</constraints>

<output>
Based on the information above, respond with:
- Confirmed inventory.
- Approved/declined commands (tests, bd updates, git, sync).
- Summary of commits/tests performed.
- Next recommended command or bead.
</output>
