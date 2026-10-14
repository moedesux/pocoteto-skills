#!/usr/bin/env bash
# Rebuild skills/ from Matt Pocock's upstream and re-apply the pocoteto patches.
# pstack is not rebuilt here: it comes from the pstack-claude plugin.
#
#   ./rebuild.sh [OUT_DIR]            rebuild at the pinned upstream commits (reproducible)
#   ./rebuild.sh --latest [OUT_DIR]   rebuild, then rebase the patches onto the latest upstream
#
# Default OUT_DIR: ./build. Pinned commits live in UPSTREAM below.
# --latest uses git rebase (3-way). If a patch conflicts, it stops and names the
# file. Resolve it in OUT_DIR, then `git rebase --continue`. When it's clean,
# copy OUT_DIR/skills over skills/, regenerate patches/ with
#   git -C OUT_DIR format-patch -o "$PWD/patches" upstream-latest..HEAD -- skills
# and update MATT_PIN with the commit it printed.
set -euo pipefail

MATT_PIN=49dd158      # mattpocock/skills

here="$(cd "$(dirname "$0")" && pwd)"
latest=0
if [ "${1:-}" = "--latest" ]; then latest=1; shift; fi
out="$(mkdir -p "${1:-$here/build}" && cd "${1:-$here/build}" && pwd)"
src="$(mktemp -d)"
trap 'rm -rf "$src"' EXIT

git clone -q --depth 200 https://github.com/mattpocock/skills.git "$src/matt"

# Lay out one upstream snapshot into $out (skills/ only).
layout() {
  local matt_ref="$1"
  git -C "$src/matt" checkout -q "$matt_ref"
  rm -rf "$out/skills"
  mkdir -p "$out/skills"
  cp -R "$src"/matt/skills/engineering/*/ "$out/skills/"
  cp -R "$src"/matt/skills/productivity/*/ "$out/skills/"
}

g() { git -C "$out" -c user.name=pocoteto -c user.email=pocoteto@localhost "$@"; }

rm -rf "$out/.git"
layout "$MATT_PIN"
g init -q
g add -A
g commit -qm "upstream: mattpocock/skills $MATT_PIN"
g tag upstream-pinned
g am -q --3way "$here"/patches/*.patch
echo "Rebuilt at pin (matt $MATT_PIN) in $out"

if [ "$latest" = 1 ]; then
  matt_new="$(git -C "$src/matt" rev-parse --short origin/HEAD)"
  g branch -q patched
  g checkout -q --detach upstream-pinned
  layout "$matt_new"
  g add -A
  g commit -qm "upstream: mattpocock/skills $matt_new"
  g tag upstream-latest
  g checkout -q patched
  echo "Rebasing patches onto matt $matt_new"
  g rebase -q upstream-latest
  echo "Clean. Set MATT_PIN=$matt_new, then regenerate patches/ (see header)."
fi
