# prepare-commit-msg-issue-number

Extracts issue number from the current branch name and prepares a commit message with the issue number as the last line.

Contains
- a prepare-commit-msg hook that prepares the commit message with the issue number, and
- a commit-msg hook that prevents committing without a summary line
