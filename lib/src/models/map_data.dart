import 'package:flutter/material.dart';

/// Noeud pour l'algorithme de pathfinding
class _PathNode {
  final int x;
  final int y;
  final int cost;
  
  _PathNode(this.x, this.y, this.cost);
}

/// Position simple sur la carte
class MapPosition {
  final int x;
  final int y;
  
  MapPosition(this.x, this.y);
}

/// Résultat du calcul de chemin
class PathResult {
  final List<MapPosition> path;
  final int totalCost;
  
  PathResult({required this.path, required this.totalCost});
}

/// Type de terrain sur la carte
enum TerrainType {
  plains,    // Plaine (facile)
  forest,    // Forêt (ralentit)
  mountain,  // Montagne (bloque)
  water,     // Eau (infranchissable)
  castle,    // Château (objectif)
  road,      // Route (rapide)
}

/// Une case sur la carte tactique
class MapTile {
  final int x;
  final int y;
  final TerrainType terrain;
  final bool walkable;
  final int moveCost; // Coût de déplacement (1 = normal, 2 = ralenti, etc.)

  const MapTile({
    required this.x,
    required this.y,
    required this.terrain,
    this.walkable = true,
    this.moveCost = 1,
  });

  /// Couleur de la case selon le terrain
  Color get color {
    switch (terrain) {
      case TerrainType.plains:
        return const Color(0xFF8BC34A);
      case TerrainType.forest:
        return const Color(0xFF4CAF50);
      case TerrainType.mountain:
        return const Color(0xFF795548);
      case TerrainType.water:
        return const Color(0xFF2196F3);
      case TerrainType.castle:
        return const Color(0xFF9E9E9E);
      case TerrainType.road:
        return const Color(0xFFFFEB3B);
    }
  }

  /// Icône du terrain
  IconData? get icon {
    switch (terrain) {
      case TerrainType.forest:
        return Icons.park;
      case TerrainType.mountain:
        return Icons.terrain;
      case TerrainType.castle:
        return Icons.castle;
      case TerrainType.water:
        return Icons.water;
      default:
        return null;
    }
  }

  MapTile copyWith({
    int? x,
    int? y,
    TerrainType? terrain,
    bool? walkable,
    int? moveCost,
  }) {
    return MapTile(
      x: x ?? this.x,
      y: y ?? this.y,
      terrain: terrain ?? this.terrain,
      walkable: walkable ?? this.walkable,
      moveCost: moveCost ?? this.moveCost,
    );
  }
}

/// Position d'une unité sur la carte
class UnitPosition {
  final String unitId;
  final int x;
  final int y;
  final String name;
  final Color color;
  final bool isPlayer;
  final String? pixelSprite; // Chemin vers le sprite pixel.png

  const UnitPosition({
    required this.unitId,
    required this.x,
    required this.y,
    required this.name,
    this.color = Colors.blue,
    this.isPlayer = false,
    this.pixelSprite,
  });

  UnitPosition copyWith({
    String? unitId,
    int? x,
    int? y,
    String? name,
    Color? color,
    bool? isPlayer,
    String? pixelSprite,
  }) {
    return UnitPosition(
      unitId: unitId ?? this.unitId,
      x: x ?? this.x,
      y: y ?? this.y,
      name: name ?? this.name,
      color: color ?? this.color,
      isPlayer: isPlayer ?? this.isPlayer,
      pixelSprite: pixelSprite ?? this.pixelSprite,
    );
  }
}

/// Configuration complète d'une map tactique
class TacticalMapData {
  final String id;
  final String name;
  final int width;
  final int height;
  final List<List<MapTile>> tiles;
  final List<UnitPosition> units;
  final String? description;

  const TacticalMapData({
    required this.id,
    required this.name,
    required this.width,
    required this.height,
    required this.tiles,
    this.units = const [],
    this.description,
  });

  /// Obtenir une case spécifique
  MapTile? getTile(int x, int y) {
    if (x < 0 || x >= width || y < 0 || y >= height) return null;
    return tiles[y][x];
  }

  /// Vérifier si une position est valide et marchable
  bool isWalkable(int x, int y) {
    final tile = getTile(x, y);
    return tile?.walkable ?? false;
  }

  /// Vérifier si une position est occupée par une unité
  bool isOccupied(int x, int y) {
    return units.any((unit) => unit.x == x && unit.y == y);
  }

