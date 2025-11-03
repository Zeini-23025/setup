# 🚀 Linux Dev Environment Setup

This repository contains three opinionated Bash installers to bootstrap a developer workstation on popular Linux distributions:

- `setup.sh` — Arch / Manjaro
- `ubuntu.sh` — Ubuntu / Debian
- `fedora.sh` — Fedora / RHEL

Each script automates: system update, essential utilities, development toolchains (Python, Node.js, Java, PHP, etc.), Docker installation and configuration, optional desktop apps (VS Code, Postman, Steam...), and Zsh + Oh My Zsh setup.

> Read the script(s) before running. These are intended for developer workstations and should be tested in a VM before running on production systems.

---

## 📋 Supported distributions

- Arch Linux / Manjaro → `setup.sh`
- Ubuntu / Debian → `ubuntu.sh`
- Fedora / RHEL → `fedora.sh`

---

## ✨ What the scripts do (summary)

- Update the OS & packages
- Install essential CLI utilities (git, curl, wget, vim, htop, etc.)
- Install developer toolchains:
	- C/C++ toolchain (gcc, make, cmake)
	- Python (python3, pip, venv)
	- Node.js + npm (NodeSource on Debian/Ubuntu)
	- Java (OpenJDK)
	- PHP + Composer
	- Databases: MySQL / MariaDB
- Install and configure Docker and Docker Compose
- Install desktop applications (VS Code, Postman, Steam, other AUR packages on Arch)
- Install and configure Zsh + Oh My Zsh + recommended plugins and theme
- Optional cleanup and basic post-install hints (e.g., secure MySQL/MariaDB)

---

## 🧩 Quick usage

From the repository root:

Make the script executable (optional) and run it:

```bash
# Example: Ubuntu
chmod +x ./ubuntu.sh        # optional
bash ./ubuntu.sh

# Example: Fedora
chmod +x ./fedora.sh
bash ./fedora.sh

# Example: Arch/Manjaro
chmod +x ./setup.sh
bash ./setup.sh
```

You can also run directly with `bash` without changing permissions:
```bash
bash ./ubuntu.sh
```

Important: run these as a user with sudo privileges. The scripts call `sudo` for privileged operations.

---

## 🧭 Exact behavior per-script (what to expect)

### setup.sh (Arch / Manjaro)
- Uses `pacman` to update: `sudo pacman -Syu`
- Installs essentials: `git`, `curl`, `wget`, `unzip`, `zip`, `htop`, `neofetch`, `fastfetch`, `base-devel`, `vim`, `nano`, etc.
- Installs `yay` (AUR helper) if not present (clones `aur.archlinux.org/yay.git` and runs `makepkg -si`)
- Installs dev tools: `gcc`, `make`, `cmake`, `php`, `composer`, `python`, `jdk-openjdk`, `nodejs`, `npm`, `mariadb`, `docker`, `docker-compose`
- Installs desktop apps via AUR (e.g., `visual-studio-code-bin`, `postman-bin`, `steam`, etc.)
- Sets up Zsh + Oh My Zsh, configures `ZSH_THEME="bira"` and common plugins
- Enables + starts Docker, adds current user to `docker` group
- Runs cleanup (AUR and pacman caches)

### ubuntu.sh (Ubuntu / Debian)
- Runs `sudo apt update && sudo apt upgrade -y`
- Installs essentials: `build-essential`, `git`, `curl`, `wget`, `unzip`, `zip`, `htop`, `neofetch`, `vim`, `nano`, etc.
- Installs dev tools:
	- `gcc`, `make`, `cmake`
	- `php` + `composer` + PHP extensions
	- `python3`, `python3-pip`, `python3-venv`
	- `openjdk` (or `default-jdk`)
	- Node.js via NodeSource setup script (LTS)
	- `mysql-server`
	- `docker.io`, `docker-compose`
- Enables + starts Docker, adds user to `docker` group
- Installs Zsh + Oh My Zsh (non-interactive where possible)
- Optionally installs Steam (if available in repos)

### fedora.sh (Fedora / RHEL)
- Runs `sudo dnf -y upgrade --refresh`
- Installs essentials: `git`, `curl`, `wget`, `vim`, `htop`, `unzip`, `zip`, `neofetch`, `nano`, etc.
- Installs dev tools:
	- `dnf groupinstall "Development Tools"`
	- `gcc`, `make`, `cmake`
	- `php`, `composer`
	- `python3`, `python3-pip`
	- `java-17-openjdk-devel`
	- `nodejs`, `npm`
	- `mysql-server`
	- `docker`, `docker-compose-plugin`
