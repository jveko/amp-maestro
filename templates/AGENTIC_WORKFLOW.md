# Agentic Workflow Protocol

This protocol defines the mandatory workflow for AI agents (Amp) working in this repository. It integrates **Beads** (Issue Tracking), **Branchlet** (Worktrees), and **Slash Commands** (HumanLayer Protocol).

```mermaid
graph TD
    %% Styling for Dark Mode readability
    classDef default fill:#2d2d2d,stroke:#fff,stroke-width:2px,color:#fff;
    classDef decision fill:#8b4500,stroke:#fff,stroke-width:2px,color:#fff;
    classDef startend fill:#005faf,stroke:#fff,stroke-width:2px,color:#fff;

    Start([User Identifies Need]) --> Ideation
    
    subgraph "1. Ideation & Triage"
        Ideation["/bd-create"]
        Backlog[("Bead Backlog")]
    end
    Ideation --> Backlog
    
    subgraph "2. Setup & Context"
        PickWork["/bd-next or Pick from Backlog"]
        Worktree["/branchlet-from-bead"]
        Context["/context (Load Artifacts)"]
        Knowledge["/kb-build (Optional)"]
    end
    Backlog --> PickWork
    PickWork --> Worktree
    Worktree --> Context
    Context --> Knowledge
    Knowledge --> Research
    Context --> Research
    Research --> Plan
    Plan --> Complexity{Atomic?}
    
    Complexity -- No (Composite) --> Split["/split"]
    Complexity -- Yes (Atomic) --> Approve
    
    Approve -- No --> Plan
    Split --> Blocked[Parent Blocked]
    
    subgraph "4. Implementation"
        Implement["/implement (Sub-agents)"]
        Verify{Tests Pass?}
    end
    
    subgraph "5. Review"
        Review["/review"]
    end
    
    Approve -- Yes --> Implement
    Implement --> Verify
    Verify -- No --> Implement
    Verify -- Yes --> Review
    
    subgraph "6. Land & Merge"
        Land["/land-plane"]
        Merge[Merge PR]
        Cleanup["branchlet delete"]
    end
    Review --> Land
    Land --> Merge
    Merge --> Cleanup
    
    class Start,Merge,Cleanup startend;
    class Approve,Verify decision;
```

## 1. Ideation & Triage
- **User**: Run `/bd-create` (or identify a need).
- **Agent**: 
  - Interviews user to understand scope.
  - Generates title/priority/type.
  - Identifies lineage (blocks/discovered-from).
- **Outcome**: A Bead ID (e.g., `bd-a1b2`) exists in the backlog.

## 2. Setup & Context
- **User**: Run `/bd-next` to pick a task.
- **Agent**: Proposes top candidates. User selects `bd-a1b2`.
- **User**: Run `/branchlet-from-bead bd-a1b2` (Recommended) or switch branch.
- **User**: Run `/context bd-a1b2`.
  - **Agent**: Loads existing artifacts and summarizes state.
- **User (Optional)**: Run `/kb-build`.
  - **Agent**: Scans codebase to build/update shared architecture docs in `.beads/kb/`.

## 3. Research & Spec (Start New Thread)
- **User**: Run `/spec bd-a1b2` (Optional but recommended).
  - **Agent**: Refines Bead into a formal `spec.md`.
- **User**: Run `/research bd-a1b2`.
  - **Agent**: Scans codebase (and KB), creates `.beads/artifacts/bd-a1b2/research.md`.

## 4. Planning (Start New Thread)
- **User**: Run `/plan bd-a1b2`.
  - **Agent (Oracle)**: reasoning -> `.beads/artifacts/bd-a1b2/plan.md`.
- **Plan Artifact**: Every plan includes a `## Child Beads` appendix reserved for `/split`; the remainder stays read-only once approved. The Test Plan section defines all canonical build/test commands by label (for example `test:unit`, `lint:ci`); those labels are reused unchanged by `/implement`, `/review`, and `/land-plane`.
- **Split Decision**: Agent analyzes complexity.
  - **Composite**: Agent runs `/split` to create child beads. Parent becomes blocked.
  - **Atomic**: Plan is approved for immediate implementation.

## 5. Implementation (Start New Thread)
- **User**: Run `/implement bd-a1b2`.
  - **Agent (Manager)**: Spawns **Subagents** for each plan step.
  - **Agent**: Updates status to `in_progress`.
  - **Agent**: Creates `.beads/artifacts/bd-a1b2/implementation.md` if missing, copies the canonical build/test command labels from the plan’s Test Plan into a `## Build & Test Commands` table, and records actual runs, deviations, and decisions there (plan stays immutable once approved and no new canonical commands are invented at this stage).
  - **Fallback**: If Task subagents are unavailable, the primary agent runs the loop directly but must preserve the same logging/test discipline.
  - **Agent**: Verifies builds/tests so that every canonical command in the plan has a recent, passing run recorded in `implementation.md`; downstream `/review` and `/land-plane` refer only to these canonical command labels for QA evidence.