  /// Obtenir l'unité à une position donnée
  UnitPosition? getUnitAt(int x, int y) {
    try {
      return units.firstWhere((unit) => unit.x == x && unit.y == y);
    } catch (e) {
      return null;
    }
  }

  /// Calcule toutes les cases accessibles depuis une position avec un mouvement donné
  /// Utilise l'algorithme de Dijkstra pour prendre en compte les coûts de déplacement
  Set<MapTile> getReachableTiles(int startX, int startY, int movementRange) {
    final reachable = <MapTile>{};
    final costs = <String, int>{}; // "x,y" -> cost
    final toVisit = <_PathNode>[]; // Priority queue simulée
    
    // Position de départ
    toVisit.add(_PathNode(startX, startY, 0));
    costs["$startX,$startY"] = 0;
    
    while (toVisit.isNotEmpty) {
      // Tri par coût (simule une priority queue)
      toVisit.sort((a, b) => a.cost.compareTo(b.cost));
      final current = toVisit.removeAt(0);
      
      final currentTile = getTile(current.x, current.y);
      if (currentTile != null && current.cost <= movementRange) {
        // Ne pas ajouter la case de départ aux cases accessibles
        if (!(current.x == startX && current.y == startY)) {
          // Ne pas ajouter les cases occupées par d'autres unités
          if (!isOccupied(current.x, current.y)) {
            reachable.add(currentTile);
          }
        }
      }
      
      // Explorer les 4 directions adjacentes
      final directions = [
        [0, -1], // Haut
        [0, 1],  // Bas
        [-1, 0], // Gauche
        [1, 0],  // Droite
      ];
      
      for (final dir in directions) {
        final newX = current.x + dir[0];
        final newY = current.y + dir[1];
        final key = "$newX,$newY";
        
        final nextTile = getTile(newX, newY);
        if (nextTile == null || !nextTile.walkable) continue;
        
        final newCost = current.cost + nextTile.moveCost;
        
        // Si on peut atteindre cette case avec un meilleur coût
        if (newCost <= movementRange && (!costs.containsKey(key) || newCost < costs[key]!)) {
          costs[key] = newCost;
          toVisit.add(_PathNode(newX, newY, newCost));
        }
      }
    }
    
    return reachable;
  }

  /// Calcule le coût de déplacement entre deux positions adjacentes
  /// Retourne null si le déplacement n'est pas possible
  int? getMovementCost(int fromX, int fromY, int toX, int toY) {
    // Vérifier si les positions sont adjacentes (distance de 1)
    final distance = (fromX - toX).abs() + (fromY - toY).abs();
    if (distance != 1) return null;
    
    final tile = getTile(toX, toY);
    if (tile == null || !tile.walkable) return null;
    
    return tile.moveCost;
  }

  /// Calcule le chemin optimal depuis une position vers une destination
  /// Retourne le coût total et le chemin (liste de positions)
  PathResult? findPath(int startX, int startY, int endX, int endY, int maxMovement) {
    final costs = <String, int>{}; // "x,y" -> cost
    final parents = <String, String>{}; // "x,y" -> "parentX,parentY"
    final toVisit = <_PathNode>[];
    
    toVisit.add(_PathNode(startX, startY, 0));
    costs["$startX,$startY"] = 0;
    
    while (toVisit.isNotEmpty) {
      toVisit.sort((a, b) => a.cost.compareTo(b.cost));
      final current = toVisit.removeAt(0);
      
      // Si on a atteint la destination
      if (current.x == endX && current.y == endY) {
        // Reconstruire le chemin
        final path = <MapPosition>[];
        var currentKey = "$endX,$endY";
        
        while (currentKey != "$startX,$startY") {
          final coords = currentKey.split(',');
          path.insert(0, MapPosition(int.parse(coords[0]), int.parse(coords[1])));
          currentKey = parents[currentKey]!;
        }
        
        return PathResult(path: path, totalCost: costs["$endX,$endY"]!);
      }
      
      final directions = [
        [0, -1], [0, 1], [-1, 0], [1, 0],
      ];
      
      for (final dir in directions) {
        final newX = current.x + dir[0];
        final newY = current.y + dir[1];
        final key = "$newX,$newY";
        
        final nextTile = getTile(newX, newY);
        if (nextTile == null || !nextTile.walkable) continue;
        
        // La destination peut être occupée, mais pas les cases intermédiaires
        if (isOccupied(newX, newY) && !(newX == endX && newY == endY)) continue;
        
        final newCost = current.cost + nextTile.moveCost;
        
        if (newCost <= maxMovement && (!costs.containsKey(key) || newCost < costs[key]!)) {
          costs[key] = newCost;
          parents[key] = "${current.x},${current.y}";
          toVisit.add(_PathNode(newX, newY, newCost));
        }
      }
    }
    
    return null; // Pas de chemin trouvé
  }

