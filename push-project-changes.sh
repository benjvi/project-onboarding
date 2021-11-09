#!/bin/bash
set -euo pipefail

readonly project="$1"
readonly deploy_dir="deployed-projects/$project"

git add "$deploy_dir"
git commit -m "generate project $project"
if [ ! $(git fetch origin "$(git branch --show-current)") ]; then
  sleep 1
  echo "no branch \"$(git branch --show-current)\" found at remote origin; this seems to be a new branch"
else
  git pull -r --autostash
fi
git push -u origin
