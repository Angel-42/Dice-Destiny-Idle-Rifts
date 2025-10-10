import 'package:flutter/material.dart';
import '../models/map_data.dart';

/// Widget de grille tactique modulable (style Fire Emblem)
class TacticalMapWidget extends StatelessWidget {
  final TacticalMapData mapData;
  final List<UnitPosition> units;
  final UnitPosition? selectedUnit;
  final Function(int x, int y)? onTileTap;
  final Function(UnitPosition unit)? onUnitTap;
  final double tileSize;
  final bool showGrid;
  final Set<String>? highlightedTiles;

  const TacticalMapWidget({
    super.key,
    required this.mapData,
    this.units = const [],
    this.selectedUnit,
    this.onTileTap,
    this.onUnitTap,
    this.tileSize = 60.0,
    this.showGrid = true,
    this.highlightedTiles,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black54, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          mapData.height,
          (y) => Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              mapData.width,
              (x) {
                final tile = mapData.tiles[y][x];
                final unit = units.firstWhere(
                  (u) => u.x == x && u.y == y,
                  orElse: () => UnitPosition(
                    unitId: '',
                    x: -1,
                    y: -1,
                    name: '',
                  ),
                );
                final hasUnit = unit.x == x && unit.y == y;
                final isSelected = selectedUnit?.x == x && selectedUnit?.y == y;
                final isHighlighted = highlightedTiles?.contains('$x,$y') ?? false;

                return _MapTileWidget(
                  tile: tile,
                  unit: hasUnit ? unit : null,
                  isSelected: isSelected,
                  isHighlighted: isHighlighted,
                  size: tileSize,
                  showGrid: showGrid,
                  onTap: () {
                    if (hasUnit && onUnitTap != null) {
                      onUnitTap!(unit);
                    } else if (onTileTap != null) {
                      onTileTap!(x, y);
                    }
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

/// Widget individuel d'une case de la map
class _MapTileWidget extends StatelessWidget {
  final MapTile tile;
  final UnitPosition? unit;
  final bool isSelected;
  final bool isHighlighted;
  final double size;
  final bool showGrid;
  final VoidCallback onTap;

  const _MapTileWidget({
    required this.tile,
    this.unit,
    this.isSelected = false,
    this.isHighlighted = false,
    required this.size,
    this.showGrid = true,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: _getTileColor(),
          border: showGrid
              ? Border.all(
                  color: Colors.black.withOpacity(0.2),
                  width: 1,
                )
              : null,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.yellow.withOpacity(0.6),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: Stack(
          children: [
            // Icône du terrain
            if (tile.icon != null)
              Center(
                child: Icon(
                  tile.icon,
                  color: Colors.black.withOpacity(0.2),
                  size: size * 0.5,
                ),
              ),

            // Highlight de mouvement possible
            if (isHighlighted)
              Container(
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.3),
                  border: Border.all(
                    color: Colors.blue,
                    width: 2,
                  ),
                ),
              ),

            // Unité
            if (unit != null)
              Center(
                child: Container(
                  width: size * 0.7,
                  height: size * 0.7,
                  decoration: BoxDecoration(
                    color: unit!.color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? Colors.yellow : Colors.white,
                      width: isSelected ? 3 : 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      unit!.name.substring(0, 1).toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: size * 0.35,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),

            if (isSelected && unit != null)
              Positioned(
                top: 2,
                right: 2,
                child: Icon(
                  Icons.check_circle,
                  color: Colors.yellow,
                  size: size * 0.25,
                ),
              ),

            if (showGrid)
              Positioned(
                bottom: 2,
                left: 2,
                child: Text(
                  '${tile.x},${tile.y}',
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.3),
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Color _getTileColor() {
    if (isSelected) {
      return tile.color.withOpacity(0.8);
    }
    if (isHighlighted) {
      return tile.color.withOpacity(0.9);
    }
    return tile.color;
  }
}

/// Widget de légende pour expliquer les terrains
class TacticalMapLegend extends StatelessWidget {
  const TacticalMapLegend({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'LÉGENDE',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          _LegendItem(
            color: const Color(0xFF8BC34A),
            icon: null,
            label: 'Plaine',
            description: 'Normal',
          ),
          _LegendItem(
            color: const Color(0xFF4CAF50),
            icon: Icons.park,
            label: 'Forêt',
            description: 'Ralentit',
          ),
          _LegendItem(
            color: const Color(0xFF795548),
            icon: Icons.terrain,
            label: 'Montagne',
            description: 'Infranchissable',
          ),
          _LegendItem(
            color: const Color(0xFF2196F3),
            icon: Icons.water,
            label: 'Eau',
            description: 'Infranchissable',
          ),
          _LegendItem(
            color: const Color(0xFFFFEB3B),
            icon: null,
            label: 'Route',
            description: 'Rapide',
          ),
          _LegendItem(
            color: const Color(0xFF9E9E9E),
            icon: Icons.castle,
            label: 'Château',
            description: 'Objectif',
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final IconData? icon;
  final String label;
  final String description;

  const _LegendItem({
    required this.color,
    this.icon,
    required this.label,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: color,
              border: Border.all(color: Colors.white, width: 1),
            ),
            child: icon != null
                ? Icon(icon, size: 14, color: Colors.black.withOpacity(0.3))
                : null,
          ),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            description,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
