import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../models/character.dart';
import '../services/game_data_service.dart';
import '../widgets/character_compact_view.dart';
import 'character_full_detail_screen.dart';

class CharactersScreen extends StatefulWidget {
  const CharactersScreen({super.key});

  @override
  State<CharactersScreen> createState() => _CharactersScreenState();
}

class _CharactersScreenState extends State<CharactersScreen> {
  Character? _selectedCharacter;

  @override
  void initState() {
    super.initState();
    GameDataService.watchCharacters().first.then((characters) {
      if (characters.isNotEmpty && mounted) {
        setState(() {
          _selectedCharacter = characters.first;
        });
      }
    });
  }
  Character? _selectedCharacterForSwap;
  bool _selectedFromTeam = false;

  void _showFullsizeImage(String? fullsizeSprite) {
    if (fullsizeSprite == null || _selectedCharacter == null) return;
    
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CharacterFullDetailScreen(character: _selectedCharacter!),
      ),
    );
  }

  void _selectCharacter(Character character) {
    setState(() {
      _selectedCharacter = character;
    });
  }

  Widget _buildCharacterSprite(String sprite, double size) {
    final cleanSprite = sprite.startsWith('~/') ? sprite.substring(2) : sprite;
    
    if (cleanSprite.contains('.png') || cleanSprite.contains('.jpg') || cleanSprite.contains('.jpeg')) {
      return Image.asset(
        cleanSprite,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Center(
            child: Text(
              '❓',
              style: TextStyle(fontSize: size * 0.8),
            ),
          );
        },
      );
    } else {
      return Center(
        child: Text(
          sprite,
          style: TextStyle(fontSize: size * 0.8),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0A0E27),
              Color(0xFF1A1A2E),
              Color(0xFF16213E),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: StreamBuilder<List<Character>>(
            stream: GameDataService.watchCharacters(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.amber),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Erreur: ${snapshot.error}',
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              }

              final allCharacters = snapshot.data ?? [];
              final teamCharacters = allCharacters
                  .where((c) => c.isInTeam)
                  .toList()
                ..sort((a, b) => a.teamPosition.compareTo(b.teamPosition));

              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (Widget child, Animation<double> animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0, -0.1),
                              end: Offset.zero,
                            ).animate(CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeOutCubic,
                            )),
                            child: child,
                          ),
                        );
                      },
                      child: _buildSelectedCharacterDetail(_selectedCharacter!),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: _buildEditTeamSection(context, teamCharacters),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverGrid(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 0.8,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final character = allCharacters[index];
                          return _buildCharacterIcon(context, character, teamCharacters, allCharacters);
                        },
                        childCount: allCharacters.length,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _handleCharacterSelection(
    Character character, 
    List<Character> teamCharacters,
    {required bool fromTeamSlot}
  ) async {
    _selectCharacter(character);
    
    if (_selectedCharacterForSwap == null) {
      setState(() {
        _selectedCharacterForSwap = character;
        _selectedFromTeam = fromTeamSlot;
      });
      return;
    }

    if (_selectedCharacterForSwap!.id == character.id) {
      setState(() {
        _selectedCharacterForSwap = null;
        _selectedFromTeam = false;
      });
      return;
    }

    // CAS 1: Les deux clics viennent de EDIT TEAM → échanger les positions
    if (_selectedFromTeam && fromTeamSlot) {
      setState(() {
        _selectedCharacterForSwap = character;
        _selectedFromTeam = fromTeamSlot;
      });
      return;
    }

    if (!_selectedFromTeam && !fromTeamSlot) {
      setState(() {
        _selectedCharacterForSwap = character;
        _selectedFromTeam = fromTeamSlot;
      });
      return;
    }

    if (_selectedCharacterForSwap!.isInTeam && character.isInTeam) {
      await _swapTeamPositions(_selectedCharacterForSwap!, character);
      setState(() {
        _selectedCharacterForSwap = null;
        _selectedFromTeam = false;
      });
      return;
    }

    await _swapCharacters(_selectedCharacterForSwap!, character, teamCharacters);
    
    setState(() {
      _selectedCharacterForSwap = null;
      _selectedFromTeam = false;
    });
  }

  /// Échange les positions de deux héros dans la team
  Future<void> _swapTeamPositions(Character char1, Character char2) async {
    try {
      final pos1 = char1.teamPosition;
      final pos2 = char2.teamPosition;
      
      final updatedChar1 = _createUpdatedCharacter(
        char1,
        isInTeam: true,
        teamPosition: pos2,
      );
      
      final updatedChar2 = _createUpdatedCharacter(
        char2,
        isInTeam: true,
        teamPosition: pos1,
      );

  await GameDataService.saveCharactersBatch([updatedChar1, updatedChar2]);

      if (mounted) {
        // Message supprimé - pas besoin d'afficher de notification
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Échange deux personnages (team ↔ all uniquement)
  Future<void> _swapCharacters(
    Character char1,
    Character char2,
    List<Character> teamCharacters,
  ) async {
    try {
      
      Character charInTeam;
      Character charOutTeam;
      
      if (char1.isInTeam) {
        charInTeam = char1;
        charOutTeam = char2;
      } else {
        charInTeam = char2;
        charOutTeam = char1;
      }
      
      final position = charInTeam.teamPosition;
      
      final updatedCharInTeam = _createUpdatedCharacter(
        charInTeam,
        isInTeam: false,
        teamPosition: 999,
      );
      
      final updatedCharOutTeam = _createUpdatedCharacter(
        charOutTeam,
        isInTeam: true,
        teamPosition: position,
      );

      // Sauvegarder les deux atomiquement
      await GameDataService.saveCharactersBatch([updatedCharInTeam, updatedCharOutTeam]);

      // Message supprimé - pas besoin d'afficher de notification
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Helper pour créer un personnage mis à jour avec nouvelles valeurs team
  Character _createUpdatedCharacter(
    Character character, {
    required bool isInTeam,
    required int teamPosition,
  }) {
    final updated = Character(
      id: character.id,
      name: character.name,
      persona: character.persona,
      stats: character.stats,
      appearance: character.appearance,
      level: character.level,
      xp: character.xp,
      x: character.x,
      y: character.y,
      weapon: character.weapon,
      armorOrAccessory: character.armorOrAccessory,
      equippedSkills: character.equippedSkills,
      weaponMasteries: character.weaponMasteries,
      basedRarity: character.basedRarity,
      currentRarity: character.currentRarity,
      isInTeam: isInTeam,
      teamPosition: teamPosition,
      obtainedAt: character.obtainedAt,
    );
    updated.currentHp = character.currentHp;
    return updated;
  }

  Widget _buildSelectedCharacterDetail(Character character) {
    return CharacterCompactView(
      character: character,
      onImageTap: () => _showFullsizeImage(character.appearance.fullsize),
    );
  }



  Widget _buildEditTeamSection(BuildContext context, List<Character> teamCharacters) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.groups, color: Colors.amber, size: 24),
              const SizedBox(width: 8),
              Text(
                S.of(context)!.editTeam,
                style: const TextStyle(
                  color: Colors.amber,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.amber),
                ),
                child: Text(
                  '${teamCharacters.length}/4',
                  style: const TextStyle(
                    color: Colors.amber,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF1E2A47),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.amber.withOpacity(0.3), width: 2),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(4, (index) {
                if (index < teamCharacters.length) {
                  final character = teamCharacters[index];
                  return _buildTeamSlot(context, character, index + 1, teamCharacters);
                } else {
                  return _buildEmptyTeamSlot(index + 1, teamCharacters);
                }
              }),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              const Icon(Icons.list, color: Colors.amber, size: 24),
              const SizedBox(width: 8),
              Text(
                S.of(context)!.allHeroes,
                style: const TextStyle(
                  color: Colors.amber,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildTeamSlot(BuildContext context, Character character, int position, List<Character> teamCharacters) {
    // Couleur de fond selon la rareté
    Color rarityColor;
    Color rarityDarkColor;
    
    switch (character.currentRarity) {
      case CharacterRarity.legendary:
        rarityColor = const Color(0xFFFFD700); // Or
        rarityDarkColor = const Color(0xFFB8860B);
        break;
      case CharacterRarity.epic:
        rarityColor = const Color(0xFFA020F0); // Violet
        rarityDarkColor = const Color(0xFF6A0DAD);
        break;
      case CharacterRarity.rare:
        rarityColor = const Color(0xFF4169E1); // Bleu royal
        rarityDarkColor = const Color(0xFF1E3A8A);
        break;
      case CharacterRarity.common:
        rarityColor = const Color(0xFF9CA3AF); // Gris
        rarityDarkColor = const Color(0xFF4B5563);
        break;
    }

    final bool isSelected = _selectedCharacterForSwap?.id == character.id && _selectedFromTeam;

    return GestureDetector(
      onTap: () => _handleCharacterSelection(character, teamCharacters, fromTeamSlot: true),
      onLongPress: () => _showFullsizeImage(character.appearance.fullsize),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        width: 70,
        height: 90,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.amber, 
            width: isSelected ? 4 : 3,
          ),
          boxShadow: [
            if (isSelected)
              const BoxShadow(
                color: Colors.blue,
                blurRadius: 15,
                spreadRadius: 3,
              )
            else
              BoxShadow(
              color: rarityColor.withOpacity(0.6),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(9),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  rarityColor,
                  rarityDarkColor,
                ],
              ),
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: _buildCharacterSprite(character.appearance.emoji, 45),
                ),
                
                Positioned(
                  bottom: 4,
                  left: 0,
                  right: 0,
                  child: Text(
                    'Lv.${character.level}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: Colors.black,
                          blurRadius: 3,
                          offset: Offset(0, 0),
                        ),
                        Shadow(
                          color: Colors.black,
                          blurRadius: 6,
                          offset: Offset(1, 1),
                        ),
                        Shadow(
                          color: Colors.black,
                          blurRadius: 6,
                          offset: Offset(-1, -1),
                        ),
                        Shadow(
                          color: Colors.black,
                          blurRadius: 6,
                          offset: Offset(1, -1),
                        ),
                        Shadow(
                          color: Colors.black,
                          blurRadius: 6,
                          offset: Offset(-1, 1),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyTeamSlot(int position, List<Character> teamCharacters) {
    return GestureDetector(
      onTap: () => _handleEmptySlotClick(position, teamCharacters),
      child: Container(
        width: 70,
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _selectedCharacterForSwap != null && !_selectedFromTeam
                      ? Colors.blue.withOpacity(0.8)
                      : Colors.grey.withOpacity(0.5),
                  width: _selectedCharacterForSwap != null && !_selectedFromTeam ? 3 : 2,
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.add,
                  color: _selectedCharacterForSwap != null && !_selectedFromTeam
                      ? Colors.blue
                      : Colors.grey.withOpacity(0.5),
                  size: 32,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Slot $position',
              style: TextStyle(
                color: Colors.grey.withOpacity(0.5),
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Gère le clic sur un slot vide
  Future<void> _handleEmptySlotClick(int position, List<Character> teamCharacters) async {
    if (_selectedCharacterForSwap == null) {
      return;
    }

    if (!_selectedFromTeam) {
      await _addToTeamSlot(_selectedCharacterForSwap!, position);
      setState(() {
        _selectedCharacterForSwap = null;
        _selectedFromTeam = false;
      });
    }
    else {
      await _moveToEmptySlot(_selectedCharacterForSwap!, position);
      setState(() {
        _selectedCharacterForSwap = null;
        _selectedFromTeam = false;
      });
    }
  }

  /// Ajoute un héros de ALL HEROES à un slot vide
  Future<void> _addToTeamSlot(Character character, int position) async {
    try {
      final updatedChar = _createUpdatedCharacter(
        character,
        isInTeam: true,
        teamPosition: position,
      );

      await GameDataService.saveCharacter(updatedChar);

      // Message supprimé - pas besoin d'afficher de notification
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Déplace un héros de la team vers un slot vide
  Future<void> _moveToEmptySlot(Character character, int position) async {
    try {
      final updatedChar = _createUpdatedCharacter(
        character,
        isInTeam: true,
        teamPosition: position,
      );

      await GameDataService.saveCharacter(updatedChar);

      // Message supprimé - pas besoin d'afficher de notification
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildCharacterIcon(
    BuildContext context, 
    Character character, 
    List<Character> teamCharacters,
    List<Character> allCharacters,
  ) {
    Color rarityColor;
    Color rarityDarkColor;
    
    switch (character.currentRarity) {
      case CharacterRarity.legendary:
        rarityColor = const Color(0xFFFFD700); // Or
        rarityDarkColor = const Color(0xFFB8860B);
        break;
      case CharacterRarity.epic:
        rarityColor = const Color(0xFFA020F0); // Violet
        rarityDarkColor = const Color(0xFF6A0DAD);
        break;
      case CharacterRarity.rare:
        rarityColor = const Color(0xFF4169E1); // Bleu royal
        rarityDarkColor = const Color(0xFF1E3A8A);
        break;
      case CharacterRarity.common:
        rarityColor = const Color(0xFF9CA3AF); // Gris
        rarityDarkColor = const Color(0xFF4B5563);
        break;
    }

    final bool isSelected = _selectedCharacterForSwap?.id == character.id && !_selectedFromTeam;

    return GestureDetector(
      onTap: () => _handleCharacterSelection(character, teamCharacters, fromTeamSlot: false),
      onLongPress: () => _showFullsizeImage(character.appearance.fullsize),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected 
                ? Colors.blue 
                : (character.isInTeam 
                    ? Colors.white
                    : Colors.black.withOpacity(0.3)),
            width: isSelected ? 4 : (character.isInTeam ? 3 : 1),
          ),
          boxShadow: [
            if (isSelected)
              const BoxShadow(
                color: Colors.blue,
                blurRadius: 12,
                spreadRadius: 2,
              )
            else
              BoxShadow(
                color: rarityColor.withOpacity(0.5),
                blurRadius: 8,
                spreadRadius: 1,
              ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(character.isInTeam ? 5 : 7),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  rarityColor,
                  rarityDarkColor,
                ],
              ),
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: _buildCharacterSprite(character.appearance.emoji, 50),
                ),
                
                Positioned(
                  bottom: 4,
                  left: 0,
                  right: 0,
                  child: Text(
                    'Lv.${character.level}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: Colors.black,
                          blurRadius: 3,
                          offset: Offset(0, 0),
                        ),
                        Shadow(
                          color: Colors.black,
                          blurRadius: 6,
                          offset: Offset(1, 1),
                        ),
                        Shadow(
                          color: Colors.black,
                          blurRadius: 6,
                          offset: Offset(-1, -1),
                        ),
                        Shadow(
                          color: Colors.black,
                          blurRadius: 6,
                          offset: Offset(1, -1),
                        ),
                        Shadow(
                          color: Colors.black,
                          blurRadius: 6,
                          offset: Offset(-1, 1),
                        ),
                      ],
                    ),
                  ),
                ),
                
                if (character.isInTeam)
                  Positioned(
                    top: 4,
                    right: 4,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.star,
                        size: 12,
                        color: Colors.white,
                      ),
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

