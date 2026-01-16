# 🤖 Système d'IA Ennemie

## 📋 Vue d'ensemble

Le système d'IA permet aux ennemis de prendre des décisions automatiquement pendant leur phase de jeu sur la map tactique. L'IA analyse la situation et décide si l'ennemi doit se déplacer, attaquer, ou rester immobile.

## 🎯 Fonctionnement

### Phase Ennemie

Pendant la **ENEMY PHASE**, tous les ennemis jouent automatiquement dans l'ordre déterminé par leur vitesse (stat `speed`).

```dart
// L'IA est exécutée automatiquement dans campaign_screen.dart
Future<void> _executeEnemyPhase() async {
  for (final enemyId in _enemyTurnOrder) {
    final action = _enemyAI.decideAction(
      enemy: enemy,
      enemyUnit: enemyUnit,
      allUnits: units,
      map: mapData,
      behavior: EnemyBehavior.aggressive,
    );
    
    await _executeEnemyAction(enemy, enemyUnit, action);
  }
}
```

### Prise de Décision

L'IA suit cette logique de décision :

1. **Trouver la cible** : L'allié (joueur) le plus proche
2. **Vérifier la portée** :
   - Si cible à portée d'attaque → **ATTAQUER**
   - Sinon → **SE DÉPLACER** vers la cible
3. **Si aucun mouvement possible** → **RESTER IMMOBILE**

```dart
final action = _enemyAI.decideAction(
  enemy: enemy,              // Character ennemi
  enemyUnit: enemyUnit,      // Position sur la map
  allUnits: allUnits,        // Toutes les unités sur la map
  map: map,                  // Données de la map
  behavior: EnemyBehavior.aggressive, // Type de comportement
);
```

## 🧠 Comportements d'IA

### 1. **Aggressive** (Par défaut)
- Fonce directement vers l'ennemi le plus proche
- Se rapproche au maximum à chaque tour
- Attaque dès que possible
- **Usage** : Guerriers, monstres de mêlée

```dart
behavior: EnemyBehavior.aggressive
```

### 2. **Defensive**
- Maintient une distance de sécurité (~3 cases)
- Ne s'approche pas trop
- Recule si trop près
- **Usage** : Archers, unités de support

```dart
behavior: EnemyBehavior.defensive
```

### 3. **Support**
- Reste éloigné des combattants
- Priorise rester en arrière
- **Usage** : Mages, clercs, soigneurs

```dart
behavior: EnemyBehavior.support
```

### 4. **Random**
- Mouvements imprévisibles
- Choisit aléatoirement parmi les cases accessibles
- **Usage** : Créatures folles, ennemis confus

```dart
behavior: EnemyBehavior.random
```

## 📊 Types d'Actions

### `EnemyAction.attack`
```dart
EnemyAction.attack(targetUnitId: 'player_1')
```
- Attaque l'unité spécifiée
- Lance un combat 1v1 via `CombatAnimationScreen`
- Applique les dégâts et gère la mort

### `EnemyAction.move`
```dart
EnemyAction.move(x: 5, y: 3)
```
- Déplace l'ennemi vers la position (x, y)
- Respecte les obstacles et le terrain
- Ne peut pas occuper une case déjà prise

### `EnemyAction.idle`
```dart
EnemyAction.idle()
```
- L'ennemi ne fait rien
- Utilisé quand aucune action possible
- Termine simplement le tour

## 🎮 Utilisation dans le Code

### Configurer un comportement personnalisé

```dart
// Dans enemy_database.dart, ajouter une propriété au Character
final Character boss = Character(
  name: 'Dragon Boss',
  // ... autres propriétés
  aiParameters: AIParameters(
    behavior: EnemyBehavior.defensive,
    aggroRange: 5, // Portée d'agression
    retreatThreshold: 0.3, // Fuit si HP < 30%
  ),
);
```

### Cibler spécifiquement un allié

Pour des ennemis spéciaux (boss, assassins), on peut override le ciblage :

```dart
// Cibler le personnage avec le moins de HP
final weakestAlly = allies.reduce((a, b) => 
  charactersMap[a.unitId]!.currentHp < charactersMap[b.unitId]!.currentHp ? a : b
);
```

### Ajouter des conditions spéciales

```dart
// Boss qui invoque des minions à 50% HP
if (enemy.currentHp <= enemy.stats.maxHp / 2 && !_hasInvoked) {
  return EnemyAction.special(type: 'summon_minions');
}
```

## 🔍 Algorithme de Pathfinding

### Mouvement Simple (Actuel)
- Calcule la distance de Manhattan
- Explore toutes les cases à portée de mouvement
- Choisit celle qui rapproche le plus de la cible

```dart
final distToTarget = _calculateDistance(newX, newY, targetX, targetY);
possibleMoves.add((x: newX, y: newY, distance: distToTarget));
```

### Pathfinding A* (Future)
Pour des mouvements plus intelligents autour des obstacles :

```dart
final path = _enemyAI.findPath(
  startX: enemyX,
  startY: enemyY,
  targetX: targetX,
  targetY: targetY,
  map: mapData,
  allUnits: units,
);
```

## 📈 Évolutions Futures

### 1. **IA Avancée**
- [ ] Pathfinding A* pour contourner obstacles
- [ ] Prédiction des mouvements du joueur
- [ ] Coordination entre ennemis (flanking, etc.)
- [ ] Utilisation intelligente des compétences

### 2. **Patterns de Boss**
```dart
class BossAI extends EnemyAI {
  List<EnemyAction> patterns = [
    // Phase 1: Agressive
    // Phase 2: Defensive + summon
    // Phase 3: Berserk
  ];
}
```

### 3. **États Émotionnels**
```dart
enum EnemyMood {
  calm,      // Comportement normal
  enraged,   // +Aggressive, +damage
  scared,    // Fuite
  confused,  // Random
}
```

### 4. **Formation Tactique**
```dart
enum Formation {
  frontLine,  // Guerriers en avant
  backLine,   // Archers/mages en arrière
  surround,   // Encercler le joueur
  turtle,     // Formation défensive
}
```

## 🧪 Tests et Debug

### Visualiser les décisions de l'IA

```dart
// Activer les logs détaillés
debugPrint('IA: ${enemy.name} décide $action');
debugPrint('  Distance à la cible: $distance');
debugPrint('  Portée d\'attaque: ${enemy.stats.range}');
```

### Mode manuel pour tester
```dart
// Dans campaign_screen.dart, désactiver temporairement l'IA
if (MANUAL_ENEMY_CONTROL) {
  // Laisser le joueur contrôler les ennemis pour tester
  return;
}
```

## 📚 Références

### Fichiers principaux
- **`lib/src/ai/enemy_ai.dart`** : Logique d'IA
- **`lib/src/screens/campaign_screen.dart`** : Intégration dans le gameplay
- **`lib/src/data/enemy_database.dart`** : Configuration des ennemis

### Inspirations
- **Fire Emblem** : IA basique mais efficace
- **XCOM** : Couverture et ligne de vue
- **Into the Breach** : IA prévisible mais intelligente

---

**Créé pour Dice Destiny: Idle Rifts** 🎲✨
