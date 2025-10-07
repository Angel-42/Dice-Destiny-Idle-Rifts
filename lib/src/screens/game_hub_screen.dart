import 'package:flutter/material.dart';
import 'dart:async';
import '../models/character.dart';
import '../models/player.dart';
import '../services/game_data_service.dart';
import 'settings_screen.dart';
import 'tactical_battle_screen.dart';
import 'character_detail_screen.dart';

class GameHubScreen extends StatefulWidget {
  final Player player;
  final Character character;

  const GameHubScreen({
    super.key,
    required this.player,
    required this.character,
  });

  @override
  State<GameHubScreen> createState() => _GameHubScreenState();
}

class _GameHubScreenState extends State<GameHubScreen> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late Player _player;
  int _idleProgress = 0;
  Timer? _idleTimer;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _player = widget.player; // Initialiser avec le player passé en paramètre
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _startIdleProgress();
  }

  void _startIdleProgress() {
    _idleTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _idleProgress = (_idleProgress + 1) % 100;
          if (_idleProgress == 0) {
            // Ajouter de l'or au joueur (compte pour les missions)
            final goldEarned = 10;
            _player.addGold(goldEarned);
            _player.addGoldCollected(goldEarned);
            // Sauvegarder automatiquement en arrière-plan
            _savePlayer();
          }
        });
      }
    });
  }
  
  // Méthode helper pour sauvegarder le player
  void _savePlayer() {
    GameDataService.savePlayer(_player).catchError((e) {
      debugPrint('⚠️ Erreur sauvegarde auto: $e');
    });
  }

  @override
  void dispose() {
    _idleTimer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0F1419), Color(0xFF1A1F2E), Color(0xFF0F1419)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildTopBar(),
              Expanded(child: _buildCurrentPage()),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF16213E).withOpacity(0.9),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: Color(widget.character.appearance.colorValue).withOpacity(0.3),
              shape: BoxShape.circle,
              border: Border.all(
                color: Color(widget.character.appearance.colorValue),
                width: 2,
              ),
            ),
            child: Center(
              child: Text(
                widget.character.appearance.emoji,
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.character.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Niv. ${widget.character.stats.maxHp ~/ 10}',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          // Ressources
          _buildResource('��', _player.gems.toString(), Colors.purple),
          const SizedBox(width: 12),
          _buildResource('💰', _player.gold.toString(), Colors.amber),
        ],
      ),
    );
  }

  Widget _buildResource(String icon, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(icon, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 6),
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

  Widget _buildCurrentPage() {
    switch (_selectedIndex) {
      case 0:
        return _buildIdleAdventurePage();
      case 1:
        return _buildHeroesPage();
      case 2:
        return _buildGachaPage();
      case 3:
        return SettingsScreen(character: widget.character);
      default:
        return _buildIdleAdventurePage();
    }
  }

  Widget _buildIdleAdventurePage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Progression Idle
          _buildIdleProgressCard(),
          const SizedBox(height: 16),
          
          // Hero principal
          _buildMainHeroCard(),
          const SizedBox(height: 16),
          
          // Missions quotidiennes
          _buildDailyMissions(),
          const SizedBox(height: 16),
          
          // Modes de jeu
          _buildGameModes(),
        ],
      ),
    );
  }

  Widget _buildIdleProgressCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.purple.withOpacity(0.3),
            Colors.blue.withOpacity(0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.purple.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                '⚡ Progression Automatique',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  return Icon(
                    Icons.auto_awesome,
                    color: Colors.amber.withOpacity(0.5 + _pulseController.value * 0.5),
                    size: 24,
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: _idleProgress / 100,
              backgroundColor: Colors.white.withOpacity(0.1),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
              minHeight: 12,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Récompense dans ${100 - _idleProgress}s',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 12,
                ),
              ),
              const Text(
                '+10 💰',
                style: TextStyle(
                  color: Colors.amber,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMainHeroCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(widget.character.appearance.colorValue).withOpacity(0.3),
            Color(widget.character.appearance.colorValue).withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Color(widget.character.appearance.colorValue).withOpacity(0.6),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Avatar principal
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(widget.character.appearance.colorValue).withOpacity(0.5),
                      Color(widget.character.appearance.colorValue).withOpacity(0.2),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Color(widget.character.appearance.colorValue),
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    widget.character.appearance.emoji,
                    style: const TextStyle(fontSize: 48),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.character.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.character.persona.characterClass.displayName,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Barre HP
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: widget.character.hpPercentage,
                        backgroundColor: Colors.white.withOpacity(0.1),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          widget.character.hpPercentage > 0.5
                              ? Colors.green
                              : Colors.orange,
                        ),
                        minHeight: 8,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'HP: ${widget.character.currentHp}/${widget.character.stats.maxHp}',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Stats en grille
          Row(
            children: [
              Expanded(
                child: _buildMiniStat('⚔️', widget.character.stats.attack),
              ),
              Expanded(
                child: _buildMiniStat('🛡️', widget.character.stats.defense),
              ),
              Expanded(
                child: _buildMiniStat('⚡', widget.character.stats.speed),
              ),
              Expanded(
                child: _buildMiniStat('✨', widget.character.stats.magic),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStat(String icon, int value) {
    return Column(
      children: [
        Text(icon, style: const TextStyle(fontSize: 20)),
        const SizedBox(height: 4),
        Text(
          '$value',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildDailyMissions() {
    // Vérifier et reset les missions si nécessaire
    _player.checkAndResetDailyMissions();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '📋 Missions Quotidiennes',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        _buildMissionTile(
          'Vaincre 10 ennemis', 
          _player.dailyEnemiesDefeated, 
          10, 
          Colors.red,
          onClaim: _player.dailyEnemiesDefeated >= 10 ? () {
            setState(() {
              _player.addGems(10);
              _savePlayer();
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('🎉 +10 💎 reçu !')),
            );
          } : null,
        ),
        const SizedBox(height: 8),
        _buildMissionTile(
          'Collecter 500 or', 
          _player.dailyGoldCollected, 
          500, 
          Colors.amber,
          onClaim: _player.dailyGoldCollected >= 500 ? () {
            setState(() {
              _player.addGems(15);
              _savePlayer();
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('🎉 +15 💎 reçu !')),
            );
          } : null,
        ),
        const SizedBox(height: 8),
        _buildMissionTile(
          'Terminer 5 aventures', 
          _player.dailyAdventuresCompleted, 
          5, 
          Colors.blue,
          onClaim: _player.dailyAdventuresCompleted >= 5 ? () {
            setState(() {
              _player.addGems(20);
              _savePlayer();
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('🎉 +20 💎 reçu !')),
            );
          } : null,
        ),
      ],
    );
  }

  Widget _buildMissionTile(
    String title, 
    int current, 
    int total, 
    Color color,
    {VoidCallback? onClaim}
  ) {
    final progress = (current / total).clamp(0.0, 1.0);
    final isCompleted = current >= total;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isCompleted 
            ? color.withOpacity(0.15) 
            : Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCompleted 
              ? color.withOpacity(0.5) 
              : Colors.white.withOpacity(0.1),
          width: isCompleted ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (isCompleted)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Icon(Icons.check_circle, color: color, size: 20),
                ),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
              Text(
                '$current/$total',
                style: TextStyle(
                  color: color,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (isCompleted && onClaim != null) ...[
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: onClaim,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    minimumSize: Size.zero,
                  ),
                  child: const Text(
                    'Claim',
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameModes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '🎮 Modes de Jeu',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildModeCard(
                '⚔️',
                'Aventure',
                'Histoire principale',
                Colors.purple,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildModeCard(
                '🏆',
                'Arène',
                'PvP classé',
                Colors.red,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildModeCard(
                '🌀',
                'Rifts',
                'Donjons',
                Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildModeCard(
                '👥',
                'Raid',
                'Coopération',
                Colors.green,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildModeCard(String icon, String title, String subtitle, Color color) {
    return GestureDetector(
      onTap: () {
        if (title == 'Aventure') {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => TacticalBattleScreen(
                character: widget.character,
                player: _player,
              ),
            ),
          ).then((_) {
            // Rafraîchir l'état quand on revient du combat
            setState(() {
              _savePlayer();
            });
          });
        } else {
          _showComingSoon(title);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color.withOpacity(0.3),
              color.withOpacity(0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.5)),
        ),
        child: Column(
          children: [
            Text(icon, style: const TextStyle(fontSize: 32)),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroesPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '👥 Mes Héros',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          // Carte compacte du héros principal
          _buildCompactHeroCard(widget.character, isPrimary: true),
          
          const SizedBox(height: 20),
          const Text(
            'Héros Supplémentaires',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          
          // Grille de héros verrouillés (3 colonnes)
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.75,
            ),
            itemCount: 9,
            itemBuilder: (context, index) => _buildLockedHeroCard(),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactHeroCard(Character character, {bool isPrimary = false}) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CharacterDetailScreen(character: character),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(character.appearance.colorValue).withOpacity(0.3),
              Color(character.appearance.colorValue).withOpacity(0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isPrimary 
                ? Colors.cyan 
                : Color(character.appearance.colorValue).withOpacity(0.5),
            width: isPrimary ? 3 : 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Color(character.appearance.colorValue).withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            // Avatar circulaire
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Color(character.appearance.colorValue).withOpacity(0.2),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Color(character.appearance.colorValue),
                  width: 3,
                ),
              ),
              child: Center(
                child: Text(
                  character.appearance.emoji,
                  style: const TextStyle(fontSize: 40),
                ),
              ),
            ),
            const SizedBox(width: 16),
            
            // Infos du héros
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badge primaire
                  if (isPrimary)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.cyan.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.cyan, width: 1),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.star, color: Colors.cyan, size: 12),
                          SizedBox(width: 4),
                          Text(
                            'Principal',
                            style: TextStyle(
                              color: Colors.cyan,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (isPrimary) const SizedBox(height: 8),
                  
                  // Nom
                  Text(
                    character.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  
                  // Niveau
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        'Niv. ${character.level}',
                        style: const TextStyle(
                          color: Colors.amber,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  
                  // Classe avec emoji
                  Row(
                    children: [
                      Text(
                        character.persona.characterClass.emoji,
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          character.persona.characterClass.displayName,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  
                  // Barre de vie mini
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: character.hpPercentage,
                      backgroundColor: Colors.white.withOpacity(0.2),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        character.hpPercentage > 0.5 ? Colors.green : Colors.orange,
                      ),
                      minHeight: 6,
                    ),
                  ),
                ],
              ),
            ),
            
            // Flèche pour voir plus
            Icon(
              Icons.chevron_right,
              color: Colors.white.withOpacity(0.5),
              size: 32,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLockedHeroCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 2,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.lock_outline,
            color: Colors.white.withOpacity(0.3),
            size: 40,
          ),
          const SizedBox(height: 8),
          Text(
            'Verrouillé',
            style: TextStyle(
              color: Colors.white.withOpacity(0.4),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGachaPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            '🎰 Invocation de Héros',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          _buildGachaBanner(
            'Invocation Standard',
            '1 héros garanti',
            '100 💰',
            Colors.blue,
            () => _showComingSoon('Gacha Standard'),
          ),
          const SizedBox(height: 16),
          _buildGachaBanner(
            'Invocation Premium',
            'Héros rares augmentés',
            '1 💎',
            Colors.purple,
            () => _showComingSoon('Gacha Premium'),
          ),
        ],
      ),
    );
  }

  Widget _buildGachaBanner(
    String title,
    String subtitle,
    String cost,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color.withOpacity(0.4),
              color.withOpacity(0.2),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.6), width: 2),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.5),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                cost,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF16213E),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.castle, 'Aventure'),
              _buildNavItem(1, Icons.groups, 'Héros'),
              _buildNavItem(2, Icons.casino, 'Gacha'),
              _buildNavItem(3, Icons.settings, 'Options'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.cyan.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.cyan : Colors.white54,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.cyan : Colors.white54,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature - En cours de développement'),
        backgroundColor: Colors.cyan,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
