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
                  
                  Column(
                    children: [
                      // Header avec portrait + infos de base
                      _buildHeader(),
                      
                      const Divider(
                        color: Color(0xFF8B4513),
                        thickness: 2,
                        height: 2,
                      ),
                      
                      // Corps : stats + équipement + compétences
                      Expanded(
                        child: Row(
                          children: [
                            // Colonne gauche : Stats
                            Expanded(
                              flex: 2,
                              child: _buildStatsColumn(),
                            ),
                            
                            Container(
                              width: 2,
                              color: const Color(0xFF8B4513),
                            ),
                            
                            // Colonne droite : Équipement + Compétences
                            Expanded(
                              flex: 3,
                              child: _buildEquipmentAndSkills(),
                            ),
                          ],
                        ),
                      ),
                    ],
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

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          // Portrait
          Container(
            width: 100,
            height: 100,
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
                style: const TextStyle(fontSize: 50),
              ),
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Infos de base
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nom
                Text(
                  character.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C1810),
                  ),
                ),
                
                const SizedBox(height: 4),
                
                // Classe
                Text(
                  character.persona.characterClass.displayName,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Color(0xFF8B4513),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                
                const SizedBox(height: 8),
                
                // Niveau et XP
                Row(
                  children: [
                    _buildStatBox('LV', character.level.toString(), 40),
                    const SizedBox(width: 8),
                    _buildStatBox('EXP', character.xp.toString(), 60),
                  ],
                ),
                
                const SizedBox(height: 8),
                
                // HP avec barre
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
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                            height: 16,
                            decoration: BoxDecoration(
                              color: Colors.black26,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: const Color(0xFF8B4513)),
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
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${character.currentHp}/${character.stats.maxHp}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2C1810),
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
    );
  }

  Widget _buildStatsColumn() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Stats',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C1810),
            ),
          ),
          const SizedBox(height: 8),
          _buildStatRow('Str', character.totalAttack.toString(), baseValue: character.stats.attack),
          _buildStatRow('Mag', character.totalMagic.toString(), baseValue: character.stats.magic),
          _buildStatRow('Skill', character.totalLuck.toString(), baseValue: character.stats.luck),
          _buildStatRow('Spd', character.totalSpeed.toString(), baseValue: character.stats.speed),
          _buildStatRow('Lck', character.totalLuck.toString(), baseValue: character.stats.luck),
          _buildStatRow('Def', character.totalDefense.toString(), baseValue: character.stats.defense),
          _buildStatRow('Res', character.totalMagic.toString(), baseValue: character.stats.magic),
          
          const Divider(color: Color(0xFF8B4513), height: 24),
          
          // Maîtrise des armes (dynamique)
          const Text(
            'Weapon Mastery',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C1810),
            ),
          ),
          const SizedBox(height: 8),
          if (character.weaponMasteries.isEmpty)
            const Text(
              'Aucune maîtrise',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF8B4513),
                fontStyle: FontStyle.italic,
              ),
            )
          else
            ...character.weaponMasteries.map((mastery) => 
              _buildWeaponMastery(
                mastery.type.emoji,
                mastery.type.displayName,
                mastery.rank,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEquipmentAndSkills() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Équipement
          const Text(
            'Equipment',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C1810),
            ),
          ),
          const SizedBox(height: 8),
          
          // Arme
          if (character.weapon != null)
            _buildEquipmentSlot(character.weapon!)
          else
            _buildEmptyEquipmentSlot('Weapon'),
          
          // Armure
          if (character.armor != null)
            _buildEquipmentSlot(character.armor!)
          else
            _buildEmptyEquipmentSlot('Armor'),
          
          // Accessoire
          if (character.accessory != null)
            _buildEquipmentSlot(character.accessory!)
          else
            _buildEmptyEquipmentSlot('Accessory'),
          
          const SizedBox(height: 16),
          
          // Compétences (Skills)
          const Text(
            'Skills',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C1810),
            ),
          ),
          const SizedBox(height: 8),
          
          if (character.equippedSkills.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Aucune compétence',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF8B4513),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: character.equippedSkills.take(5).map((skill) =>
                _buildSkillIcon(skill.emoji, skill.name),
              ).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildStatBox(String label, String value, double width) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFE6D5C3),
        border: Border.all(color: const Color(0xFF8B4513)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C1810),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C1810),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value, {int? baseValue}) {
    final hasBonus = baseValue != null && int.parse(value) > baseValue;
    final bonus = hasBonus ? int.parse(value) - baseValue : 0;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 50,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2C1810),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFE6D5C3),
                border: Border.all(color: const Color(0xFF8B4513)),
                borderRadius: BorderRadius.circular(4),
              ),
              child: hasBonus
                  ? FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerRight,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '$baseValue',
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF8B4513),
                            ),
                          ),
                          const SizedBox(width: 3),
                          Text(
                            '+$bonus',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2E7D32),
                            ),
                          ),
                          const SizedBox(width: 3),
                          const Text(
                            '=',
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFF8B4513),
                            ),
                          ),
                          const SizedBox(width: 3),
                          Text(
                            value,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1B5E20),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Text(
                      value,
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C1810),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeaponMastery(String icon, String weapon, String rank) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              weapon,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF2C1810),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFF8B4513),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              rank,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEquipmentSlot(Equipment equipment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFE6D5C3),
        border: Border.all(color: const Color(0xFF8B4513)),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Text(equipment.emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  equipment.name,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C1810),
                  ),
                ),
                if (equipment.bonusDescription.isNotEmpty)
                  Text(
                    equipment.bonusDescription,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF8B4513),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyEquipmentSlot(String type) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFE6D5C3).withOpacity(0.5),
        border: Border.all(color: const Color(0xFF8B4513), style: BorderStyle.solid),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          const Text('⚪', style: TextStyle(fontSize: 20)),
          const SizedBox(width: 8),
          Text(
            'Empty $type',
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF8B4513),
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillIcon(String icon, String name) {
    return Container(
      width: 80,
      height: 80,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFE6D5C3),
        border: Border.all(color: const Color(0xFF8B4513), width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(icon, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 4),
            Text(
              name,
              style: const TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C1810),
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}