#!/bin/bash

set -e

CONFIG_FILE="repos.txt"

while read -r prefix url branch; do
  # skip comments or empty lines
  [[ "$prefix" =~ ^#.*$ || -z "$prefix" ]] && continue

  # check if subtree already exists (tracked in git)
  if git ls-tree -d HEAD "$prefix" > /dev/null 2>&1; then
    echo "⏭️  Skipping $prefix (already exists)"
    continue
  fi

  echo "➕ Adding $prefix..."
  git subtree add --prefix="$prefix" "$url" "$branch"

done < "./$CONFIG_FILE"

echo "✅ Setup complete"
