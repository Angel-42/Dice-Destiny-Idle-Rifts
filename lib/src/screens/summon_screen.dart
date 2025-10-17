import 'package:flutter/material.dart';
import 'dart:math';
import '../services/game_data_service.dart';
import '../models/character.dart';
import '../models/preset_character.dart';
import '../data/character_database.dart';

class SummonScreen extends StatefulWidget {
  const SummonScreen({super.key});

  @override
  State<SummonScreen> createState() => _SummonScreenState();
}

class _SummonScreenState extends State<SummonScreen> {
  bool _isSummoning = false;

  /// Helper pour afficher soit un emoji, soit une image sprite
  Widget _buildCharacterSprite(String sprite, double size) {
    // Nettoyer le chemin d'abord si nécessaire
    final cleanSprite = sprite.startsWith('~/') ? sprite.substring(2) : sprite;
    
    // Si le sprite contient une extension d'image, c'est un chemin d'asset
    if (cleanSprite.contains('.png') || cleanSprite.contains('.jpg') || cleanSprite.contains('.jpeg')) {
      return Image.asset(
        cleanSprite,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          // Si l'image ne charge pas, afficher un emoji par défaut
          return Text(
            '❓',
            style: TextStyle(fontSize: size * 0.8),
          );
        },
      );
    } else {
      // C'est un emoji
      return Text(
        sprite,
        style: TextStyle(fontSize: size * 0.8),
      );
    }
  }

  Future<void> _performSummon() async {
    if (_isSummoning) return;

    setState(() {
      _isSummoning = true;
    });

    try {
      // 🎲 Système de gacha avec vraies chances
      final random = Random();
      final roll = random.nextDouble(); // 0.0 - 1.0

      PresetCharacter? preset;

      if (roll <= 0.03) {
        // 3% Légendaire
        final legendaries = CharacterDatabase.getByRarity(CharacterRarity.legendary);
        preset = legendaries[random.nextInt(legendaries.length)];
      } else if (roll <= 0.15) {
        // 12% Épique (3% + 12% = 15%)
        final epics = CharacterDatabase.getByRarity(CharacterRarity.epic);
        preset = epics[random.nextInt(epics.length)];
      } else if (roll <= 0.40) {
        // 25% Rare (15% + 25% = 40%)
        final rares = CharacterDatabase.getByRarity(CharacterRarity.rare);
        preset = rares[random.nextInt(rares.length)];
      } else {
        // 60% Commun (le reste)
        final commons = CharacterDatabase.getByRarity(CharacterRarity.common);
        preset = commons[random.nextInt(commons.length)];
      }

      // Créer le personnage à partir du preset
      final character = preset.toCharacter();

      // Vérifier la taille de l'équipe actuelle
      final team = await GameDataService.getTeamCharacters();
      final isTeamFull = team.length >= 4;

      // Configurer l'équipe
      character.isInTeam = !isTeamFull;
      character.teamPosition = isTeamFull ? 999 : team.length;

      // Sauvegarder dans Firestore
      await GameDataService.createCharacter(character);

      if (mounted) {
        setState(() {
          _isSummoning = false;
        });

        // Animation de succès avec rareté
        _showSummonSuccessDialog(character, preset, isTeamFull);
      }
    } catch (e) {
      debugPrint('❌ Erreur summon: $e');
      if (mounted) {
        setState(() {
          _isSummoning = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de l\'invocation : $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showSummonSuccessDialog(Character character, PresetCharacter preset, bool isTeamFull) {
    // Obtenir la couleur basée sur la rareté
    Color rarityColor;
    String rarityText;
    String rarityStars;
    
    switch (preset.rarity) {
      case CharacterRarity.legendary:
        rarityColor = Colors.amber;
        rarityText = 'LÉGENDAIRE';
        rarityStars = '⭐⭐⭐⭐⭐';
        break;
      case CharacterRarity.epic:
        rarityColor = Colors.purple;
        rarityText = 'ÉPIQUE';
        rarityStars = '⭐⭐⭐⭐';
        break;
      case CharacterRarity.rare:
        rarityColor = Colors.blue;
        rarityText = 'RARE';
        rarityStars = '⭐⭐⭐';
        break;
      case CharacterRarity.common:
        rarityColor = Colors.grey;
        rarityText = 'COMMUN';
        rarityStars = '⭐⭐';
        break;
    }
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  rarityColor.withOpacity(0.3),
                  Colors.black,
                  Colors.black,
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: rarityColor, width: 3),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Badge de rareté
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                    color: rarityColor.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: rarityColor, width: 2),
                  ),
                  child: Column(
                    children: [
                      Text(
                        rarityStars,
                        style: TextStyle(
                          fontSize: 20,
                          color: rarityColor,
                        ),
                      ),
                      Text(
                        rarityText,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: rarityColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                
                // Sprite du personnage (utiliser lheadshot si disponible, sinon headshot)
                _buildCharacterSprite(preset.lheadshot ?? preset.headshot, 72),
                const SizedBox(height: 16),
                
                // Nom
                Text(
                  character.name,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: rarityColor,
                    shadows: [
                      Shadow(
                        color: rarityColor.withOpacity(0.5),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                
                // Titre
                Text(
                  preset.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                
                // Classe et race
                Text(
                  '${character.persona.race.name} ${character.persona.characterClass.name}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Description
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: rarityColor.withOpacity(0.3), width: 1),
                  ),
                  child: Text(
                    preset.description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Voice line
                if (preset.voiceLines.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: rarityColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: rarityColor.withOpacity(0.5), width: 2),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.format_quote, color: rarityColor, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            preset.voiceLines.first,
                            style: TextStyle(
                              fontSize: 13,
                              fontStyle: FontStyle.italic,
                              color: rarityColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Icon(Icons.format_quote, color: rarityColor, size: 20),
                      ],
                    ),
                  ),
                const SizedBox(height: 16),
                
                // Stats
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildStatDisplay('HP', character.stats.maxHp.toString()),
                      const SizedBox(width: 16),
                      _buildStatDisplay(character.offensiveStatName, character.totalOffensive.toString()),
                      const SizedBox(width: 16),
                      _buildStatDisplay('DEF', character.stats.defense.toString()),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                
                // Badge "Ajouté à l'équipe"
                if (!isTeamFull)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green, width: 2),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle, color: Colors.green, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Ajouté à l\'équipe!',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 24),
                
                // Bouton OK
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: rarityColor,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  ),
                  child: const Text(
                    'OK',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatDisplay(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.7),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF1A237E),
              Color(0xFF311B92),
              Color(0xFF4A148C),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Portal magique
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Colors.purpleAccent.withOpacity(0.8),
                        Colors.purple.withOpacity(0.3),
                        Colors.transparent,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.purpleAccent.withOpacity(0.5),
                        blurRadius: 50,
                        spreadRadius: 20,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.auto_awesome,
                      size: 100,
                      color: Colors.amber,
                    ),
                  ),
                ),
                const SizedBox(height: 48),
                const Text(
                  'Hero Summoning',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 48),
                // Bouton Summon
                ElevatedButton(
                  onPressed: _isSummoning ? null : _performSummon,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 20),
                  ),
                  child: _isSummoning
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Summon Hero',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}