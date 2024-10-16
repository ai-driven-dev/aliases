#!/bin/bash

. "$(dirname "$0")/scripts/_.sh"

# Development purpose

NAME="ai-driven-dev-aliases"
DEST=~/.ai-driven-dev

if [ -d "$DEST" ]; then
  debug "Directory $DEST already exists, removing..."
  rm -rf $DEST
fi

debug "Copying {$NAME} to {$DEST}..."
cp -r . $DEST

debug "Making scripts executable..."
chmod +x $DEST/scripts/*.sh
chmod +x $DEST/scripts/git/*.sh
chmod +x $DEST/scripts/files/*.sh

# Install node modules
cd $DEST
npm install

source ~/.bashrc

if grep -q 'source ~/.ai-driven-dev/aliases.sh' ~/.bashrc; then
    success "The aliases are already sourced in .bashrc."
else
    debug "The source line for aliases is missing in .bashrc, adding..."
    echo 'source ~/.ai-driven-dev/aliases.sh' >> ~/.bashrc
fi

success "$NAME installed successfully."
