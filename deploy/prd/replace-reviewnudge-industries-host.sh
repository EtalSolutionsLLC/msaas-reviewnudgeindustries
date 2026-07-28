#!/usr/bin/env bash
set -euo pipefail

cd -- "${1:-.}"

old_host='industries.reviewnudge.etal.solutions'
new_host='reviewnudgeindustries.etal.solutions'
script_name="$(basename -- "$0")"

mapfile -d '' files < <(
  rg --files-with-matches --null --hidden --no-ignore \
    --glob '!.git/**' \
    --glob '!**/.git/**' \
    --glob '!node_modules/**' \
    --glob '!**/node_modules/**' \
    --glob '!deploy/**' \
    --glob '!**/deploy/**' \
    --glob "!**/${script_name}" \
    --fixed-strings "$old_host" .
)

if (( ${#files[@]} == 0 )); then
  printf 'No occurrences of %s found.\n' "$old_host"
  exit 0
fi

printf 'Updating %d file(s):\n' "${#files[@]}"
printf '  %s\n' "${files[@]}"

perl -pi -e \
  's/\Qindustries.reviewnudge.etal.solutions\E/reviewnudgeindustries.etal.solutions/g' \
  -- "${files[@]}"

printf 'Done. Replaced %s with %s.\n' "$old_host" "$new_host"
