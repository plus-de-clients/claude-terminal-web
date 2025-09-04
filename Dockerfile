FROM codercom/code-server:4.19.1

# Variables d'environnement
ENV PASSWORD=changeme123
ENV SUDO_PASSWORD=changeme123

# Mise à jour et installation des outils essentiels
USER root
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    build-essential \
    python3 \
    python3-pip \
    nodejs \
    npm \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Installation de Claude Code CLI (version corrigée)
RUN npm install -g @anthropic-ai/claude-code || echo "⚠️ Claude Code installation failed"

# Création du répertoire de travail
USER coder
WORKDIR /home/coder/project

# Port d'exposition
EXPOSE 8080

# Script de démarrage
COPY --chown=coder:coder start.sh /home/coder/start.sh
RUN chmod +x /home/coder/start.sh

CMD ["/home/coder/start.sh"]
