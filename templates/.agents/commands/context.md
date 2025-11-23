# /context – Load full context for a bead

<role>
Context loader that bootstraps the agent with the latest bead state and artifacts.
</role>

<goal>
Summarize bead metadata, artifacts, and blockers, then recommend the next command.
</goal>

<constraints>
- Never infer artifacts; only report what exists on disk.
</constraints>

<communication>
- Keep each artifact summary to 1–2 sentences.
- Explicitly note missing artifacts or stale files.
</communication>

<workflow>
1. **Bead Snapshot**
   - Run `bd show <id> --json`; capture title, status, priority, dependencies, acceptance criteria.
2. **Artifacts**
   - Inspect `.beads/artifacts/<id>/` for `spec.md`, `research.md`, `plan.md`, `implementation.md`, `review.md`, `landing.md`, and any `sessions/*.md` files if they exist.
   - For each present file, summarize key points + timestamp; for missing files, note “not found”.
   - Freshness rule: capture `updated_at` from `bd show <id> --json` (fallback: latest commit touching `.beads/artifacts/<id>/`). For each artifact, record its own timestamp (`git log -1 --format=%ct -- <file>` for tracked files, `stat -f %m <file>` on macOS or `stat -c %Y <file>` on Linux for untracked). Declare an artifact “stale” only when you have evidence that a newer stage ran without updating it—for example, `plan.md` older than the latest `research.md`, `implementation.md` predating recent code commits/tests, or bead `updated_at` from a later-stage command (status change to `ready_for_review`, new sessions note, etc.) where the artifact is missing. Otherwise, report the timestamp and mark freshness as “current” or “unknown”. Document when timestamps cannot be collected.
   - Mention relevant `.beads/kb/*.md` references if cited in the artifacts; if `sessions/` is absent, simply state “sessions log: not tracked”. Treat `sessions/*.md` as optional, append-only logs that may be written by external tooling rather than this command.
3. **State Synthesis**
   - Concisely restate title + objective, highlight blockers, and surface outstanding plan steps or QA gaps.
4. **Next Command**
   - Recommend the next slash command (e.g., `/spec`, `/plan`, `/implement`, `/review`, `/land-plane`) and ask for confirmation.
</workflow>

<output>
Based on the information above, respond with:
- Bead snapshot (id/title/status/priority/deps).
- Bullet summaries for each artifact (spec, research, plan, implementation, review, landing, sessions-if-any).
- Explicit blockers or missing context.
- Recommended next command plus confirmation question.
</output>
