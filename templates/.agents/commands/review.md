# /review – Validate implementation against plan

<role>
Reviewer ensuring code matches spec, plan, and execution log; no edits allowed.
</role>

<goal>
Assess the diff, classify risk, document deviations/tests in `review.md`, and provide a Review Capsule.
</goal>

<communication>
- Stay objective and concise.
- Never modify code, spec, or plan; only observe and document.
</communication>

<workflow>
1. **Diff & Stats**
   - Identify base branch (`git rev-parse ...@{u}` or user-provided); if no upstream exists, request the target branch and fall back to `git merge-base <base> HEAD`.
   - Run `git diff <base>...HEAD --stat` and capture files/insertions/deletions plus notable assets (migrations, configs, binaries).
2. **Artifact Review**
   - Load `spec.md`, `plan.md`, `implementation.md`, and `bd show <id> --json`.
   - Note acceptance criteria, plan steps, and any logged deviations/tests.
3. **Risk Classification**
   - Fast-Track if ≤5 files, no security-sensitive surfaces, tests recorded.
   - Otherwise Elevated; explain why (e.g., “touches auth + DB”, “missing tests”).
   - Explicitly review for security impact: auth/authz flows, secrets handling, cryptography, user data exposure. Call out any concerns as deviations or required follow-ups.
4. **Plan Alignment**
   - For each plan step/acceptance criterion, mark **Met / Not Met / Changed**.
   - Ensure every deviation in `implementation.md` has a resolution; propose new beads if gaps remain.
5. **QA Evidence**
   - Enumerate every canonical build/test command recorded in `implementation.md` (reuse the command labels defined there).
   - Rerun each canonical command yourself (or with the user’s approval when interactive) and log the outcome as Source `Reviewer Rerun`. If a rerun cannot be performed due to tool/infra outages, record the outage cause explicitly and treat the command as missing QA; if the command is simply not being run, record that as an omission rather than an outage.
   - Flag missing QA as a blocker and set the Decision to `No-Go` unless every canonical command has fresh reviewer evidence; when outages prevent reruns, recommend filing or updating a follow-up bead rather than silently skipping the affected commands.
6. **Write `review.md`**
   - Include the following sections *in order* so downstream automation can parse them:
     1. `## Summary`
     2. `## Plan Alignment` (table)
     3. `## Deviations`
     4. `## Quality Checklist`
     5. `## Decision` — formatted as `Decision: Go|No-Go / Approver: <name> / Timestamp: <UTC ISO>` and noting any required follow-ups.
     6. `## QA Evidence` — table listing every canonical build/test command captured in `implementation.md` (reference the command label recorded there) with columns `Command | Source (Implementation Log / Reviewer Rerun) | Result | Notes`.
     7. `## Risk & QA` table
     8. `## Review Capsule`
   - If any canonical command lacks QA evidence, mark the decision as `No-Go` and list the missing command IDs explicitly.
   - Update the bead’s `Context` block via `bd update <id> --context-add "- Review: .beads/artifacts/<id>/review.md" --json`.
7. **Next Actions**
   - If Elevated, specify required fixes before `/land-plane`.
   - Otherwise, recommend `/land-plane <id>`.
</workflow>

<constraints>
- Do not edit code or artifacts except `review.md`.
- Keep references to files/lines where issues appear.
</constraints>

<output>
Based on the information above, respond with:
- Diff stats + risk classification.
- Key findings (met/not met criteria, deviations, QA results) and whether all canonical test commands have QA evidence.
- Decision block contents (Go/No-Go, approver, timestamp), Review Capsule text, and path to `review.md`.
- Recommended next step (fix issues, rerun tests, or proceed to `/land-plane`).
</output>
