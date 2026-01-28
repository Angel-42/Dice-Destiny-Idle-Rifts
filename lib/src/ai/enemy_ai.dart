import 'dart:math';
import '../models/character.dart';
import '../models/map_data.dart';

/// Système d'IA pour les ennemis sur la map tactique
/// Gère les décisions de mouvement et d'attaque des ennemis
class EnemyAI {
  final Random _random = Random();

  /// Décide de l'action d'un ennemi pour ce tour
  /// Retourne l'action à effectuer (mouvement ou attaque)
  EnemyAction decideAction({
    required Character enemy,
    required UnitPosition enemyUnit,
    required List<UnitPosition> allUnits,
    required TacticalMapData map,
    EnemyBehavior behavior = EnemyBehavior.aggressive,
  }) {
    // Trouver tous les alliés (joueurs)
    final allies = allUnits.where((u) => u.isPlayer).toList();
    if (allies.isEmpty) {
      return EnemyAction.idle(); // Pas d'alliés, ne rien faire
    }

    // Trouver l'allié le plus proche
    final target = _findNearestTarget(enemyUnit, allies);
    final distance = _calculateDistance(
      enemyUnit.x,
      enemyUnit.y,
      target.x,
      target.y,
    );

    // Si l'ennemi est à portée d'attaque, ATTAQUER
    if (distance <= enemy.stats.range) {
      return EnemyAction.attack(targetUnitId: target.unitId);
    }

    // Sinon, se déplacer vers l'allié le plus proche
    final movePosition = _findBestMoveTowards(
      from: enemyUnit,
      to: target,
      map: map,
      allUnits: allUnits,
      movement: enemy.stats.movement,
      behavior: behavior,
    );

    if (movePosition != null) {
      return EnemyAction.move(x: movePosition.x, y: movePosition.y);
    }

    // Si aucun mouvement possible, rester immobile
    return EnemyAction.idle();
  }

  /// Trouve l'allié le plus proche de l'ennemi
  UnitPosition _findNearestTarget(
    UnitPosition enemy,
    List<UnitPosition> allies,
  ) {
    UnitPosition? nearest;
    int minDistance = 999999;

    for (final ally in allies) {
      final dist = _calculateDistance(enemy.x, enemy.y, ally.x, ally.y);
      if (dist < minDistance) {
        minDistance = dist;
        nearest = ally;
      }
    }

    return nearest!;
  }

  /// Calcule la distance de Manhattan entre deux points
  int _calculateDistance(int x1, int y1, int x2, int y2) {
    return (x1 - x2).abs() + (y1 - y2).abs();
  }

  /// Trouve la meilleure case où se déplacer pour se rapprocher de la cible
  ({int x, int y})? _findBestMoveTowards({
    required UnitPosition from,
    required UnitPosition to,
    required TacticalMapData map,
    required List<UnitPosition> allUnits,
    required int movement,
    required EnemyBehavior behavior,
  }) {
    final possibleMoves = <({int x, int y, int distance})>[];

    // Explorer toutes les cases accessibles dans la portée de mouvement
    for (int dx = -movement; dx <= movement; dx++) {
      for (int dy = -movement; dy <= movement; dy++) {
        final newX = from.x + dx;
        final newY = from.y + dy;

        // Distance de Manhattan ne doit pas dépasser le mouvement
        if (_calculateDistance(from.x, from.y, newX, newY) > movement) {
          continue;
        }

        // Vérifier si la case est valide et marchable
        if (!_isValidMove(newX, newY, map, allUnits)) {
          continue;
        }

        // Calculer la distance vers la cible
        final distToTarget = _calculateDistance(newX, newY, to.x, to.y);

        possibleMoves.add((x: newX, y: newY, distance: distToTarget));
      }
    }

    if (possibleMoves.isEmpty) return null;

    // Selon le comportement, choisir la meilleure case
    switch (behavior) {
      case EnemyBehavior.aggressive:
        // Se rapprocher au maximum
        possibleMoves.sort((a, b) => a.distance.compareTo(b.distance));
        return (x: possibleMoves.first.x, y: possibleMoves.first.y);

      case EnemyBehavior.defensive:
        // Rester à distance mais pas trop loin
        final idealDistance = 3;
        possibleMoves.sort((a, b) {
          final aDiff = (a.distance - idealDistance).abs();
          final bDiff = (b.distance - idealDistance).abs();
          return aDiff.compareTo(bDiff);
        });
        return (x: possibleMoves.first.x, y: possibleMoves.first.y);

      case EnemyBehavior.random:
        // Mouvement aléatoire parmi les cases possibles
        final randomMove = possibleMoves[_random.nextInt(possibleMoves.length)];
        return (x: randomMove.x, y: randomMove.y);

      case EnemyBehavior.support:
        // Rester loin des alliés (pour soigneurs/mages)
        possibleMoves.sort((a, b) => b.distance.compareTo(a.distance));
        return (x: possibleMoves.first.x, y: possibleMoves.first.y);
    }
  }

