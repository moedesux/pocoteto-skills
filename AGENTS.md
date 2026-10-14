# For agents: installing pocoteto into a repo

You were asked to set up Matt Pocock's skills + pstack ("pocoteto") in a repository. Do this:

1. From the target repo's root, run:

   ```bash
   curl -fsSL https://raw.githubusercontent.com/moedesux/pocoteto-skills/main/setup.sh | bash
   ```

   Or, from a checkout of this repo: `./setup.sh /path/to/target-repo`. It needs `git`, `bash` and `python3`. It is idempotent.

2. It writes three things into the target repo. Commit them on a branch:
   - `.claude/skills/`: Matt's skills with the pocoteto patches, plus `/flow`.
   - `.claude/settings.json`: enables the `pstack@pstack-claude` plugin, so Claude Code installs pstack for this repo.
   - `CLAUDE.md`: a block between `<!-- pocoteto:start -->` and `<!-- pocoteto:end -->`. Don't hand-edit inside the markers; re-run setup to update.

3. The remaining setup steps are interviews, so they need the human. Tell them to run, in Claude Code inside the repo:
   `/setup-matt-pocock-skills`, then `/pstack:setup-pstack`, then `/pstack:create-verification-skill`, then `/flow`.
   If you are running unattended, report these as the next steps instead of guessing their answers.

4. If pstack's `/pstack:` commands are missing after a restart, the plugin wasn't installed. Run `/plugin marketplace add michael-denyer/pstack-claude` and `/plugin install pstack@pstack-claude`.

Don't copy pstack skill folders into the repo. pstack comes only from the plugin, and loose copies load twice.

# For agents working on this repo itself

- `skills/` is generated: upstream Matt skills plus `patches/`. Change a skill by adding a patch and running `./rebuild.sh`, as the README's Updating section says, not by editing `skills/` alone.
- pstack-side behaviour lives in `AGENTS-snippet.md`, not in files here.
- Background and decisions: `docs/PROJECT_BRIEF.md`, `docs/DECISION-pstack-source.md`.
