#!/bin/bash
set -euo pipefail

readonly project="$1"
readonly deploy_dir="deployed-projects/$project"
readonly

upstream_branch_count="$(git ls-remote --heads git@github.com:user/repo.git branch-name | wc -l)"
git add "$deploy_dir"
git commit -m "generate project $project"
{ git fetch origin "$(git branch --show-current)" && git pull -r --autostash } || echo "no remote found; this is a new branch"
git push
