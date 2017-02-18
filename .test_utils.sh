#!/bin/sh

# Utility functions and variables for running tests for
# File is at root of project to easily share utils among all git hook tests in this repo

# Color definitions
export RED='\033[0;31m'
export GREEN='\033[0;32m'
export BLUE='\033[0;34m'
export LIGHT_BLUE='\033[1;34m'
export LIGHT_GRAY='\033[0;37m'
export CYAN='\033[0;36m'
export NC='\033[0m' # No Color

####
# Logging functions
###################

# Enables info logging for all tests
export INFO=true
# Enables debug logging for all tests
#export DEBUG=true

function is_set(){ [ -n "$1" ] ; }

export -f is_set

function debug () { is_set $DEBUG && echo -e "${CYAN}[DEBUG] $@ ${NC}" ; }
function info () { is_set $INFO && echo -e "[INFO] $@" ; }
function error () { echo -e "${RED}[ERROR] $@ ${NC}" ; }

export -f debug
export -f info
export -f error

####
# Test functions
################
function fail () { echo -e "${RED}[FAIL] $@ ${NC}" ; exit -1 ; }
function success () { echo -e "${GREEN}[SUCCESS] $@ ${NC}" ; }

export -f fail
export -f success

#
# Runs the given test using files from given source folder.
#
# arg $1: SRC_FOLDER, folder containing source code for hooks
# arg $2: TEST_FILE, file containing test logic. An exit code != 0 is interpreted as a test failure
#
# Automatically initialized a clean git test repo. Previous repo will be removed.
# Automatically cleans up test repo after succesful test, but leaves repo on failure for easier debugging.
#
# Tests should accept:
# - arg $1: SANDBOX_FOLDER, the root of the test repo
# - arg $2: SRC_FOLDER
#
function runTest() {


    SRC_DIR=$1
    TEST_FILE=$2

    [ -d "$SRC_DIR" ] || { fail "Could not run test: source folder '$SRC_DIR' does not exists" ; }
    [ -f "$TEST_FILE" ] || { fail "Could not run test: no test file '$1'" ; }

    SANDBOX_FOLDER="$( cd "$( dirname "$TEST_FILE}" )" && pwd )"

    info "${LIGHT_BLUE}Running test "$(basename "$TEST_FILE")" ${NC}"

    # Repo setup

    TARGET=$SANDBOX_FOLDER/target
    [ -d "$TARGET" ] || { debug "Creating target folder $TARGET" ; mkdir "$TARGET" ; }

    # Clean target
    rm -rf "$TARGET/"*

    debug 'Initializing git repo at'"$TARGET"
    cd $TARGET

    [ -d ".git" ] && { debug 'Cleaning up git folder' ; rm -rf .git; }

    git init >/dev/null

    debug "Copying $SRC_DIR/hooks to $TARGET/.git"
    cp -r "$SRC_DIR"/* "$TARGET"/.git/

    debug "Starting test execution $TEST_FILE"

    # Test exec

    sh "$TEST_FILE" "$TARGET" "$SRC_DIR"
    TEST_RET_CODE=$?

    if [ 0 -eq "$TEST_RET_CODE" ]; then

        success 'Test completed successfully.'

        # Test cleanup
        cd $SANDBOX_FOLDER

        debug 'Cleaning up target'
        rm -rf "$TARGET"
    else
        fail 'Test failed with errors. Test repo located at' "$TARGET"
    fi
}

export -f runTest
