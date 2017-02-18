# git-utils

Repository with several utilities to facilitate your git workflow.

## Available utilities

The following lists all available utilities:

- alias-commit-ammend-reusemessage: allows to ammend a commit without changing the original commit message

- alias-push-origin-same-name: alias to automatically push newly created branch to the upstream origin branch under the same name

- hook-prepare-commit-msg-issue-number: extract issue number from the current branch name and prepares a commit message with the issue number at the last line.

## How to use

*Hooks* To use a hook in a single repository, simply copy the hook into the .git/hooks folder. 

*Aliases* To use an alias, append the contents of the src/config file to the main config file of the repository.

## How to test

Run `bash runTest.sh` in the root of the repository to run all tests for all utilities.

All tests were written so they could be run with bash/sh. This allows the tests to run within the git bash terminal that comes with git for Windows.