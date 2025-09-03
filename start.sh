#!/bin/bash

# Configuration de Git (optionnel)
git config --global user.name "Remote Dev"
git config --global user.email "dev@remote.local"

# Démarrage de code-server
exec /usr/bin/entrypoint.sh --bind-addr 0.0.0.0:8080 --auth password
