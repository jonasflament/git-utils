#!/bin/sh

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

TEST_UTILS_FILE="$SCRIPT_DIR/../.test_utils.sh"; source "${TEST_UTILS_FILE}"

SRC_DIR=$SCRIPT_DIR/src
TEST_DIR=$SCRIPT_DIR/test

runTest "$SRC_DIR" "$TEST_DIR/test_no_issue_number_adds_nothing/test_no_issue_number_adds_nothing.sh"
runTest "$SRC_DIR" "$TEST_DIR/test_only_issue_number_adds_issue_number/test_only_issue_number_adds_issue_number.sh"
runTest "$SRC_DIR" "$TEST_DIR/test_issue_number_with_additional_description_only_adds_issue_number/test_issue_number_with_additional_description_only_adds_issue_number.sh"
runTest "$SRC_DIR" "$TEST_DIR/test_allow_custom_pattern/test_allow_custom_pattern.sh"
