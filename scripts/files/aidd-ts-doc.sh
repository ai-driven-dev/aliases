#!/bin/sh

###############################################################################
# Script Name: "files/aidd-ts-doc.sh"
# Description: Generates TypeScript documentation using typedoc and combines markdown files
# Parameters: 
#   --input-dir: Input directory containing TypeScript files (default: 'documentation/')
#   --output-file: Output file name (default: 'project-documentation.txt')
#   --commit: Automatically commit changes
# Usage: aidd-ts-doc [--input-dir dir] [--output-file file] [--commit]
###############################################################################

. "$(dirname "$0")/../_.sh"

# REQUIREMENTS
# --------------------
check_binary "typedoc"
check_binary "node"
check_binary "git"

# SCRIPT PARAMS
# --------------------
INPUT_DIR=${INPUT_DIR:-'documentation/'}
OUTPUT_FILE=${OUTPUT_FILE:-'project-documentation.txt'}
if [ -f "./package.json" ]; then
  VERSION=${VERSION:-$(node -p "require('./package.json').version")}
else
  VERSION=${VERSION:-"0.0.0"}
fi
DATE=$(date +%Y-%m-%d-%H:%M:%S)

# Parse command line arguments
while [ "$#" -gt 0 ]; do
  case "$1" in
    --input-dir) INPUT_DIR="$2"; shift 2;;
    --output-file) OUTPUT_FILE="$2"; shift 2;;
    --commit) COMMIT_CHANGES=true; shift 1;;
    *) echo "Unknown parameter: $1"; exit 1;;
  esac
done

# SCRIPT
# --------------------
echo "Exporting markdown files for version $VERSION"

# Generate markdown documentation
typedoc --options typedoc.json \
  --plugin typedoc-plugin-markdown \
  --out "${INPUT_DIR}"

# Navigate to input directory
cd "${INPUT_DIR}" || exit 1

# Combine markdown files
find . -name '*.md*' ! -name "${OUTPUT_FILE}" -exec cat {} \; > "${OUTPUT_FILE}"

# Add metadata header
{
  echo "---"
  echo "version: $VERSION"
  echo "date: $DATE"
  echo "---"
  echo
  cat "${OUTPUT_FILE}"
} > "${OUTPUT_FILE}.tmp"
mv "${OUTPUT_FILE}.tmp" "${OUTPUT_FILE}"

# Return to original directory
cd - || exit 1

# Commit changes if requested
if [ "$COMMIT_CHANGES" = true ]; then
  git add "${INPUT_DIR}"
  git commit -m "docs: update project documentation for version $VERSION"
fi