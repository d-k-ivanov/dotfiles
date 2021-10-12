#!/usr/bin/env bash

BRANCHNAME="$1"

# Need an input file:
if [ -z "$BRANCHNAME" ]
then
    echo "Branch name is missing"
    exit 1
fi

git checkout --orphan new${BRANCHNAME}
git add -A
git commit "renew history"
git branch -D ${BRANCHNAME}
git branch -m ${BRANCHNAME}
git push -f origin ${BRANCHNAME}
git gc --aggressive --prune=all
