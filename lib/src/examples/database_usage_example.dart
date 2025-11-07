import 'package:dice_destiny_idle_rifts/src/data/weapons_database.dart';
import 'package:dice_destiny_idle_rifts/src/data/skills_database.dart';
import 'package:dice_destiny_idle_rifts/src/data/armors_database.dart';
import 'package:dice_destiny_idle_rifts/src/models/equipment.dart';
import 'package:dice_destiny_idle_rifts/src/models/skill.dart';

/// Exemples d'utilisation des bases de données d'items
void exampleUsage() {
  print('=== EXEMPLES D\'UTILISATION DES BASES DE DONNÉES ===\n');

  // ============================================================================
  // ARMES
  // ============================================================================
  
  print('--- ARMES ---');
  
  // Récupérer une arme spécifique
  final excalibur = WeaponsDatabase.excalibur;
  print('Arme: ${excalibur.name} ${excalibur.emoji}');
  print('Rareté: ${excalibur.rarity.name}');
  print('Bonus: ${excalibur.bonusDescription}\n');
  
  // Récupérer toutes les épées
  final swords = WeaponsDatabase.getByCategory('swords');
  print('Nombre d\'épées disponibles: ${swords.length}');
  for (final sword in swords) {
    print('  - ${sword.name} (${sword.rarity.name})');
  }
  print('');
  
  // Récupérer les armes légendaires
  final legendaryWeapons = WeaponsDatabase.getByRarity(EquipmentRarity.legendary);
  print('Armes légendaires (${legendaryWeapons.length}):');
  for (final weapon in legendaryWeapons) {
    print('  - ${weapon.name} ${weapon.emoji}');
  }
  print('');

  // ============================================================================
  // COMPÉTENCES
  // ============================================================================
  
  print('--- COMPÉTENCES ---');
  
  // Récupérer une compétence spécifique
  final fireball = SkillsDatabase.fireball;
  print('Compétence: ${fireball.name} ${fireball.emoji}');
  print('Type: ${fireball.type.name}');
  print('Description: ${fireball.description}\n');
  
  // Récupérer les compétences de guerrier
  final warriorSkills = SkillsDatabase.getByCategory('warrior_active');
  print('Compétences de guerrier (${warriorSkills.length}):');
  for (final skill in warriorSkills) {
    print('  - ${skill.name}: ${skill.description}');
  }
  print('');
  
  // Récupérer les compétences passives
  final passives = SkillsDatabase.getBySkillType(SkillType.passive);
  print('Compétences passives: ${passives.length}');
  print('');
  
  // Récupérer les compétences recommandées pour un mage
  final mageSkills = SkillsDatabase.getRecommendedForClass('mage');
  print('Compétences recommandées pour mage (${mageSkills.length}):');
  for (final skill in mageSkills.take(5)) {
    print('  - ${skill.name} ${skill.emoji}');
  }
  print('');

  // ============================================================================
  // ARMURES
  // ============================================================================
  
  print('--- ARMURES ---');
  
  // Récupérer une armure spécifique
  final dragonScale = ArmorsDatabase.dragonScaleArmor;
  print('Armure: ${dragonScale.name} ${dragonScale.emoji}');
  print('Bonus: ${dragonScale.bonusDescription}\n');
  
  // Récupérer les armures rares et plus
  final rareArmors = ArmorsDatabase.allArmors
      .where((a) => a.rarity.index >= EquipmentRarity.rare.index)
      .toList();
  print('Armures rares et plus (${rareArmors.length}):');
  for (final armor in rareArmors) {
    print('  - ${armor.name} (${armor.rarity.name})');
  }
  print('');

  // ============================================================================
  // ACCESSOIRES
  // ============================================================================
  
  print('--- ACCESSOIRES ---');
  
  // Récupérer un accessoire spécifique
  final crownOfKings = AccessoriesDatabase.crownOfKings;
  print('Accessoire: ${crownOfKings.name} ${crownOfKings.emoji}');
  print('Bonus: ${crownOfKings.bonusDescription}\n');
  
  // Récupérer tous les anneaux (accessoires avec 'ring' dans l'ID)
  final rings = AccessoriesDatabase.allAccessories
      .where((a) => a.id.contains('ring'))
      .toList();
  print('Anneaux disponibles (${rings.length}):');
  for (final ring in rings) {
    print('  - ${ring.name} ${ring.emoji}');
  }
  print('');

  // ============================================================================
  // RECHERCHE PAR ID
  // ============================================================================
  
  print('--- RECHERCHE PAR ID ---');
  
  final weapon = WeaponsDatabase.getById('katana');
  print('Arme trouvée: ${weapon?.name ?? "Non trouvée"}');
  
  final skill = SkillsDatabase.getById('backstab');
  print('Compétence trouvée: ${skill?.name ?? "Non trouvée"}');
  
  final armor = ArmorsDatabase.getById('celestial_armor');
  print('Armure trouvée: ${armor?.name ?? "Non trouvée"}');
  
  final accessory = AccessoriesDatabase.getById('phoenix_ring');
  print('Accessoire trouvé: ${accessory?.name ?? "Non trouvé"}');
  
  print('');

  // ============================================================================
  // STATISTIQUES GLOBALES
  // ============================================================================
  
  print('--- STATISTIQUES ---');
  print('Total d\'armes: ${WeaponsDatabase.allWeapons.length}');
  print('Total de compétences: ${SkillsDatabase.allSkills.length}');
  print('Total d\'armures: ${ArmorsDatabase.allArmors.length}');
  print('Total d\'accessoires: ${AccessoriesDatabase.allAccessories.length}');
  
  final totalItems = WeaponsDatabase.allWeapons.length +
                     ArmorsDatabase.allArmors.length +
                     AccessoriesDatabase.allAccessories.length;
  print('Total d\'équipements: $totalItems');
  print('');
}
