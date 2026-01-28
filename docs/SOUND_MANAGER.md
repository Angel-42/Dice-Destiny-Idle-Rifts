# 🎵 Sound Manager Documentation

## Vue d'ensemble

Le `SoundManager` est un service singleton modulaire qui gère tous les sons du jeu :
- **Musiques de fond** (loop automatique)
- **Effets sonores** (one-shot)

## Architecture

### Structure
```
lib/src/
├── services/
│   └── sound_manager.dart      # Service principal (singleton)
└── widgets/
    └── sound_control_widget.dart  # UI controls (boutons mute/volume)
```

### Caractéristiques

✅ **Singleton** : Une seule instance partagée dans toute l'app  
✅ **Modulaire** : Players séparés pour musique et SFX  
✅ **Fade in/out** : Transitions douces entre musiques  
✅ **Volume indépendant** : Contrôle séparé musique/SFX  
✅ **Enable/Disable** : Activation/désactivation par catégorie  

## Utilisation

### 1. Initialisation (au démarrage de l'app)

```dart
final SoundManager soundManager = SoundManager();
await soundManager.initialize();
```

### 2. Jouer une musique (loop automatique)

```dart
// Sans fade
await soundManager.playMusic('musics/menu.mp3');

// Avec fade-in de 1 seconde
await soundManager.playMusic('musics/menu.mp3', fadeIn: 1000);
```

### 3. Arrêter la musique

```dart
// Arrêt immédiat
await soundManager.stopMusic();

// Fade-out de 500ms
await soundManager.stopMusic(fadeOut: 500);
```

### 4. Pause/Resume

```dart
await soundManager.pauseMusic();
await soundManager.resumeMusic();
```

### 5. Jouer un effet sonore

```dart
// Volume par défaut
await soundManager.playSfx('sounds/click.mp3');

// Volume personnalisé (0.0 à 1.0)
await soundManager.playSfx('sounds/explosion.mp3', volume: 0.5);
```

### 6. Contrôles de volume

```dart
// Changer le volume de la musique (0.0 à 1.0)
soundManager.musicVolume = 0.7;

// Changer le volume des SFX
soundManager.sfxVolume = 1.0;

// Activer/désactiver
soundManager.musicEnabled = false;
soundManager.sfxEnabled = false;
```

## Intégration UI

### Boutons simples (dans n'importe quel écran)

```dart
import '../widgets/sound_control_widget.dart';

// Dans votre build()
const SoundControlWidget()
```

### Dialog de paramètres avancés

```dart
import '../widgets/sound_control_widget.dart';

// Afficher le dialog
showDialog(
  context: context,
  builder: (context) => const SoundSettingsDialog(),
);
```

## Assets

Les fichiers audio doivent être placés dans `assets/` et déclarés dans `pubspec.yaml` :

```yaml
flutter:
  assets:
    - assets/musics/     # Musiques de fond
    - assets/sounds/     # Effets sonores
```

### Organisation recommandée

```
assets/
├── musics/
│   ├── menu.mp3
│   ├── battle.mp3
│   └── victory.mp3
└── sounds/
    ├── click.mp3
    ├── attack.mp3
    └── heal.mp3
```

## Formats supportés

- ✅ MP3
- ✅ WAV
- ✅ OGG
- ✅ M4A (iOS)

## Exemples d'intégration

### Menu principal

```dart
class MainMenuScreen extends StatefulWidget {
  @override
  void initState() {
    super.initState();
    _initSound();
  }

  Future<void> _initSound() async {
    final soundManager = SoundManager();
    await soundManager.initialize();
    await soundManager.playMusic('musics/menu.mp3', fadeIn: 1000);
  }
}
```

### Transition entre écrans

```dart
// Arrêter la musique du menu avec fade-out
await SoundManager().stopMusic(fadeOut: 500);

// Attendre la fin du fade
await Future.delayed(Duration(milliseconds: 500));

// Démarrer la musique de combat
await SoundManager().playMusic('musics/battle.mp3', fadeIn: 800);
```

### Effets sonores dans le combat

```dart
// Attaque
await SoundManager().playSfx('sounds/sword_slash.mp3');

// Soin
await SoundManager().playSfx('sounds/heal.mp3', volume: 0.8);
```

## Best Practices

1. **Initialiser tôt** : Appelez `initialize()` au démarrage de l'app
2. **Fade transitions** : Utilisez toujours des fades entre musiques pour éviter les coupures brutales
3. **Volume SFX** : Gardez les SFX entre 0.6 et 1.0 pour éviter de couvrir la musique
4. **Async/await** : Toutes les méthodes sont async, pensez à await
5. **Ne pas dispose** : Le SoundManager est un singleton, ne le dispose jamais

## Dépendance

```yaml
dependencies:
  audioplayers: ^6.1.0
```

## Notes techniques

- **Loop automatique** : Le player de musique est configuré en mode loop
- **Libération auto** : Les SFX sont automatiquement libérés après lecture
- **Thread-safe** : Une seule musique peut jouer à la fois
- **Singleton** : Accessible partout via `SoundManager()`
