# prepare-commit-msg-issue-number

Extracts issue number from the current branch name and prepares a commit message with the issue number as the last line.

The regex to match the issue number can be overridden with a custom posix regex in the 'issue.pattern' git config.

Contains
- a prepare-commit-msg hook that prepares the commit message with the issue number, and
- a commit-msg hook that prevents committing without a summary line

# How to use

Create a branch which contains an issue number in its name, and commit a change.

To override the default issue pattern, set the issue.pattern git config

    git config 'issue.pattern' '<posix-pattern>'