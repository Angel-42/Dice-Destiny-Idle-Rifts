# Système de Map Tactique 🗺️

## Vue d'ensemble

Système de grille tactique inspiré de Fire Emblem pour **Dice Destiny: Idle Rifts**. Permet de créer des maps modulables avec différents types de terrain et de déplacer des unités case par case.

---

## 🎯 Fonctionnalités

### Maps Tactiques
- **Grille personnalisable** : Dimensions configurables (largeur × hauteur)
- **Types de terrain** :
  - 🟢 **Plaine** : Terrain normal (coût 1)
  - 🌲 **Forêt** : Ralentit le mouvement (coût 2)
  - ⛰️ **Montagne** : Infranchissable
  - 💧 **Eau** : Infranchissable
  - 🛣️ **Route** : Déplacement rapide (coût 1)
  - 🏰 **Château** : Objectif de mission
- **Génération** : Maps prédéfinies ou personnalisées
- **Scroll** : Support du défilement horizontal/vertical pour grandes maps

### Système de déplacement
- **Sélection d'unité** : Clic sur le personnage du joueur
- **Cases en surbrillance** : Cases adjacentes accessibles (haut/bas/gauche/droite)
- **Déplacement** : Clic sur une case surlignée pour s'y déplacer
- **Validation** : Les cases occupées ou infranchissables sont bloquées
- **Tour par tour** : Bouton "FIN DU TOUR" pour passer au suivant

### Interface
- **Header** : Nom de la map + description
- **Légende** : Popup explicative des types de terrain (icône `?`)
- **Panel inférieur** : Info de l'unité sélectionnée + bouton fin de tour
- **Visuels** : 
  - Unités en cercles colorés avec initiale
  - Bordure jaune sur l'unité sélectionnée
  - Cases surlignées en bleu pour les mouvements possibles

---

## 📁 Structure des fichiers

```
lib/src/
├── models/
│   └── map_data.dart              # Modèles de données (MapTile, UnitPosition, TacticalMapData)
├── screens/
│   └── campaign_screen.dart       # Écran de campagne avec interaction map
├── widgets/
│   └── tactical_map_widget.dart   # Widget réutilisable de grille tactique
```

---

## 🛠️ Utilisation

### 1. Créer une map de test (automatique)

```dart
final mapData = TacticalMapData.createTestMap();
```

Génère une map 8×8 avec :
- Montagnes aux coins
- Château au centre
- Route horizontale au milieu
- Forêts parsemées
- Eau sur les bords gauche/droit

### 2. Créer une map personnalisée

```dart
final customMap = TacticalMapData.custom(
  id: 'mission_01',
  name: 'Plaine des Rifts',
  width: 10,
  height: 10,
  terrainLayout: [
    [TerrainType.plains, TerrainType.plains, TerrainType.forest, ...],
    [TerrainType.road, TerrainType.road, TerrainType.castle, ...],
    // ... reste de la grille
  ],
  description: 'Première mission de la campagne',
);
```

### 3. Utiliser le widget dans un écran

```dart
TacticalMapWidget(
  mapData: mapData,
  units: units,
  selectedUnit: selectedUnit,
  onUnitTap: _onUnitTap,
  onTileTap: _onTileTap,
  tileSize: 70, // Taille en pixels d'une case
  showGrid: true, // Afficher la grille
  highlightedTiles: {'2,3', '3,3', '2,4'}, // Cases surlignées (format "x,y")
)
```

### 4. Accéder à la campagne depuis le jeu

Dans le **Home Screen** :
- Bouton **"CAMPAGNE"** (icône `campaign`)
- Lance automatiquement avec le premier personnage du joueur
- Navigation vers `CampaignScreen`

---

## 🎮 Contrôles

| Action | Contrôle |
|--------|----------|
| **Sélectionner une unité** | Clic sur le cercle du personnage |
| **Se déplacer** | Clic sur une case surlignée en bleu |
| **Désélectionner** | Clic sur l'unité déjà sélectionnée |
| **Afficher la légende** | Icône `?` dans le header |
| **Retour** | Flèche `←` dans le header |
| **Fin du tour** | Bouton `FIN DU TOUR` en bas |

---

## 📊 Modèles de données

