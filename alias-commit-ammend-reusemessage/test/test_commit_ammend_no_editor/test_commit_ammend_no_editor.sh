#!/bin/sh

[ -d "$1" ] || fail 'No target folder in $2, cannot run test!'   
[ -d "$2" ] || fail 'No src folder in $1, cannot run test!'

TARGET=$1
SRC=$2

COMMIT_MSG="First commit message"

cd $TARGET

git init

touch a

git add a

git commit -m "$COMMIT_MSG"

echo "abc" > a

# Commit-ammending without editor
git cam || fail "Was not able to git cam to commit-ammend without editor, command returned error status"

NB_COMMITS="$(git log --format=oneline | wc -l | sed 's/ //g')"

[ "1" -eq "$NB_COMMITS" ] || fail "Git log expected to be one commit long, but was $NB_COMMITS long"
(git log | grep "$COMMIT_MSG") || fail "Git log did not contain expected commit message ($COMMIT_MSG)"