#!/bin/sh

#
# This is the main script for the AI-Driven Dev Community.
# It is the entry point for all commands.
#

# Exit if any command fails
set -e

#
# Notice function in yellow color
# Prints a notice message in yellow color.
# Arguments:
#   $1 - The notice message to print.
#
notice() {
    printf "\033[0;33m%s\033[0m\n" "$1"
}

#
# Success function in green color
# Prints a success message in green color.
# Arguments:
#   $1 - The success message to print.
#
success() {
    printf "\033[0;32m%s\033[0m\n" "$1"
}

#
# Error function in red color
# Prints an error message in red color.
# Arguments:
#   $1 - The error message to print.
#
error() {
    printf "\033[0;31m%s\033[0m\n" "$1"
}

#
# Debug function
# Prints debug messages if DEBUG environment variable is set to "true".
# Arguments:
#   $1 - The debug message to print.
#
debug() {
    if [ -n "${DEBUG}" ] && [ "${DEBUG}" = "true" ]; then
        echo "---> DEBUG: $1"
    fi
}


#
# This function checks if a binary is installed
#
check_binary() {
    if ! command -v "$1" &>/dev/null; then
        error "$1 is not installed"
        exit 1
    fi
}

check_binary "node"

#
# Call AI function
# Calls the main AI script using Node.js.
#
call_ai() {
    echo "$1" > "$BASE_DIR/../.prompt"

    debug "Prompt size is: $(wc -c "$BASE_DIR/../.prompt")"

    node "$BASE_DIR/../main.js"

    rm "$BASE_DIR/../.prompt"
}

#
# Copy to clipboard function
#
copy () {
    notice "---"
    echo "$1"
    notice "---"
    echo "$1" | pbcopy
    success "📋 Copied to clipboard"
}