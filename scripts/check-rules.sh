#!/usr/bin/env bash
# Syntactic sanity check for committed Snort .rules files.
# Verifies each non-comment rule has an action, balanced parentheses,
# and the required msg + sid options. Exits non-zero on the first problem.
set -euo pipefail

shopt -s nullglob globstar
files=( labs/**/configs/*.rules )

if [ ${#files[@]} -eq 0 ]; then
  echo "No .rules files found — nothing to check."
  exit 0
fi

status=0
for f in "${files[@]}"; do
  echo "Checking $f"
  # Join line-continuations (\ at EOL) so multi-line rules are one logical line.
  mapfile -t rules < <(sed ':a;/\\$/{N;s/\\\n//;ba}' "$f" | grep -vE '^\s*(#|$)')
  n=0
  for rule in "${rules[@]}"; do
    n=$((n+1))
    if ! grep -qE '^\s*(alert|drop|reject|pass|log)\b' <<<"$rule"; then
      echo "  ✗ rule $n: missing/invalid action"; status=1; continue
    fi
    opens=$(tr -cd '(' <<<"$rule" | wc -c)
    closes=$(tr -cd ')' <<<"$rule" | wc -c)
    [ "$opens" -eq "$closes" ] || { echo "  ✗ rule $n: unbalanced parentheses"; status=1; }
    grep -q 'msg:' <<<"$rule" || { echo "  ✗ rule $n: missing msg"; status=1; }
    grep -qE 'sid:[0-9]+' <<<"$rule" || { echo "  ✗ rule $n: missing sid"; status=1; }
  done
  echo "  ✓ $n rule(s) checked"
done
exit $status
