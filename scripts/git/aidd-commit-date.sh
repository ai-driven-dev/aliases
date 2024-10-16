#!/bin/sh

set -e  # Exit on error

###############################################################################
# Script Name: "git/aidd-commit-date.sh"
# Description: Changes the commit date of the specified commit using a specified date.
# Parameters: [required] Date in the format 'YYYY-MM-DD HH:MM:SS', [optional] Commit ID.
# Usage: aidd-commit-date "2024-10-04 20:13:46" "commitId"
###############################################################################

. "$(dirname "$0")/../_.sh"

# REQUIREMENTS
# --------------------
check_binary "git"

# SCRIPT PARAMS
# --------------------
DATE_PARAM=${1:-}
COMMIT_ID=${2:-}

# If no commit ID is provided, use the latest commit
if [ -z "$COMMIT_ID" ]; then
  COMMIT_ID=$(git log -1 --format=%H)
  if [ -z "$COMMIT_ID" ]; then
    error "No commits found in the repository."
    exit 1
  fi

  notice "No commit ID provided. Using the latest commit: $COMMIT_ID"
fi


# Validate the parameters
if [ -z "$DATE_PARAM" ]; then
  error "No date provided. Please provide a date in the format 'YYYY-MM-DD HH:MM:SS'."
  exit 1
fi

# Check if the date format is valid
if ! date -j -f "%Y-%m-%d %H:%M:%S" "$DATE_PARAM" >/dev/null 2>&1; then
  error "Invalid date format: $DATE_PARAM. Please provide a date in the format 'YYYY-MM-DD HH:MM:SS'."
  exit 1
fi

# Check if the commit ID exists
if ! git cat-file -e "$COMMIT_ID" 2>/dev/null; then
  LAST_5_COMMITS=$(git log -n 5 --pretty=format:"%h - %cd - %s" --date=format:"%Y-%m-%d %H:%M:%S")
  error "Commit ID does not exist. Please provide a valid commit ID."
  error "Last 5 commits:"
  error "$LAST_5_COMMITS"
  exit 1
fi


# FUNCTIONS
# --------------------
get_commit_date() {
  git log -1 --format="%cd" --date=format:"%Y-%m-%d %H:%M:%S" "$COMMIT_ID"
}

get_last_commit_info() {
  git log --pretty=format:"%h - %cd - %s" --date=format:"%Y-%m-%d %H:%M:%S" "$COMMIT_ID"
}

# SCRIPT
# --------------------
GIT_COMMITTER_DATE="$DATE_PARAM" git commit --amend --no-edit --date "$DATE_PARAM" --no-verify --reuse-message="$COMMIT_ID" >> /dev/null

echo "Please check your commit date!"

COMMAND="LAST_COMMIT_DATE=\$(git log --pretty=format:'%h - %cd - %s' --date=format:'%Y-%m-%d %H:%M:%S' -n 1) && echo \"\$LAST_COMMIT_DATE\""
copy "$COMMAND"
