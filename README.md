# pocoteto

Matt Pocock's skills and poteto's pstack, working as one pipeline. This bundle holds Matt's skills with the pocoteto patches. pstack comes from the **pstack-claude plugin**, installed unchanged; the pstack-side changes live in `AGENTS-snippet.md`, a CLAUDE.md block the plugin follows.

Matt's skills own alignment: interviewing you, a shared glossary, a spec, and tickets. pstack owns execution: playbooks, delegation, proof on the real surface, adversarial review, and merging. The two packs ha## Upstream

| Pack | Source | How |
| --- | --- | --- |
| Matt Pocock skills | `github.com/mattpocock/skills` (engineering + productivity), pinned `49dd158` | Files in `skills/`, rebuilt by `rebuild.sh` from `patches/` |
| pstack | `michael-denyer/pstack-claude` plugin (community Claude Code port) | Installed as a plugin, updated the plugin way. Not in this bundle. |

Both are MIT.

> The "What changed" tables below describe the original all-in-one bundle. In this version the pstack-side rows (`/explain` rename, poteto-mode and playbook edits, the `correct` table location, poteto-help links) are rules in `AGENTS-snippet.md` instead of file edits, and pstack's one-shot explainer is `/pstack:teach`.

 the standalone mirror of `cursor/plugins/pstack` | `fce11a3`, 2026-10-12 |

Both are MIT. All changes live in `patches/` as twelve small commits, so you can read each one on its own.

## What changed

### Collisions resolved

| Problem | Fix |
| --- | --- |
| Both packs ship a skill named `tdd` | Kept Matt's, which covers features and bugs. pstack's bug-fix guardrails moved into it: skip a test that would be bad, use the closest executable check, report red-then-green evidence. |
| Both packs ship a skill named `teach`, with different jobs | Matt's `/teach` (learn a topic over sessions) keeps the name. pstack's one-shot explainer is now `/explain`. `poteto-help` links updated. |
| Matt's `tdd` asks you to confirm test seams. pstack's `never-block-on-the-human` says don't ask | `tdd` takes seams from the ticket's Proof line. Inside `/poteto-mode` or an unattended run it picks seams and reports them instead of asking. |
| Grilling skills exist to ask questions. poteto-mode tells the agent not to | poteto-mode and the principle now say an interview the user asked for is exempt. The rule governs the build that follows. |
| `diagnosing-bugs` and `pr` are model-invoked, so they fired inside poteto-mode's Bug fix and Opening a PR playbooks | Their descriptions now step aside inside `/poteto-mode`. Opening a PR absorbed `pr`'s door call and Summary visual. |
| Two routers (`ask-matt`, `poteto-help`), each blind to the other pack | New `/flow` router over both. The old routers point to it for cross-pack questions. |

### Bridges added

| Gap | Fix |
| --- | --- |
| pstack verifies against "the real artifact" but nothing says which one | `to-tickets` and `triage` briefs give every ticket a **Proof** line: the surface to drive and the result to observe. "Tests pass" doesn't count. |
| poteto-mode ignored specs, tickets, and the glossary | Feature playbook step 1 and a new Non-negotiable read the ticket, `GLOSSARY.md`, and ADRs first. Names come from the glossary. Missing terms get reported for the next `/grill-with-docs`. |
| Matt's `implement` stopped at tests plus `code-review` | `implement` and `implement-spec` close out with the Proof check on the real surface, then `code-review`, then `interrogate` (multi-model attack). `implement-spec` re-runs every Proof on the integration branch after merges. |
| poteto-mode's review never checked the diff against the spec | Feature playbook step 7 runs `code-review`'s Spec axis before `interrogate`. |
| Prototypes evaporated | pstack's Prototype playbook uses Matt's `prototype` artifact shapes and keeps losing variants on a `prototype/<name>` branch. |
| PR bodies didn't link tickets or call one-way doors | Opening a PR adds `Closes #<n>`, the door call in Blast Radius, before/after Verification, and the Proof as the first check. |
| `retro` found problems and stopped | `retro` ends by naming the command for each finding: `/correct`, `/reflect`, `/improve-codebase-architecture`, or `/grill-with-docs`. |
| `correct` wrote its rule table into `CLAUDE.md`, which Matt keeps minimal | The table goes in `CODING_STANDARDS.md`, which `code-review` reads at review time. `CLAUDE.md` gets a one-line pointer. |

## Install into a repo

From the repo's root:

```bash
curl -fsSL https://raw.githubusercontent.com/moedesux/pocoteto-skills/main/setup.sh | bash
```

That puts Matt's skills in `.claude/skills/`, turns on the pstack plugin in `.claude/settings.json`, and adds the pocoteto rules to `CLAUDE.md`. Commit those, so every clone and every cloud agent gets the same setup. Re-run it any time to update.

Then open Claude Code in the repo:

1. Accept the prompt to install the pstack plugin. If none appears: `/plugin marketplace add michael-denyer/pstack-claude`, then `/plugin install pstack@pstack-claude`.
2. `/setup-matt-pocock-skills` (tracker, labels, glossary location)
3. `/pstack:setup-pstack` (models per role)
4. `/pstack:create-verification-skill` (a project `verify` skill the Proof checks use)
5. `/flow` to start.

If you had the old marketplace `mattpocock-skills` plugin, uninstall it so Matt's skills don't load twice.

Agents: see [AGENTS.md](AGENTS.md).

**For all your repos instead of one:** `./install.sh` installs the skills user-wide (`~/.claude/skills`). You still need the plugin and the `CLAUDE.md` block per repo, so `setup.sh` is usually the better choice.

## Updating

```bash
./rebuild.sh ./build            # reproduce this bundle at the pinned upstream commits
./rebuild.sh --latest ./build   # then rebase the patches onto the newest upstream
```

The pin (`MATT_PIN`) is at the top of `rebuild.sh`. `--latest` rebases with a three-way merge, so an upstream change near a patched line usually still applies. On a real conflict it stops and names the file: resolve it in `./build`, then `git rebase --continue`. When it's clean, copy `build/skills` over `skills/`, regenerate `patches/` as the script header shows, update the pins, and re-run `install.sh`.

## Not included

From Matt: the `in-progress`, `misc`, and `deprecated` folders. pstack is not bundled at all; the plugin brings its own skills, agents, docs and hooks.
