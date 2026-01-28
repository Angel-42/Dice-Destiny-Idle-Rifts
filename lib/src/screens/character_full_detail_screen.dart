import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../models/character.dart';
import '../models/skill.dart';
import '../models/equipment.dart';
import '../services/game_data_service.dart';
import '../widgets/icon_display.dart';

/// Écran fullscreen pour afficher et éditer les détails complets d'un personnage
class CharacterFullDetailScreen extends StatefulWidget {
  final Character character;

  const CharacterFullDetailScreen({super.key, required this.character});

  @override
  State<CharacterFullDetailScreen> createState() => _CharacterFullDetailScreenState();
}

class _CharacterFullDetailScreenState extends State<CharacterFullDetailScreen> {
  bool _showUI = true;

  String _cleanSprite(String sprite) {
    return sprite.startsWith('~/') ? sprite.substring(2) : sprite;
  }

  @override
  Widget build(BuildContext context) {
    final character = widget.character;
    final fullsizeSprite = character.appearance.fullsize;

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          setState(() {
            _showUI = !_showUI;
          });
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(character.appearance.colorValue).withOpacity(0.6),
                Colors.black,
              ],
            ),
          ),
          child: Stack(
            children: [
              Center(
                child: fullsizeSprite != null
                    ? InteractiveViewer(
                        child: Image.asset(
                          _cleanSprite(fullsizeSprite),
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Icon(Icons.error, color: Colors.red, size: 64),
                            );
                          },
                        ),
                      )
                    : const Center(
                        child: Icon(Icons.person, color: Colors.white, size: 128),
                      ),
              ),

              if (_showUI) ...[
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 120,
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
                  ),
                ),

                Positioned(
                  top: 40,
                  left: 16,
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
                    ),
                  ),
                ),

                Positioned(
                  top: 40,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.touch_app, color: Colors.white, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Tap!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: SafeArea(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildHeader(character),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withOpacity(0.0),
                                Colors.black.withOpacity(0.45),
                              ],
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: _buildMainInfoBlock(character),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // Header séparé au-dessus du bloc principal
  Widget _buildHeader(Character character) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 8, 12, 0),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(character.appearance.colorValue).withOpacity(0.4),
            Color(character.appearance.colorValue).withOpacity(0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.amber.withOpacity(0.6), width: 1.5),
      ),
      child: Row(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              character.currentRarity.stars,
              (index) => const Icon(Icons.star, color: Colors.amber, size: 18),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  character.persona.displayName,
                  style: const TextStyle(
                    color: Colors.amber,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  character.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Bloc principal : Niveau/EXP + Stats à gauche + Équipement/Skills à droite
  Widget _buildMainInfoBlock(Character character) {
    final expProgress = character.xp / character.xpForNextLevel;
    
    return Container(
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E3A5F).withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: Colors.red.withOpacity(0.6)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.military_tech, color: Colors.red, size: 14),
                              const SizedBox(width: 4),
                              Text(
                                'LV. ${character.level}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: Colors.blue.withOpacity(0.5)),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade800,
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(3),
                                    child: LinearProgressIndicator(
                                      value: character.level >= 40 ? 1.0 : expProgress,
                                      backgroundColor: Colors.transparent,
                                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                                    ),
                                  ),
                                ),
                                Text(
                                  character.level >= 40 ? S.of(context)!.expMax : S.of(context)!.exp(character.xp, character.xpForNextLevel),
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 9,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Stats (6 lignes)
                    _buildStatRow('HP', character.stats.maxHp, Colors.green),
                    _buildStatRow(character.offensiveStatName, character.totalOffensive, Colors.red),
                    _buildStatRow('Spd', character.totalSpeed, Colors.blue),
                    _buildStatRow('Def', character.totalDefense, Colors.orange),
                    _buildStatRow('Lck', character.totalLuck, Colors.purple),
                  ],
                ),
              ),
            ),
            
            Container(
              width: 1,
              color: Colors.white.withOpacity(0.3),
            ),
            
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildEquipmentSlotCompact(
                      icon: character.weapon?.displayIcon ?? '⚔️',
                      name: character.weapon?.name ?? '-',
                      hasItem: character.weapon != null,
                      onTap: () async {
                        await _showEquipmentSelectionDialog(
                          character: character,
                          equipmentType: EquipmentType.weapon,
                          onSelect: (equipment) async {
                            setState(() {
                              character.weapon = equipment;
                            });
                            await GameDataService.saveCharacter(character);
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 3),
                    _buildEquipmentSlotCompact(
                      icon: character.armorOrAccessory?.displayIcon ?? '🛡️',
                      name: character.armorOrAccessory?.name ?? '-',
                      hasItem: character.armorOrAccessory != null,
                      onTap: () async {
                        await _showArmorOrAccessorySelectionDialog(
                          character: character,
                          onSelect: (equipment) async {
                            setState(() {
                              character.armorOrAccessory = equipment;
                            });
                            await GameDataService.saveCharacter(character);
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 6),
                    ...List.generate(4, (index) {
                      Skill? skill;
                      if (index < character.equippedSkills.length) {
                        final currentSkill = character.equippedSkills[index];
                        if (!currentSkill.id.startsWith('empty_')) {
                          skill = currentSkill;
                        }
                      }
                      
                      final hasSkill = skill != null;
                      final isActiveSlot = index == 0;
                      
                      return Column(
                        children: [
                          if (index > 0) const SizedBox(height: 10),
                          _buildEquipmentSlotCompact(
                            icon: skill?.displayIcon ?? (isActiveSlot ? '⚡' : '🔰'),
                            name: skill?.name ?? (isActiveSlot ? 'Active' : 'Passive ${index}'),
                            hasItem: hasSkill,
                            onTap: () async {
                              await _showSkillSelectionDialog(
                                character: character,
                                skillSlotIndex: index,
                                onSelect: (selectedSkill) async {
                                  setState(() {
                                    if (selectedSkill == null) {
                                      if (index < character.equippedSkills.length) {
                                        character.equippedSkills[index] = Skill(
                                          id: 'empty_$index',
                                          name: '-',
                                          emoji: '🔰',
                                          description: S.of(context)!.emptySlot,
                                          type: index == 0 ? SkillType.active : SkillType.passive,
                                        );
                                      }
                                    } else {
                                      while (character.equippedSkills.length <= index) {
                                        character.equippedSkills.add(
                                          Skill(
                                            id: 'empty_${character.equippedSkills.length}',
                                            name: '-',
                                            emoji: '🔰',
                                            description: S.of(context)!.emptySlot,
                                            type: character.equippedSkills.length == 0 
                                                ? SkillType.active 
                                                : SkillType.passive,
                                          ),
                                        );
                                      }
                                      character.equippedSkills[index] = selectedSkill;
                                    }
                                  });
                                  await GameDataService.saveCharacter(character);
                                },
                              );
                            },
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Dialog pour sélectionner une compétence depuis l'inventaire
  Future<void> _showSkillSelectionDialog({
    required Character character,
    required int skillSlotIndex, // L'index du slot de compétence (0-3)
    required Function(Skill?) onSelect,
  }) async {
    final requiredType = skillSlotIndex == 0 ? SkillType.active : SkillType.passive;
    
    final allSkills = character.inventory.getAllSkills()
        .where((item) => item.item.type == requiredType)
        .toList();
    
    final alreadyEquippedIds = <String>{};
    for (int i = 0; i < character.equippedSkills.length; i++) {
      if (i != skillSlotIndex) {
        final skill = character.equippedSkills[i];
        if (!skill.id.startsWith('empty_')) {
          alreadyEquippedIds.add(skill.id);
        }
      }
    }

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A2332),
        title: Text(
          skillSlotIndex == 0 
              ? 'Sélectionner une compétence active (Slot 1)'
              : 'Sélectionner une compétence passive (Slot ${skillSlotIndex + 1})',
          style: const TextStyle(color: Colors.white),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: allSkills.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return ListTile(
                  leading: const Text('❌', style: TextStyle(fontSize: 24)),
                  title: const Text(
                    'Aucun',
                    style: TextStyle(color: Colors.grey),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    onSelect(null);
                  },
                );
              }

              final inventoryItem = allSkills[index - 1];
              final skill = inventoryItem.item;
              final isUnlocked = inventoryItem.isUnlocked(
                characterLevel: character.level,
                characterStars: character.currentRarity.index + 1,
              );
              
              final isAlreadyEquipped = alreadyEquippedIds.contains(skill.id);

              return ListTile(
                enabled: isUnlocked && !isAlreadyEquipped,
                leading: IconDisplay(
                  icon: skill.displayIcon,
                  size: 35,
                ),
                title: Text(
                  skill.name,
                  style: TextStyle(
                    color: isUnlocked && !isAlreadyEquipped ? Colors.white : Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: isAlreadyEquipped
                    ? const Text(
                        '⚠️ Déjà équipé',
                        style: TextStyle(color: Colors.orange, fontSize: 12),
                      )
                    : isUnlocked
                        ? Text(
                            skill.description,
                            style: const TextStyle(color: Colors.white70, fontSize: 12),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          )
                        : Text(
                            '🔒 ${inventoryItem.condition.description}',
                            style: const TextStyle(color: Colors.red, fontSize: 12),
                          ),
                trailing: isAlreadyEquipped
                    ? const Icon(Icons.warning, color: Colors.orange)
                    : isUnlocked
                        ? Icon(
                            Icons.chevron_right,
                            color: Colors.blue.withOpacity(0.6),
                          )
                        : const Icon(Icons.lock, color: Colors.grey),
                onTap: isUnlocked && !isAlreadyEquipped
                    ? () {
                        Navigator.of(context).pop();
                        onSelect(skill);
                      }
                    : null,
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }

  // Une ligne de stat (label à gauche, valeur à droite)
  Widget _buildStatRow(String label, int value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFF2A4A6A).withOpacity(0.6),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              value.toString(),
              style: TextStyle(
                color: color,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Dialog pour sélectionner une armure OU un accessoire
  Future<void> _showArmorOrAccessorySelectionDialog({
    required Character character,
    required Function(Equipment?) onSelect,
  }) async {
    final allArmors = character.inventory.armors;
    final allAccessories = character.inventory.accessories;
    final allItems = [...allArmors, ...allAccessories];

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A2332),
        title: const Text(
          'Sélectionner une armure ou un accessoire',
          style: TextStyle(color: Colors.white),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: allItems.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return ListTile(
                  leading: const Text('❌', style: TextStyle(fontSize: 24)),
                  title: const Text(
                    'Aucun',
                    style: TextStyle(color: Colors.grey),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    onSelect(null);
                  },
                );
              }

              final inventoryItem = allItems[index - 1];
              final equipment = inventoryItem.item;
              final isUnlocked = inventoryItem.isUnlocked(
                characterLevel: character.level,
                characterStars: character.currentRarity.index + 1,
              );

              return ListTile(
                enabled: isUnlocked,
                leading: SizedBox(
                  width: 40,
                  height: 40,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: IconDisplay(icon: equipment.displayIcon, size: 40),
                  ),
                ),
                title: Text(
                  equipment.name,
                  style: TextStyle(
                    color: isUnlocked ? Colors.white : Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: isUnlocked
                    ? Text(
                        equipment.bonusDescription.isNotEmpty 
                            ? equipment.bonusDescription 
                            : 'Pas de bonus',
                        style: const TextStyle(color: Colors.white70, fontSize: 12),
                      )
                    : Text(
                        '🔒 ${inventoryItem.condition.description}',
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
                trailing: isUnlocked
                    ? Icon(
                        Icons.chevron_right,
                        color: Colors.blue.withOpacity(0.6),
                      )
                    : const Icon(Icons.lock, color: Colors.grey),
                onTap: isUnlocked
                    ? () {
                        Navigator.of(context).pop();
                        onSelect(equipment);
                      }
                    : null,
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }

  // Dialog pour sélectionner un équipement depuis l'inventaire
  Future<void> _showEquipmentSelectionDialog({
    required Character character,
    required EquipmentType equipmentType,
    required Function(Equipment?) onSelect,
  }) async {
    final allItems = equipmentType == EquipmentType.weapon
        ? character.inventory.getAllWeapons()
        : equipmentType == EquipmentType.armor
            ? character.inventory.armors
            : character.inventory.accessories;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A2332),
        title: Text(
          equipmentType == EquipmentType.weapon
              ? 'Sélectionner une arme'
              : equipmentType == EquipmentType.armor
                  ? 'Sélectionner une armure'
                  : 'Sélectionner un accessoire',
          style: const TextStyle(color: Colors.white),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: allItems.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return ListTile(
                  leading: const Text('❌', style: TextStyle(fontSize: 24)),
                  title: const Text(
                    'Aucun',
                    style: TextStyle(color: Colors.grey),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    onSelect(null);
                  },
                );
              }

              final inventoryItem = allItems[index - 1];
              final equipment = inventoryItem.item;
              final isUnlocked = inventoryItem.isUnlocked(
                characterLevel: character.level,
                characterStars: character.currentRarity.index + 1,
              );

              return ListTile(
                enabled: isUnlocked,
                leading: SizedBox(
                  width: 40,
                  height: 40,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: IconDisplay(icon: equipment.displayIcon, size: 40),
                  ),
                ),
                title: Text(
                  equipment.name,
                  style: TextStyle(
                    color: isUnlocked ? Colors.white : Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: isUnlocked
                    ? Text(
                        equipment.bonusDescription.isNotEmpty 
                            ? equipment.bonusDescription 
                            : 'Pas de bonus',
                        style: const TextStyle(color: Colors.white70, fontSize: 12),
                      )
                    : Text(
                        '🔒 ${inventoryItem.condition.description}',
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
                trailing: isUnlocked
                    ? Icon(
                        Icons.chevron_right,
                        color: Colors.blue.withOpacity(0.6),
                      )
                    : const Icon(Icons.lock, color: Colors.grey),
                onTap: isUnlocked
                    ? () {
                        Navigator.of(context).pop();
                        onSelect(equipment);
                      }
                    : null,
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }

  Widget _buildEquipmentSlotCompact({
    required String icon,
    required String name,
    required bool hasItem,
    VoidCallback? onTap,
  }) {
    final widget = Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF2A4A6A).withOpacity(hasItem ? 0.8 : 0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: hasItem ? Colors.blue.withOpacity(0.6) : Colors.grey.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 30,
            height: 30,
            child: FittedBox(
              fit: BoxFit.contain,
              child: IconDisplay(icon: icon, size: 30),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              name,
              style: TextStyle(
                color: hasItem ? Colors.white : Colors.grey.withOpacity(0.5),
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: widget,
      );
    }
    return widget;
  }
}
