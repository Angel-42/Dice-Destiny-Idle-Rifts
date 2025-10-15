import 'package:flutter/material.dart';
import '../models/character.dart';
import '../services/game_data_service.dart';
import 'character_detail_screen.dart';

class CharactersScreen extends StatelessWidget {
  const CharactersScreen({super.key});

  void _showCharacterDetail(BuildContext context, Character character) {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (context) => CharacterDetailScreen(character: character),
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
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(
                      Icons.people,
                      color: Colors.amber,
                      size: 32,
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'MES PERSONNAGES',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(
                color: Colors.amber,
                thickness: 2,
                height: 2,
              ),

              // Liste des personnages (StreamBuilder pour temps réel)
              Expanded(
                child: StreamBuilder<List<Character>>(
                  stream: GameDataService.watchCharacters(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.amber),
                      );
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              '❌',
                              style: TextStyle(fontSize: 80),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'Erreur: ${snapshot.error}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white.withOpacity(0.7),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    }

                    final characters = snapshot.data ?? [];

                    if (characters.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              '📭',
                              style: TextStyle(fontSize: 80),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'Aucun personnage\nAllez dans Summon pour en invoquer !',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white.withOpacity(0.7),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    }

                    return Column(
                      children: [
                        // Compteur de personnages
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black45,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.amber),
                            ),
                            child: Text(
                              '${characters.length} personnage(s)',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GridView.builder(
                            padding: const EdgeInsets.all(16),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 0.75,
                            ),
                            itemCount: characters.length,
                            itemBuilder: (context, index) {
                              final character = characters[index];
                              return _buildCharacterCard(context, character);
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCharacterCard(BuildContext context, Character character) {
    return GestureDetector(
      onTap: () => _showCharacterDetail(context, character),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(character.appearance.colorValue).withOpacity(0.3),
              Color(character.appearance.colorValue).withOpacity(0.1),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Color(character.appearance.colorValue),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Color(character.appearance.colorValue).withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          children: [
            // Badge d'équipe
            if (character.isInTeam)
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '⭐ Team #${character.teamPosition}',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),

            const Spacer(),

            // Emoji portrait
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(character.appearance.colorValue),
                border: Border.all(color: Colors.white, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  character.appearance.emoji,
                  style: const TextStyle(fontSize: 40),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Nom
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                character.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 4),

            // Classe
            Text(
              character.persona.characterClass.displayName,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withOpacity(0.7),
              ),
            ),

            const SizedBox(height: 8),

            // Stats de base
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(14),
                  bottomRight: Radius.circular(14),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildQuickStat('LV', character.level.toString()),
                  _buildQuickStat('⚔️', character.totalAttack.toString()),
                  _buildQuickStat('🛡️', character.totalDefense.toString()),
                  _buildQuickStat('⚡', character.totalSpeed.toString()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStat(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.white.withOpacity(0.6),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}