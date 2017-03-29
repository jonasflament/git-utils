# alias-create-pullrequest

Alias to automatically create a pull request.

Currently works for:
- bitbucket: https://bitbucket.org/{user}/{repo}/pull-requests/new?source={remote-branch-name}&t=1

Disclaimer:
- requires at least one commit in repo to work, otherwise it will attempt to create pull request to "HEAD" branch
- only tested against bitbucket with `git@bitbucket.org:${USER}/${REPO_NAME}.git` like urls, HTTP for example is untested and might not work.

## How to use

    # Configure repo
    git add remote origin ${REMOTE_REPO_URL} # only if origin not yet configured
    git config pullreq.cmd ${COMMAND_TO_OPEN_PULLREQ_URL_WITH}

    # Checkout new branch
    git checkout -b ${BRANCH_NAME}

    # do some commits

    # Create pull request
    git pullreq

Following will open up browser with pull request url (Windows): `git config pullreq.cmd =explorer`

## How to install

Install the alias by adding the contents of ./src/config to the general .git/config file of the repository where you want to use the alias.
