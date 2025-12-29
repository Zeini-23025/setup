#!/usr/bin/env bash
# ===========================================================
# 🚀 Arch / Manjaro Setup Script - Version Optimisée
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
echo "🔧 Updating system..."
sudo pacman -Syu --noconfirm

# -----------------------------------------------------------
# 🛠  Packages de base
# -----------------------------------------------------------
log_info "Installing essential packages..."
# Note: neofetch wasn't available via pacman in this environment;
# using fastfetch instead (lightweight and available in repos)
sudo pacman -S --noconfirm \
    git curl wget unzip zip \
    htop fastfetch \
    base-devel vim nano \
    sl lolcat

# -----------------------------------------------------------
# 🧠 Installation de yay (AUR helper)
# -----------------------------------------------------------
if ! command -v yay &> /dev/null; then
    log_info "Installing yay..."
    cd /tmp
    rm -rf yay
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd ~
    log_info "yay installed successfully"
else
    log_info "yay already installed"
fi

# -----------------------------------------------------------
# 💻 Outils de développement
# -----------------------------------------------------------
log_info "Installing development tools..."
sudo pacman -S --noconfirm \
    gcc make cmake \
    php composer \
    python python-pip \
    jdk-openjdk \
    nodejs npm \
    mariadb docker docker-compose

# Configuration MariaDB (optionnel)
if ! systemctl is-active --quiet mariadb; then
    log_info "Initializing MariaDB..."
    sudo mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql 2>/dev/null || true
    sudo systemctl enable mariadb
    sudo systemctl start mariadb
    log_warn "Run 'sudo mysql_secure_installation' to secure MariaDB"
fi

# -----------------------------------------------------------
# 🌐 Navigateurs & Applications
# -----------------------------------------------------------
log_info "Installing desktop apps..."
sudo pacman -S --noconfirm firefox

# Installation des paquets AUR avec gestion d'erreur
AUR_PACKAGES=(
    "visual-studio-code-bin"
    "postman-bin"
    "pips.sh-bin"
    "cava"
    "steam"
)

for pkg in "${AUR_PACKAGES[@]}"; do
    if yay -S --noconfirm "$pkg"; then
        log_info "$pkg installed"
    else
        log_error "$pkg installation failed (continuing...)"
    fi
done

# -----------------------------------------------------------
# ⚙️  Zsh + Oh My Zsh
# -----------------------------------------------------------
log_info "Installing Zsh + Oh My Zsh..."
sudo pacman -S --noconfirm zsh

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

# Plugins recommandés (optionnel)
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
# 🎨 Configuration supplémentaire (optionnel)
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
yay -Yc --noconfirm
sudo pacman -Scc --noconfirm

# -----------------------------------------------------------
# 🎉 Terminé
# -----------------------------------------------------------
echo ""
echo "╔════════════════════════════════════════╗"
echo "║  ✅ Installation terminée avec succès! ║"
echo "╚════════════════════════════════════════╝"
echo ""
log_warn "Actions recommandées:"
echo "  1. Redémarre ton système: reboot"
echo "  2. Lance MariaDB secure: sudo mysql_secure_installation"
echo "  3. Configure ton .zshrc selon tes préférences"
echo ""
echo "🚀 Profite bien de ton nouveau setup!"