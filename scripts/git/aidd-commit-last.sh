#!/bin/sh

###############################################################################
# Script Name: "git/aidd-commit-last.sh"
# Description: Copies the last 10 commit messages to the clipboard.
# Parameters: None
# Usage: aidd-commit-last
###############################################################################

. "$(dirname "$0")/../_.sh"

# REQUIREMENTS
# --------------------
check_binary "git"

# PARAMETERS
# --------------------
PREV_COMMIT_MSG=$(git log -10 --pretty=format:%s)

# SCRIPT
# --------------------
copy "$PREV_COMMIT_MSG"