  /// Vérifie si un déplacement est valide
  bool _isValidMove(
    int x,
    int y,
    TacticalMapData map,
    List<UnitPosition> allUnits,
  ) {
    // Hors de la map
    if (x < 0 || x >= map.width || y < 0 || y >= map.height) {
      return false;
    }

    // Case non marchable
    final tile = map.getTile(x, y);
    if (tile == null || !tile.walkable) {
      return false;
    }

    // Case occupée par une autre unité
    final occupied = allUnits.any((u) => u.x == x && u.y == y);
    if (occupied) {
      return false;
    }

    return true;
  }

  /// Variante avancée : Pathfinding A* (pour future implémentation)
  /// Trouve le chemin optimal vers une cible
  List<({int x, int y})>? findPath({
    required int startX,
    required int startY,
    required int targetX,
    required int targetY,
    required TacticalMapData map,
    required List<UnitPosition> allUnits,
    int maxSteps = 10,
  }) {
    // TODO: Implémenter A* pour pathfinding avancé
    // Pour l'instant, on utilise le mouvement direct simple
    return null;
  }
}

/// Types de comportements pour l'IA
enum EnemyBehavior {
  /// Fonce vers l'ennemi le plus proche pour attaquer
  aggressive,

  /// Maintient une distance de sécurité
  defensive,

  /// Se déplace aléatoirement
  random,

  /// Reste en arrière (pour soigneurs/support)
  support,
}

/// Action décidée par l'IA
class EnemyAction {
  final EnemyActionType type;
  final String? targetUnitId; // Pour attaque
  final int? targetX; // Pour mouvement
  final int? targetY; // Pour mouvement

  EnemyAction._({
    required this.type,
    this.targetUnitId,
    this.targetX,
    this.targetY,
  });

  /// Action : Attaquer une unité
  factory EnemyAction.attack({required String targetUnitId}) {
    return EnemyAction._(
      type: EnemyActionType.attack,
      targetUnitId: targetUnitId,
    );
  }

  /// Action : Se déplacer vers une position
  factory EnemyAction.move({required int x, required int y}) {
    return EnemyAction._(
      type: EnemyActionType.move,
      targetX: x,
      targetY: y,
    );
  }

  /// Action : Ne rien faire
  factory EnemyAction.idle() {
    return EnemyAction._(type: EnemyActionType.idle);
  }

  bool get isAttack => type == EnemyActionType.attack;
  bool get isMove => type == EnemyActionType.move;
  bool get isIdle => type == EnemyActionType.idle;

  @override
  String toString() {
    switch (type) {
      case EnemyActionType.attack:
        return 'Attack $targetUnitId';
      case EnemyActionType.move:
        return 'Move to ($targetX, $targetY)';
      case EnemyActionType.idle:
        return 'Idle';
    }
  }
}

enum EnemyActionType {
  attack,
  move,
  idle,
}