  /// Calcule les cases attaquables depuis les cases accessibles avec une portée d'attaque donnée
  Set<MapTile> getAttackableTiles(Set<MapTile> reachableTiles, int startX, int startY, int attackRange) {
    final attackable = <MapTile>{};
    
    // Cases attaquables depuis la position actuelle (sans bouger)
    _addAttackTilesFromPosition(startX, startY, attackRange, attackable);
    
    // Cases attaquables depuis chaque case accessible
    for (final tile in reachableTiles) {
      _addAttackTilesFromPosition(tile.x, tile.y, attackRange, attackable);
    }
    
    // Retirer les cases de mouvement de la liste d'attaque
    attackable.removeWhere((tile) => 
      reachableTiles.contains(tile) || (tile.x == startX && tile.y == startY)
    );
    
    return attackable;
  }

  /// Ajoute les cases attaquables depuis une position donnée
  void _addAttackTilesFromPosition(int x, int y, int range, Set<MapTile> attackable) {
    for (int dx = -range; dx <= range; dx++) {
      for (int dy = -range; dy <= range; dy++) {
        // Distance de Manhattan
        final distance = dx.abs() + dy.abs();
        if (distance > 0 && distance <= range) {
          final tile = getTile(x + dx, y + dy);
          if (tile != null) {
            attackable.add(tile);
          }
        }
      }
    }
  }

  /// Créer une map de test simple
  factory TacticalMapData.createTestMap() {
    const width = 8;
    const height = 8;

    final tiles = List.generate(
      height,
      (y) => List.generate(
        width,
        (x) {
          if ((x == 0 && y == 0) ||
              (x == width - 1 && y == 0) ||
              (x == 0 && y == height - 1) ||
              (x == width - 1 && y == height - 1)) {
            return MapTile(
              x: x,
              y: y,
              terrain: TerrainType.mountain,
              walkable: false,
            );
          }

          if (x == width ~/ 2 && y == height ~/ 2) {
            return MapTile(
              x: x,
              y: y,
              terrain: TerrainType.castle,
              walkable: true,
            );
          }

          if (y == height ~/ 2) {
            return MapTile(
              x: x,
              y: y,
              terrain: TerrainType.road,
              walkable: true,
              moveCost: 1,
            );
          }

          if ((x + y) % 3 == 0 && x > 1 && x < width - 2) {
            return MapTile(
              x: x,
              y: y,
              terrain: TerrainType.forest,
              walkable: true,
              moveCost: 2,
            );
          }

          if (x == 1 && y > 2 && y < height - 2) {
            return MapTile(
              x: x,
              y: y,
              terrain: TerrainType.water,
              walkable: false,
            );
          }

          return MapTile(
            x: x,
            y: y,
            terrain: TerrainType.plains,
            walkable: true,
            moveCost: 1,
          );
        },
      ),
    );

    return TacticalMapData(
      id: 'test_map_01',
      name: 'Plaine des Premiers Pas',
      width: width,
      height: height,
      tiles: tiles,
      description: 'Une carte d\'entraînement pour apprendre les bases du combat tactique.',
    );
  }

  /// Créer une map personnalisée
  factory TacticalMapData.custom({
    required String id,
    required String name,
    required int width,
    required int height,
    required List<List<TerrainType>> terrainLayout,
    String? description,
  }) {
    final tiles = List.generate(
      height,
      (y) => List.generate(
        width,
        (x) {
          final terrain = terrainLayout[y][x];
          return MapTile(
            x: x,
            y: y,
            terrain: terrain,
            walkable: terrain != TerrainType.mountain && terrain != TerrainType.water,
            moveCost: terrain == TerrainType.forest ? 2 : 1,
          );
        },
      ),
    );

    return TacticalMapData(
      id: id,
      name: name,
      width: width,
      height: height,
      tiles: tiles,
      description: description,
    );
  }
}
