#!/usr/bin/env bash
# Set up a repo for Matt Pocock's skills + pstack (pocoteto) in one step.
#
#   ./setup.sh [REPO_DIR]          from a checkout of this repo
#   curl -fsSL https://raw.githubusercontent.com/moedesux/pocoteto-skills/main/setup.sh | bash
#   curl -fsSL https://raw.githubusercontent.com/moedesux/pocoteto-skills/main/setup.sh | bash -s -- REPO_DIR
#
# REPO_DIR defaults to the current directory. It writes, inside REPO_DIR:
#   .claude/skills/          Matt's skills with the pocoteto patches, plus /flow
#   .claude/settings.json    asks Claude Code to install the pstack-claude plugin for this repo
#   CLAUDE.md                the pocoteto block, between pocoteto:start/end markers
# Safe to re-run: it replaces its own block and backs up skill folders it overwrites.
# Commit the results so every clone and teammate gets the same setup. Headless and cloud
# sessions don't act on the plugin settings: they must run the `claude plugin` commands printed at the end.
set -euo pipefail

SOURCE_REPO="${POCOTETO_REPO:-https://github.com/moedesux/pocoteto-skills}"
# pstack is pinned to a release tag of the pstack-claude marketplace (v0.9.84 = commit 990cd7b).
# Bump it on purpose, after reviewing the upstream diff: see the README's Updating section.
PSTACK_REF=v0.9.84
target="$(cd "${1:-.}" && pwd)"

# Find the bundle: next to this script, or a fresh shallow clone when piped from curl.
here=""
src_dir="$(dirname "${BASH_SOURCE[0]:-/nonexistent/x}")"
if [ -f "$src_dir/install.sh" ] && [ -f "$src_dir/AGENTS-snippet.md" ] && [ -d "$src_dir/skills/flow" ]; then
  here="$(cd "$src_dir" && pwd)"
else
  tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT
  git clone -q --depth 1 "$SOURCE_REPO" "$tmp/pocoteto"
  here="$tmp/pocoteto"
fi

echo "pocoteto: setting up $target"

# 1. Skills, project scope.
POCOTETO_QUIET_NEXT=1 bash "$here/install.sh" --project "$target"

# 2. Ask Claude Code to install pstack for this repo. Claude Code reads these keys
#    and offers to install the plugin when the repo is trusted.
settings="$target/.claude/settings.json"
mkdir -p "$target/.claude"
[ -s "$settings" ] || echo '{}' > "$settings"
python3 - "$settings" "$PSTACK_REF" <<'PY'
import json, sys
p = sys.argv[1]
s = json.load(open(p))
s.setdefault("extraKnownMarketplaces", {})["pstack-claude"] = {
    "source": {"source": "github", "repo": "michael-denyer/pstack-claude", "ref": sys.argv[2]}
}
s.setdefault("enabledPlugins", {})["pstack@pstack-claude"] = True
json.dump(s, open(p, "w"), indent=2)
open(p, "a").write("\n")
PY
echo "Wrote pstack plugin settings to $settings (pinned to $PSTACK_REF)"

# 3. CLAUDE.md block (replaced in place on re-run).
claude_md="$target/CLAUDE.md"
touch "$claude_md"
python3 - "$claude_md" "$here/AGENTS-snippet.md" <<'PY'
import re, sys
path, snippet_path = sys.argv[1], sys.argv[2]
snippet = open(snippet_path).read().strip()
snippet = re.sub(r"^<!--.*?-->\s*", "", snippet, flags=re.S)  # drop the paste instructions
block = "<!-- pocoteto:start (managed by pocoteto setup.sh; re-run it to update) -->\n" + snippet + "\n<!-- pocoteto:end -->"
text = open(path).read()
pattern = re.compile(r"<!-- pocoteto:start.*?<!-- pocoteto:end -->", re.S)
if pattern.search(text):
    text = pattern.sub(lambda _: block, text)
else:
    text = (text.rstrip() + "\n\n" if text.strip() else "") + block + "\n"
open(path, "w").write(text)
PY
echo "Updated the pocoteto block in $claude_md"

# 4. Keep the local tracker and other process files off feature branches.
gitignore="$target/.gitignore"
touch "$gitignore"
if ! grep -qxF '.scratch/' "$gitignore"; then
  [ -s "$gitignore" ] && [ -n "$(tail -c1 "$gitignore")" ] && echo >> "$gitignore"
  echo '.scratch/' >> "$gitignore"
  echo "Added .scratch/ to $gitignore"
fi

cat <<EOF

Done. Next, open Claude Code in this repo and:
  1. Accept the prompt to install the pstack plugin. No prompt? Run:
       /plugin marketplace add michael-denyer/pstack-claude#$PSTACK_REF
       /plugin install pstack@pstack-claude
     Headless or cloud agent (claude -p, CI)? It never sees the prompt. Run, in the repo:
       claude plugin marketplace add michael-denyer/pstack-claude#$PSTACK_REF --scope project
       claude plugin install pstack@pstack-claude --scope project
  2. /setup-matt-pocock-skills        (tracker, labels, glossary location)
  3. /pstack:setup-pstack             (models per role)
  4. /pstack:create-verification-skill (a verify skill the Proof checks use)
  5. /flow                            (which command to run next)
Commit .claude/, CLAUDE.md and .gitignore so every clone gets the same setup.
EOF
