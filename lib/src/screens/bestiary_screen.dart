import 'package:flutter/material.dart';
import '../models/player.dart';
import '../models/character.dart';
import '../models/bestiary_entry.dart';
import '../data/enemy_database.dart';
import '../services/game_data_service.dart';
import '../widgets/icon_display.dart';

/// Écran Encyclopédie/Bestiaire affichant tous les ennemis rencontrés
class BestiaryScreen extends StatefulWidget {
  const BestiaryScreen({super.key});

  @override
  State<BestiaryScreen> createState() => _BestiaryScreenState();
}

class _BestiaryScreenState extends State<BestiaryScreen> {
  Player? _player;
  String _selectedFilter = 'all';
  String _sortBy = 'name';

  @override
  void initState() {
    super.initState();
    _loadPlayerData();
  }

  Future<void> _loadPlayerData() async {
    final player = await GameDataService.getPlayer();
    if (mounted) {
      setState(() {
        _player = player;
      });
    }
  }

  List<String> _getFilteredEnemyIds() {
    final allEnemyIds = EnemyDatabase.getAllEnemyIds();
    
    if (_selectedFilter == 'all') {
      return allEnemyIds;
    } else if (_selectedFilter == 'discovered') {
      return allEnemyIds.where((id) => _player?.hasDiscovered(id) ?? false).toList();
    } else if (_selectedFilter == 'undiscovered') {
      return allEnemyIds.where((id) => !(_player?.hasDiscovered(id) ?? true)).toList();
    } else {
      // Filtrer par thème
      return EnemyDatabase.getEnemiesByTheme(_selectedFilter);
    }
  }

  List<String> _getSortedEnemyIds(List<String> ids) {
    final sortedIds = List<String>.from(ids);
    
    switch (_sortBy) {
      case 'name':
        sortedIds.sort((a, b) {
          final enemyA = EnemyDatabase.createEnemy(a);
          final enemyB = EnemyDatabase.createEnemy(b);
          return enemyA.name.compareTo(enemyB.name);
        });
        break;
      case 'encounters':
        sortedIds.sort((a, b) {
          final countA = _player?.bestiary[a]?.encounterCount ?? 0;
          final countB = _player?.bestiary[b]?.encounterCount ?? 0;
          return countB.compareTo(countA);
        });
        break;
      case 'winRate':
        sortedIds.sort((a, b) {
          final rateA = _player?.bestiary[a]?.winRate ?? 0;
          final rateB = _player?.bestiary[b]?.winRate ?? 0;
          return rateB.compareTo(rateA);
        });
        break;
    }
    
    return sortedIds;
  }

