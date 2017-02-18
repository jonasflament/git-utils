#!/bin/sh

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

#TEST_UTILS_FILE="$SCRIPT_DIR/../test_utils.sh"; source "${TEST_UTILS_FILE}"

[ -d "$1" ] || fail 'No target folder in $1, cannot run test!'   
[ -d "$2" ] || fail 'No src folder in $2, cannot run test!'

TARGET=$1
SRC=$2

####
# Repo setup
#############

BRANCH_NAME='new_branch'

COMMIT_MSG_SRC=$SRC/hooks/commit-msg
PREPARE_COMMIT_MSG_SRC=$SRC/hooks/prepare-commit-msg

debug $COMMIT_MSG_SRC

[ -f "$COMMIT_MSG_SRC" ] || fail "Test setup failure: no commit-msg file found in src folder"
[ -f "$PREPARE_COMMIT_MSG_SRC" ] || fail "Test setup failure: no prepare-commit-msg file found in src folder"

# Initialize git repo

cd $TARGET

info 'Initializing git repo'
rm -rf .git # We need to remove it to start from a clean slate
git init

info 'Changing editor to sed to mock user input'
git config core.editor "sed  -i '1i summary'"

info 'Copying required hooks to initialized git repo'

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
[ 0 -eq $(git log -1 | grep "$BRANCH_NAME" | wc -l) ] || fail 'Test failed: branch name was added to file, but it should not'