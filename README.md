# ChessArena

**The Ultimate Chess Game — Mobile Application (Flutter/Dart)**

## Description
ChessArena est une application mobile Flutter permettant de jouer à trois jeux de plateau classiques :
- Échecs
- Dames
- Morpion (Tic-Tac-Toe)

Le projet propose une expérience utilisateur soignée avec une interface graphique moderne, intuitive et personnalisable.

## Fonctionnalités principales

### Échecs
- Plateau interactif respectant les règles officielles FIDE
- Validation des déplacements selon les règles spécifiques de chaque pièce
- Détection automatique :
  - Échec / Échec et mat
  - Pat
  - Roque
  - Promotion
  - Répétition de position
- Système d'**Undo** (retour arrière) via SQLite
- Sauvegarde et reprise des parties
- Timer individuel par joueur, configurable
- Indicateur d'échec visuel (bordure rouge du roi)
- Affichage des coups possibles d'une pièce
- Skins personnalisables pour le plateau et les pièces
- Boutons :
  - Réinitialiser la partie
  - Abandon avec confirmation
  - Modification du thème visuel

### Dames
- Plateau et mécanique adaptés
- Gestion complète des règles spécifiques :
  - Déplacement en diagonale
  - Prise obligatoire et enchaînée
  - Promotion en Dame
- Indication visuelle des coups possibles
- Boutons :
  - Réinitialiser
  - Affichage des coups
- Détection de fin de partie (victoire/défaite)

### Morpion (Tic-Tac-Toe)
- Plateau 3x3
- Alternance automatique des joueurs
- Détection de victoire ou match nul
- Intégration complète au thème graphique choisi

## Technologies utilisées
- **Flutter** & **Dart**
- **SQLite** (sauvegarde d'état des parties)
- **Figma** (conception des maquettes)
- **Trello** (gestion de projet)
- **GitHub** (gestion de version)

## Installation

1. Cloner le projet :
   ```bash
   git clone https://github.com/nom-utilisateur/ChessArena.git
   ```
2. Installer les dépendances :
    ```bash
    flutter pub get
    ```

3. Lancer l'application :
    ```bash
    flutter run
    ```

ou

1. Installer l'apk se situant dans le dossier apk.

## Auteurs

- Thomas Manche — Back-end et front-end des échecs
- Gauvain Lepitre — Front-end échecs et intégration
- Dan Depredurand — Interface graphique & transitions
- Alphonse Kerbellec — Développement du jeu de dames

## Limitations connues

Problème résiduel sur le timer d'échecs : après une défaite au temps, le timer ne se réinitialise pas correctement pour les parties suivantes (lié à la gestion des threads).

## Perspectives d'amélioration

- Mode multijoueur en ligne
- Intelligence artificielle pour les jeux solo
- Amélioration de la gestion du timer
- Optimisation de la gestion d'état