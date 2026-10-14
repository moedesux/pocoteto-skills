# Project brief: Matt Pocock skills + pstack ("pocoteto")

The state of the work so far, for picking it up in a new chat. Last updated 2026-10-14.

## Goal

Use Matt Pocock's agent skills and poteto's pstack together as one pipeline. Matt's skills own **alignment**: grilling, a glossary, the spec, and tracer-bullet tickets. pstack owns **execution**: poteto-mode playbooks, architect and arena design, proof on the real surface, interrogate, and merging. The bridge between them is the ticket's **Proof** line.

## Decisions made

| Decision | Choice | Why |
| --- | --- | --- |
| Matt source | **His repo as editable files** (`mattpocock/skills`, pinned `49dd158`), not the plugin | The official-marketplace plugin is pinned to `c55ee46` (Sep 18, v1.2.3). It has no `implement-spec`, `pr`, or `retro`, and still uses `CONTEXT.md` rather than `GLOSSARY.md`. Matt's own marketplace tracks main but is read-only. |
| pstack source | **Open.** Option 1: fork `michael-denyer/pstack-claude` and patch it. Option 2: install that plugin as-is and add a thin bridge layer. | See "Open question". The current bundle uses the `backnotprop/pstack` mirror (Cursor-oriented). |
| Name collisions | Matt's `tdd` kept, absorbing pstack's bad-test escape and evidence report. Matt's `teach` keeps the name. pstack's one-shot teach becomes `/explain`. | Both packs shipped `tdd` and `teach`. |
| Ticket order | `/to-spec` then `/to-tickets` stay adjacent. `/to-tickets` now writes a **shape sketch** (data shape and named seams) and cuts slices along it. | Field test: tickets cut before design left ticket 02 already done by ticket 01. |
| Ticket rules | `skills/to-tickets/WORKING-A-TICKET.md`, used by `implement` and `implement-spec` | See below. |

## Ticket rules (adopted)

1. **Gate.** Run the ticket's Proof before starting. Some checks fail: build those. All pass: the ticket becomes **verify-only** (Proof plus the code-review Spec axis), and it is never auto-closed. The gate narrows a ticket. It never widens one.
2. **Ownership.** Each criterion has one owning ticket. Build only your own. Note a side effect on the other ticket, and don't claim it.
3. **New behaviour goes through the spec.** If the spec already says it, it joins the owning ticket with the spec line quoted. If not, amend the spec and cut a new ticket (ask first, or mark it `ASSUMED` when unattended).
4. **A contradiction stops the work.** If your ticket would break another ticket's criterion, stop and report it. That is a spec conflict, not an implementer's choice.
5. **Regression.** Closing a ticket re-runs the Proof of every ticket closed before it.
6. **Shared seams serialize.** Tickets whose `Touches:` lines name the same seam don't run in parallel.

## Field test (python-markdown2, `abbr` extra)

- **Result:** 4 commits. 297 tests OK (baseline 288). The known-failing `Abbr` fixture passes. All 26 Proof checks pass. Output is unchanged with the extra off. Verified independently.
- **What helped:** Proof lines (a red baseline before any code, and they exposed the stale ticket). Arena (caught a quadratic regex: 0.54 s vs 0 s at 8,000 characters). Interrogate (about 3 solid bugs that the tests, Proofs, and code-review all missed).
- **What chafed:**
  - Tickets were cut before the design (now fixed).
  - `/flow` and poteto-mode disagree on unattended work: Feature vs figure-it-out (open).
  - to-tickets' "no file paths" rule clashed with the Proof line (fixed: Proof lines are exempt).
  - The grilling exemption doesn't cover a self-run interview (open).
  - The interrogate gate differs between the Feature playbook and `implement` (open).
- **Harness issues** (not the merge): Cursor-oriented pstack, Claude-only models, and no human present.
- Evaluators: Sonnet and Haiku, independent. Fable was unavailable without usage credits.

## Open question: pstack as a forked repo (1) or a plugin plus bridge (2)

Pending discussion. The considerations are in the chat. Key facts:

- `pstack-claude` is a **community port by Michael Denyer**, not poteto or Anthropic. It's at v0.9.84 with 47 declared forks of upstream, adds `deslop`, `babysit`, and `fix-ci`, and is Claude Code native.
- **The plugin's SessionStart hook** tells Claude to route any multi-file, design, or unknown-cause task through `pstack:poteto-mode`. Its `tdd`, `teach`, and `poteto-mode` are model-invocable. Its hook defers to CLAUDE.md, and `/setup-pstack` can turn routing off.
- **Upstream moves fast.** The pstack mirror changed overnight (to `1f0f9c3`, pstack 0.15.23). `rebuild.sh` now pins upstream commits and offers `--latest`, which rebases the patches with a 3-way merge. That rebase was clean this time.

## Still to do

- Decide 1 vs 2. Then port the pstack-side bridges: the Feature playbook reading ticket/Proof/glossary, the gate when building via poteto-mode, and the grilling exemption.
- Fix the open seams from the field test (above).
- Re-run the same `abbr` task on the new setup and compare it with the first run.

## Files

The bundle (`pocoteto/`) contains:

- `skills/`: 79 skills, plus the new `flow` and `to-tickets/WORKING-A-TICKET.md`.
- `patches/`: 12 commits against upstream.
- `install.sh` and `rebuild.sh`.
- `README.md` (what changed and why).
- `AGENTS-snippet.md`.

The field-test record is in `field-test.zip`.
