FROM codercom/code-server:4.19.1

# Variables d'environnement
ENV PASSWORD=changeme123
ENV DEBIAN_FRONTEND=noninteractive

USER root

# Installation des outils de base
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    build-essential \
    python3 \
    python3-pip \
    sudo \
    ca-certificates \
    gnupg \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Installation Node.js 20.x LTS
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs

# Installation Claude Code avec permissions root
RUN curl -L -o /usr/local/bin/claude https://github.com/anthropics/claude-code/releases/latest/download/claude-linux-x64 && \
    chmod +x /usr/local/bin/claude

# Permissions sudo pour l'utilisateur coder
RUN echo "coder ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER coder
WORKDIR /home/coder/project

# Configuration Git et historique bash
RUN git config --global user.name "Remote Dev" && \
    git config --global user.email "dev@remote.local" && \
    git config --global init.defaultBranch main && \
    echo 'export HISTSIZE=10000' >> ~/.bashrc && \
    echo 'export HISTFILESIZE=10000' >> ~/.bashrc && \
    echo 'export HISTCONTROL=ignoredups:erasedups' >> ~/.bashrc && \
    echo 'shopt -s histappend' >> ~/.bashrc && \
    echo 'export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"' >> ~/.bashrc

# Structure de projet
RUN mkdir -p coding-projects mcp-components automation agenda-management

EXPOSE 8080

# Démarrage direct de code-server
CMD ["/usr/bin/entrypoint.sh", "--bind-addr", "0.0.0.0:8080", "--auth", "password"]
