#!/bin/bash
set -e

CONFIG_FILE="repos.txt"

while read -r prefix url branch; do
  [[ "$prefix" =~ ^#.*$ || -z "$prefix" ]] && continue

  # check if subtree is actually valid
  if git log --grep="git-subtree-dir: $prefix" > /dev/null 2>&1; then
    echo "⏭️  Skipping $prefix (already a subtree)"
    continue
  fi

  echo "➕ Adding $prefix..."

  # if folder exists but is not a subtree → remove it
  if [ -d "$prefix" ]; then
    echo "⚠️  Removing existing folder $prefix (not a subtree)"
    rm -rf "$prefix"
  fi

  git subtree add --prefix="$prefix" "$url" "$branch"

done < "./$CONFIG_FILE"

echo "✅ Setup complete"
