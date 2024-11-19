#!/bin/bash
set -e

CURRENT_DIR=$(cd -- "$(dirname -- "$0")" && cd .. && pwd)

notice "*** generate_aliases: $CURRENT_DIR ***"

# ... existing code ...

generate_aliases() {
    local SCRIPTS_DIR="$1"
    local ALIASES_FILE="$2"

    # Start with the header
    cat > "$ALIASES_FILE" <<EOL
# ~/.ai-driven-dev/aliases.sh

_PATH=~/.ai-driven-dev/scripts

EOL

    # Function to process scripts in a directory
    process_scripts() {
        local dir=$1
        local relative_path=${dir#$SCRIPTS_DIR/}
        
        # Add a comment for the section if it's a subdirectory
        if [ -n "$relative_path" ]; then
            echo "" >> "$ALIASES_FILE"
            echo "# $(basename "$relative_path")" >> "$ALIASES_FILE"
        fi
        
        # Find all .sh files in the directory, excluding _.sh
        find "$dir" -maxdepth 1 -type f -name "*.sh" ! -name "_.sh" | sort | while read -r script; do
            local script_name=$(basename "$script" .sh)
            local alias_name="$script_name"
            local script_relative_path="${script#$SCRIPTS_DIR/}"
            echo "alias $alias_name=\"\$_PATH/$script_relative_path\"" >> "$ALIASES_FILE"
        done
    }

    # Process the main scripts directory
    process_scripts "$SCRIPTS_DIR"

    # Process subdirectories, excluding the _ directory
    find "$SCRIPTS_DIR" -type d | while read -r dir; do
        if [ "$dir" != "$SCRIPTS_DIR" ] && [ "$(basename "$dir")" != "_" ]; then
            process_scripts "$dir"
        fi
    done

    echo "aliases.sh generated successfully."
}