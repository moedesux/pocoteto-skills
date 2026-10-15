<!-- setup.sh writes this into CLAUDE.md for you. To do it by hand, paste it into CLAUDE.md or AGENTS.md.
     pstack-claude's startup hook says CLAUDE.md takes precedence, so these rules steer pstack's playbooks. -->

### Matt Pocock skills + pstack (pocoteto)

Matt's skills own alignment (grilling, `GLOSSARY.md`, spec, tickets). pstack, installed as the pstack-claude plugin, owns execution (`/pstack:poteto-mode`). The seam is the ticket's **Proof** line: work isn't done until it's been observed on that surface. Run `/flow` for the next command.

**Which skill wins.**
- Tests: Matt's `tdd`, not `pstack:tdd`.
- Learning a topic over several sessions: Matt's `/teach`. A one-off plain explanation of some code: `/pstack:teach`.
- Cross-pack "which command now?": `/flow`, not `ask-matt` or `pstack:poteto-help`.
- Rules the agent keeps breaking go in `CODING_STANDARDS.md` (create it if it doesn't exist), which `code-review` enforces. When `pstack:correct` adds a rule table, put it there and leave a one-line pointer here.

**Inside `pstack:poteto-mode`, on any playbook:**
1. If a ticket, spec, or `GLOSSARY.md` exists for the work, read it before the playbook's first step, with the ADRs in the area. Glossary terms name every type and function you introduce. If a term is missing or ambiguous, use the closest one and list the gap in your reply for the next `/grill-with-docs`. Don't invent vocabulary.
2. Building from a ticket follows `to-tickets/WORKING-A-TICKET.md`: run the Proof first as a gate (all green means verify-only, never auto-close), build only your own criteria, new behaviour goes through the spec, stop on a contradiction, re-run every earlier Proof at close, and don't build tickets with the same `Touches:` seam in parallel.
3. Verify step: the ticket's Proof line is the surface and the result to observe. Wrong surface or inconclusive is not a pass.
4. Review step: when a ticket or spec exists, run `code-review` and read its Spec axis (built what was asked, no more), then `interrogate` whenever the diff is nontrivial or the design is contested. Same close-out as Matt's `implement`.
   - When to interrogate: once per ticket when tickets ship as separate PRs; once over the whole branch when they ship together.
   - Before `interrogate`, when the change adds an option, extra, plugin or flag to something that has others, probe it switched on together with each of the others, not only alone.
   - No helper agents available (no way to start a subagent or another model): do one labelled self-review pass, record `BLOCKED: independent review` in the report and the PR, and don't call the branch merge-ready.
5. Opening a PR: end Why with `Closes #<n>`; open Blast Radius with the door call (**one-way** = hard to roll back, **two-way** = a revert undoes it); Verification's first bullet runs the Proof, shown before and after. `diagnosing-bugs` and `pr` step aside inside poteto-mode.
6. Prototype playbook: follow Matt's `prototype` skill (`UI.md` or `LOGIC.md`) for the artifact's shape, and keep losing variants on a `prototype/<name>` branch linked from the ticket.
7. Unattended ticketed builds use the Feature playbook, not figure-it-out.
8. Process files stay off the feature branch. Tickets in `.scratch/`, grilling notes, alignment docs and the retro don't go in the feature commits or the PR diff. `setup.sh` gitignores `.scratch/`; if the notes must be kept, commit them on a separate branch.

**Never-block applies to builds, not interviews.** When the user runs `/grill-me`, `/grill-with-docs`, `/wayfinder`, `/triage`, `/to-questionnaire` or `/improve-codebase-architecture`, asking questions is the job. In an unattended run that interviews itself, answer each question from evidence and record it as `ASSUMED (evidence: …)`.
