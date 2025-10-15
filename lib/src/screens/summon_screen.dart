import 'package:flutter/material.dart';
import 'dart:math';
import '../services/game_data_service.dart';
import '../models/character.dart';
import '../models/persona.dart';

class SummonScreen extends StatefulWidget {
  const SummonScreen({super.key});

  @override
  State<SummonScreen> createState() => _SummonScreenState();
}

class _SummonScreenState extends State<SummonScreen> {
  bool _isSummoning = false;
  Character? _lastSummonedCharacter;

  // Générateur de noms aléatoires
  final List<String> _namePool = [
    'Aric', 'Bran', 'Cedric', 'Darius', 'Erin', 'Fiona', 'Garen', 'Helena',
    'Ivan', 'Jade', 'Kael', 'Luna', 'Marcus', 'Nina', 'Owen', 'Petra',
    'Quinn', 'Raven', 'Soren', 'Talia', 'Ulric', 'Vera', 'Wade', 'Xara',
    'Yara', 'Zane', 'Aria', 'Brom', 'Celia', 'Drake', 'Elara', 'Finn',
  ];

  Future<void> _performSummon() async {
    if (_isSummoning) return;

    setState(() {
      _isSummoning = true;
      _lastSummonedCharacter = null;
    });

    try {
      // Générer un personnage aléatoire
      final random = Random();
      final name = _namePool[random.nextInt(_namePool.length)];
      
      final races = PersonaRace.values;
      final race = races[random.nextInt(races.length)];
      
      final classes = PersonaClass.values;
      final characterClass = classes[random.nextInt(classes.length)];
      
      final regions = PersonaRegion.values;
      final region = regions[random.nextInt(regions.length)];
      
      final origins = PersonaOrigin.values;
      final origin = origins[random.nextInt(origins.length)];

      // Créer le persona
      final persona = Persona(
        race: race,
        characterClass: characterClass,
        region: region,
        origin: origin,
      );

      // Générer des stats de base (entre 10 et 15)
      final baseStats = CharacterStats(
        maxHp: 80 + random.nextInt(41), // 80-120
        attack: 10 + random.nextInt(6),  // 10-15
        defense: 10 + random.nextInt(6), // 10-15
        magic: 10 + random.nextInt(6),   // 10-15
        speed: 10 + random.nextInt(6),   // 10-15
        luck: 10 + random.nextInt(6),    // 10-15
        range: 1,                         // Mêlée par défaut
      );

      // Apparence aléatoire
      final appearance = CharacterAppearance.fromRace(race);

      // Vérifier la taille de l'équipe actuelle
      final team = await GameDataService.getTeamCharacters();
      final isTeamFull = team.length >= 4;

      // Créer le personnage avec l'équipe configurée
      final character = Character(
        name: name,
        persona: persona,
        stats: baseStats,
        appearance: appearance,
        level: 1,
        xp: 0,
        isInTeam: !isTeamFull,
        teamPosition: isTeamFull ? 999 : team.length, // Position à la fin de la team
      );

      // Sauvegarder dans Firestore
      await GameDataService.createCharacter(character);

      if (mounted) {
        setState(() {
          _lastSummonedCharacter = character;
          _isSummoning = false;
        });

        // Animation de succès
        _showSummonSuccessDialog(character, isTeamFull);
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

  void _showSummonSuccessDialog(Character character, bool isTeamFull) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.purple.shade900,
                Colors.purple.shade700,
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.amber, width: 3),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.auto_awesome,
                color: Colors.amber,
                size: 64,
              ),
              const SizedBox(height: 16),
              const Text(
                'HERO SUMMONED!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                character.name,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${character.persona.race.name} ${character.persona.characterClass.name}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
              const SizedBox(height: 16),
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
                    _buildStatDisplay('ATK', character.stats.attack.toString()),
                    const SizedBox(width: 16),
                    _buildStatDisplay('DEF', character.stats.defense.toString()),
                  ],
                ),
              ),
              const SizedBox(height: 16),
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
                        'Added to Team!',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
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