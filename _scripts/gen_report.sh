#!/usr/bin/env bash
set -e
type html2text grep sed
[ $# -lt 1 ] && { echo "Usage: $0 (dir) (file) (?filter)"; exit 1; }
DIR="$1"
OUT="${2-README.md}"
FILTER="${3-*}"
ROOT="$(git rev-parse --show-toplevel)"
[ -d "$DIR" ]

> "$DIR/$OUT"
find "$DIR" -type f -name "*$FILTER*test.txt" -maxdepth 1 -print0 | sort -z | while IFS= read -r -d '' report; do
  file=$(basename "$report")
  name=$(echo "$file" | sed "s/-/ /g")
  gif="$(basename "${file%.*}.gif")"
  gifpath=$(cd "$DIR" && find . -name "$gif" -maxdepth 1 -print -quit)
  printf "\n### Report: ${name%.*}\n\n" >> "$DIR/$OUT"
  printf "![$name]($gifpath)\n\n" >> "$DIR/$OUT"
  grep "^\S" "$report" | sed 's/^/    /' >> "$DIR/$OUT"
done
echo "$0 done."
