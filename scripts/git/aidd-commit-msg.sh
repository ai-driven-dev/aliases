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

    echo "<created_files>"
    
    for file in $UNTRACKED; do
        echo "---"
        echo "$file"
        if file "$file" | grep -q "text"; then
            cat "$file"
        fi
        echo "---"
        echo ""
    done

    echo "</created_files>"
}

example_script() {
    cat << 'EOFSCRIPT'
# 
# Changes:
# --------------------
# 1: [Brief description of functional change]
# 2: [Brief description of functional change]
# ...
# 
# Change 1: [Brief description of functional change]
git add [relative path to file(s)]
git commit -m "feat: Implement new feature X"

# Change 2: [Brief description of functional change]
git add -p [relative path to file] << 'EOFPATCH'
y
y
EOFPATCH
git commit -m "fix: Resolve issue with function Y"

# Test changes
git add [relative path to test file(s)]
git commit -m "test: Add unit tests for feature X"
EOFSCRIPT
}

# PROMPT
# --------------------
PROMPT=$(cat <<EOF
Context:
<git_changes>
$CHANGES
</git_changes>

<previous_commit_messages>
$PREV_COMMIT_MSG
</previous_commit_messages>

$(created_files_prompt)

Steps:
1. Analyze the Git changes and summarize functional changes in a numbered list.
2. Identify hunks (areas of change within files) but do not display them.
3. Generate git add commands and commit messages for the changes, following the rules below.

Rules for commit messages:
- Use Conventional Commit format (type: description).
- Maintain consistency with the latest commit messages.
- Describe functional changes, not implementation details.
- One commit message can cover multiple file changes.
- Focus on the "what" and "why" of the changes, not the "how".

Rules for git add commands:
- Use relative paths based on $CURRENT_DIR.
- Use "git add --patch" ONLY if at least two functional changes concern the same file.
- When using the patch option, include "y" in EOF multiple times if needed.
- Do not use patch if the entire file content needs to be added.
- Generate separate commits for test files when possible.

Additional guidelines:
- Generate separate commits for test files when possible.
- Provide the output as a shell script only.

Before generating the shell script, analyze the Git changes and plan your approach. In this analysis:

1. List each file changed and its relative path.
2. Summarize the changes in each file.
3. Identify if the change is a new feature, bug fix, or test.
4. Determine if the change requires a patch or full file add.
5. Group related changes together for potential combined commits.
6. Propose commit messages for each group of changes.

It is OK for this section to be quite long.

Example output structure:
<example_output>
$(example_script)
</example_output>
EOF
)

# CALLING AI
# --------------------
call_ai "$PROMPT"
