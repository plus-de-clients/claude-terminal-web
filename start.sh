#!/bin/bash

# Vérifier la version de Node
echo "Node version: $(node --version)"

# Installer Claude CLI si nécessaire
if ! command -v claude &> /dev/null; then
    echo "Installing Claude CLI..."
    npm install -g @anthropic-ai/claude-code
fi

# Configurer l'authentification via variable d'environnement
# (Ajoutez votre API key dans les variables d'environnement Render)
if [ ! -z "$ANTHROPIC_API_KEY" ]; then
    # Créer le fichier de configuration Claude
    mkdir -p ~/.config/claude
    echo "{\"apiKey\": \"$ANTHROPIC_API_KEY\"}" > ~/.config/claude/config.json
    echo "Claude authentication configured"
fi

# Votre application principale
exec "$@"
