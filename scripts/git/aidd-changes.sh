#!/bin/sh

###############################################################################
# Script Name: "git/aidd-changes.sh"
# Description: Copies the current git changes to the clipboard.
# Parameters: None
# Usage: aidd-changes
###############################################################################

. "$(dirname "$0")/../_.sh"

# REQUIREMENTS
# --------------------
check_binary "pbcopy"

# PARAMETERS
# --------------------
CHANGES=$(git diff)

# SCRIPT
# --------------------
copy "$CHANGES"
