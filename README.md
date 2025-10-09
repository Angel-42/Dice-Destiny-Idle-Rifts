# 🎲 Dice Destiny: Idle Rifts

[![Flutter CI/CD](https://github.com/Angel-42/Dice-Destiny-Idle-Rifts/actions/workflows/ci.yml/badge.svg)](https://github.com/Angel-42/Dice-Destiny-Idle-Rifts/actions/workflows/ci.yml)
[![Release](https://img.shields.io/github/v/release/Angel-42/Dice-Destiny-Idle-Rifts)](https://github.com/Angel-42/Dice-Destiny-Idle-Rifts/releases/latest)
[![Flutter](https://img.shields.io/badge/Flutter-3.35.5-blue)](https://flutter.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

Un RPG tactique idle où le destin est dicté par les dés cosmiques. Affrontez les Rifts dimensionnels et sauvez l'équilibre des mondes !

![Game Banner](assets/banner.png)

## 🎮 Caractéristiques

- ⚔️ **Combat Tactique** : Système de grille stratégique avec déplacement et attaques
- 🎲 **Système de Dés** : Le hasard dicte votre destinée
- 👤 **Création de Personnage** : Race, Région, Origine et Classe personnalisables
- 🏰 **Aventure Idle** : Progression automatique même hors-ligne
- 🎰 **Système Gacha** : Invocation de héros légendaires
- 🌍 **Univers Riche** : Lore profond avec différentes régions (Occident, Orient, Nord, Sud)

## 📱 Installation

### Android

#### Option 1 : Téléchargement Direct (Recommandé)
[![Download APK](https://img.shields.io/github/v/release/Angel-42/Dice-Destiny-Idle-Rifts?label=Download%20APK&style=for-the-badge&logo=android)](https://github.com/Angel-42/Dice-Destiny-Idle-Rifts/releases/latest/download/dice-destiny-idle-rifts-latest.apk)

1. Téléchargez l'APK depuis la [page des releases](https://github.com/Angel-42/Dice-Destiny-Idle-Rifts/releases/latest)
2. Activez "Sources inconnues" dans les paramètres Android
3. Installez l'APK
4. Lancez le jeu !

#### Option 2 : Compilation depuis les sources
```bash
# Cloner le repository
git clone https://github.com/Angel-42/Dice-Destiny-Idle-Rifts.git
cd Dice-Destiny-Idle-Rifts

# Installer les dépendances
flutter pub get

# Compiler l'APK
flutter build apk --release

# L'APK se trouve dans: build/app/outputs/flutter-apk/app-release.apk
```

### Linux
```bash
flutter build linux --release
./build/linux/x64/release/bundle/dice_destiny_idle_rifts
```

### Windows
```bash
flutter build windows --release
```

## 🎯 Comment Jouer

### 1. Création de Personnage
Choisissez votre :
- **Race** : Humain, Elfe, Nain ou Orc
- **Région** : Occident, Orient, Nord ou Sud
- **Origine** : Noble, Marchand, Paysan ou Érudit
- **Classe** : Guerrier, Mage, Voleur ou Clerc

### 2. Modes de Jeu
- 🗺️ **Aventure** : Explorez des donjons tactiques
- ⚔️ **Combat** : Système de grille stratégique
- 🏪 **Boutique** : Achetez équipements et consommables
- 🎰 **Gacha** : Invoquez de nouveaux héros
- ⚙️ **Paramètres** : Personnalisez votre expérience

### 3. Progression
- Gagnez de l'or et des gemmes
- Améliorez vos statistiques
- Débloquez de nouveaux héros
- Progressez dans l'histoire

## 🛠️ Technologies

- **Framework** : [Flutter 3.35.5](https://flutter.dev)
- **Langage** : Dart
- **Plateforme** : Android, Linux, Windows, macOS, iOS (à venir)
- **CI/CD** : GitHub Actions
- **Notifications** : Discord Webhooks

## 📊 Architecture

```
lib/
├── main.dart                    # Point d'entrée
└── src/
    ├── models/                  # Modèles de données
    │   ├── character.dart
    │   └── persona.dart
    ├── screens/                 # Écrans de l'app
    │   ├── main_menu_screen.dart
    │   ├── intro_screen.dart
    │   ├── persona_creation_screen.dart
    │   ├── game_hub_screen.dart
    │   ├── tactical_battle_screen.dart
    │   ├── character_detail_screen.dart
    │   ├── settings_screen.dart
    │   └── shop_screen.dart
    └── services/                # Services et logique métier
        ├── character_service.dart
        └── character_factory.dart
```

## 🚀 Développement

### Prérequis
- Flutter SDK 3.35.5+
- Dart 3.5.0+
- Android Studio / VS Code
- Git

### Setup Local
```bash
# Cloner le projet
git clone https://github.com/Angel-42/Dice-Destiny-Idle-Rifts.git
cd Dice-Destiny-Idle-Rifts

# Installer les dépendances
flutter pub get

# Lancer en mode debug
flutter run

# Lancer les tests
flutter test

# Analyser le code
flutter analyze
```

### Branches
- `main` : Version stable de production
- `dev` : Développement actif
- `feature/*` : Nouvelles fonctionnalités

## 📝 Roadmap

### Version 1.1.0 (Q1 2025)
- [ ] Système de combat amélioré
- [ ] Nouveaux héros et classes
- [ ] Système d'équipement
- [ ] Sauvegarde en cloud

### Version 1.2.0 (Q2 2025)
- [ ] Mode PvP
- [ ] Guildes et coopération
- [ ] Events saisonniers
- [ ] Support iOS

## 🤝 Contribution

Les contributions sont les bienvenues ! Voici comment participer :

1. Fork le projet
2. Créez une branche (`git checkout -b feature/AmazingFeature`)
3. Commit vos changements (`git commit -m 'Add some AmazingFeature'`)
4. Push vers la branche (`git push origin feature/AmazingFeature`)
5. Ouvrez une Pull Request

## 📜 License

Ce projet est sous licence MIT. Voir le fichier [LICENSE](LICENSE) pour plus de détails.

## 👥 Équipe

- **Développeur Principal** : [Votre Nom](https://github.com/Angel-42)

## 📧 Contact

- **Discord** : [Rejoindre notre serveur](https://discord.gg/VOTRE_LIEN)
- **Email** : votre.email@example.com
- **Issues** : [GitHub Issues](https://github.com/Angel-42/Dice-Destiny-Idle-Rifts/issues)

## 🙏 Remerciements

- Flutter Team pour l'excellent framework
- Contributeurs open-source
- Communauté de joueurs

---

**🎮 Jouez maintenant !** Téléchargez la dernière version et commencez votre aventure !

[![Download](https://img.shields.io/badge/Download-Latest%20Release-brightgreen?style=for-the-badge&logo=android)](https://github.com/Angel-42/Dice-Destiny-Idle-Rifts/releases/latest)