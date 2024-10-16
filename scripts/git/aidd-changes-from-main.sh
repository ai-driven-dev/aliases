#!/bin/sh

###############################################################################
# Script Name: "git/aidd-changes-from-main.sh"
# Description: Copies the changes from the main branch to the clipboard.
# Parameters: None
# Usage: aidd-changes-from-main
###############################################################################

. "$(dirname "$0")/../_.sh"

# PARAMETERS
# --------------------
CHANGES=$(git diff main)

# SCRIPT
# --------------------
copy "$CHANGES"
