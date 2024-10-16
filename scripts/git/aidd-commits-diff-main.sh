#!/bin/sh

###############################################################################
# Script Name: "git/aidd-commits-diff-main.sh"
# Description: Copies the commit differences between the current branch and main.
# Parameters: None
# Usage: aidd-commits-diff-main
###############################################################################

. "$(dirname "$0")/../_.sh"

# REQUIREMENTS
# --------------------
check_binary "git"

# PROMPT PARAMS
# --------------------
DIFF=$(git log --oneline --no-merges main..HEAD)

#
# PROMPT
#
PROMPT=$DIFF
#
# COPY OUTPUT
# 
copy "$PROMPT"
