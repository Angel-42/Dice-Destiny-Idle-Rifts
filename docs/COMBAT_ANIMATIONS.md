# 🎬 Système d'Animations de Combat

## 📋 Vue d'ensemble

Le système d'animations de combat permet d'afficher des spritesheets animés pour les personnages et ennemis pendant les combats, avec différents états (idle, attack, hit, death, victory).

## 🔧 Architecture

### Modèles

#### `AnimationState` (enum)
États d'animation disponibles :
- `idle` - Animation de repos/attente
- `attack` - Animation d'attaque
- `hit` - Animation de réception de dégâts
- `death` - Animation de mort
- `victory` - Animation de victoire (optionnel)

#### `AnimationConfig`
Configuration d'une animation individuelle :
```dart
AnimationConfig(
  assetPath: 'assets/ennemies/wolf/attack_spritesheet.png',
  frameCount: 6,              // Nombre de frames dans le spritesheet
  frameDuration: Duration(milliseconds: 100),  // Durée d'une frame
  loop: false,                // L'animation boucle-t-elle ?
)
```

#### `AnimationSet`
Ensemble d'animations pour un personnage/ennemi :
```dart
AnimationSet(
  idle: AnimationConfig(...),
  attack: AnimationConfig(...),
  hit: AnimationConfig(...),
  death: AnimationConfig(...),
  victory: AnimationConfig(...),  // Optionnel
)
```

### Widgets

#### `CombatAnimatedSprite`
Widget principal qui affiche les animations de combat :
```dart
CombatAnimatedSprite(
  animationSet: character.appearance.combatAnimations!,
  currentState: AnimationState.attack,
  width: 150,
  height: 250,
  flipHorizontal: false,
  fallbackBuilder: () => Widget de fallback,
)
```

**Caractéristiques :**
- Gère automatiquement le changement d'état
- Support du flip horizontal pour orienter le sprite
- Fallback automatique si l'animation n'existe pas
- Callback quand l'animation se termine (pour les non-loop)

## 📁 Structure des Assets

Les spritesheets doivent être organisés ainsi :

```
assets/
  ennemies/
    wolf/
      idle_spritesheet.png      # 4 frames horizontales (idle loop)
      attack_spritesheet.png    # 6 frames horizontales (non-loop)
      hit_spritesheet.png       # 3 frames horizontales (non-loop)
      death_spritesheet.png     # 5 frames horizontales (non-loop)
      
  characters/
    Elio/
      idle_spritesheet.png
      attack_spritesheet.png
      hit_spritesheet.png
      death_spritesheet.png
      victory_spritesheet.png   # Optionnel
```

### Format des Spritesheets

Les spritesheets doivent contenir **toutes les frames alignées horizontalement** :

```
┌──────┬──────┬──────┬──────┐
│Frame1│Frame2│Frame3│Frame4│  (exemple: idle avec 4 frames)
└──────┴──────┴──────┴──────┘
```

**Bonnes pratiques :**
- Toutes les frames d'une animation doivent avoir la **même taille**
- Utiliser des dimensions en puissance de 2 (64x64, 128x128, etc.)
- Format PNG avec transparence
- Pixel art : utiliser `filterQuality: FilterQuality.none`

## 🎯 Utilisation

### 1. Ajouter des animations à un ennemi

Dans `enemy_database.dart` :

```dart
Character _createWolf(int level) {
  return Character(
    name: 'Wolf',
    // ... autres propriétés ...
    appearance: CharacterAppearance(
      headshot: '🐺',
      // ... autres sprites ...
      combatAnimations: const AnimationSet(
        idle: AnimationConfig(
          assetPath: 'assets/ennemies/wolf/idle_spritesheet.png',
          frameCount: 4,
          frameDuration: Duration(milliseconds: 200),
          loop: true,
        ),
        attack: AnimationConfig(
          assetPath: 'assets/ennemies/wolf/attack_spritesheet.png',
          frameCount: 6,
          frameDuration: Duration(milliseconds: 100),
          loop: false,
        ),
        hit: AnimationConfig(
          assetPath: 'assets/ennemies/wolf/hit_spritesheet.png',
          frameCount: 3,
          frameDuration: Duration(milliseconds: 120),
          loop: false,
        ),
        death: AnimationConfig(
          assetPath: 'assets/ennemies/wolf/death_spritesheet.png',
          frameCount: 5,
          frameDuration: Duration(milliseconds: 150),
          loop: false,
        ),
      ),
    ),
  );
}
```

