#!/usr/bin/env bash
# ===========================================================
# 🚀 Ubuntu / Debian Setup Script - Version Optimisée
# ===========================================================
set -e  # stop on error
set -u  # treat unset vars as error

# Couleurs pour l'output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Fonction pour logger
log_info() {
    echo -e "${GREEN}[✓]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[!]${NC} $1"
}

log_error() {
    echo -e "${RED}[✗]${NC} $1"
}

# -----------------------------------------------------------
# 🔄 Mise à jour du système
# -----------------------------------------------------------
log_info "Updating system..."
sudo apt update
sudo apt upgrade -y

# -----------------------------------------------------------
# 🛠  Packages de base
# -----------------------------------------------------------
log_info "Installing essential packages..."
sudo apt install -y \
    git curl wget unzip zip \
    htop neofetch \
    build-essential \
    software-properties-common \
    apt-transport-https \
    ca-certificates \
    gnupg \
    lsb-release \
    vim nano \
    sl

# -----------------------------------------------------------
# 💻 Outils de développement
# -----------------------------------------------------------
log_info "Installing development tools..."

# GCC, Make, CMake
sudo apt install -y gcc g++ make cmake

# PHP
sudo apt install -y php php-cli php-mbstring php-xml php-curl composer

# Python
sudo apt install -y python3 python3-pip python3-venv

# Java
sudo apt install -y default-jdk

# Node.js (via NodeSource)
log_info "Installing Node.js..."
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt install -y nodejs

# MySQL
log_info "Installing MySQL..."
sudo apt install -y mysql-server
sudo systemctl enable mysql
sudo systemctl start mysql
log_warn "Run 'sudo mysql_secure_installation' to secure MySQL"

# Docker
log_info "Installing Docker..."
if ! command -v docker &> /dev/null; then
    # Ajouter la clé GPG officielle de Docker
    sudo install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    sudo chmod a+r /etc/apt/keyrings/docker.gpg
    
    # Ajouter le repository
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
      $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    
    sudo apt update
    sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    log_info "Docker installed successfully"
else
    log_info "Docker already installed"
fi

# -----------------------------------------------------------
# 🌐 Navigateurs & Applications
# -----------------------------------------------------------
log_info "Installing desktop apps..."

# Firefox (déjà installé sur Ubuntu généralement)
sudo apt install -y firefox

# VS Code
log_info "Installing VS Code..."
if ! command -v code &> /dev/null; then
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
    sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
    sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
    rm -f packages.microsoft.gpg
    sudo apt update
    sudo apt install -y code
    log_info "VS Code installed"
else
    log_info "VS Code already installed"
fi

# Postman (via Snap)
if command -v snap &> /dev/null; then
    log_info "Installing Postman via Snap..."
    sudo snap install postman || log_error "Postman installation failed"
fi

# CAVA (Audio Visualizer)
log_info "Installing CAVA..."
sudo apt install -y libfftw3-dev libasound2-dev libncursesw5-dev libpulse-dev
if [ ! -d "/tmp/cava" ]; then
    cd /tmp
    git clone https://github.com/karlstav/cava.git
    cd cava
    ./autogen.sh
    ./configure
    make
    sudo make install
    cd ~
    log_info "CAVA installed"
fi

# Steam
if command -v snap &> /dev/null; then
    log_info "Installing Steam..."
    sudo snap install steam || sudo apt install -y steam
fi

# -----------------------------------------------------------
# ⚙️  Zsh + Oh My Zsh
# -----------------------------------------------------------
log_info "Installing Zsh + Oh My Zsh..."
sudo apt install -y zsh

# Installation Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    log_info "Installing Oh My Zsh..."
    export CHSH=no RUNZSH=no
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    log_info "Oh My Zsh installed"
fi

# Configuration du thème
if [ -f "$HOME/.zshrc" ]; then
    sed -i 's/^ZSH_THEME=.*/ZSH_THEME="bira"/' ~/.zshrc
    log_info "Zsh theme configured"
fi

# Changement du shell par défaut
if [ "$SHELL" != "$(which zsh)" ]; then
    chsh -s $(which zsh)
    log_warn "Zsh will be active after logout/login"
fi

# Plugins recommandés
if [ -f "$HOME/.zshrc" ]; then
    if ! grep -q "plugins=(git" ~/.zshrc; then
        sed -i 's/^plugins=.*/plugins=(git docker docker-compose npm node python)/' ~/.zshrc
        log_info "Zsh plugins configured"
    fi
fi

# -----------------------------------------------------------
# 🐳 Configuration Docker
# -----------------------------------------------------------
log_info "Configuring Docker..."
sudo systemctl enable docker
sudo systemctl start docker

# Ajout de l'utilisateur au groupe docker
if ! groups $USER | grep -q docker; then
    sudo usermod -aG docker $USER
    log_warn "Logout and login again to use Docker without sudo"
fi

# -----------------------------------------------------------
# 🎨 Configuration supplémentaire
# -----------------------------------------------------------
log_info "Additional configurations..."

# Git config basique
if [ ! -f "$HOME/.gitconfig" ]; then
    read -p "Configure Git? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        read -p "Git username: " git_user
        read -p "Git email: " git_email
        git config --global user.name "$git_user"
        git config --global user.email "$git_email"
        log_info "Git configured"
    fi
fi

# -----------------------------------------------------------
# 🧼 Nettoyage
# -----------------------------------------------------------
log_info "Cleaning up..."
sudo apt autoremove -y
sudo apt autoclean

# -----------------------------------------------------------
# 🎉 Terminé
# -----------------------------------------------------------
echo ""
echo "╔════════════════════════════════════════╗"
echo "║  ✅ Installation terminée avec succès! ║"
echo "╚════════════════════════════════════════╝"
echo ""
log_warn "Actions recommandées:"
echo "  1. Redémarre ton système: sudo reboot"
echo "  2. Lance MySQL secure: sudo mysql_secure_installation"
echo "  3. Configure ton .zshrc selon tes préférences"
echo ""
echo "🚀 Profite bien de ton nouveau setup!"