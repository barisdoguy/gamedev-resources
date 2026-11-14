#!/usr/bin/env bash
# Stars every repository listed in the README tables, using the GitHub CLI.
#
#   ./scripts/star-all.sh --dry-run   # list what would be starred
#   ./scripts/star-all.sh             # star them
#
# Requires: gh (https://cli.github.com), signed in with `gh auth login`.
set -euo pipefail

readme="$(cd "$(dirname "$0")/.." && pwd)/README.md"
dry_run=false
[[ "${1:-}" == "--dry-run" ]] && dry_run=true

# Only table rows ("| [owner/repo](https://github.com/owner/repo) | ...").
mapfile -t repos < <(
  grep -E '^\| \[' "$readme" |
    grep -oE 'https://github\.com/[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+' |
    sed 's|https://github.com/||' |
    sort -u
)

echo "${#repos[@]} repositories found in README.md"

if "$dry_run"; then
  printf '  %s\n' "${repos[@]}"
  exit 0
fi

if ! command -v gh >/dev/null 2>&1; then
  echo "error: GitHub CLI (gh) is not installed: https://cli.github.com" >&2
  exit 1
fi
gh auth status >/dev/null 2>&1 || { echo "error: run 'gh auth login' first" >&2; exit 1; }

failed=0
for repo in "${repos[@]}"; do
  if gh api --silent -X PUT "user/starred/${repo}" 2>/dev/null; then
    echo "starred  ${repo}"
  else
    echo "FAILED   ${repo}" >&2
    failed=$((failed + 1))
  fi
done

echo "done: $(( ${#repos[@]} - failed )) starred, ${failed} failed"
[[ "$failed" -eq 0 ]]
