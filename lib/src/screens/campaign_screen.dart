import 'package:flutter/material.dart';
import '../models/map_data.dart';
import '../widgets/tactical_map_widget.dart';

/// Écran de campagne avec map tactique et déplacement
class CampaignScreen extends StatefulWidget {
  final String characterId;
  final String characterName;

  const CampaignScreen({
    super.key,
    required this.characterId,
    required this.characterName,
  });

  @override
  State<CampaignScreen> createState() => _CampaignScreenState();
}

class _CampaignScreenState extends State<CampaignScreen> {
  late TacticalMapData mapData;
  late List<UnitPosition> units;
  UnitPosition? selectedUnit;
  Set<String> highlightedTiles = {};

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  void _initializeMap() {
    // Créer la map
    mapData = TacticalMapData.createTestMap();

    // Placer le joueur en position de départ (bas gauche)
    final playerUnit = UnitPosition(
      unitId: widget.characterId,
      x: 2,
      y: 6,
      name: widget.characterName,
      color: Colors.blue,
      isPlayer: true,
    );

    // Ajouter quelques ennemis de test (optionnel)
    final enemy1 = UnitPosition(
      unitId: 'enemy_1',
      x: 5,
      y: 2,
      name: 'Goblin',
      color: Colors.red,
      isPlayer: false,
    );

    final enemy2 = UnitPosition(
      unitId: 'enemy_2',
      x: 6,
      y: 3,
      name: 'Orc',
      color: Colors.red,
      isPlayer: false,
    );

    units = [playerUnit, enemy1, enemy2];
  }

  void _onUnitTap(UnitPosition unit) {
    if (!unit.isPlayer) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${unit.name} - Ennemi'),
          duration: const Duration(seconds: 1),
        ),
      );
      return;
    }

    setState(() {
      if (selectedUnit?.unitId == unit.unitId) {
        // Désélectionner
        selectedUnit = null;
        highlightedTiles.clear();
      } else {
        // Sélectionner
        selectedUnit = unit;
        _highlightMoveOptions(unit);
      }
    });
  }

  void _highlightMoveOptions(UnitPosition unit) {
    highlightedTiles.clear();

    // Cases adjacentes (haut, bas, gauche, droite)
    final directions = [
      (0, -1), // Haut
      (0, 1),  // Bas
      (-1, 0), // Gauche
      (1, 0),  // Droite
    ];

    for (final (dx, dy) in directions) {
      final newX = unit.x + dx;
      final newY = unit.y + dy;

      // Vérifier si la case est valide et marchable
      if (mapData.isWalkable(newX, newY) && !mapData.isOccupied(newX, newY)) {
        highlightedTiles.add('$newX,$newY');
      }
    }

    setState(() {});
  }

  void _onTileTap(int x, int y) {
    if (selectedUnit == null) return;

    // Vérifier si la case est dans les mouvements possibles
    if (!highlightedTiles.contains('$x,$y')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Déplacement impossible !'),
          duration: Duration(seconds: 1),
        ),
      );
      return;
    }

    // Déplacer l'unité
    setState(() {
      final index = units.indexWhere((u) => u.unitId == selectedUnit!.unitId);
      if (index != -1) {
        units[index] = units[index].copyWith(x: x, y: y);
        selectedUnit = units[index];
        
        // Mettre à jour les cases en surbrillance
        _highlightMoveOptions(selectedUnit!);
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${selectedUnit!.name} déplacé vers ($x, $y)'),
        duration: const Duration(seconds: 1),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF1A237E),
              const Color(0xFF311B92),
              Colors.black,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              _buildHeader(context),

              const SizedBox(height: 20),

              // Map avec scroll
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TacticalMapWidget(
                        mapData: mapData,
                        units: units,
                        selectedUnit: selectedUnit,
                        onUnitTap: _onUnitTap,
                        onTileTap: _onTileTap,
                        tileSize: 70,
                        showGrid: true,
                        highlightedTiles: highlightedTiles,
                      ),
                    ),
                  ),
                ),
              ),

              // Panel inférieur
              _buildBottomPanel(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        border: Border(
          bottom: BorderSide(
            color: Colors.amber.withOpacity(0.3),
            width: 2,
          ),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mapData.name,
                  style: const TextStyle(
                    color: Colors.amber,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                if (mapData.description != null)
                  Text(
                    mapData.description!,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ),
          // Icône d'aide
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.white70),
            onPressed: () => _showLegend(context),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomPanel() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        border: Border(
          top: BorderSide(
            color: Colors.amber.withOpacity(0.3),
            width: 2,
          ),
        ),
      ),
      child: Row(
        children: [
          // Info unité sélectionnée
          Expanded(
            child: selectedUnit != null
                ? Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: selectedUnit!.color,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Center(
                          child: Text(
                            selectedUnit!.name.substring(0, 1).toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            selectedUnit!.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Position: (${selectedUnit!.x}, ${selectedUnit!.y})',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                : Text(
                    'Sélectionnez votre personnage pour vous déplacer',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
          ),

          // Bouton fin de tour
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                selectedUnit = null;
                highlightedTiles.clear();
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Tour terminé !'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
            icon: const Icon(Icons.check),
            label: const Text('FIN DU TOUR'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  void _showLegend(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: const TacticalMapLegend(),
      ),
    );
  }
}
