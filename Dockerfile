FROM codercom/code-server:4.19.1

# Variables d'environnement
ENV PASSWORD=changeme123

USER root

# Installation uniquement des outils de base
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    build-essential \
    python3 \
    python3-pip \
    nodejs \
    npm \
    sudo \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Permissions sudo
RUN echo "coder ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER coder
WORKDIR /home/coder/project

# Configuration Git de base
RUN git config --global user.name "Remote Dev" && \
    git config --global user.email "dev@remote.local"

# Création de la structure de projet
RUN mkdir -p /home/coder/project/{coding-projects,mcp-components,automation,agenda-management}

EXPOSE 8080

# Démarrage direct sans Claude Code
CMD ["/usr/bin/entrypoint.sh", "--bind-addr", "0.0.0.0:8080", "--auth", "password"]
