#!/bin/sh

###############################################################################
# Script Name: "files/aidd-tree.sh"
# Description: Generates a directory tree excluding specified directories.
# Parameters: [optional] Exclude directories pattern.
# Usage: aidd-tree 'node_modules|dist|documentation'
###############################################################################

. "$(dirname "$0")/../_.sh"

# REQUIREMENTS
# --------------------
check_binary "tree"

# SCRIPT PARAMS
# --------------------
EXCLUDE=${1:-}

# EXCLUDE DIRS
# --------------------
EXCLUDE_DIRS=$(grep -v '^#' .gitignore | grep -v '^$' | sed 's|^/||' | sed 's|/$||' | sed 's/\*//g' | sed -e :a -e '$!N; s/\n/|/; ta')
EXCLUDE_DIRS="${EXCLUDE_DIRS}|project-structure|.git"

if [ -n "$EXCLUDE" ]; then
  EXCLUDE_DIRS="${EXCLUDE_DIRS}|$EXCLUDE"
fi

CURRENT_DIR=$(basename "$(pwd)" | sed -e 's/[^[:alnum:]]/-/g' | tr -s '-' | tr A-Z a-z)

# GENERATE TREE OUTPUT
# --------------------
tree -aIif "$EXCLUDE_DIRS"
