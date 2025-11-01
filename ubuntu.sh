#!/bin/bash
#==========================================================
# 🚀 Setup Script - Ubuntu
#==========================================================
set -e  # stop on error
set -u  # treat unset vars as error

# Update package list and upgrade packages
echo "Updating system..."
sudo apt update && sudo apt upgrade -y


#------------------------------------------------------------
# 📦 Installing essential packages
sudo apt install -y build-essential git curl wget unzip zip \
    htop neofetch vim nano \
    sl lolcat
echo "Essential packages installation completed."

#------------------------------------------------------------
# 🧠 Installing development tools
sudo apt install -y build-essential git curl wget unzip zip \
    htop neofetch vim nano \
    sl lolcat
echo "Essential packages installation completed."


#------------------------------------------------------------
# 💻 Development Tools
echo "Installing development tools..."
# GCC, Make, CMake
sudo apt install -y gcc make cmake
# PHP
sudo apt install -y php libapache2-mod-php composer
# Python
sudo apt install -y python3 python3-pip
# OpenJDK 17
sudo apt install -y openjdk-17-jdk
# Node.js and npm
sudo apt install -y nodejs npm
# MySQL
sudo apt install -y mysql-server
# Docker
sudo apt install -y docker.io docker-compose

echo "Development tools installation completed."

#------------------------------------------------------------
# 🐳 Docker setup
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker $USER
echo "Docker setup completed."

#------------------------------------------------------------
# ⚙️ Zsh + Oh My Zsh
echo "Installing Oh My Zsh..."
sudo apt install -y zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
chsh -s $(which zsh) || true
echo "Oh My Zsh installation completed."

#==========================================================
# Steam installation
echo "Installing Steam..."
sudo apt install -y steam
echo "Steam installation completed."

echo "Setup completed successfully. Please restart your terminal."
