FROM codercom/code-server:4.19.1

# Variables d'environnement
ENV PASSWORD=changeme123

USER root

# Installation de base sans Claude Code
RUN apt-get update && apt-get install -y \
    curl wget git build-essential python3 python3-pip \
    nodejs npm sudo && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Permissions sudo
RUN echo "coder ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER coder
WORKDIR /home/coder/project

EXPOSE 8080

# Démarrage simple SANS Claude Code pour l'instant
CMD ["/usr/bin/entrypoint.sh", "--bind-addr", "0.0.0.0:8080", "--auth", "password"]
