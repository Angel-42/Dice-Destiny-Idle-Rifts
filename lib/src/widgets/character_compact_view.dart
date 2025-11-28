import 'package:flutter/material.dart';
import '../models/character.dart';
import '../models/skill.dart';
import '../../l10n/app_localizations.dart';
import 'icon_display.dart';

/// Widget réutilisable pour afficher les détails compacts d'un personnage
/// Utilisé dans CharactersScreen et CharacterDetailPopup
class CharacterCompactView extends StatelessWidget {
  final Character character;
  final bool isEnemy;
  final VoidCallback? onImageTap;

  const CharacterCompactView({
    super.key,
    required this.character,
    this.isEnemy = false,
    this.onImageTap,
  });

  @override
  Widget build(BuildContext context) {
    final String image = character.appearance.lheadshot ?? character.appearance.headshot;
    
    return Container(
      padding: const EdgeInsets.only(left: 0, right: 6, top: 6, bottom: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isEnemy
              ? [
                  const Color(0xFF4A0E0E).withOpacity(0.95),
                  const Color(0xFF8B1A1A).withOpacity(0.95),
                ]
              : [
                  Color(character.appearance.colorValue).withOpacity(0.3),
                  const Color(0xFF1E2A47),
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isEnemy ? Colors.red.withOpacity(0.8) : Colors.amber.withOpacity(0.5),
          width: 2,
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image du personnage
            _buildCharacterImage(image, onImageTap),
            
            // Colonne gauche: Nom + HP + Stats
            Flexible(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildNameHeader(context),
                  const SizedBox(height: 8),
                  _buildHpBar(context),
                  const SizedBox(height: 2),
                  _buildStatsSection(context),
                ],
              ),
            ),
            const SizedBox(width: 7),
            
            // Colonne droite: Level + Passives + Équipement
            Flexible(
              flex: 1,
              child: Column(
                children: [
                  _buildLevelAndPassives(context),
                  const SizedBox(height: 8),
                  _buildEquipmentList(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCharacterImage(String image, VoidCallback? onTap) {
    return SizedBox(
      width: 80,
      child: Stack(
        children: [
          GestureDetector(
            onTap: onTap,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: _buildCharacterSprite(image, 120),
            ),
          ),
          // Bouton '+' en bas à gauche
          if (onTap != null)
            Positioned(
              bottom: 4,
              left: 4,
              child: GestureDetector(
                onTap: onTap,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.add,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCharacterSprite(String sprite, double height) {
    final cleanSprite = sprite.startsWith('~/') ? sprite.substring(2) : sprite;
    
    // Si c'est un fichier image, afficher l'image
    if (cleanSprite.contains('.png') || cleanSprite.contains('.jpg') || cleanSprite.contains('.jpeg')) {
      return Image.asset(
        cleanSprite,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Center(
            child: Text(
              '❓',
              style: TextStyle(fontSize: height * 0.6),
            ),
          );
        },
      );
    } else {
      return Center(
        child: Text(
          sprite,
          style: TextStyle(fontSize: height * 0.6),
        ),
      );
    }
  }

  Widget _buildNameHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isEnemy ? Colors.red.withOpacity(0.5) : Colors.amber.withOpacity(0.5),
        ),
      ),
      child: Text(
        character.name,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: isEnemy ? Colors.red.shade200 : Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildHpBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.amber.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Text(
            S.of(context)!.hp,
            style: const TextStyle(
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
    );
  }

  Widget _buildStatsSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.amber.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        character.offensiveStatName,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 2),
                    Text(
                      character.totalOffensive.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
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
                    Flexible(
                      child: Text(
                        S.of(context)!.spd,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 2),
                    Text(
                      character.totalSpeed.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        S.of(context)!.def,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 2),
                    Text(
                      character.totalDefense.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
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
                    Flexible(
                      child: Text(
                        S.of(context)!.lck,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 2),
                    Text(
                      character.totalLuck.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
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
    );
  }

  Widget _buildLevelAndPassives(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 68,
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.4),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.amber.withOpacity(0.5)),
          ),
          child: Text(
            'Lv. ${character.level}',
            style: const TextStyle(
              color: Colors.amber,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 4),
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
                      child: _buildPassiveIcon(passives[index].displayIcon),
                    ),
                  );
                }
                return Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 2),
                    child: _buildEmptyPassiveSlot(),
                  ),
                );
              });
            }(),
          ),
        ),
      ],
    );
  }

  Widget _buildPassiveIcon(String icon) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        border: Border.all(color: Colors.amber.withOpacity(0.5), width: 1.5),
        shape: BoxShape.circle,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: FittedBox(
          fit: BoxFit.contain,
          child: IconDisplay(icon: icon, size: 28),
        ),
      ),
    );
  }

  Widget _buildEmptyPassiveSlot() {
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

  Widget _buildEquipmentList(BuildContext context) {
    final activeSkill = character.equippedSkills
        .where((s) => s.type == SkillType.active)
        .firstOrNull;
    
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 2),
          child: _buildEquipmentSlot(
            character.weapon?.displayIcon ?? '⚔️',
            character.weapon?.name ?? '-',
            character.weapon != null,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 2),
          child: _buildEquipmentSlot(
            character.armorOrAccessory?.displayIcon ?? '🛡️',
            character.armorOrAccessory?.name ?? '-',
            character.armorOrAccessory != null,
          ),
        ),
        _buildEquipmentSlot(
          activeSkill?.displayIcon ?? '✨',
          activeSkill?.name ?? '-',
          activeSkill != null,
        ),
      ],
    );
  }

  Widget _buildEquipmentSlot(String icon, String name, bool hasItem) {
    return Container(
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
          SizedBox(
            width: 24,
            height: 24,
            child: FittedBox(
              fit: BoxFit.contain,
              child: IconDisplay(icon: icon, size: 24),
            ),
          ),
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
}
