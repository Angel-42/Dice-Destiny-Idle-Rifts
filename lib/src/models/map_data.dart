import 'package:flutter/material.dart';

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

  const UnitPosition({
    required this.unitId,
    required this.x,
    required this.y,
    required this.name,
    this.color = Colors.blue,
    this.isPlayer = false,
  });

  UnitPosition copyWith({
    String? unitId,
    int? x,
    int? y,
    String? name,
    Color? color,
    bool? isPlayer,
  }) {
    return UnitPosition(
      unitId: unitId ?? this.unitId,
      x: x ?? this.x,
      y: y ?? this.y,
      name: name ?? this.name,
      color: color ?? this.color,
      isPlayer: isPlayer ?? this.isPlayer,
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
