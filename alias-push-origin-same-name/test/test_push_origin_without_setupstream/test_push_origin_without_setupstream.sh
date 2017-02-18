#!/bin/sh

[ -d "$1" ] || fail 'No target folder in $2, cannot run test!'   
[ -d "$2" ] || fail 'No src folder in $1, cannot run test!'

TARGET=$1
SRC=$2

REMOTE_REPO=$TARGET/remote
LOCAL_REPO=$TARGET/local

# Cleanup .git folder created by test framework, will be creating 2 separate repos
# Must be removed, otherwise faulty test might try to use that git repo
rm -rf $TARGET/.git

# Initialize remote remo
info 'Initializing remote repo'
git init --bare $REMOTE_REPO

cd $LOCAL_REPO/..

info 'Cloning remote repo to local repo'
git clone $REMOTE_REPO $LOCAL_REPO || fail 'Test setup failed: could not clone remote repo as local repo'

cd $LOCAL_REPO

[ 0 -eq $(git remote -v | wc -l | sed 's/ //g') ] && fail 'Test setup failed: no remote added in local repo'

# Append config to local git repo config file, otherwise we lose the branch information
cat $SRC/config >> .git/config

touch $LOCAL_REPO/a

git add a || fail "Test setup failure: could not add file"

COMMIT_MSG="First commit"
git commit -m "$COMMIT_MSG" || fail 'Test setup failed: could not commit'

git pu || fail 'Could not push to origin with alias'

cd $REMOTE_REPO

NB_COMMITS="$(git log --format=oneline | wc -l | sed 's/ //g')"

[ "1" -eq "$NB_COMMITS" ] || fail "Git log expected to be one commit long, but was $NB_COMMITS long"
(git log | grep "$COMMIT_MSG") || fail "Git log did not contain expected commit message ($COMMIT_MSG)"
