#!/bin/bash

set -e

SOURCE=https://github.com/ai-driven-dev/aliases/archive/refs/heads/main.zip
DEST=~/.ai-driven-dev
REPO_NAME=aliases-main
TMP=/tmp/aidd

echo "Create TMP folder if not exist."
if [ -d "$TMP" ]; then
    echo "Removing existing TMP folder."
    rm -rf "$TMP"
fi

mkdir -vp $TMP

echo "Download and extract source."
wget -qO- $SOURCE | tar -xz -C $TMP

if [ ! -d "$TMP/$REPO_NAME" ]; then
  echo "Failed to download or extract the source folder."
  exit 1
fi

echo "Create DEST folder if not exist."
mkdir -p $DEST

echo "Move files from $TMP to $DEST."
mv -v $TMP/$REPO_NAME/* $DEST/

. "$DEST/scripts/_.sh"

chmod +x $DEST/scripts/*.sh
chmod +x $DEST/scripts/git/*.sh
chmod +x $DEST/scripts/files/*.sh

debug "Remove the tmp folder."
rm -rf $TMP

debug "Added the following line to .bashrc: \`source $DEST/aliases.sh\`"

if grep -q "source $DEST/aliases.sh" ~/.bashrc; then
    notice "The aliases are already sourced in .bashrc."
else
    debug "The source line for aliases is missing in .bashrc, adding..."
    echo "source $DEST/aliases.sh" >> ~/.bashrc
fi

if [ -f ~/.zshrc ]; then
    if grep -q "source $DEST/aliases.sh" ~/.zshrc; then
        notice "The aliases are already sourced in .zshrc."
    else
        debug "The source line for aliases is missing in .zshrc, adding..."
        echo "source $DEST/aliases.sh" >> ~/.zshrc
    fi
else
    debug "~/.zshrc does not exist, skipping..."
fi

cd $DEST
npm install > /dev/null 2>&1

success "AI-Driven-Dev successfully installed: use 'aidd-help' to get started."