  @override
  Widget build(BuildContext context) {
    if (_player == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final filteredIds = _getFilteredEnemyIds();
    final sortedIds = _getSortedEnemyIds(filteredIds);
    final totalEnemies = EnemyDatabase.getAllEnemyIds().length;
    final completion = _player!.bestiaryCompletion(totalEnemies);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF1A1A2E),
              Color(0xFF16213E),
              Color(0xFF0F3460),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(completion, totalEnemies),
              _buildFiltersBar(),
              Expanded(
                child: sortedIds.isEmpty
                    ? _buildEmptyState()
                    : _buildBestiaryGrid(sortedIds),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(double completion, int totalEnemies) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.purple.shade900.withOpacity(0.5),
            Colors.blue.shade900.withOpacity(0.3),
          ],
        ),
        border: Border(
          bottom: BorderSide(color: Colors.purple.shade300.withOpacity(0.3), width: 1),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              const Expanded(
                child: Text(
                  '📖 BESTIAIRE',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatCard(
                icon: '🎯',
                label: 'Découverts',
                value: '${_player!.totalEnemiesDiscovered}/$totalEnemies',
              ),
              _buildStatCard(
                icon: '⚔️',
                label: 'Vaincus',
                value: '${_player!.totalEnemiesDefeated}',
              ),
              _buildStatCard(
                icon: '📊',
                label: 'Complétion',
                value: '${completion.toStringAsFixed(1)}%',
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: completion / 100,
              minHeight: 8,
              backgroundColor: Colors.grey.shade800,
              valueColor: AlwaysStoppedAnimation<Color>(
                completion < 33
                    ? Colors.red
                    : completion < 66
                        ? Colors.orange
                        : Colors.green,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({required String icon, required String label, required String value}) {
    return Column(
      children: [
        Text(
          icon,
          style: const TextStyle(fontSize: 24),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildFiltersBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.black.withOpacity(0.3),
      child: Column(
        children: [
          // Filtres par catégorie
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('Tous', 'all'),
                _buildFilterChip('Découverts', 'discovered'),
                _buildFilterChip('Non découverts', 'undiscovered'),
                const SizedBox(width: 16),
                _buildFilterChip('Génériques', 'generic'),
                _buildFilterChip('Aethelgard', 'aethelgard'),
                _buildFilterChip('Sylla', 'sylla'),
                _buildFilterChip('Ferro', 'ferro'),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Tri
          Row(
            children: [
              const Icon(Icons.sort, color: Colors.white70, size: 20),
              const SizedBox(width: 8),
              Text(
                'Trier par:',
                style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
              ),
              const SizedBox(width: 8),
              _buildSortButton('Nom', 'name'),
              _buildSortButton('Rencontres', 'encounters'),
              _buildSortButton('Victoires', 'winRate'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _selectedFilter == value;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedFilter = value;
          });
        },
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.grey.shade300,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        backgroundColor: Colors.grey.shade800,
        selectedColor: Colors.purple.shade700,
        checkmarkColor: Colors.white,
      ),
    );
  }

  Widget _buildSortButton(String label, String value) {
    final isSelected = _sortBy == value;
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: OutlinedButton(
        onPressed: () {
          setState(() {
            _sortBy = value;
          });
        },
        style: OutlinedButton.styleFrom(
          backgroundColor: isSelected ? Colors.purple.shade700 : Colors.transparent,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 11),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 80,
            color: Colors.grey.shade600,
          ),
          const SizedBox(height: 16),
          Text(
            'Aucun ennemi trouvé',
            style: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Explorez le monde pour découvrir des ennemis !',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBestiaryGrid(List<String> enemyIds) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: enemyIds.length,
      itemBuilder: (context, index) {
        final enemyId = enemyIds[index];
        final enemy = EnemyDatabase.createEnemy(enemyId);
        final entry = _player!.bestiary[enemyId];
        final isDiscovered = entry?.discovered ?? false;

        return _buildEnemyCard(enemy, entry, isDiscovered);
      },
    );
  }

  Widget _buildEnemyCard(Character enemy, BestiaryEntry? entry, bool isDiscovered) {
    return GestureDetector(
      onTap: isDiscovered
          ? () => _showEnemyDetails(enemy, entry!)
          : null,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDiscovered
                ? [
                    Color(enemy.appearance.colorValue).withOpacity(0.3),
                    Color(enemy.appearance.colorValue).withOpacity(0.1),
                  ]
                : [
                    Colors.grey.shade900,
                    Colors.grey.shade800,
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDiscovered
                ? Color(enemy.appearance.colorValue).withOpacity(0.5)
                : Colors.grey.shade700,
            width: 2,
          ),
          boxShadow: isDiscovered
              ? [
                  BoxShadow(
                    color: Color(enemy.appearance.colorValue).withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ]
              : [],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Sprite ou point d'interrogation
            if (isDiscovered)
              IconDisplay(
                icon: enemy.appearance.headshot,
                size: 80,
              )
            else
              Icon(
                Icons.help_outline,
                size: 80,
                color: Colors.grey.shade600,
              ),
            const SizedBox(height: 12),
            
            // Nom
            Text(
              isDiscovered ? enemy.name : '???',
              style: TextStyle(
                color: isDiscovered ? Colors.white : Colors.grey.shade500,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            
            // Stats
            if (isDiscovered && entry != null) ...[
              Text(
                'Niveau ${enemy.level}',
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildMiniStat('👁️', '${entry.encounterCount}'),
                  _buildMiniStat('⚔️', '${entry.defeatedCount}'),
                  _buildMiniStat('📊', '${entry.winRate.toStringAsFixed(0)}%'),
                ],
              ),
            ] else if (!isDiscovered)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Non découvert',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 11,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniStat(String icon, String value) {
    return Column(
      children: [
        Text(icon, style: const TextStyle(fontSize: 14)),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  void _showEnemyDetails(Character enemy, BestiaryEntry entry) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(enemy.appearance.colorValue).withOpacity(0.2),
              Colors.grey.shade900,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            // Handle
            Container(
              margin: const EdgeInsets.only(top: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade600,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header avec sprite
                    Center(
                      child: Column(
                        children: [
                          IconDisplay(
                            icon: enemy.appearance.fullsize ?? enemy.appearance.headshot,
                            size: 120,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            enemy.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            enemy.appearance.description,
                            style: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    const Divider(color: Colors.white30),
                    const SizedBox(height: 16),
                    
                    // Stats de rencontre
                    _buildDetailSection(
                      '📊 Statistiques de Rencontre',
                      [
                        _buildDetailRow('Rencontres totales', '${entry.encounterCount}'),
                        _buildDetailRow('Victoires', '${entry.defeatedCount}'),
                        _buildDetailRow('Taux de victoire', '${entry.winRate.toStringAsFixed(1)}%'),
                        _buildDetailRow('Première rencontre', entry.firstEncounter != null
                            ? '${entry.firstEncounter!.day}/${entry.firstEncounter!.month}/${entry.firstEncounter!.year}'
                            : 'N/A'),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Stats de combat
                    _buildDetailSection(
                      '⚔️ Statistiques de Combat',
                      [
                        _buildDetailRow('HP', '${enemy.stats.maxHp}'),
                        _buildDetailRow('Attaque', '${enemy.totalAttack}'),
                        _buildDetailRow('Défense', '${enemy.totalDefense}'),
                        _buildDetailRow('Magie', '${enemy.totalMagic}'),
                        _buildDetailRow('Vitesse', '${enemy.totalSpeed}'),
                        _buildDetailRow('Portée', '${enemy.stats.range}'),
                        _buildDetailRow('Mouvement', '${enemy.stats.movement}'),
                      ],
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

  Widget _buildDetailSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
