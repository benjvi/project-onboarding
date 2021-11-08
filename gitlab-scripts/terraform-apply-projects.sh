#!/bin/sh
projects="$(git diff --name-only HEAD~8 | grep deployed-projects | cut -d "/" -f2 | sort | uniq)"
printf "Will deploy the following projects with changed detected:\n${projects}"
