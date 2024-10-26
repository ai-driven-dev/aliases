#!/bin/sh

###############################################################################
# Script Name: "git/aidd-commit-msg.sh"
# Description: Prepares a commit message based on current changes.
# Parameters: None
# Usage: aidd-commit-msg
###############################################################################

. "$(dirname "$0")/../_.sh"

# PARAMETERS
# --------------------
# Last 10 previous commit message from the user.
PREV_COMMIT_MSG=$(git log -10 --pretty=format:%s)

# Current staged git changes.
CHANGES=$(git diff)
CURRENT_DIR=$(pwd)

# If there is no changes, exit.
if [ -z "$CHANGES" ]; then
    error "No changes to commit"
    echo "Please UNSTAGE changes before generating a commit message."
    exit 1
fi

# FUNCTION
# --------------------
created_files_prompt() {

    local UNTRACKED=$(git ls-files --others --exclude-standard)

    if [ -z "$UNTRACKED" ]; then
        return
    fi

    echo "Created files:"
    
    for file in $UNTRACKED; do
        echo "---"
        echo "$file"
        cat "$file"
        echo "---"
        echo ""
    done
}

# PROMPT
# --------------------
PROMPT=$(cat <<EOF
Goal:
1. Summarize functionnal changes in comments, with numbered list.
2. Identify hunks (but do not display them).
3. Generate git add + git commit message for every changes in the code, following rules.

Rules:
- Format in Conventional Commit.
- Remain consistent with latest commit messages.
- Describe changes made, not implementation details.
- Commit messages should be small and focused on a single change.
- 1 commit message can have multiple files changes.
- Answer with shell script ONLY.
- Use relative git add path based on $CURRENT_DIR.
- Use "git add --patch" with hunks when little changes are made.
    - When using path option, be sure to "y" in EOF multiple if needed.
- Do not use patch if all file content need to be added.
- Test should have their own commit if possible.

Previous commit messages:
<commitMessages>
$PREV_COMMIT_MSG
</commitMessages>

Current git changes:
<codeDiff>
$CHANGES
</codeDiff>

$(created_files_prompt)
EOF
)

# CALLING AI
# --------------------
call_ai "$PROMPT"
