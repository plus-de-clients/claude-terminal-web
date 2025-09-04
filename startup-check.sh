#!/bin/bash

echo "🚀 Démarrage de l'environnement VS Code Web..."

# Fonction de logging
log() {
    echo "[$(date '+%H:%M:%S')] $1"
}

# Vérification et installation de Claude Code si nécessaire
check_claude() {
    log "Vérification de Claude Code..."
    
    if command -v claude >/dev/null 2>&1; then
        log "✅ Claude Code déjà installé: $(claude --version 2>/dev/null || echo 'version inconnue')"
        return 0
    fi
    
    log "⚠️ Claude Code non trouvé, installation en cours..."
    
    # Méthode 1: npm global
    if npm install -g @anthropic-ai/claude-code --silent 2>/dev/null; then
        log "✅ Claude Code installé via npm"
        return 0
    fi
    
    # Méthode 2: script officiel
    if curl -fsSL https://claude.ai/install.sh | bash 2>/dev/null; then
        # Ajouter au PATH
        export PATH="$HOME/.local/bin:$PATH"
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
        log "✅ Claude Code installé via script officiel"
        return 0
    fi
    
    # Méthode 3: téléchargement direct
    if curl -L -o /tmp/claude https://github.com/anthropics/claude-code/releases/latest/download/claude-linux-x64 2>/dev/null; then
        chmod +x /tmp/claude
        sudo mv /tmp/claude /usr/local/bin/claude 2>/dev/null && {
            log "✅ Claude Code installé via téléchargement direct"
            return 0
        }
    fi
    
    log "❌ Échec de l'installation de Claude Code - continuera sans"
    return 1
}

# Vérification des outils essentiels
check_tools() {
    log "Vérification des outils..."
    
    for tool in git node npm python3; do
        if command -v $tool >/dev/null 2>&1; then
            log "✅ $tool: $(${tool} --version 2>/dev/null | head -n1)"
        else
            log "❌ $tool manquant"
        fi
    done
}

# Configuration de l'environnement
setup_environment() {
    log "Configuration de l'environnement..."
    
    # Créer les répertoires de travail
    mkdir -p ~/project/{coding-projects,mcp-components,automation,agenda-management}
    
    # Configuration Git si pas déjà fait
    if ! git config --global user.name >/dev/null 2>&1; then
        git config --global user.name "Remote Developer"
        git config --global user.email "dev@remote.local"
        git config --global init.defaultBranch main
        log "✅ Git configuré"
    fi
    
    # Créer un fichier README dans le workspace
    if [ ! -f ~/project/README.md ]; then
        cat > ~/project/README.md << 'EOF'
# 🚀 Environnement de Développement Distant

## Outils disponibles
- ✅ VS Code Web
- ✅ Claude Code CLI (si installé)
- ✅ Node.js & npm
- ✅ Python 3
- ✅ Git

## Répertoires
- `coding-projects/` : Vos projets de développement
- `mcp-components/` : Composants MCP personnalisés
- `automation/` : Scripts d'automatisation
- `agenda-management/` : Outils de gestion RDV

## Premiers pas
1. Ouvrir le terminal : `Terminal → New Terminal`
2. Tester Claude Code : `claude --version`
3. Configurer Claude Code : `claude auth`

Bon développement ! 🎯
EOF
        log "✅ README créé dans ~/project/"
    fi
}

# Fonction principale
main() {
    log "=== INITIALISATION ENVIRONNEMENT VS CODE WEB ==="
    
    # Vérifications et installations
    check_tools
    check_claude
    setup_environment
    
    log "=== DÉMARRAGE VS CODE SERVER ==="
    
    # Changer vers le répertoire de projet
    cd ~/project
    
    # Démarrer code-server avec configuration optimisée
    exec /usr/bin/entrypoint.sh \
        --bind-addr 0.0.0.0:8080 \
        --auth password \
        --disable-telemetry \
        --disable-update-check
}

# Gestion des signaux pour arrêt propre
trap 'log "Arrêt demandé, fermeture propre..."; exit 0' SIGTERM SIGINT

# Lancement
main "$@"
