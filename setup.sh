#!/usr/bin/env bash
# ===========================================================
# 🚀 Setup Script - arch / manjaro
# ===========================================================
set -e  # stop on error
set -u  # treat unset vars as error


echo " updating system..."
sudo pacman -Syu --noconfirm
echo " Installing essential packages..."
sudo pacman -S --noconfirm \
    git curl wget unzip zip \
    htop neofetch fastfetch \
    base-devel vim nano \
    sl lolcat

echo " Essential packages installation completed."

# -----------------------------------------------------------
# 🧠 Installation de yay (AUR helper)
echo " Installing yay (AUR helper)..."
sudo pacman -S --noconfirm git base-devel
cd /tmp
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si --noconfirm

cd ~
echo " yay installed successfully"
# -----------------------------------------------------------
# 💻 Outils de développement
echo " Installing development tools..."
# GCC, Make, CMake
sudo pacman -S --noconfirm gcc make cmake
# PHP
sudo pacman -S --noconfirm php php-apache composer
# Python
sudo pacman -S --noconfirm python python-pip
# OpenJDK 17
sudo pacman -S --noconfirm jdk17-openjdk
# Node.js et npm
sudo pacman -S --noconfirm nodejs npm
# MySQL
sudo pacman -S --noconfirm mysql
# Docker
sudo pacman -S --noconfirm docker docker-compose

echo " Development tools installation completed."

# -----------------------------------------------------------
# 🐳 Docker setup
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker $USER
echo " Docker setup completed."

# -----------------------------------------------------------
# ⚙️ Zsh + Oh My Zsh
echo " Installing Oh My Zsh..."
chsh -s $(which zsh) || true
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi
# Simple Zsh theme
sed -i 's/^ZSH_THEME=.*/ZSH_THEME="bira"/' ~/.zshrc
echo " Oh My Zsh installation completed."

# -----------------------------------------------------------
# 🧼 Optional: GUI apps
echo " Installing desktop apps..."
sudo pacman -S --noconfirm firefox steam
echo " Desktop apps installation completed."


# -----------------------------------------------------------
# steam 
log_info "Installing Steam..."
sudo pacman -S --noconfirm steam
echo " Steam installation completed."


echo " Setup completed. Please restart your terminal or log out/in for changes to take effect."
