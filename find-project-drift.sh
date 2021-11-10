#!/bin/bash
set -euo pipefail

# script should
projects="$(ls -d deployed-projects/*)"
for proj in $projects; do
  echo "------- Running terraform plan for $proj --------" 2>&1 > /dev/null
  cd "$proj"
  set +e
  terraform init 2>&1 > /dev/null
  terraform plan -detailed-exitcode 2>&1 > /dev/null
  exitcode="$?"
  set -e
  if [ "$exitcode" -eq "2" ]; then
    echo "$proj"
  fi
  cd - 2>&1 > /dev/null
done

