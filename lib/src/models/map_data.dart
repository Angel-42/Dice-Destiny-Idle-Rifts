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

  /// Créer une map de forêt (Chapitre 1)
  factory TacticalMapData.createForestMap() {
    const width = 10;
    const height = 10;

    final tiles = List.generate(
      height,
      (y) => List.generate(
        width,
        (x) {
          // Bordures montagneuses
          if (x == 0 || x == width - 1 || y == 0 || y == height - 1) {
            return MapTile(
              x: x,
              y: y,
              terrain: TerrainType.mountain,
              walkable: false,
            );
          }

          // Forêts denses (60% de la map)
          if ((x + y) % 2 == 0 && x > 1 && x < width - 2) {
            return MapTile(
              x: x,
              y: y,
              terrain: TerrainType.forest,
              walkable: true,
              moveCost: 2,
            );
          }

          // Plaines
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
      id: 'forest_map',
      name: 'Forêt Mystérieuse',
      width: width,
      height: height,
      tiles: tiles,
      description: 'Une épaisse forêt où les ennemis se cachent.',
    );
  }

  /// Créer une map de plaines (Chapitre 2)
  factory TacticalMapData.createPlainsMap() {
    const width = 12;
    const height = 10;

    final tiles = List.generate(
      height,
      (y) => List.generate(
        width,
        (x) {
          // Route centrale
          if (y == height ~/ 2) {
            return MapTile(
              x: x,
              y: y,
              terrain: TerrainType.road,
              walkable: true,
              moveCost: 1,
            );
          }

          // Quelques forêts dispersées
          if ((x * y) % 7 == 0) {
            return MapTile(
              x: x,
              y: y,
              terrain: TerrainType.forest,
              walkable: true,
              moveCost: 2,
            );
          }

          // Plaines majoritaires
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
      id: 'plains_map',
      name: 'Plaines Ouvertes',
      width: width,
      height: height,
      tiles: tiles,
      description: 'De vastes plaines où la stratégie est clé.',
    );
  }

  /// Créer une map de montagne (Chapitre 3)
  factory TacticalMapData.createMountainMap() {
    const width = 10;
    const height = 10;

    final tiles = List.generate(
      height,
      (y) => List.generate(
        width,
        (x) {
          // Montagnes aléatoires (30%)
          if ((x * 3 + y * 2) % 5 == 0) {
            return MapTile(
              x: x,
              y: y,
              terrain: TerrainType.mountain,
              walkable: false,
            );
          }

          // Forêts sur les pentes
          if ((x + y) % 3 == 0) {
            return MapTile(
              x: x,
              y: y,
              terrain: TerrainType.forest,
              walkable: true,
              moveCost: 2,
            );
          }

          // Plaines rocheuses
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
      id: 'mountain_map',
      name: 'Pics Escarpés',
      width: width,
      height: height,
      tiles: tiles,
      description: 'Des montagnes traîtresses avec des passages étroits.',
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

  /// Créer une map de donjon
  factory TacticalMapData.createDungeonMap() {
    const width = 8;
    const height = 8;

    final tiles = List.generate(
      height,
      (y) => List.generate(
        width,
        (x) {
          // Murs extérieurs
          if (x == 0 || x == width - 1 || y == 0 || y == height - 1) {
            return MapTile(
              x: x,
              y: y,
              terrain: TerrainType.mountain,
              walkable: false,
            );
          }

          // Couloirs en croix
          if (x == width ~/ 2 || y == height ~/ 2) {
            return MapTile(
              x: x,
              y: y,
              terrain: TerrainType.plains,
              walkable: true,
              moveCost: 1,
            );
          }

          // Salles dans les coins
          if ((x < 3 && y < 3) || (x > width - 4 && y < 3) ||
              (x < 3 && y > height - 4) || (x > width - 4 && y > height - 4)) {
            return MapTile(
              x: x,
              y: y,
              terrain: TerrainType.plains,
              walkable: true,
              moveCost: 1,
            );
          }

          // Murs intérieurs
          return MapTile(
            x: x,
            y: y,
            terrain: TerrainType.mountain,
            walkable: false,
          );
        },
      ),
    );

    return TacticalMapData(
      id: 'dungeon_map',
      name: 'Geôles Sombres',
      width: width,
      height: height,
      tiles: tiles,
      description: 'Un donjon sombre avec des couloirs étroits.',
    );
  }

  /// Créer une map de ville
  factory TacticalMapData.createTownMap() {
    const width = 10;
    const height = 8;

    final tiles = List.generate(
      height,
      (y) => List.generate(
        width,
        (x) {
          // Route principale horizontale
          if (y == height ~/ 2) {
            return MapTile(
              x: x,
              y: y,
              terrain: TerrainType.road,
              walkable: true,
              moveCost: 1,
            );
          }

          // Routes verticales
          if (x == 2 || x == 5 || x == 8) {
            return MapTile(
              x: x,
              y: y,
              terrain: TerrainType.road,
              walkable: true,
              moveCost: 1,
            );
          }

          // Bâtiments (châteaux)
          if ((x == 1 || x == 3 || x == 6 || x == 9) && 
              (y == 1 || y == height - 2)) {
            return MapTile(
              x: x,
              y: y,
              terrain: TerrainType.castle,
              walkable: true,
              moveCost: 1,
            );
          }

          // Plaines (places publiques)
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
      id: 'town_map',
      name: 'Place du Marché',
      width: width,
      height: height,
      tiles: tiles,
      description: 'Une ville animée avec des routes et des bâtiments.',
    );
  }

  /// Créer une map de brèche
  factory TacticalMapData.createBreachMap() {
    const width = 12;
    const height = 10;

    final tiles = List.generate(
      height,
      (y) => List.generate(
        width,
        (x) {
          // Faille chaotique au centre
          if (x >= width ~/ 2 - 1 && x <= width ~/ 2 + 1 && 
              y >= height ~/ 2 - 2 && y <= height ~/ 2 + 2) {
            return MapTile(
              x: x,
              y: y,
              terrain: TerrainType.water, // Représente le vide
              walkable: false,
            );
          }

          // Montagnes déformées autour
          if ((x + y) % 4 == 0 && 
              (x < width ~/ 2 - 2 || x > width ~/ 2 + 2)) {
            return MapTile(
              x: x,
              y: y,
              terrain: TerrainType.mountain,
              walkable: false,
            );
          }

          // Terrain corrompu (forêt sombre)
          if ((x * y) % 5 == 0) {
            return MapTile(
              x: x,
              y: y,
              terrain: TerrainType.forest,
              walkable: true,
              moveCost: 2,
            );
          }

          // Plaines désolées
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
      id: 'breach_map',
      name: 'Brèche Dimensionnelle',
      width: width,
      height: height,
      tiles: tiles,
      description: 'Une faille dans la réalité déforme le paysage.',
    );
  }

  /// Créer une map d'escaliers (Confluence)
  factory TacticalMapData.createStairsMap() {
    const width = 8;
    const height = 12;

    final tiles = List.generate(
      height,
      (y) => List.generate(
        width,
        (x) {
          // Escalier central en diagonale
          if (x == y ~/ 2 + 1 || x == y ~/ 2 + 2) {
            return MapTile(
              x: x,
              y: y,
              terrain: TerrainType.road,
              walkable: true,
              moveCost: 1,
            );
          }

          // Plateformes aux niveaux
          if (y % 3 == 0 && x > 0 && x < width - 1) {
            return MapTile(
              x: x,
              y: y,
              terrain: TerrainType.castle,
              walkable: true,
              moveCost: 1,
            );
          }

          // Vide de chaque côté
          if (x == 0 || x == width - 1) {
            return MapTile(
              x: x,
              y: y,
              terrain: TerrainType.water,
              walkable: false,
            );
          }

          // Remplissage par défaut
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
      id: 'stairs_map',
      name: 'Marches Grises',
      width: width,
      height: height,
      tiles: tiles,
      description: 'Des marches infinies s\'élèvent vers l\'inconnu.',
    );
  }

  /// Créer une map de relais technologique
  factory TacticalMapData.createRelayMap() {
    const width = 8;
    const height = 8;

    final tiles = List.generate(
      height,
      (y) => List.generate(
        width,
        (x) {
          // Serveur central
          if (x >= 3 && x <= 4 && y >= 3 && y <= 4) {
            return MapTile(
              x: x,
              y: y,
              terrain: TerrainType.castle,
              walkable: true,
              moveCost: 1,
            );
          }

          // Conduits de données
          if (x == 1 || x == 6 || y == 1 || y == 6) {
            return MapTile(
              x: x,
              y: y,
              terrain: TerrainType.road,
              walkable: true,
              moveCost: 1,
            );
          }

          // Barrières énergétiques
          if (x == 0 || x == 7 || y == 0 || y == 7) {
            return MapTile(
              x: x,
              y: y,
              terrain: TerrainType.mountain,
              walkable: false,
            );
          }

          // Sol métallique
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
      id: 'relay_map',
      name: 'Relais Oméga',
      width: width,
      height: height,
      tiles: tiles,
      description: 'Un complexe technologique aux circuits complexes.',
    );
  }

  /// Créer une map de canyon
  factory TacticalMapData.createCanyonMap() {
    const width = 12;
    const height = 8;

    final tiles = List.generate(
      height,
      (y) => List.generate(
        width,
        (x) {
          // Crevasse centrale
          if (x >= 5 && x <= 6 && y >= 2 && y <= 5) {
            return MapTile(
              x: x,
              y: y,
              terrain: TerrainType.water,
              walkable: false,
            );
          }

          // Parois du canyon
          if (x == 4 || x == 7) {
            return MapTile(
              x: x,
              y: y,
              terrain: TerrainType.mountain,
              walkable: false,
            );
          }

          // Pont au milieu
          if (x >= 5 && x <= 6 && y == height ~/ 2) {
            return MapTile(
              x: x,
              y: y,
              terrain: TerrainType.road,
              walkable: true,
              moveCost: 1,
            );
          }

          // Terrain rocailleux
          if ((x + y) % 3 == 0) {
            return MapTile(
              x: x,
              y: y,
              terrain: TerrainType.mountain,
              walkable: false,
            );
          }

          // Plaines désertiques
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
      id: 'canyon_map',
      name: 'Canyon des Murmures',
      width: width,
      height: height,
      tiles: tiles,
      description: 'Un canyon profond où résonnent les échos du passé.',
    );
  }

  /// Créer une map du vide cosmique
  factory TacticalMapData.createVoidMap() {
    const width = 10;
    const height = 10;

    final tiles = List.generate(
      height,
      (y) => List.generate(
        width,
        (x) {
          // Îlots de réalité
          if ((x == 2 && y == 2) || (x == 7 && y == 2) ||
              (x == 2 && y == 7) || (x == 7 && y == 7) ||
              (x == 5 && y == 5)) {
            return MapTile(
              x: x,
              y: y,
              terrain: TerrainType.castle,
              walkable: true,
              moveCost: 1,
            );
          }

          // Ponts d'énergie
          if ((x == 5 && (y >= 2 && y <= 7)) ||
              (y == 5 && (x >= 2 && x <= 7))) {
            return MapTile(
              x: x,
              y: y,
              terrain: TerrainType.road,
              walkable: true,
              moveCost: 1,
            );
          }

          // Vide intersidéral
          return MapTile(
            x: x,
            y: y,
            terrain: TerrainType.water,
            walkable: false,
          );
        },
      ),
    );

    return TacticalMapData(
      id: 'void_map',
      name: 'Escalier du Vide',
      width: width,
      height: height,
      tiles: tiles,
      description: 'Fragments de réalité flottent dans le néant.',
    );
  }

  /// Créer une map céleste
  factory TacticalMapData.createCelestialMap() {
    const width = 8;
    const height = 8;

    final tiles = List.generate(
      height,
      (y) => List.generate(
        width,
        (x) {
          // Pavillon central
          if (x >= 3 && x <= 4 && y >= 3 && y <= 4) {
            return MapTile(
              x: x,
              y: y,
              terrain: TerrainType.castle,
              walkable: true,
              moveCost: 1,
            );
          }

          // Jardins de méditation
          if ((x + y) % 2 == 0 && x > 1 && x < 6 && y > 1 && y < 6) {
            return MapTile(
              x: x,
              y: y,
              terrain: TerrainType.forest,
              walkable: true,
              moveCost: 2,
            );
          }

          // Sentiers dorés
          if (x == 1 || x == 6 || y == 1 || y == 6) {
            return MapTile(
              x: x,
              y: y,
              terrain: TerrainType.road,
              walkable: true,
              moveCost: 1,
            );
          }

          // Nuages étincelants (infranchissables)
          if (x == 0 || x == 7 || y == 0 || y == 7) {
            return MapTile(
              x: x,
              y: y,
              terrain: TerrainType.water,
              walkable: false,
            );
          }

          // Plateformes de jade
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
      id: 'celestial_map',
      name: 'Pavillon de Jade',
      width: width,
      height: height,
      tiles: tiles,
      description: 'Un lieu de méditation aux énergies divines.',
    );
  }

  /// Génère une map selon le thème spécifié
  static TacticalMapData generateMap(String theme) {
    switch (theme) {
      case 'forest':
        return TacticalMapData.createForestMap();
      case 'plains':
        return TacticalMapData.createPlainsMap();
      case 'mountain':
        return TacticalMapData.createMountainMap();
      case 'dungeon':
        return TacticalMapData.createDungeonMap();
      case 'town':
        return TacticalMapData.createTownMap();
      case 'breach':
        return TacticalMapData.createBreachMap();
      case 'stairs':
        return TacticalMapData.createStairsMap();
      case 'relay':
        return TacticalMapData.createRelayMap();
      case 'canyon':
        return TacticalMapData.createCanyonMap();
      case 'void':
        return TacticalMapData.createVoidMap();
      case 'celestial':
        return TacticalMapData.createCelestialMap();
      default:
        return TacticalMapData.createTestMap();
    }
  }
}
