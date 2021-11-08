#!/bin/sh
set -eu

projects="$(git diff --name-only HEAD~14 | grep deployed-projects | cut -d "/" -f2 | sort | uniq)"
printf "Will deploy the following projects with changes detected:\n${projects}\n"

for proj in $projects; do
  if [ -d "deployed-projects/$proj" ]; then
    printf "\n-----------  Starting to deploy $proj  -------------\n\n"
    cd "deployed-projects/$proj"
    ls
    terraform init
    terraform plan
    cd -
    echo "\n-----------  Finished deploying $proj  ------------\n\n"
  else
    echo "Folder \"deployed-projects/$proj\" not found (it may have been deleted), skipping"
  fi
done 
