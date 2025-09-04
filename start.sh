#!/bin/bash

# Auto-installation de Claude Code si absent
if ! command -v claude &> /dev/null; then
    echo "🤖 Installation de Claude Code..."
    npm install -g @anthropic-ai/claude-code
fi

# Configuration de Git (optionnel)
git config --global user.name "Remote Dev"
git config --global user.email "dev@remote.local"

# Démarrage de code-server
exec /usr/bin/entrypoint.sh --bind-addr 0.0.0.0:8080 --auth password
