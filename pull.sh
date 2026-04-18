#!/bin/bash

set -e

CONFIG_FILE="repos.txt"

# read config file
while read -r prefix url branch; do
  # skip comments or empty lines
  [[ "$prefix" =~ ^#.*$ || -z "$prefix" ]] && continue

  echo "Adding $prefix..."
  git subtree add --prefix=$prefix $url $branch

done < ./$CONFIG_FILE


git push

echo "✅ All repos updated"
