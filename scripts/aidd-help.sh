#!/bin/sh

###############################################################################
# Script Name: "aidd-help.sh"
# Description: Provides help and usage information for aidd scripts.
# Parameters: None
# Usage: aidd-help
###############################################################################

# Load the main script
. "$(dirname "$0")/_.sh"

# ANSI color codes
PRIMARY='\033[38;5;20m'     # #020244 # Blue
SECONDARY='\033[38;5;197m'  # #DD5475 # Red
TERTIARY='\033[38;5;108m'   # #66CC99 # Green
NC='\033[38;5;255m'         # White (No Color)

# ASCII Art for the title
echo "${SECONDARY}"
echo "    _    ___      ____       _                   ____             "
echo "   / \  |_ _|    |  _ \ _ __(_)_   _____ _ __   |  _ \  _____   __"
echo "  / _ \  | |_____| | | | '__| \ \ / / _ \ '_ \  | | | |/ _ \ \ / /"
echo " / ___ \ | |_____| |_| | |  | |\ V /  __/ | | | | |_| |  __/\ V / "
echo "/_/   \_\___|    |____/|_|  |_| \_/ \___|_| |_| |____/ \___| \_/  "
echo "${NC}"

# Usage section
echo
echo "Usage: ${TERTIARY}aidd-help${NC}"
echo

# Description
echo "Provides help and usage information for aidd scripts."
echo

# Function to list all aliases in the scripts directory
list_aliases() {
    SCRIPTS_DIR="$(dirname "$0")"
    echo "${NC}Available Aliases:${NC}"
    echo "-------------------"
    find "$SCRIPTS_DIR" -type f -name "*.sh" ! -name "_.sh" ! -path "*/_/*" | while read -r script; do
        # Extract the description from the script
        description=$(grep -E "^# Description:" "$script" | sed 's/# Description: //')
        # Extract the alias from the script name
        alias=$(basename "$script" .sh)
        # Extract the parameters from the script
        parameters=$(grep -E "^# Parameters:" "$script" | sed 's/# Parameters: //')
        # Remove [optional] from parameters
        parameters=$(echo "$parameters" | sed 's/\[optional\] //g')
        # Output the alias, parameters, and description
        if [ -n "$parameters" ] && [ "$parameters" != "None" ]; then
            echo "- ${SECONDARY}$alias${NC} ${TERTIARY}<${parameters}>${NC} $description"
        else
            echo "- ${SECONDARY}$alias${NC} $description"
        fi
    done | sort
    echo "-------------------"
    echo
    echo "${NC}Usage Example:${NC}"
    echo "  ${TERTIARY}aidd-help${NC}"
}

# Call the function to list all aliases
list_aliases
