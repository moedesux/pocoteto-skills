#!/usr/bin/env bash
# Install Matt Pocock's skills with the pocoteto patches. pstack comes from the pstack-claude plugin.
#
#   ./install.sh                 Claude Code, user scope   (~/.claude/skills)
#   ./install.sh --project DIR   Claude Code, project scope (DIR/.claude/skills)
#   ./install.sh --agents        Codex, OpenCode and others (~/.agents/skills)
#
# Install the pstack-claude plugin separately (see README).
set -euo pipefail

here="$(cd "$(dirname "$0")" && pwd)"
mode="user"; project=""
case "${1:-}" in
  --project) mode="project"; project="${2:?--project needs a directory}";;
  --agents)  mode="agents";;
  "")        ;;
  *) echo "unknown option: $1" >&2; exit 2;;
esac

case "$mode" in
  user)    skills_dir="$HOME/.claude/skills"; agents_dir="$HOME/.claude/agents";;
  project) skills_dir="$project/.claude/skills"; agents_dir="$project/.claude/agents";;
  agents)  skills_dir="$HOME/.agents/skills"; agents_dir="";;
esac

mkdir -p "$skills_dir"
backup="$skills_dir/.pocoteto-backup-$(date +%Y%m%d-%H%M%S)"

# pstack skills copied in by the old all-in-one bundle. The plugin provides these now,
# so loose copies would load twice. Move them aside, never delete.
old_pstack="architect arena automate-me benchmark-checklist blast-radius bro correct create-verification-skill explain figure-it-out how interrogate ketchup maintain-verification-skill make-bot-ui no-comments poteto-help poteto-mode principle-attack-the-premise principle-boundary-discipline principle-build-the-lever principle-encode-lessons-in-structure principle-exhaust-the-design-space principle-experience-first principle-explain-the-number principle-fix-root-causes principle-foundational-thinking principle-guard-the-context-window principle-laziness-protocol principle-make-operations-idempotent principle-migrate-callers-then-delete-legacy-apis principle-minimize-reader-load principle-model-the-domain principle-never-block-on-the-human principle-outcome-oriented-execution principle-prove-it-works principle-redesign-from-first-principles principle-separate-before-serializing-shared-state principle-sequence-verifiable-units principle-subtract-before-you-add principle-test-behavior-not-implementation principle-type-system-discipline recall reflect setup-pstack show-me-your-work swarm technical-writing typescript-best-practices unslop why "
for name in $old_pstack; do
  if [ -e "$skills_dir/$name" ]; then
    mkdir -p "$backup"; mv "$skills_dir/$name" "$backup/"
  fi
done
if [ -n "$agents_dir" ]; then
  for a in poteto-agent.md comment-sicko.md; do
    if [ -e "$agents_dir/$a" ]; then mkdir -p "$backup/agents"; mv "$agents_dir/$a" "$backup/agents/"; fi
  done
fi

# Back up anything we would overwrite, so a re-install never loses local edits.
for d in "$here"/skills/*/; do
  name="$(basename "$d")"
  if [ -e "$skills_dir/$name" ]; then
    diff -rq "$d" "$skills_dir/$name" >/dev/null 2>&1 && continue  # already up to date
    mkdir -p "$backup"; mv "$skills_dir/$name" "$backup/"
  fi
  cp -R "$d" "$skills_dir/$name"
done

echo "Installed $(ls -d "$here"/skills/*/ | wc -l | tr -d ' ') skills into $skills_dir"
[ -d "$backup" ] && echo "Previous copies moved to $backup"
echo "Next, in each repo: /setup-matt-pocock-skills, /pstack:setup-pstack, /pstack:create-verification-skill,"
echo "then paste AGENTS-snippet.md into CLAUDE.md. Run /flow to start."
