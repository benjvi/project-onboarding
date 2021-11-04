#!/bin/bash
set -euo pipefail

readonly project="$1"
readonly deploy_dir="deployed-projects/$project"
mkdir -p "$deploy_dir"
cp template/single-project/*.tf "$deploy_dir"
if [ ! -f "$deploy_dir/terraform.tfvars" ]; then
  cp template/single-project/terraform.tfvars "$deploy_dir/"
fi
cd "$deploy_dir"
vi terraform.tfvars
terraform init
terraform apply || { echo "terraform run failed - manual steps may be required to fix terraform and save changes to git"; exit 1; }

git add .
git commit -m "deploy project $project"
git pull -r --autostash && git push
