#!/bin/sh
set -eu

# note: this only works properly when a single commit triggers the pipeline
# for a more robust, but more complicated solution see https://gitlab.com/gitlab-org/gitlab-foss/-/issues/19813#note_26341975
projects="$(git diff --name-only HEAD~1 | grep deployed-projects | cut -d "/" -f2 | sort | uniq)"
printf "Will deploy the following projects with changes detected:\n${projects}\n"

for proj in $projects; do
  if [ -d "deployed-projects/$proj" ]; then
    printf "\n-----------  Starting to deploy $proj  -------------\n\n"
    cd "deployed-projects/$proj"
    ls
    terraform init
    terraform apply -auto-approve

    git add . 
    git commit -m "Gitlab CI scrip: applied terraform for $proj"
    git push
    printf "\n-----------  Finished deploying $proj  ------------\n\n"

    cd -
  else
    echo "Folder \"deployed-projects/$proj\" not found (it may have been deleted), skipping"
  fi
done 
