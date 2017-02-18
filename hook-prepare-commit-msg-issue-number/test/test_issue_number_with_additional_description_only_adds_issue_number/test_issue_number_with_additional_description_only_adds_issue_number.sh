#!/bin/sh

[ -d "$1" ] || fail 'No target folder in $2, cannot run test!'   
[ -d "$2" ] || fail 'No src folder in $1, cannot run test!'

TARGET=$1
SRC=$2

####
# Repo setup
#############

ISSUE_NUMBER='QSDF-1265'
BRANCH_NAME="${ISSUE_NUMBER}"'-additional-issue-description'

COMMIT_MSG_SRC=$SRC/hooks/commit-msg
PREPARE_COMMIT_MSG_SRC=$SRC/hooks/prepare-commit-msg

[ -f "$COMMIT_MSG_SRC" ] || fail "Test setup failure: no commit-msg file found in src folder"
[ -f "$PREPARE_COMMIT_MSG_SRC" ] || fail "Test setup failure: no prepare-commit-msg file found in src folder"

cd $TARGET

info 'Initializing git repo'
rm -rf .git # We need to remove it to start from a clean slate
git init

debug 'Changing editor to sed to mock user input'
git config core.editor "sed  -i '1i summary'"

debug 'Copying required hooks to initialized git repo'

SRC_HOOKS=$SRC/hooks
TARGET_HOOKS=$TARGET/.git/hooks

ls $SRC_HOOKS

debug "Moving $(ls $SRC_HOOKS) to $TARGET_HOOKS"

cp -r "$SRC_HOOKS/." "$TARGET_HOOKS"
[ -f "$TARGET_HOOKS/commit-msg" ] || fail 'Test setup error. Error during commit-msg file copy: file not found in git hooks folder'
[ -f "$TARGET_HOOKS/prepare-commit-msg" ] || fail 'Test setup error. Error during prepare-commit-msg file copy: file not found in git hooks folder'

####
# Test exec
#############

info "Checking out branch $BRANCH_NAME"
git checkout -b "$BRANCH_NAME"

info 'Creating file to commit'

echo 'a' >> file.txt || fail 'Test failed. Error during file append.'

info 'Adding file'
git add file.txt > /dev/null 2>&1 || fail 'Test failed. Error during file add.'


info 'Committing file with whitespace error'
git commit || fail 'Test failed. Commit was not allowed, but was expected to be allowed'

info 'Checking commit log'

[ 0 -eq $(git log -1 | grep "$BRANCH_NAME" | wc -l) ] || fail 'Test failed: full branch name was added to file, but it should not have'
[ 0 -eq $(git log -1 | grep "$ISSUE_NUMBER" | wc -l) ] && fail 'Test failed: issue number was not added to file, but it should have'

# Signals test was success
exit 0