### 2. Les animations sont automatiques

Le `CombatAnimationScreen` gère automatiquement :
- **Idle** au début et entre les actions
- **Attack** quand le personnage attaque
- **Hit** quand le personnage reçoit des dégâts
- **Death** quand le personnage meurt
- **Victory** quand le personnage gagne (si disponible)

### 3. Fallback automatique

Si aucune animation n'est configurée :
1. Utilise le sprite `fullsize` statique
2. Sinon, affiche un widget de fallback (initiale du personnage)

## 🔄 Workflow de développement

### Étape 1 : Créer les spritesheets

1. Dessiner chaque frame de l'animation (idle, attack, hit, death)
2. Aligner toutes les frames horizontalement
3. Exporter en PNG avec transparence
4. Placer dans `assets/ennemies/[nom]/`

### Étape 2 : Configurer les animations

1. Ouvrir `enemy_database.dart` ou `character_database.dart`
2. Ajouter `combatAnimations: AnimationSet(...)` dans `CharacterAppearance`
3. Spécifier le nombre de frames et la durée pour chaque animation

### Étape 3 : Déclarer les assets

Dans `pubspec.yaml` :

```yaml
flutter:
  assets:
    - assets/ennemies/wolf/idle_spritesheet.png
    - assets/ennemies/wolf/attack_spritesheet.png
    - assets/ennemies/wolf/hit_spritesheet.png
    - assets/ennemies/wolf/death_spritesheet.png
```

Ou utiliser un glob pattern :
```yaml
flutter:
  assets:
    - assets/ennemies/
```

## 🎨 Ressources pour créer des spritesheets

### Éditeurs recommandés
- **[Piskel](https://www.piskelapp.com/)** - Éditeur pixel-art en ligne gratuit
- **[Aseprite](https://www.aseprite.org/)** - Éditeur professionnel ($)
- **[LibreSprite](https://libresprite.github.io/)** - Fork gratuit d'Aseprite

### Assets gratuits
- **[Itch.io - Game Assets](https://itch.io/game-assets/free)**
- **[OpenGameArt](https://opengameart.org/)**
- **[Kenney Assets](https://kenney.nl/assets)**

### Tutoriels
- [Fire Emblem-style combat animations](https://www.youtube.com/results?search_query=fire+emblem+sprite+animation)
- [Pixel art combat tutorial](https://www.youtube.com/results?search_query=pixel+art+combat+animation)

## ⚙️ Configuration avancée

### Animations conditionnelles

Vous pouvez créer différentes animations selon le contexte :

```dart
AnimationSet getAnimationsForClass(CharacterClass charClass) {
  if (charClass == CharacterClass.warrior) {
    return AnimationSet(
      attack: AnimationConfig(
        assetPath: 'assets/animations/warrior_slash.png',
        frameCount: 8,
      ),
      // ...
    );
  } else if (charClass == CharacterClass.mage) {
    return AnimationSet(
      attack: AnimationConfig(
        assetPath: 'assets/animations/mage_cast.png',
        frameCount: 6,
      ),
      // ...
    );
  }
  // ...
}
```

### Optimisation des performances

- **Lazy loading** : Les spritesheets ne sont chargés qu'au moment du combat
- **Cache** : Flutter met automatiquement les images en cache
- **Compression** : Utiliser des outils comme `pngquant` pour réduire la taille des PNG

## 🐛 Débogage

### L'animation ne s'affiche pas
1. Vérifier que le fichier existe dans `assets/`
2. Vérifier que le fichier est déclaré dans `pubspec.yaml`
3. Exécuter `flutter clean` puis `flutter pub get`
4. Vérifier les logs pour les erreurs d'assets

### L'animation est trop rapide/lente
- Ajuster `frameDuration` dans `AnimationConfig`
- Idle : ~200-300ms par frame
- Attack : ~80-120ms par frame
- Hit : ~100-150ms par frame
- Death : ~150-200ms par frame

### Le sprite est coupé ou déformé
- Vérifier que `frameCount` correspond au nombre réel de frames
- Vérifier que toutes les frames ont la même taille
- Utiliser `fit: BoxFit.contain` dans le widget

## 📊 Performance

**Mesures de performance typiques :**
- Chargement d'un spritesheet (512x64, 8 frames) : ~5-10ms
- Animation (60 FPS) : ~16ms par frame
- Mémoire : ~2-3 MB par spritesheet en RAM

**Recommandations :**
- Max 10 frames par animation
- Taille max 1024px de large
- Format PNG optimisé
