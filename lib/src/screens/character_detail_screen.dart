import 'package:flutter/material.dart';
import '../models/character.dart';
import '../models/equipment.dart';

/// Écran de détails d'un personnage (style Fire Emblem)
class CharacterDetailScreen extends StatelessWidget {
  final Character character;

  const CharacterDetailScreen({
    super.key,
    required this.character,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.7),
      body: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Center(
          child: GestureDetector(
            onTap: () {}, // Empêche le tap de fermer quand on clique sur la carte
            child: Container(
              width: 450,
              height: 600,
              decoration: BoxDecoration(
                color: const Color(0xFFF5E6D3), // Parchemin beige
                border: Border.all(
                  color: const Color(0xFF8B4513),
                  width: 4,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Motif de fond (optionnel)
                  Positioned.fill(
                    child: Opacity(
                      opacity: 0.05,
                      child: Image.asset(
                        'assets/pattern.png',
                        repeat: ImageRepeat.repeat,
                        errorBuilder: (context, error, stackTrace) => const SizedBox(),
                      ),
                    ),
                  ),
                  
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        // Ligne du haut : Image + Infos + Passives
                        _buildTopRow(),
                        
                        const SizedBox(height: 16),
                        
                        // HP Bar
                        _buildHPBar(),
                        
                        const SizedBox(height: 16),
                        
                        // Stats + Équipement
                        _buildStatsAndEquipment(),
                      ],
                    ),
                  ),
                  
                  // Bouton fermer
                  Positioned(
                    top: 8,
                    right: 8,
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Color(0xFF8B4513)),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Ligne du haut : Image carrée à gauche + Nom, Level à droite + 3 passives à droite
  Widget _buildTopRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color(0xFF8B4513),
              width: 3,
            ),
            borderRadius: BorderRadius.circular(8),
            color: Color(character.appearance.colorValue),
          ),
          child: Center(
            child: Text(
              character.appearance.emoji,
              style: const TextStyle(fontSize: 40),
            ),
          ),
        ),
        
        const SizedBox(width: 12),
        
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                character.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C1810),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  _buildSmallStatBox('LV', character.level.toString()),
                  const SizedBox(width: 8),
                  Text(
                    character.persona.characterClass.displayName,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF8B4513),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        
        const SizedBox(width: 8),
        
        Column(
          children: [
            if (character.equippedSkills.isNotEmpty)
              ...character.equippedSkills.take(3).map((skill) =>
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: _buildPassiveIcon(skill.emoji),
                ),
              )
            else
              ...[
                _buildPassiveIcon('⚪'),
                const SizedBox(height: 4),
                _buildPassiveIcon('⚪'),
                const SizedBox(height: 4),
                _buildPassiveIcon('⚪'),
              ],
          ],
        ),
      ],
    );
  }

  // HP Bar
  Widget _buildHPBar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'HP',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C1810),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '${character.currentHp}/${character.stats.maxHp}',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C1810),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          height: 20,
          decoration: BoxDecoration(
            color: Colors.black26,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFF8B4513), width: 2),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: character.hpPercentage,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.green.shade400,
                    Colors.green.shade600,
                  ],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Stats (4 en carré) + Équipement (arme, armure, compétence active) à droite
  Widget _buildStatsAndEquipment() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 4 Stats en carré (2x2)
        Column(
          children: [
            Row(
              children: [
                _buildStatSquare(character.offensiveStatIcon, character.totalOffensive.toString(), character.offensiveStatName),
                const SizedBox(width: 8),
                _buildStatSquare('🛡️', character.totalDefense.toString(), 'DEF'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildStatSquare('⚡', character.totalSpeed.toString(), 'SPD'),
                const SizedBox(width: 8),
                _buildStatSquare('🍀', character.totalLuck.toString(), 'LCK'),
              ],
            ),
          ],
        ),
        
        const SizedBox(width: 16),
        
        // Équipement à droite (arme, armure, compétence active)
        Expanded(
          child: Column(
            children: [
              // Arme
              if (character.weapon != null)
                _buildCompactEquipmentSlot(character.weapon!)
              else
                _buildCompactEmptySlot('⚔️', 'Weapon'),
              
              const SizedBox(height: 8),
              
              // Armure ou Accessoire (mutuellement exclusif)
              if (character.armorOrAccessory != null)
                _buildCompactEquipmentSlot(character.armorOrAccessory!)
              else
                _buildCompactEmptySlot('🛡️', 'Armor/Accessory'),
              
              const SizedBox(height: 8),
              
              // Compétence active (skill actif)
              if (character.equippedSkills.length > 3)
                _buildActiveSkillSlot(character.equippedSkills[3])
              else
                _buildCompactEmptySlot('✨', 'Active Skill'),
            ],
          ),
        ),
      ],
    );
  }

  // Petite boîte de stat
  Widget _buildSmallStatBox(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFE6D5C3),
        border: Border.all(color: const Color(0xFF8B4513)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C1810),
            ),
          ),
          const SizedBox(width: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C1810),
            ),
          ),
        ],
      ),
    );
  }

  // Icône de passive (petit carré)
  Widget _buildPassiveIcon(String emoji) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: const Color(0xFFE6D5C3),
        border: Border.all(color: const Color(0xFF8B4513), width: 2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: Text(
          emoji,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  // Stat en carré
  Widget _buildStatSquare(String icon, String value, String label) {
    return Container(
      width: 70,
      height: 70,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFE6D5C3),
        border: Border.all(color: const Color(0xFF8B4513), width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            icon,
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C1810),
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 9,
              color: Color(0xFF8B4513),
            ),
          ),
        ],
      ),
    );
  }

  // Slot d'équipement compact
  Widget _buildCompactEquipmentSlot(Equipment equipment) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFE6D5C3),
        border: Border.all(color: const Color(0xFF8B4513), width: 2),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Text(equipment.emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  equipment.name,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C1810),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (equipment.bonusDescription.isNotEmpty)
                  Text(
                    equipment.bonusDescription,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Color(0xFF8B4513),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Slot vide compact
  Widget _buildCompactEmptySlot(String icon, String label) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFE6D5C3).withOpacity(0.5),
        border: Border.all(color: const Color(0xFF8B4513), width: 2, style: BorderStyle.solid),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF8B4513),
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  // Compétence active
  Widget _buildActiveSkillSlot(dynamic skill) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFE6D5C3),
        border: Border.all(color: const Color(0xFF8B4513), width: 2),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Text(skill.emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              skill.name,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C1810),
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