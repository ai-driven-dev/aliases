#!/bin/sh

###############################################################################
# Script Name: "git/aidd-pull-request.sh"
# Description: Prepares a pull request using a pre-filled template.
# Parameters: [optional] Template file path.
# Usage: aidd-pull-request './my-projects/.github/pull_request_template.md'
###############################################################################

. "$(dirname "$0")/../_.sh"

# REQUIREMENTS
# --------------------
check_binary "git"

# SCRIPT PARAMS
# --------------------
DEFAULT_PARAM="$(dirname "$0")/../../templates/pull_request_template.md"
PARAM=${1:-$DEFAULT_PARAM}

# Check for --no-context parameter
INCLUDE_CHANGES=true
if [ "$1" = "--no-context" ]; then
  INCLUDE_CHANGES=false
  shift # Remove the parameter from the list
  PARAM=${1:-$DEFAULT_PARAM}
fi

# Validate the parameter
if [ "$PARAM" = "$DEFAULT_PARAM" ]; then
  notice "[aidd-pull-request]: Using default template"
fi

if [ ! -f "$PARAM" ]; then
  error "Template file does not exist: $PARAM"
  exit 1
fi

# PARAMETERS
# --------------------
TEMPLATE=$(cat $PARAM)
CHANGES=$(git diff main)
COMMITS=$(git log --oneline main..)

# PROMPT
# --------------------
PROMPT=$(cat <<_
Goal:
Create a pull request for my changes.

Rules:
- Use the changes from main.
- Fill the "template" file to create the PR (the "output").
- "Instructions" comments must be followed no matter what.
- "Instructions" comments must be remove from the output.
- Output should be properly formated in markdown.


Template file:
<template>
$TEMPLATE
</template>

List of commits:
<commits>
$COMMITS
</commits>

The feature I want to implement is:
<feature>
$FEATURE
</feature>
_
)

if [ "$INCLUDE_CHANGES" = "true" ]; then
  notice "[aidd-pull-request]: Including changes from main"
  PROMPT=$(echo "$PROMPT" | sed '/Changes from main:/,+3d')
fi

# CALLING AI
# --------------------
call_ai "$PROMPT"
