#!/bin/bash
#==========================================================
# 🚀 Setup Script - Fedora
#==========================================================

set -e  # stop on error
set -u  # treat unset vars as error


# ------------------------------------------------------------
# 📦 Updating system

echo "Updating system..."
sudo dnf upgrade -y

# ------------------------------------------------------------
# 📦 Installing essential packages

sudo dnf install -y \
    git \
    curl \
    wget \
    vim \
    htop
    unzip \
    zip \
    neofetch \
    nano \
    sl \
    lolcat

echo "Essential packages installation completed."

# ------------------------------------------------------------
# 💻 Development Tools

sudo dnf groupinstall -y "Development Tools"
echo "Installing development tools..."
# GCC, Make, CMake
sudo dnf install -y gcc make cmake
# PHP
sudo dnf install -y php php-cli php-mysqlnd composer
# Python
sudo dnf install -y python3 python3-pip
# OpenJDK 17
sudo dnf install -y java-17-openjdk-devel
# Node.js and npm
sudo dnf install -y nodejs npm
# MySQL
sudo dnf install -y mysql-server
# Docker
sudo dnf install -y docker docker-compose

echo "Development tools installation completed."

# ------------------------------------------------------------
# 🐳 Docker setup

sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker $USER

echo "Docker setup completed."

# ------------------------------------------------------------
# ⚙️ Zsh + Oh My Zsh

echo "Installing Oh My Zsh..."
sudo dnf install -y zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
chsh -s $(which zsh) || true
echo "Oh My Zsh installation completed."

#==========================================================
# Steam installation

echo "Installing Steam..."
sudo dnf install -y steam
echo "Steam installation completed."

#==========================================================
echo "Setup completed successfully!" Please restart your terminal.