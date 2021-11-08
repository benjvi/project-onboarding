#!/bin/sh
set -eu

projects="$(git diff --name-only HEAD~14 | grep deployed-projects | cut -d "/" -f2 | sort | uniq)"
printf "Will deploy the following projects with changes detected:\n${projects}\n"

for proj in $projects; do
  printf "\n-----------  Starting to deploy $proj  -------------\n\n"
  cd "deployed-projects/$proj"
  ls
  terraform init
  terraform plan
  cd -
  echo "\n-----------  Finished deploying $proj  ------------\n\n"
done 
