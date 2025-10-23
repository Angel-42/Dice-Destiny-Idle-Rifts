import 'package:flutter/material.dart';
import '../models/character.dart';
import '../models/skill.dart';
import '../services/game_data_service.dart';

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
    if (fullsizeSprite == null) return;
    
    // Nettoyer le préfixe ~/ si présent
    final cleanPath = fullsizeSprite.startsWith('~/') 
        ? fullsizeSprite.substring(2) 
        : fullsizeSprite;
    
    showDialog(
      context: context,
      builder: (context) => GestureDetector(
        onTap: () => Navigator.pop(context),
        child: InteractiveViewer(
          child: Image.asset(cleanPath),
        ),
      ),
    );
  }

  void _selectCharacter(Character character) {
    setState(() {
      _selectedCharacter = character;
    });
  }

  /// Helper pour afficher soit un emoji, soit une image sprite
  Widget _buildCharacterSprite(String sprite, double size) {
    // Nettoyer le chemin d'abord si nécessaire
    final cleanSprite = sprite.startsWith('~/') ? sprite.substring(2) : sprite;
    
    // Si le sprite contient une extension d'image, c'est un chemin d'asset
    if (cleanSprite.contains('.png') || cleanSprite.contains('.jpg') || cleanSprite.contains('.jpeg')) {
      return Image.asset(
        cleanSprite,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          // Si l'image ne charge pas, afficher un emoji par défaut
          return Center(
            child: Text(
              '❓',
              style: TextStyle(fontSize: size * 0.8),
            ),
          );
        },
      );
    } else {
      // C'est un emoji - le centrer
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
              // Ne pas afficher de loading après le premier chargement
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
                  // Section 1: Character Detail (si sélectionné) avec animation
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
                  // Section 2: Edit Team
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

  /// Gère la sélection/échange de personnages dans la team
  /// [fromTeamSlot] = true si le clic vient de EDIT TEAM, false si de ALL HEROES
  Future<void> _handleCharacterSelection(
    Character character, 
    List<Character> teamCharacters,
    {required bool fromTeamSlot}
  ) async {
    // D'abord, sélectionner le personnage pour afficher ses détails
    _selectCharacter(character);
    
    // Si aucun personnage n'est sélectionné pour swap, sélectionner celui-ci
    if (_selectedCharacterForSwap == null) {
      setState(() {
        _selectedCharacterForSwap = character;
        _selectedFromTeam = fromTeamSlot;
      });
      return;
    }

    // Si on clique sur le même personnage, le désélectionner pour swap
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

    // CAS 2: Les deux clics viennent de ALL HEROES → changer juste la sélection
    if (!_selectedFromTeam && !fromTeamSlot) {
      setState(() {
        _selectedCharacterForSwap = character;
        _selectedFromTeam = fromTeamSlot;
      });
      return;
    }

    // Cas spécial: même si l'un des clics provient de la grille ALL HEROES,
    // si les DEUX personnages sont marqués comme "isInTeam", il s'agit
    // d'un échange de positions dans la team — traiter comme CAS 1.
    if (_selectedCharacterForSwap!.isInTeam && character.isInTeam) {
      await _swapTeamPositions(_selectedCharacterForSwap!, character);
      setState(() {
        _selectedCharacterForSwap = null;
        _selectedFromTeam = false;
      });
      return;
    }

    // CAS 3: Zones différentes (team ↔ all) → remplacer
    await _swapCharacters(_selectedCharacterForSwap!, character, teamCharacters);
    
    // Désélectionner après l'échange
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('🔄 ${char1.name} ↔ ${char2.name} (positions ${pos1 + 1} ↔ ${pos2 + 1})'),
            backgroundColor: Colors.blue,
            duration: const Duration(seconds: 2),
          ),
        );
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
      
      // Récupérer la position du héros dans la team
      final position = charInTeam.teamPosition;
      
      // Créer les versions mises à jour
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

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ ${updatedCharOutTeam.name} remplace ${updatedCharInTeam.name} (Position ${position + 1})'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
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
      armor: character.armor,
      accessory: character.accessory,
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
    final String image = character.appearance.lheadshot ?? character.appearance.headshot;
    return Container(
      padding: const EdgeInsets.only(left: 0, right: 6, top: 6, bottom: 0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(character.appearance.colorValue).withOpacity(0.3),
            const Color(0xFF1E2A47),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.withOpacity(0.5), width: 2),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
          GestureDetector(
            onTap: () => _showFullsizeImage(character.appearance.fullsize),
            child: SizedBox(
              width: 80,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: _buildCharacterSprite(image, 120),
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.amber.withOpacity(0.5)),
                  ),
                  child: Text(
                    character.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 8),
                // HP Bar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.amber.withOpacity(0.5)),
                  ),
                  child: Row(
                    children: [
                      const Text(
                        'HP',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Stack(
                          children: [
                            Container(
                              height: 18,
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(9),
                              ),
                            ),
                            FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: character.hpPercentage,
                              child: Container(
                                height: 18,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.green.shade400,
                                      Colors.green.shade700,
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(9),
                                ),
                              ),
                            ),
                            Positioned.fill(
                              child: Center(
                                child: Text(
                                  '${character.currentHp} / ${character.stats.maxHp}',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black,
                                        offset: Offset(1, 1),
                                        blurRadius: 2,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 2),
                // Stats style FEH (2 lignes, label + valeur)
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.amber.withOpacity(0.5)),
                  ),
                  child: Column(
                    children: [
                      // Ligne 1: Atk + Spd
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  character.offensiveStatName,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  character.totalOffensive.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Spd',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  character.totalSpeed.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      // Ligne 2: Def + Res (Lck)
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Def',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  character.totalDefense.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Lck',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  character.totalLuck.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 7),
          // Colonne de droite : Level + Passives + Équipement (taille équitable)
          Flexible(
            flex: 1,
            child: Column(
              children: [
                // const SizedBox(height: 6),
                // Niveau + Passives sur la même ligne
                Row(
                  children: [
                    // Level avec taille fixe pour Lv. 999
                    Container(
                      width: 68, // Taille fixe pour "Lv. 999"
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.amber.withOpacity(0.5)),
                      ),
                      child:Text(
                          'Lv. ${character.level}',
                          style: const TextStyle(
                            color: Colors.amber,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ),
                    const SizedBox(width: 4),
                    // Passives (3 skills côte à côte) - réduites
                    Expanded(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: () {
                          final passives = character.equippedSkills
                              .where((s) => s.type == SkillType.passive)
                              .take(3)
                              .toList();
                          
                          return List.generate(3, (index) {
                            if (index < passives.length) {
                              return Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 2),
                                  child: _buildCharDetailPassiveIcon(passives[index].emoji),
                                ),
                              );
                            }
                            return Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 2),
                                child: _buildCharDetailEmptyPassiveSlot(),
                              ),
                            );
                          });
                        }(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              // Arme
              Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: _buildCharDetailEquipmentSlot(
                  character.weapon?.emoji ?? '⚔️',
                  character.weapon?.name ?? '-',
                  character.weapon != null,
                ),
              ),
              // Armure
              Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: _buildCharDetailEquipmentSlot(
                  character.armor?.emoji ?? '🛡️',
                  character.armor?.name ?? '-',
                  character.armor != null,
                ),
              ),
              // Compétence active
              () {
                final activeSkill = character.equippedSkills
                    .where((s) => s.type == SkillType.active)
                    .firstOrNull;
                
                return _buildCharDetailEquipmentSlot(
                  activeSkill?.emoji ?? '✨',
                  activeSkill?.name ?? '-',
                  activeSkill != null,
                );
              }(),
            ],
          ),
          ),
        ],
        ),
      ),
    );
  }

  // Icône de passive pour le détail du personnage (circulaire)
  Widget _buildCharDetailPassiveIcon(String emoji) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        border: Border.all(color: Colors.amber.withOpacity(0.5), width: 1.5),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          emoji,
          style: const TextStyle(fontSize: 14),
        ),
      ),
    );
  }

  // Slot vide pour passive (circulaire)
  Widget _buildCharDetailEmptyPassiveSlot() {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        border: Border.all(color: Colors.grey.withOpacity(0.3), width: 1.5),
        shape: BoxShape.circle,
      ),
    );
  }

  // Slot d'équipement pour le détail
  Widget _buildCharDetailEquipmentSlot(String icon, String name, bool hasItem) {
    return Container(
      // Prend toute la largeur disponible
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: hasItem ? Colors.black.withOpacity(0.4) : Colors.black.withOpacity(0.2),
        border: Border.all(
          color: hasItem ? Colors.amber.withOpacity(0.5) : Colors.grey.withOpacity(0.3),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              name,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: hasItem ? Colors.white : Colors.grey,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
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
              const Text(
                'EDIT TEAM',
                style: TextStyle(
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
          const Row(
            children: [
              Icon(Icons.list, color: Colors.amber, size: 24),
              SizedBox(width: 8),
              Text(
                'ALL HEROES',
                style: TextStyle(
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

    // Vérifier si ce personnage est sélectionné pour swap ET que la sélection vient de EDIT TEAM
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
                
                // Niveau en bas avec ombre noire autour du texte
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
    // Si aucun héros n'est sélectionné, ne rien faire
    if (_selectedCharacterForSwap == null) {
      return;
    }

    // Si le héros sélectionné vient de ALL HEROES, l'ajouter à ce slot
    if (!_selectedFromTeam) {
      await _addToTeamSlot(_selectedCharacterForSwap!, position);
      setState(() {
        _selectedCharacterForSwap = null;
        _selectedFromTeam = false;
      });
    }
    // Si le héros vient de EDIT TEAM, déplacer vers ce slot
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

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ ${character.name} ajouté au slot $position !'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
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

  /// Déplace un héros de la team vers un slot vide
  Future<void> _moveToEmptySlot(Character character, int position) async {
    try {
      final updatedChar = _createUpdatedCharacter(
        character,
        isInTeam: true,
        teamPosition: position,
      );

      await GameDataService.saveCharacter(updatedChar);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ ${character.name} déplacé au slot $position !'),
            backgroundColor: Colors.blue,
            duration: const Duration(seconds: 2),
          ),
        );
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

  Widget _buildCharacterIcon(
    BuildContext context, 
    Character character, 
    List<Character> teamCharacters,
    List<Character> allCharacters,
  ) {
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

    // Vérifier si ce personnage est sélectionné pour swap ET que la sélection vient de ALL HEROES
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
                // Sprite du personnage (remplit tout l'espace)
                Positioned.fill(
                  child: _buildCharacterSprite(character.appearance.emoji, 50),
                ),
                
                // Niveau en bas avec ombre noire autour du texte
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
                
                // Étoile en haut à droite si dans la team
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