### `TerrainType` (Enum)
- `plains` : Plaine
- `forest` : Forêt
- `mountain` : Montagne
- `water` : Eau
- `castle` : Château
- `road` : Route

### `MapTile` (Class)
```dart
MapTile(
  x: 2,
  y: 3,
  terrain: TerrainType.forest,
  walkable: true,
  moveCost: 2,
)
```

### `UnitPosition` (Class)
```dart
UnitPosition(
  unitId: 'char_123',
  x: 2,
  y: 6,
  name: 'Ragnar',
  color: Colors.blue,
  isPlayer: true,
)
```

### `TacticalMapData` (Class)
```dart
TacticalMapData(
  id: 'map_01',
  name: 'Première Mission',
  width: 8,
  height: 8,
  tiles: [[...]], // Grille 2D de MapTile
  units: [...],   // Liste d'unités
  description: 'Description...',
)
```

#### Méthodes utiles :
- `getTile(x, y)` : Obtenir une case
- `isWalkable(x, y)` : Vérifier si on peut marcher
- `isOccupied(x, y)` : Vérifier si une unité est présente
- `getUnitAt(x, y)` : Obtenir l'unité à une position

---

## 🚀 Extensions futures

### Système de combat
- Attaque d'unités adjacentes
- Calcul de dégâts selon les stats
- Animation de combat
- Gestion de la mort d'unités

### Portée de mouvement avancée
- Déplacement multiple cases selon stat `movement`
- Pathfinding (A*) pour contourner obstacles
- Zones d'effet (AoE) pour compétences

### Ennemis IA
- Patterns de mouvement (agressif, défensif, patrouille)
- Ciblage intelligent du joueur
- Conditions de victoire/défaite

### Types de missions
- **Élimination** : Tuer tous les ennemis
- **Survie** : Tenir X tours
- **Escorte** : Protéger une unité jusqu'à un point
- **Boss** : Vaincre l'ennemi principal

### Terrain avancé
- **Buff/Debuff** : Forêt = +évasion, Eau = -mouvement
- **Dangers** : Lave (dégâts par tour), Piège
- **Destructibles** : Murs cassables
- **Hauteur** : Bonus d'attaque depuis position élevée

### Sauvegarde de progression
- Position des unités en Firestore
- Tours écoulés
- Objectifs complétés
- Reprise de partie

---

## 🎨 Personnalisation visuelle

### Modifier la taille des cases
```dart
TacticalMapWidget(
  tileSize: 80, // Plus grande case = 80px au lieu de 70px
  ...
)
```

### Changer les couleurs de terrain
Dans `map_data.dart`, méthode `MapTile.color` :
```dart
case TerrainType.plains:
  return const Color(0xFF8BC34A); // Vert clair personnalisé
```

### Personnaliser l'apparence des unités
Dans `tactical_map_widget.dart`, classe `_MapTileWidget` :
```dart
// Remplacer le cercle par une image
child: unit!.avatarImage != null
  ? Image.asset(unit!.avatarImage)
  : Text(unit!.name.substring(0, 1).toUpperCase()),
```

---

## 🐛 Débogage

### Afficher les coordonnées
```dart
TacticalMapWidget(
  showGrid: true, // Active l'affichage des coordonnées (x,y) en bas de chaque case
  ...
)
```

### Logger les déplacements
Dans `campaign_screen.dart`, méthode `_onTileTap` :
```dart
print('Déplacement de ${selectedUnit.name} vers ($x, $y)');
```

---

## 📝 TODO

- [ ] Système de combat (attaque/défense)
- [ ] IA ennemis basique (déplacement aléatoire)
- [ ] Portée de mouvement selon stats
- [ ] Animations de déplacement (tweening)
- [ ] Effets de terrain (buffs/debuffs)
- [ ] Sauvegarde position unités dans Firestore
- [ ] Missions avec conditions de victoire
- [ ] Editor de maps (outil de création in-game)
- [ ] Multiples types d'ennemis
- [ ] Boss avec patterns spéciaux

---

## 🔗 Références

- **Fire Emblem** : Inspiration pour le gameplay tactique
- **Advance Wars** : Système de grille et capture d'objectifs
- **XCOM** : Système de couverture et ligne de vue

---

**Créé pour Dice Destiny: Idle Rifts** 🎲✨
