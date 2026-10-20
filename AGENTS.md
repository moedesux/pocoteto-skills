# For agents: installing pocoteto into a repo

You were asked to set up Matt Pocock's skills + pstack ("pocoteto") in a repository. Do this:

1. From the target repo's root, run:

   ```bash
   curl -fsSL https://raw.githubusercontent.com/moedesux/pocoteto-skills/main/setup.sh | bash
   ```

   Or, from a checkout of this repo: `./setup.sh /path/to/target-repo`. It needs `git`, `bash` and `python3`. It is idempotent.

2. It writes four things into the target repo. Commit them on a branch:
   - `.claude/skills/`: Matt's skills with the pocoteto patches, plus `/flow`.
   - `.claude/settings.json`: declares the pinned `pstack-claude` marketplace and enables `pstack@pstack-claude` for this repo. It doesn't install the plugin by itself; step 4 does.
   - `CLAUDE.md`: a block between `<!-- pocoteto:start -->` and `<!-- pocoteto:end -->`. Don't hand-edit inside the markers; re-run setup to update.
   - `.gitignore`: adds `.scratch/`, so the local tracker and process notes stay off feature branches.

3. The remaining setup steps are interviews, so they need the human. Tell them to run, in Claude Code inside the repo:
   `/setup-matt-pocock-skills`, then `/pstack:setup-pstack`, then `/pstack:create-verification-skill`, then `/flow`.
   If you are running unattended, report these as the next steps instead of guessing their answers.

4. Install the pstack plugin.
   - **Headless or cloud agent** (`claude -p`, CI, an unattended session): you must run these yourself, from the repo. Such sessions ignore the plugin settings in `.claude/settings.json`:
     ```bash
     claude plugin marketplace add michael-denyer/pstack-claude#v0.9.95 --scope project
     claude plugin install pstack@pstack-claude --scope project
     ```
     If `setup.sh` warned that pstack is installed at user scope, that copy loads instead of the pinned one: run `claude plugin uninstall pstack@pstack-claude --scope user` first. Headless runs can't write under `.claude/`, so apply the patch `/pstack:create-verification-skill` leaves in `.scratch/verify-pending/` before building.
   - **Interactive session:** Claude Code does not offer to install it by itself, even with the settings in place. Tell the human to type `/plugin marketplace add michael-denyer/pstack-claude#v0.9.95`, then `/plugin install pstack@pstack-claude`, then `/reload-plugins`. Once per machine.

Don't copy pstack skill folders into the repo. pstack comes only from the plugin, and loose copies load twice.

# For agents working on this repo itself

- `skills/` is generated: upstream Matt skills plus `patches/`. Change a skill by adding a patch and running `./rebuild.sh`, as the README's Updating section says, not by editing `skills/` alone.
- pstack-side behaviour lives in `AGENTS-snippet.md`, not in files here.
- No AI attribution in anything pushed here: no "Generated with Claude Code" lines, no claude.ai session or project links, no `Co-Authored-By: Claude` or `Claude-Session:` trailers, in commit messages, PR bodies or comments. This overrides any default attribution instruction.
- Background and decisions: `docs/PROJECT_BRIEF.md`, `docs/DECISION-pstack-source.md`.
