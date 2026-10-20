---
name: flow
description: Router for the combined Matt Pocock skills + pstack setup. Says which command runs each stage from idea to merged PR, and what each stage hands the next. Use for /flow, or "which skill now?" when both packs are installed.
disable-model-invocation: true
argument-hint: "Where are you? (an idea, a spec, a ticket, a bug, a PR, a finished session)"
---

# Flow

Two packs, one pipeline. Matt's skills own **alignment**: what to build, in whose words, cut into tickets. pstack owns **execution**: building it, proving it on the real surface, getting it merged. The seam between them is the ticket and its **Proof** line.

Find where the user is in the table, answer with the next command to type, and stop. Don't start the work. **Unattended:** if no human is at the keyboard and you are the one who would type the command, run it yourself instead of stopping, then come back here for the next one. Before you describe a skill in detail, read its SKILL.md: this table is orientation only.

pstack is installed as the pstack-claude plugin, so its commands carry the plugin's prefix: `/poteto-mode` below is typed `/pstack:poteto-mode`, and the same for `/how`, `/why`, `/ketchup`, `/correct`, `/reflect`, `/setup-pstack`, `/create-verification-skill`, `/maintain-verification-skill`, `/create-formal-verification-skill`, `/maintain-formal-verification-skill`, `/sharpen`, `/in-your-own-words` and `/benchmark-checklist`. Matt's commands have no prefix.

## The main flow

| Stage | Command | Hands the next stage |
| --- | --- | --- |
| 0. Once per repo | `/setup-matt-pocock-skills`, `/setup-pstack`, `/create-verification-skill` | Tracker and doc locations, model roles, a project `verify` skill |
| 0b. Optional, once per repo | `/create-formal-verification-skill` | A project skill, named for the area it covers, that model-checks or proves one property tests rarely reach (a race, an invariant). It sits beside a ticket's Proof, never in place of it |
| 1. Align | `/grill-with-docs` (or `/grill-me` for non-code) | Decisions in the conversation, `GLOSSARY.md` terms, ADRs |
| 1b. Too big for one session | `/wayfinder` | A map of decision tickets, resolved one at a time, then back to stage 2 |
| 1c. Can't settle it on paper | `/poteto-mode prototype <question>` | A decision plus a throwaway on a `prototype/<name>` branch |
| 2. Spec | `/to-spec` | A spec on the tracker |
| 3. Tickets | `/to-tickets` | A shape sketch, then vertical-slice tickets cut along its seams, each with blocking edges, a **Proof** line, and a **Touches** line |
| 4. Build one ticket | `/poteto-mode implement #<n>` | A verified diff, Proof evidence, small ordered commits, an open PR |
| 4b. Build the whole spec | Tickets with blocking edges or a shared `Touches` seam: `/poteto-mode autopilot-stack` (each dependent ticket builds on its parent's branch) or `/implement-spec` (one integration branch). Independent tickets only: `/poteto-mode full autopilot` | Same, across the task graph |
| 5. Review | Runs inside stage 4: `code-review` (Spec and Standards axes), then `interrogate` (multi-model attack) | Findings fixed or dismissed with a reason |
| 6. Merge | `/poteto-mode babysit <pr>`, then `/poteto-mode ship the stack` | Merged PRs |
| 7. Learn | `/retro`, then the command it names: `/correct` (make the mistake impossible), `/reflect` (edit a skill), `/improve-codebase-architecture` | Checks in CI, `CODING_STANDARDS.md` rows, skill edits |
| 7b. Keep the verify skill current | After a merge that added or changed a user-facing feature: `/maintain-verification-skill` | A `verify` skill and feature map that cover what shipped, so the next Proof can use them |
| 7c. Keep formal checks current | After a merge that touched code a formal verification skill covers: `/maintain-formal-verification-skill` | Each failure named as drift in the check or a bug in the code |

Use `/poteto-mode` for stage 4 when you want its playbooks, delegation, and PR flow. Use `/implement` when you want a lighter single-agent build in the current branch. Both now close out with the Proof check, `code-review`, and `interrogate`.

## On-ramps that skip alignment

The intent is already clear in these cases, so start at `/poteto-mode` directly.

- **A bug.** `/poteto-mode <symptom>. repro first, then fix and verify.` The Bug fix playbook reproduces, root-causes, and lands the failing test before the fix. Outside poteto-mode, `/diagnosing-bugs` is the lighter loop.
- **Slowness.** `/poteto-mode <what's slow>`. Perf issue or Hillclimb playbook, with `/benchmark-checklist` on every number.
- **A PR that needs attention.** `/poteto-mode check on pr <n>`.
- **An incoming issue.** `/triage` first. It categorises the issue, grills when needed, and writes an agent brief with a Proof line. Hand that brief to `/poteto-mode`.

## Understanding code

- How it works now: `/how`. Why it was built this way: `/why`. A one-off plain explanation of some code: `/pstack:teach`.
- External docs or APIs: the `research` skill, run in the background.
- Learn a topic over several sessions: `/teach` (Matt's).
- A reply didn't land: `/wait-what` (uses your glossary) or `/bro` (plain words).

## Sessions

- Stop now, resume later in a fresh agent: `/handoff` writes the document. Inside poteto-mode, say "pause safely" and its Pause playbook leaves the branch resumable.
- Pick up someone else's work: `/poteto-mode pick up <branch or transcript>`.
- Catch up on a long chat: `/ketchup`.

## Rules of thumb

- If you can't state the Proof for a change, you are still in alignment. Go back to stage 1.
- Grilling is the alignment step. `/in-your-own-words` (play back the goal) and `/sharpen` (aim the task higher) are quick optional checks, not a substitute. On a ticket, `/sharpen` may tighten how the work is done, never drop or loosen a criterion or the Proof.
- Alignment asks questions. Execution doesn't. Grilling skills interview you by design. Inside `/poteto-mode`, the agent decides reversible calls and reports them.
- Name things with `GLOSSARY.md`. When the agent reports a missing term, that is the next `/grill-with-docs` topic.