- Enables + starts Docker, adds user to `docker` group
- Installs Zsh + Oh My Zsh
- Attempts to install Steam (may require third-party repos)

---

## 🧾 Table — tools & packages installed (high-level)

| Category | Common packages (examples) |
|---|---|
| Essentials | git, curl, wget, unzip, zip, htop, neofetch, vim, nano, sl, lolcat |
| Build / Dev tools | gcc, g++, make, cmake, base-devel (Arch), Development Tools (Fedora) |
| Languages | python3 (+pip, venv), nodejs + npm, openjdk / jdk |
| PHP ecosystem | php, php-cli, composer (and some PHP extensions) |
| Databases | mysql-server (Ubuntu/Fedora), mariadb (Arch) |
| Docker | docker, docker-compose (or docker-compose-plugin) |
| Desktop apps (examples) | VS Code (binary), Postman, Steam, cava |
| Shell & UX | zsh, oh-my-zsh, zsh plugins, theme |

> Note: exact package names vary across distros. Check each script to view the precise package lists.

---

## ✅ Prerequisites

- A user account with sudo privileges
- Internet connection
- Preferably run on a non-production machine (VM recommended for first run)
- For Arch: `git` available (used to clone `yay`)
- For Debian/Ubuntu: ability to run NodeSource installer if Node.js is desired
- For Fedora/RHEL: may need to enable EPEL/RPM Fusion for some packages (Steam, etc.)

---

## 🔧 Post-install steps & recommendations

- Docker group
	- After `sudo usermod -aG docker $USER` you need to log out and log back in for group membership to apply. Alternatively run:
		```bash
		newgrp docker
		```
- Secure MariaDB / MySQL
	- Run:
		```bash
		sudo mysql_secure_installation
		```
	- Follow prompts to set root password, remove anonymous users, disallow remote root login, remove test database.
- Zsh / Oh My Zsh
	- The script may set Zsh as default. If you prefer bash, skip `chsh` or change back with:
		```bash
		chsh -s /bin/bash
		```
	- Customize `~/.zshrc` to change theme and plugins.
- Reboot
	- After heavy system changes (kernel, Docker config, group changes), reboot:
		```bash
		sudo reboot
		```
- Check Docker
	```bash
	sudo systemctl status docker
	docker run hello-world
	```

---

## 🛠 Troubleshooting tips

- Package fails to install:
	- Check network, retry, inspect package manager logs (`/var/log/apt`, `journalctl`, `dnf` output).
- AUR package (Arch) build fails:
	- Ensure `base-devel` and required dependencies are installed; inspect `makepkg` output for missing deps.
- Oh My Zsh installation fails:
	- Ensure `curl` is present and the machine has outbound HTTPS access.
- Steam or proprietary apps not found:
	- May require enabling third-party repos (e.g., multiverse, RPM Fusion).

---

## 🧭 Example run workflows

1) Quick demo (Ubuntu)
```bash
# From repo root
bash ./ubuntu.sh
# Follow the output and run mysql_secure_installation and reboot when done.
```

2) Arch (with AUR)
```bash
chmod +x ./setup.sh
bash ./setup.sh
# If you see AUR failures, open the log and retry the specific package with yay.
```

3) Fedora
```bash
bash ./fedora.sh
# If steam or other packages fail, enable required repos and retry.
```

---

## 🤝 Contributing

Contributions welcome — small steps:

1. Fork the repository
2. Create a branch: `git checkout -b feat/your-change`
3. Make changes, test locally (ideally in a VM)
4. Commit with a clear message, push and open a Pull Request

Please:
- Keep scripts idempotent where possible
- Prefer non-interactive flags for unattended installs (or make interactive steps clearly optional)
- Document any new packages or repo additions in the README

---

## 📝 License

This repository is provided under the MIT License. See `LICENSE` for details.

---
## 👨‍💻 Auteur

**Zeini Cheikh**
[![GitHub](https://img.shields.io/badge/GitHub-Zeini--23025-black?style=flat&logo=github)](https://github.com/Zeini-23025)
<br>

## ℹ️ Final Notes

- These scripts make system-level changes; always read them before running.
- Use a virtual machine for testing initially.



## ⭐ **Feel free to give a star if this project helped you!**