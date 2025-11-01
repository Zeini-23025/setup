# Setup Script (Arch / Manjaro)

Ce dépôt contient un script `setup.sh` pour automatiser l'installation d'outils et d'applications sur Arch / Manjaro.

## Objectif

Fournir un script autonome pour :
- mettre à jour le système,
- installer des paquets essentiels,
- installer `yay` (AUR helper),
- installer des outils de développement (GCC, Python, Node.js, OpenJDK, etc.),
- configurer Docker et Oh My Zsh,
- installer quelques applications desktop.

## Prérequis

- Système : Arch Linux ou Manjaro
- Compte avec droits sudo
- Connexion Internet

## Usage

Depuis le répertoire du projet :

```bash
# Exécuter avec bash
bash ./setup.sh
```

Notes :
- Le script utilise `sudo` pour installer des paquets et démarrer des services.
- L'ajout de l'utilisateur au groupe `docker` nécessite une déconnexion/reconnexion pour prendre effet.
- Le script clone et construit `yay` depuis l'AUR (si non présent).

## Recommandations de test

- Ne lancez pas ce script sur une machine de production sans l'avoir relu.
- Testez-le d'abord dans une VM ou un conteneur Arch/Manjaro.
- Vous pouvez lire le fichier `setup.sh` et adapter la liste de paquets avant exécution.

## Pull request

Branche créée : `feature/setup-script` (PR proposée). Titre suggéré : `feat: ajouter script d'installation (setup.sh)`.

Description courte suggérée pour la PR :

> Ajout du script `setup.sh` pour automatiser l'installation d'outils et d'applications sur Arch/Manjaro. Le script met à jour le système, installe des paquets essentiels, installe `yay`, configure Docker et Oh My Zsh. Tester en VM avant usage sur un système de production.

---
Fichier créé automatiquement pour documenter l'usage basique du script.
# setup
