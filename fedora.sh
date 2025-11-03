#!/usr/bin/env bash
# ===========================================================
# 🚀 Fedora Setup Script - Version Optimisée
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
sudo dnf upgrade -y --refresh

# -----------------------------------------------------------
# 🔌 Activation des repositories RPM Fusion
# -----------------------------------------------------------
log_info "Enabling RPM Fusion repositories..."
sudo dnf install -y \
    https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
    https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# -----------------------------------------------------------
# 🛠  Packages de base
# -----------------------------------------------------------
log_info "Installing essential packages..."
sudo dnf install -y \
    git curl wget unzip zip \
    htop neofetch \
    @development-tools \
    vim nano \
    sl

# Fastfetch (alternative à neofetch)
sudo dnf copr enable -y konimex/fastfetch
sudo dnf install -y fastfetch

# -----------------------------------------------------------
# 💻 Outils de développement
# -----------------------------------------------------------
log_info "Installing development tools..."

# GCC, Make, CMake
sudo dnf install -y gcc gcc-c++ make cmake

# PHP
sudo dnf install -y php php-cli php-mbstring php-xml php-curl composer

# Python
sudo dnf install -y python3 python3-pip python3-virtualenv

# Java
sudo dnf install -y java-latest-openjdk java-latest-openjdk-devel

# Node.js
log_info "Installing Node.js..."
sudo dnf install -y nodejs npm

# MySQL (MariaDB sur Fedora)
log_info "Installing MariaDB..."
sudo dnf install -y mariadb-server
sudo systemctl enable mariadb
sudo systemctl start mariadb
log_warn "Run 'sudo mysql_secure_installation' to secure MariaDB"

# Docker
log_info "Installing Docker..."
if ! command -v docker &> /dev/null; then
    sudo dnf remove -y docker \
                      docker-client \
                      docker-client-latest \
                      docker-common \
                      docker-latest \
                      docker-latest-logrotate \
                      docker-logrotate \
                      docker-selinux \
                      docker-engine-selinux \
                      docker-engine 2>/dev/null || true
    
    sudo dnf install -y dnf-plugins-core
    sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
    sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    log_info "Docker installed successfully"
else
    log_info "Docker already installed"
fi

# -----------------------------------------------------------
# 🌐 Navigateurs & Applications
# -----------------------------------------------------------
log_info "Installing desktop apps..."

# Firefox (généralement pré-installé)
sudo dnf install -y firefox

# VS Code
log_info "Installing VS Code..."
if ! command -v code &> /dev/null; then
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
    sudo dnf check-update
    sudo dnf install -y code
    log_info "VS Code installed"
else
    log_info "VS Code already installed"
fi

# Postman (via Flatpak)
if command -v flatpak &> /dev/null; then
    log_info "Installing Postman via Flatpak..."
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    flatpak install -y flathub com.getpostman.Postman || log_error "Postman installation failed"
fi

# CAVA (Audio Visualizer)
log_info "Installing CAVA..."
sudo dnf install -y fftw-devel alsa-lib-devel ncurses-devel pulseaudio-libs-devel autoconf automake libtool
if [ ! -d "/tmp/cava" ]; then
    cd /tmp
    rm -rf cava
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
log_info "Installing Steam..."
sudo dnf install -y steam || log_error "Steam installation failed"

# -----------------------------------------------------------
# ⚙️  Zsh + Oh My Zsh
# -----------------------------------------------------------
log_info "Installing Zsh + Oh My Zsh..."
sudo dnf install -y zsh

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
        sed -i 's/^plugins=.*/plugins=(git docker docker-compose npm node python dnf)/' ~/.zshrc
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
# ⚡ Optimisations Fedora
# -----------------------------------------------------------
log_info "Applying Fedora optimizations..."

# DNF plus rapide
if ! grep -q "max_parallel_downloads" /etc/dnf/dnf.conf; then
    echo "max_parallel_downloads=10" | sudo tee -a /etc/dnf/dnf.conf
    echo "fastestmirror=True" | sudo tee -a /etc/dnf/dnf.conf
    log_info "DNF optimized"
fi

# -----------------------------------------------------------
# 🧼 Nettoyage
# -----------------------------------------------------------
log_info "Cleaning up..."
sudo dnf autoremove -y
sudo dnf clean all

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
echo "  2. Lance MariaDB secure: sudo mysql_secure_installation"
echo "  3. Configure ton .zshrc selon tes préférences"
echo "  4. Pour Flatpak apps: flatpak update"
echo ""
echo "🚀 Profite bien de ton nouveau setup!"