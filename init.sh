#!/bin/bash
set -e

CONFIG_FILE="repos.txt"

echo "🔄 Starting smart subtree sync..."

while read -r prefix url branch; do
  # skip comments / empty lines
  [[ "$prefix" =~ ^#.*$ || -z "$prefix" ]] && continue

  echo ""
  echo "📦 Processing: $prefix"

  # ----------------------------------------------------
  # Check if this is a REAL subtree (not just a folder)
  # ----------------------------------------------------
  if git log --grep="git-subtree-dir: $prefix" --oneline | grep -q .; then
    echo "🔄 Updating existing subtree: $prefix"
    git subtree pull --prefix="$prefix" "$url" "$branch"
    continue
  fi

  # ----------------------------------------------------
  # If folder exists but is NOT a subtree → clean it
  # ----------------------------------------------------
  if [ -d "$prefix" ]; then
    echo "⚠️  Found existing non-subtree folder: $prefix"
    echo "🧹 Removing it to avoid conflicts..."
    rm -rf "$prefix"
  fi

  # ----------------------------------------------------
  # Add as new subtree
  # ----------------------------------------------------
  echo "➕ Adding new subtree: $prefix"
  git subtree add --prefix="$prefix" "$url" "$branch"

done < "./$CONFIG_FILE"

echo ""
echo "📤 Pushing changes..."
git push

echo "✅ Sync complete"
