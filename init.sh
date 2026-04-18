#!/bin/bash

set -e

CONFIG_FILE="repos.txt"

while read -r prefix url branch; do
  [[ "$prefix" =~ ^#.*$ || -z "$prefix" ]] && continue

  echo "Updating $prefix..."
  git subtree pull --prefix=$prefix $url $branch

done < $CONFIG_FILE# push
git push -u origin main

echo "✅ Setup complete"
