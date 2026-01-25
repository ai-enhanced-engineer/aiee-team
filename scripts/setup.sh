#!/bin/bash
# AIEE Team Plugin Setup Script
# Creates symlink for Claude Code plugin discovery

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_DIR="$(dirname "$SCRIPT_DIR")"
PLUGIN_NAME="aiee-team"
CLAUDE_PLUGINS_DIR="$HOME/.claude/plugins"

echo "AIEE Team Plugin Setup"
echo "======================"
echo ""

# Create plugins directory if it doesn't exist
if [ ! -d "$CLAUDE_PLUGINS_DIR" ]; then
    echo "Creating plugins directory: $CLAUDE_PLUGINS_DIR"
    mkdir -p "$CLAUDE_PLUGINS_DIR"
fi

# Check if symlink already exists
if [ -L "$CLAUDE_PLUGINS_DIR/$PLUGIN_NAME" ]; then
    echo "Symlink already exists. Removing old symlink..."
    rm "$CLAUDE_PLUGINS_DIR/$PLUGIN_NAME"
elif [ -e "$CLAUDE_PLUGINS_DIR/$PLUGIN_NAME" ]; then
    echo "Error: $CLAUDE_PLUGINS_DIR/$PLUGIN_NAME exists but is not a symlink."
    echo "Please remove it manually and run this script again."
    exit 1
fi

# Create symlink
echo "Creating symlink: $CLAUDE_PLUGINS_DIR/$PLUGIN_NAME -> $PLUGIN_DIR"
ln -s "$PLUGIN_DIR" "$CLAUDE_PLUGINS_DIR/$PLUGIN_NAME"

echo ""
echo "Setup complete!"
echo ""
echo "The following agents are now available:"
for agent in "$PLUGIN_DIR/agents/"*.md; do
    basename "$agent" .md
done
echo ""
echo "Restart Claude Code to load the plugin."
