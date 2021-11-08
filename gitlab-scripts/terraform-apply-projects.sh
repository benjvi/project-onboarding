#!/bin/sh
set -eu

projects="$(git diff --name-only HEAD~12 | grep deployed-projects | cut -d "/" -f2 | sort | uniq)"
printf "Will deploy the following projects with changes detected:\n${projects}\n"

for proj in $projects; do
  echo "placeholder: deploying $proj"
  cd "deployed-projects/$proj"
  ls
  terraform init
  terraform plan
  cd -
done 
