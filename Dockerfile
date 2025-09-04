# Utiliser une image Node.js récente
FROM node:18-slim

# Installer les dépendances système nécessaires
RUN apt-get update && apt-get install -y \
    curl \
    git \
    && rm -rf /var/lib/apt/lists/*

# Créer un répertoire de travail
WORKDIR /app

# Installer Claude CLI globalement
RUN npm install -g @anthropic-ai/claude-code

# Copier votre script de démarrage
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

# Commande de démarrage
CMD ["/app/start.sh"]
