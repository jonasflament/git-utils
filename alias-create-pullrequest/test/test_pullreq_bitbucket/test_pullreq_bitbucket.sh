#!/bin/sh

[ -d "$1" ] || fail 'No target folder in $2, cannot run test!'
[ -d "$2" ] || fail 'No src folder in $1, cannot run test!'

TARGET=$1
SRC=$2

cd $TARGET

git init

# Setup pullreq cmd to simply echo
git config --local pullreq.cmd 'echo'

USER='notARealUserNoWayInHelloWorldBestProgrammingTesterDeveloperExtraordinaireKitkatLeoOle'
REPO_NAME='tmp'
BRANCH_NAME='tmp_test_branch'
EXPECTED_PULL_REQ_URL="https://bitbucket.org/${USER}/${REPO_NAME}/pull-requests/new?source=${BRANCH_NAME}&t=1"

# Add remote for which to create the pull request
git remote add origin "git@bitbucket.org:${USER}/${REPO_NAME}.git"

# Checkout a branch to create the pull request from (by default to master)
git checkout -b ${BRANCH_NAME}

# Create dummy commit (otherwise pullreq will try to create pull request to "HEAD")
touch a
git add a
git commit -m "Initial commit"

# Create pull request, echo will ensure that it is simply printed to STDOUT
PULL_REQ_URL=$(git pullreq)

# Test verifivication: actual pull request must match rexpected pull request
[ "$PULL_REQ_URL" ==  "$EXPECTED_PULL_REQ_URL" ] || fail "Invalid pull req url: expected\n'${EXPECTED_PULL_REQ_URL}'\nbut was \n'${PULL_REQ_URL}'"
