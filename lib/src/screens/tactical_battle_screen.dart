import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../models/character.dart';

class TacticalBattleScreen extends StatefulWidget {
  final Character character;

  const TacticalBattleScreen({super.key, required this.character});

  @override
  State<TacticalBattleScreen> createState() => _TacticalBattleScreenState();
}

class _TacticalBattleScreenState extends State<TacticalBattleScreen> {
  // Taille de la grille
  static const int gridSize = 25;
  static const double cellSize = 48.0;
  
  // Position du personnage sur la grille
  int playerX = 2;
  int playerY = 2;
  
  // Offset de la caméra
  double cameraX = 0.0;
  double cameraY = 0.0;
  
  // Position de déplacement valide
  Set<String> validMoves = {};
  bool isSelectingMove = false;
  
  // Paramètres de mouvement
  final int moveRange = 3; // Portée de déplacement
  
  // Zoom
  double _scale = 1.0;
  
  @override
  void initState() {
    super.initState();
    // Centrer la caméra sur le joueur au démarrage
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _centerCameraOnPlayer();
    });
  }

  void _centerCameraOnPlayer() {
    final screenSize = MediaQuery.of(context).size;
    setState(() {
      cameraX = (screenSize.width / 2) - (playerX * cellSize * _scale) - (cellSize * _scale / 2);
      cameraY = (screenSize.height / 2) - (playerY * cellSize * _scale) - (cellSize * _scale / 2);
      _constrainCamera();
    });
  }

  void _constrainCamera() {
    final screenSize = MediaQuery.of(context).size;
    final mapWidth = gridSize * cellSize * _scale;
    final mapHeight = gridSize * cellSize * _scale;
    
    // Limiter le déplacement de la caméra pour ne pas sortir de la carte
    final minX = screenSize.width - mapWidth;
    final minY = screenSize.height - mapHeight;
    
    cameraX = cameraX.clamp(minX, 0.0);
    cameraY = cameraY.clamp(minY, 0.0);
  }

  void _calculateValidMoves() {
    validMoves.clear();
    
    // BFS pour trouver toutes les cases accessibles dans la portée
    final queue = <MapNode>[];
    final visited = <String>{};
    
    queue.add(MapNode(playerX, playerY, 0));
    visited.add('${playerX}_$playerY');
    
    while (queue.isNotEmpty) {
      final current = queue.removeAt(0);
      
      if (current.distance < moveRange) {
        // Vérifier les 4 directions
        final directions = [
          [0, 1],   // Bas
          [0, -1],  // Haut
          [1, 0],   // Droite
          [-1, 0],  // Gauche
        ];
        
        for (final dir in directions) {
          final newX = current.x + dir[0];
          final newY = current.y + dir[1];
          final key = '${newX}_$newY';
          
          if (newX >= 0 && newX < gridSize && 
              newY >= 0 && newY < gridSize && 
              !visited.contains(key)) {
            visited.add(key);
            validMoves.add(key);
            queue.add(MapNode(newX, newY, current.distance + 1));
          }
        }
      }
    }
    
    // Retirer la position actuelle du joueur
    validMoves.remove('${playerX}_$playerY');
  }

  void _onCellTap(int x, int y) {
    if (isSelectingMove) {
      final key = '${x}_$y';
      if (validMoves.contains(key)) {
        setState(() {
          playerX = x;
          playerY = y;
          isSelectingMove = false;
          validMoves.clear();
        });
      }
    }
  }

  void _toggleMoveMode() {
    setState(() {
      isSelectingMove = !isSelectingMove;
      if (isSelectingMove) {
        _calculateValidMoves();
      } else {
        validMoves.clear();
      }
    });
  }

  bool _isPlayerFarFromCenter() {
    final screenSize = MediaQuery.of(context).size;
    final playerScreenX = cameraX + (playerX * cellSize * _scale);
    final playerScreenY = cameraY + (playerY * cellSize * _scale);
    
    final dx = playerScreenX - screenSize.width / 2;
    final dy = playerScreenY - screenSize.height / 2;
    final distance = math.sqrt(dx * dx + dy * dy);
    
    return distance > 200; // Si le joueur est à plus de 200px du centre
  }

  Color _getTerrainColor(int x, int y) {
    // Générer un terrain pseudo-aléatoire basé sur la position
    final hash = (x * 7 + y * 13) % 4;
    switch (hash) {
      case 0:
        return const Color(0xFF6B8E9F); // Plaine bleu-gris
      case 1:
        return const Color(0xFF5A7A8A); // Plaine bleu foncé
      case 2:
        return const Color(0xFFD4A373); // Désert/sable
      case 3:
        return const Color(0xFF8B6F47); // Terre
      default:
        return const Color(0xFF6B8E9F);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0F1419), Color(0xFF1A1F2E)],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Carte tactique avec gestes
              GestureDetector(
                onPanUpdate: (details) {
                  if (!isSelectingMove) {
                    setState(() {
                      cameraX += details.delta.dx;
                      cameraY += details.delta.dy;
                      _constrainCamera();
                    });
                  }
                },
                child: ClipRect(
                  child: Transform.translate(
                    offset: Offset(cameraX, cameraY),
                    child: Transform.scale(
                      scale: _scale,
                      alignment: Alignment.topLeft,
                      child: _buildGrid(),
                    ),
                  ),
                ),
              ),
              
              // Bouton de recentrage (si le joueur est loin)
              if (_isPlayerFarFromCenter())
                Positioned(
                  bottom: 100,
                  right: 20,
                  child: GestureDetector(
                    onTap: _centerCameraOnPlayer,
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.cyan.withOpacity(0.9),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          widget.character.appearance.emoji,
                          style: const TextStyle(fontSize: 30),
                        ),
                      ),
                    ),
                  ),
                ),
              
              // UI supérieure
              _buildTopUI(),
              
              // Boutons d'action
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGrid() {
    return SizedBox(
      width: gridSize * cellSize,
      height: gridSize * cellSize,
      child: Stack(
        children: [
          // Grille de fond
          ...List.generate(gridSize * gridSize, (index) {
            final x = index % gridSize;
            final y = index ~/ gridSize;
            final key = '${x}_$y';
            final isValid = validMoves.contains(key);
            
            return Positioned(
              left: x * cellSize,
              top: y * cellSize,
              child: GestureDetector(
                onTap: () => _onCellTap(x, y),
                child: Container(
                  width: cellSize,
                  height: cellSize,
                  decoration: BoxDecoration(
                    color: isValid
                        ? Colors.blue.withOpacity(0.5)
                        : _getTerrainColor(x, y),
                    border: Border.all(
                      color: Colors.black.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: isValid
                      ? Center(
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: Colors.cyan.withOpacity(0.7),
                              shape: BoxShape.circle,
                            ),
                          ),
                        )
                      : null,
                ),
              ),
            );
          }),
          
          // Personnage du joueur
          Positioned(
            left: playerX * cellSize,
            top: playerY * cellSize,
            child: Container(
              width: cellSize,
              height: cellSize,
              decoration: BoxDecoration(
                color: Color(widget.character.appearance.colorValue).withOpacity(0.3),
                border: Border.all(
                  color: Color(widget.character.appearance.colorValue),
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Text(
                      widget.character.appearance.emoji,
                      style: const TextStyle(fontSize: 32),
                    ),
                  ),
                  // Barre de vie
                  Positioned(
                    bottom: 2,
                    left: 2,
                    right: 2,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: LinearProgressIndicator(
                        value: widget.character.hpPercentage,
                        backgroundColor: Colors.black.withOpacity(0.5),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          widget.character.hpPercentage > 0.5
                              ? Colors.green
                              : Colors.orange,
                        ),
                        minHeight: 4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopUI() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0.7),
              Colors.transparent,
            ],
          ),
        ),
        child: Row(
          children: [
            // Bouton retour
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              style: IconButton.styleFrom(
                backgroundColor: Colors.black.withOpacity(0.5),
              ),
            ),
            const SizedBox(width: 12),
            
            // Info personnage
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Text(
                      widget.character.appearance.emoji,
                      style: const TextStyle(fontSize: 24),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.character.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(2),
                            child: LinearProgressIndicator(
                              value: widget.character.hpPercentage,
                              backgroundColor: Colors.white24,
                              valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                              minHeight: 6,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${widget.character.currentHp}/${widget.character.stats.maxHp}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Positioned(
      bottom: 20,
      left: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bouton déplacement
          _buildActionButton(
            icon: Icons.directions_walk,
            label: 'Déplacer',
            color: isSelectingMove ? Colors.cyan : Colors.blue,
            onTap: _toggleMoveMode,
          ),
          const SizedBox(height: 12),
          
          // Bouton attaque (à implémenter)
          _buildActionButton(
            icon: Icons.local_fire_department,
            label: 'Attaquer',
            color: Colors.red,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Attaque - À implémenter'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          
          // Bouton terminer le tour
          _buildActionButton(
            icon: Icons.check_circle,
            label: 'Fin du tour',
            color: Colors.green,
            onTap: () {
              setState(() {
                isSelectingMove = false;
                validMoves.clear();
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Tour terminé'),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.9),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MapNode {
  final int x;
  final int y;
  final int distance;

  MapNode(this.x, this.y, this.distance);
}