## 6. Review (Start New Thread)
- **Trigger**: Implementation passes local verification.
- **User**: Run `/review bd-a1b2`.
  - **Agent**: Audits the diff against `plan.md`/`spec.md` and the runtime log in `implementation.md`, classifies Fast-Track vs Elevated risk, and highlights any high-entropy files.
  - **Agent**: Records findings, QA evidence keyed to the canonical command labels, and a PR-ready Review Capsule in `.beads/artifacts/<id>/review.md` (see `/review` command template for the exact structure). If canonical commands cannot be rerun due to tool/infra outages or are missing QA, the review marks them as missing, sets `Decision: No-Go`, and recommends follow-up beads instead of treating them as implicitly passing.
- **Outcome**: Clear go/no-go signal plus documented deviations, risk rating, and test proof so downstream reviewers can move quickly, with outages or missing QA treated as hard blockers rather than soft warnings.

## 7. Land & Merge (Start New Thread)
- **Prereq**: `/review` is complete (or explicitly skipped with rationale).
- **User**: Run `/land-plane bd-a1b2`.
  - **Agent**: Verifies review artifacts are approved before touching git.
  - **Agent**: Runs final linters/tests by revalidating the same canonical commands recorded in `implementation.md`, files/updates beads, and syncs `bd`; any failing rerun halts landing, and if tests cannot be run at all due to tool/infra outages the landing is treated as having incomplete QA and must spin off or update beads instead of proceeding.
  - **Agent**: Writes QA revalidation results into `.beads/artifacts/<id>/landing.md` so that `implementation.md` and `review.md` remain immutable after their stages complete.
  - **Agent**: For multiple active branchlets, land beads sequentially per the `/land-plane` command template.
  - **Agent**: Commits with `Refs <id>` and optionally pushes.
- **User**: Merge Pull Request.
- **User**: `branchlet delete` (cleanup).

## 8. Parallelism & Swarms (Epic Structure)
To complete Epics faster, structure Beads for **maximum parallel agent execution**:

1.  **The "Epic" Bead (The Manager)**
    - **Role**: Holds the master `research.md` and `plan.md`.
    - **Action**: Runs `/plan` and `/split`.
    - **Never**: Writes code directly.

2.  **The "Task" Beads (The Workers)**
    - **Role**: Single, independent unit of work (e.g., "Create UI Component", "Add DB Migration").
    - **Independence**: Must be solvable *without* waiting for other Tasks (unless explicitly blocked).
    - **Context**: Description MUST link to `.beads/artifacts/<EPIC_ID>/plan.md`.

3.  **Dependency Graphing**
    - **Sequential**: If Task B needs Task A's code, `bd create "Task B" --deps blocks:bd-A`.
    - **Parallel (Fan-out)**: If Task A and B are independent, they both just block the Epic.
  - **Agent Swarm**: You can launch multiple terminal tabs, creating a `branchlet` for each Task, and run `/implement` in parallel. Reference the `/land-plane` checklist when wrapping up each bead.


## 9. Context Hygiene
To ensure maximum reliability and avoid context window pollution:
- **Always start a new Amp thread** after running a slash command (e.g., after `/plan` finishes start a new thread for `/implement`, then fresh threads for `/review` and `/land-plane`).
- This ensures the agent focuses only on the current step's artifacts (`plan.md`, `research.md`) without being distracted by the conversation history of previous steps.
- **Command Usage**: Slash commands populate the chat with a prompt template. **Always paste the Bead ID** at the end of the prompt (e.g., `/research bd-a1b2`) before sending.
- **Artifact Discipline**: Treat `plan.md` as immutable after approval (except for `/split` appendices), keep execution deviations and test runs in `implementation.md`, record review outcomes and QA evidence in `review.md`, and use `landing.md` only for landing-time QA revalidation; `sessions/*.md` are optional append-only logs surfaced by `/context` but not required for correctness.

## Summary of Tools
| Tool | Purpose |
| :--- | :--- |
| `bd` | Source of Truth (Status, Title, What) |
| `.md Artifacts` | Context (Research, Plan, Implementation log, Review) - *Stored in .beads/artifacts/* |
| `branchlet` | Isolation (Filesystem, Git state) |
| `slash commands` | Protocol Enforcement (The "Verbs") |

## Slash Command Reference

| Command | Stage | Why/When |
| :--- | :--- | :--- |
| `/bd-create` | Ideation | File new beads with lineage and priority. |
| `/bd-next` | Setup | Select the next bead to execute. |
| `/branchlet-from-bead` | Setup | Create an isolated worktree tied to the bead. |
| `/context` | Setup | Load artifacts and summarize the bead’s current state. |
| `/kb-build` *(optional)* | Setup | Refresh `.beads/kb/` when architecture knowledge is stale. |
| `/spec` *(optional)* | Research | Produce `spec.md` for complex/ambiguous beads before planning. |
| `/research` | Research | Gather references and codify them in `research.md`. |
| `/plan` | Plan | Ask the Oracle for an actionable plan (`plan.md`). |
| `/split` *(conditional)* | Plan | Break composite beads into atomic children. |
| `/implement` | Work | Execute plan steps via the manager/worker loop and log execution details. |
| `/review` | Quality | Verify implementation vs. plan/spec/logs, tag risk, log QA evidence, and emit a Review Capsule. |
| `/land-plane` | Ship | Run quality gates, sync beads, commit/push, and tee up next work. |
| `/bead-notes` *(optional)* | Context Hygiene | Append session summaries to bead notes for future agents. |
