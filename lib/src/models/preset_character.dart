import 'persona.dart';
import 'character.dart';
import 'equipment.dart';
import 'skill.dart';
import 'class_tree.dart';
import 'character_inventory.dart';

/// Personnage prédéfini (template) pour le système de gacha
class PresetCharacter {
  final String id;
  final String name;
  final String title; // "Le Conquérant", "La Sage"...
  
  // Sprites pour différents contextes
  final String headshot;      // Icône dans la liste
  final String? lheadshot;    // Image longue pour les détails
  final String? pixel;        // Spritesheet pour les combats
  final String? fullsize;     // Image plein écran
  
  final int colorValue;
  final String description;
  final String backstory;
  final Persona persona;
  final CharacterRarity rarity;
  final Map<String, int> baseStats; // Stats de base
  final Equipment? starterWeapon;
  final List<String> voiceLines; // Phrases du personnage
  final List<String> tags; // Ex: ['Tank', 'Leader', 'DPS']
  
  final CharacterInventory? customInventory;

  const PresetCharacter({
    required this.id,
    required this.name,
    required this.title,
    required this.headshot,
    this.lheadshot,
    this.pixel,
    this.fullsize,
    required this.colorValue,
    required this.description,
    required this.backstory,
    required this.persona,
    required this.rarity,
    required this.baseStats,
    this.starterWeapon,
    this.voiceLines = const [],
    this.tags = const [],
    this.customInventory,
  });

  /// Convertit le preset en personnage jouable
  Character toCharacter() {
    final stats = CharacterStats(
      maxHp: baseStats['maxHp'] ?? 100,
      attack: baseStats['attack'] ?? 10,
      defense: baseStats['defense'] ?? 8,
      speed: baseStats['speed'] ?? 6,
      magic: baseStats['magic'] ?? 5,
      range: baseStats['range'] ?? 1,
      luck: baseStats['luck'] ?? 5,
      gold: 100,
      movement: baseStats['movement'] ?? 4, // Portée de déplacement par défaut
    );

    final appearance = CharacterAppearance(
      headshot: headshot,
      lheadshot: lheadshot,
      pixel: pixel,
      fullsize: fullsize,
      colorValue: colorValue,
      description: description,
    );

    // Déterminer les classes initiales selon le persona et la rareté
  final tree = ClassTree.instance;
    final noviceId = persona.characterClass.noviceId;
    final owned = <String>{noviceId};
    String? active = noviceId;

    if (rarity == CharacterRarity.epic || rarity == CharacterRarity.legendary) {
      final noviceNode = tree.get(noviceId);
      if (noviceNode != null && noviceNode.children.isNotEmpty) {
        final advId = noviceNode.children.first;
        owned.add(advId);
        active = advId;

        if (rarity == CharacterRarity.legendary) {
          final advNode = tree.get(advId);
          if (advNode != null && advNode.children.isNotEmpty) {
            final eliteId = advNode.children.first;
            owned.add(eliteId);
            active = eliteId;
          }
        }
      }
    }

    // Équiper les compétences de départ depuis l'inventaire custom
    List<Skill>? startingSkills;
    if (customInventory != null) {
      final allSkills = customInventory!.getAllSkills();
      
      // Prendre la première compétence active débloquée (toujours disponible)
      final activeSkills = allSkills
          .where((item) => 
              item.item.type == SkillType.active && 
              item.condition.type == UnlockConditionType.always)
          .map((item) => item.item)
          .toList();
      
      // Prendre les premières compétences passives débloquées (toujours disponibles)
      final passiveSkills = allSkills
          .where((item) => 
              item.item.type == SkillType.passive && 
              item.condition.type == UnlockConditionType.always)
          .map((item) => item.item)
          .toList();
      
      // Construire la liste : 1 active + jusqu'à 3 passives
      startingSkills = [
        if (activeSkills.isNotEmpty) activeSkills.first,
        ...passiveSkills.take(3),
      ];
    }

    return Character(
      name: name,
      persona: persona,
      stats: stats,
      appearance: appearance,
      weapon: starterWeapon,
      equippedSkills: startingSkills, // Utilise les compétences de l'inventaire custom
      basedRarity: rarity,
      currentRarity: rarity,
      initialOwnedClassIds: owned,
      activeClassId: active,
      inventory: customInventory, // Utilise l'inventaire personnalisé si fourni
    );
  }
}