#!/usr/bin/env bash
# Újragenerálja a docs/TARTALOMJEGYZEK.md fájlt a docs/NN-*.md fejezetcímeiből.
set -euo pipefail
cd "$(dirname "$0")/.."
VER=$(sed -n 's/^## \[\([0-9.]*\)\].*/\1/p' CHANGELOG.md | head -1)
{
  echo "# Részletes tartalomjegyzék"
  echo
  echo "> Generált fejezetlista a \`docs/\` dokumentumaiból (verzió ${VER}, $(date +%F)). Újragenerálás: \`scripts/toc.sh\`."
  echo
  echo "- [README](../README.md)"
  echo "- [CHANGELOG](../CHANGELOG.md)"
  echo "- [Átadási jegyzet](ATADAS.md)"
  for f in docs/[0-9]*.md; do
    b=$(basename "$f"); title=$(sed -n '1s/^# //p' "$f")
    echo; echo "## [$title]($b)"
    grep -E '^## ' "$f" | sed 's/^## /- /'
  done
} > docs/TARTALOMJEGYZEK.md
echo "docs/TARTALOMJEGYZEK.md frissítve"
