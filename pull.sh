#!/bin/bash
set -e

CONFIG_FILE="repos.txt"

if [ ! -f "$CONFIG_FILE" ]; then
  echo "Config file not found!"
  exit 1
fi

while read -r prefix url branch; do
  [[ "$prefix" =~ ^#.*$ || -z "$prefix" ]] && continue

  echo "Updating $prefix..."
  git subtree pull --prefix="$prefix" "$url" "$branch"

done < "$CONFIG_FILE"

git push -u origin main

echo "✅ All repos updated"
