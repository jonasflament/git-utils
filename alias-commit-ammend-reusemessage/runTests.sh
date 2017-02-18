#!/bin/sh

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

TEST_UTILS_FILE="$SCRIPT_DIR/../.test_utils.sh"; source "${TEST_UTILS_FILE}"

SRC_DIR=$SCRIPT_DIR/src
TEST_DIR=$SCRIPT_DIR/test

runTest "$SRC_DIR" "$TEST_DIR/test_commit_ammend_no_editor/test_commit_ammend_no_editor.sh"
