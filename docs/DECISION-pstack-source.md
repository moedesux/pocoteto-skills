# pstack source: fork (1) or plugin + bridge (2)

**Decided: option 2, plugin + bridge** (M confirmed 2026-10-14). Built in `bundle-v2/`; the bridge is `bundle-v2/AGENTS-snippet.md`.

## Which patches touch pstack

| Patch | Side | Under option 2 |
| --- | --- | --- |
| 0001 teach → explain | pstack (rename + poteto-help links) | Not needed: plugin skills are namespaced (`pstack:teach`), so no hard collision. Precedence line in the bridge. |
| 0002 tdd | Matt | Kept. Bridge says use Matt's `tdd` over `pstack:tdd`. |
| 0003, 0004, 0012 | Matt | Kept as-is. |
| 0007 correct | pstack (correct is a pstack skill) | Bridge rule: rule table goes in CODING_STANDARDS.md. |
| 0005 poteto-mode, feature, opening-a-pr, prototype, never-block | pstack | The whole of it becomes bridge rules 1–6 + the interview exemption. |
| 0006 diagnosing-bugs, pr, retro | Matt | Kept. |
| 0008 flow, triage | Matt + new | Kept. `/flow` needs `poteto-mode` → `pstack:poteto-mode` wording. |
| 0009 ask-matt / poteto-help | both | Matt half kept; poteto-help half → bridge precedence line. |
| 0010 poteto-help guide links | pstack | Not needed: a plugin install keeps its own docs. |
| 0011 prototype playbook | pstack | Bridge rule 6. |

So 7 of 12 patches are Matt-only, and every pstack-side change is additive instruction text, not structural surgery. Nothing requires a fork.

## Why 2

- pstack-claude ships fast (v0.9.84, and the mirror it tracks changed overnight). A fork of a community fork means rebasing two upstreams forever.
- The plugin's SessionStart hook defers to CLAUDE.md, so a CLAUDE.md block is a supported override point.
- It is Claude Code native, which removes the "Cursor-oriented pstack" harness problem from the field test. It also brings `deslop`, `babysit`, `fix-ci`, which the bundle currently lacks.
- `rebuild.sh` shrinks to Matt only: one pin, half the conflict surface.

## Cost and fallback

- Bridge rules live outside the playbooks, so they may be followed less reliably at the exact step. The abbr re-run is the test: if poteto-mode skips the ticket read, the Proof gate or the Spec axis, fork only `poteto-mode/` (feature.md, opening-a-pr.md, SKILL.md) as a local override skill, not the whole plugin.
- Not yet verified against pstack-claude's actual files (this session had no access to that repo). Before install, check that its playbook names and the `tdd`/`teach` model-invocable descriptions match what the bridge assumes.

## Next steps under 2

1. Check pstack-claude's poteto-mode layout against the bridge draft (`bundle-v2/AGENTS-snippet.md`).
2. Split `rebuild.sh` to Matt only; drop pstack skills from `skills/` and `install.sh`; drop patches 0001, 0005, 0010, 0011 and the pstack half of 0009.
3. Fold the open field-test seams into the bridge (unattended Feature vs figure-it-out and the self-run interview are drafted; the interrogate gate is aligned in rule 4).
4. Re-run the abbr task and compare with the first run.
