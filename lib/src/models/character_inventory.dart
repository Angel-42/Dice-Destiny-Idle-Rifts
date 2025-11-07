import 'equipment.dart';
import 'skill.dart';

/// Condition de déblocage pour un item
class UnlockCondition {
  final UnlockConditionType type;
  final dynamic value;
  final String description;

  const UnlockCondition({
    required this.type,
    required this.value,
    required this.description,
  });

  /// Vérifie si la condition est remplie
  bool isMet({
    required int characterLevel,
    required int characterStars,
    int? classPromotionCount,
  }) {
    switch (type) {
      case UnlockConditionType.level:
        return characterLevel >= (value as int);
      case UnlockConditionType.stars:
        return characterStars >= (value as int);
      case UnlockConditionType.classPromotion:
        return (classPromotionCount ?? 0) >= (value as int);
      case UnlockConditionType.always:
        return true;
    }
  }

  Map<String, dynamic> toJson() => {
    'type': type.name,
    'value': value,
    'description': description,
  };

  factory UnlockCondition.fromJson(Map<String, dynamic> json) => UnlockCondition(
    type: UnlockConditionType.values.byName(json['type']),
    value: json['value'],
    description: json['description'],
  );
}

enum UnlockConditionType {
  level,      // Niveau requis
  stars,      // Rareté requise (nombre d'étoiles)
  classPromotion, // Nombre de promotions de classe
  always,     // Toujours débloqué
}

/// Item d'inventaire avec condition de déblocage
class InventoryItem<T> {
  final T item;
  final UnlockCondition condition;
  final bool isDefault; // Item de départ

  const InventoryItem({
    required this.item,
    required this.condition,
    this.isDefault = false,
  });

  bool isUnlocked({
    required int characterLevel,
    required int characterStars,
    int? classPromotionCount,
  }) {
    return condition.isMet(
      characterLevel: characterLevel,
      characterStars: characterStars,
      classPromotionCount: classPromotionCount,
    );
  }

  Map<String, dynamic> toJson() => {
    'item': item is Equipment 
        ? (item as Equipment).toJson() 
        : (item as Skill).toJson(),
    'condition': condition.toJson(),
    'isDefault': isDefault,
    'itemType': item is Equipment ? 'equipment' : 'skill',
  };

  factory InventoryItem.fromJson(Map<String, dynamic> json) {
    final itemType = json['itemType'] as String;
    final item = itemType == 'equipment'
        ? Equipment.fromJson(json['item'])
        : Skill.fromJson(json['item']);
    
    return InventoryItem(
      item: item as T,
      condition: UnlockCondition.fromJson(json['condition']),
      isDefault: json['isDefault'] ?? false,
    );
  }
}

/// Inventaire personnel d'un personnage
class CharacterInventory {
  // Armes disponibles pour ce personnage
  final List<InventoryItem<Equipment>> weapons;
  
  // Armures disponibles
  final List<InventoryItem<Equipment>> armors;
  
  // Accessoires disponibles
  final List<InventoryItem<Equipment>> accessories;
  
  // Compétences disponibles
  final List<InventoryItem<Skill>> skills;

  CharacterInventory({
    List<InventoryItem<Equipment>>? weapons,
    List<InventoryItem<Equipment>>? armors,
    List<InventoryItem<Equipment>>? accessories,
    List<InventoryItem<Skill>>? skills,
  })  : weapons = weapons ?? [],
        armors = armors ?? [],
        accessories = accessories ?? [],
        skills = skills ?? [];

  /// Récupère toutes les armes (débloquées + bloquées)
  List<InventoryItem<Equipment>> getAllWeapons() => weapons;

  /// Récupère seulement les armes débloquées
  List<Equipment> getUnlockedWeapons({
    required int characterLevel,
    required int characterStars,
    int? classPromotionCount,
  }) {
    return weapons
        .where((item) => item.isUnlocked(
              characterLevel: characterLevel,
              characterStars: characterStars,
              classPromotionCount: classPromotionCount,
            ))
        .map((item) => item.item)
        .toList();
  }

  /// Récupère toutes les compétences (débloquées + bloquées)
  List<InventoryItem<Skill>> getAllSkills() => skills;

  /// Récupère seulement les compétences débloquées
  List<Skill> getUnlockedSkills({
    required int characterLevel,
    required int characterStars,
    int? classPromotionCount,
  }) {
    return skills
        .where((item) => item.isUnlocked(
              characterLevel: characterLevel,
              characterStars: characterStars,
              classPromotionCount: classPromotionCount,
            ))
        .map((item) => item.item)
        .toList();
  }

  Map<String, dynamic> toJson() => {
    'weapons': weapons.map((w) => w.toJson()).toList(),
    'armors': armors.map((a) => a.toJson()).toList(),
    'accessories': accessories.map((a) => a.toJson()).toList(),
    'skills': skills.map((s) => s.toJson()).toList(),
  };

  factory CharacterInventory.fromJson(Map<String, dynamic> json) {
    return CharacterInventory(
      weapons: (json['weapons'] as List?)
          ?.map((w) => InventoryItem<Equipment>.fromJson(w))
          .toList(),
      armors: (json['armors'] as List?)
          ?.map((a) => InventoryItem<Equipment>.fromJson(a))
          .toList(),
      accessories: (json['accessories'] as List?)
          ?.map((a) => InventoryItem<Equipment>.fromJson(a))
          .toList(),
      skills: (json['skills'] as List?)
          ?.map((s) => InventoryItem<Skill>.fromJson(s))
          .toList(),
    );
  }

  /// Crée un inventaire par défaut pour une classe donnée
  static CharacterInventory createDefault(String className) {
    return CharacterInventory(
      weapons: _getDefaultWeapons(className),
      armors: _getDefaultArmors(),
      accessories: _getDefaultAccessories(),
      skills: _getDefaultSkills(className),
    );
  }

  static List<InventoryItem<Equipment>> _getDefaultWeapons(String className) {
    // Warrior / Knight
    if (className.toLowerCase().contains('warrior') || className.toLowerCase().contains('knight')) {
      return [
        // Arme de départ
        InventoryItem(
          item: const Equipment(
            id: 'iron_sword',
            name: 'Iron Sword',
            emoji: '⚔️',
            type: EquipmentType.weapon,
            bonuses: {'attack': 5},
          ),
          condition: const UnlockCondition(
            type: UnlockConditionType.always,
            value: 0,
            description: 'Arme de départ',
          ),
          isDefault: true,
        ),
        // Arme niveau 5
        InventoryItem(
          item: const Equipment(
            id: 'bronze_axe',
            name: 'Bronze Axe',
            emoji: '🪓',
            type: EquipmentType.weapon,
            rarity: EquipmentRarity.common,
            bonuses: {'attack': 7, 'defense': 1},
          ),
          condition: const UnlockCondition(
            type: UnlockConditionType.level,
            value: 5,
            description: 'Niveau 5 requis',
          ),
        ),
        // Arme niveau 10
        InventoryItem(
          item: const Equipment(
            id: 'steel_sword',
            name: 'Steel Sword',
            emoji: '⚔️',
            type: EquipmentType.weapon,
            rarity: EquipmentRarity.uncommon,
            bonuses: {'attack': 10, 'defense': 2},
          ),
          condition: const UnlockCondition(
            type: UnlockConditionType.level,
            value: 10,
            description: 'Niveau 10 requis',
          ),
        ),
        // Arme niveau 15
        InventoryItem(
          item: const Equipment(
            id: 'battle_hammer',
            name: 'Battle Hammer',
            emoji: '🔨',
            type: EquipmentType.weapon,
            rarity: EquipmentRarity.uncommon,
            bonuses: {'attack': 13, 'defense': 3},
          ),
          condition: const UnlockCondition(
            type: UnlockConditionType.level,
            value: 15,
            description: 'Niveau 15 requis',
          ),
        ),
        // Arme niveau 20
        InventoryItem(
          item: const Equipment(
            id: 'silver_sword',
            name: 'Silver Sword',
            emoji: '⚔️',
            type: EquipmentType.weapon,
            rarity: EquipmentRarity.rare,
            bonuses: {'attack': 16, 'speed': 4},
          ),
          condition: const UnlockCondition(
            type: UnlockConditionType.level,
            value: 20,
            description: 'Niveau 20 requis',
          ),
        ),
        // Arme 3 étoiles
        InventoryItem(
          item: const Equipment(
            id: 'flame_blade',
            name: 'Flame Blade',
            emoji: '🔥',
            type: EquipmentType.weapon,
            rarity: EquipmentRarity.rare,
            bonuses: {'attack': 18, 'magic': 5},
          ),
          condition: const UnlockCondition(
            type: UnlockConditionType.stars,
            value: 3,
            description: '3★ requis',
          ),
        ),
        // Arme 5 étoiles
        InventoryItem(
          item: const Equipment(
            id: 'legendary_blade',
            name: 'Excalibur',
            emoji: '⚔️',
            type: EquipmentType.weapon,
            rarity: EquipmentRarity.legendary,
            bonuses: {'attack': 25, 'defense': 8, 'speed': 7},
          ),
          condition: const UnlockCondition(
            type: UnlockConditionType.stars,
            value: 5,
            description: '5★ requis',
          ),
        ),
      ];
    }
    
    // Mage / Wizard
    if (className.toLowerCase().contains('mage') || className.toLowerCase().contains('wizard')) {
      return [
        InventoryItem(
          item: const Equipment(
            id: 'wooden_staff',
            name: 'Wooden Staff',
            emoji: '🪄',
            type: EquipmentType.weapon,
            bonuses: {'magic': 6},
          ),
          condition: const UnlockCondition(
            type: UnlockConditionType.always,
            value: 0,
            description: 'Arme de départ',
          ),
          isDefault: true,
        ),
        InventoryItem(
          item: const Equipment(
            id: 'apprentice_tome',
            name: 'Apprentice Tome',
            emoji: '📖',
            type: EquipmentType.weapon,
            bonuses: {'magic': 8, 'speed': 2},
          ),
          condition: const UnlockCondition(
            type: UnlockConditionType.level,
            value: 5,
            description: 'Niveau 5 requis',
          ),
        ),
        InventoryItem(
          item: const Equipment(
            id: 'mystic_wand',
            name: 'Mystic Wand',
            emoji: '🪄',
            type: EquipmentType.weapon,
            rarity: EquipmentRarity.uncommon,
            bonuses: {'magic': 12, 'speed': 3},
          ),
          condition: const UnlockCondition(
            type: UnlockConditionType.level,
            value: 10,
            description: 'Niveau 10 requis',
          ),
        ),
        InventoryItem(
          item: const Equipment(
            id: 'crystal_staff',
            name: 'Crystal Staff',
            emoji: '✨',
            type: EquipmentType.weapon,
            rarity: EquipmentRarity.rare,
            bonuses: {'magic': 18, 'speed': 5},
          ),
          condition: const UnlockCondition(
            type: UnlockConditionType.level,
            value: 15,
            description: 'Niveau 15 requis',
          ),
        ),
        InventoryItem(
          item: const Equipment(
            id: 'archmage_grimoire',
            name: 'Archmage Grimoire',
            emoji: '📚',
            type: EquipmentType.weapon,
            rarity: EquipmentRarity.rare,
            bonuses: {'magic': 22, 'speed': 6, 'defense': 3},
          ),
          condition: const UnlockCondition(
            type: UnlockConditionType.level,
            value: 20,
            description: 'Niveau 20 requis',
          ),
        ),
        InventoryItem(
          item: const Equipment(
            id: 'staff_of_eternity',
            name: 'Staff of Eternity',
            emoji: '🌟',
            type: EquipmentType.weapon,
            rarity: EquipmentRarity.legendary,
            bonuses: {'magic': 30, 'speed': 8, 'defense': 5},
          ),
          condition: const UnlockCondition(
            type: UnlockConditionType.stars,
            value: 5,
            description: '5★ requis',
          ),
        ),
      ];
    }

    // Archer / Ranger
    if (className.toLowerCase().contains('archer') || className.toLowerCase().contains('ranger')) {
      return [
        InventoryItem(
          item: const Equipment(
            id: 'short_bow',
            name: 'Short Bow',
            emoji: '🏹',
            type: EquipmentType.weapon,
            bonuses: {'attack': 4, 'speed': 3},
          ),
          condition: const UnlockCondition(
            type: UnlockConditionType.always,
            value: 0,
            description: 'Arme de départ',
          ),
          isDefault: true,
        ),
        InventoryItem(
          item: const Equipment(
            id: 'hunting_bow',
            name: 'Hunting Bow',
            emoji: '🏹',
            type: EquipmentType.weapon,
            bonuses: {'attack': 8, 'speed': 5},
          ),
          condition: const UnlockCondition(
            type: UnlockConditionType.level,
            value: 5,
            description: 'Niveau 5 requis',
          ),
        ),
        InventoryItem(
          item: const Equipment(
            id: 'longbow',
            name: 'Longbow',
            emoji: '🏹',
            type: EquipmentType.weapon,
            rarity: EquipmentRarity.uncommon,
            bonuses: {'attack': 12, 'speed': 7},
          ),
          condition: const UnlockCondition(
            type: UnlockConditionType.level,
            value: 10,
            description: 'Niveau 10 requis',
          ),
        ),
        InventoryItem(
          item: const Equipment(
            id: 'composite_bow',
            name: 'Composite Bow',
            emoji: '🏹',
            type: EquipmentType.weapon,
            rarity: EquipmentRarity.rare,
            bonuses: {'attack': 16, 'speed': 9},
          ),
          condition: const UnlockCondition(
            type: UnlockConditionType.level,
            value: 15,
            description: 'Niveau 15 requis',
          ),
        ),
        InventoryItem(
          item: const Equipment(
            id: 'silver_hawk',
            name: 'Silver Hawk',
            emoji: '🦅',
            type: EquipmentType.weapon,
            rarity: EquipmentRarity.legendary,
            bonuses: {'attack': 24, 'speed': 12, 'luck': 5},
          ),
          condition: const UnlockCondition(
            type: UnlockConditionType.stars,
            value: 5,
            description: '5★ requis',
          ),
        ),
      ];
    }

    // Thief / Rogue
    if (className.toLowerCase().contains('thief') || className.toLowerCase().contains('rogue')) {
      return [
        InventoryItem(
          item: const Equipment(
            id: 'rusty_dagger',
            name: 'Rusty Dagger',
            emoji: '🗡️',
            type: EquipmentType.weapon,
            bonuses: {'attack': 3, 'speed': 5},
          ),
          condition: const UnlockCondition(
            type: UnlockConditionType.always,
            value: 0,
            description: 'Arme de départ',
          ),
          isDefault: true,
        ),
        InventoryItem(
          item: const Equipment(
            id: 'steel_dagger',
            name: 'Steel Dagger',
            emoji: '🗡️',
            type: EquipmentType.weapon,
            bonuses: {'attack': 7, 'speed': 7},
          ),
          condition: const UnlockCondition(
            type: UnlockConditionType.level,
            value: 5,
            description: 'Niveau 5 requis',
          ),
        ),
        InventoryItem(
          item: const Equipment(
            id: 'poison_blade',
            name: 'Poison Blade',
            emoji: '🐍',
            type: EquipmentType.weapon,
            rarity: EquipmentRarity.uncommon,
            bonuses: {'attack': 11, 'speed': 9},
          ),
          condition: const UnlockCondition(
            type: UnlockConditionType.level,
            value: 10,
            description: 'Niveau 10 requis',
          ),
        ),
        InventoryItem(
          item: const Equipment(
            id: 'shadow_strike',
            name: 'Shadow Strike',
            emoji: '🌑',
            type: EquipmentType.weapon,
            rarity: EquipmentRarity.rare,
            bonuses: {'attack': 15, 'speed': 11, 'luck': 4},
          ),
          condition: const UnlockCondition(
            type: UnlockConditionType.level,
            value: 15,
            description: 'Niveau 15 requis',
          ),
        ),
        InventoryItem(
          item: const Equipment(
            id: 'phantom_edge',
            name: 'Phantom Edge',
            emoji: '👻',
            type: EquipmentType.weapon,
            rarity: EquipmentRarity.legendary,
            bonuses: {'attack': 22, 'speed': 15, 'luck': 8},
          ),
          condition: const UnlockCondition(
            type: UnlockConditionType.stars,
            value: 5,
            description: '5★ requis',
          ),
        ),
      ];
    }

    // Défaut générique
    return [
      InventoryItem(
        item: DefaultWeapons.byClass[className] ?? const Equipment(
          id: 'basic_weapon',
          name: 'Basic Weapon',
          emoji: '🗡️',
          type: EquipmentType.weapon,
          bonuses: {'attack': 3},
        ),
        condition: const UnlockCondition(
          type: UnlockConditionType.always,
          value: 0,
          description: 'Arme de départ',
        ),
        isDefault: true,
      ),
    ];
  }

  static List<InventoryItem<Equipment>> _getDefaultArmors() {
    return [
      // Armure de base
      InventoryItem(
        item: const Equipment(
          id: 'cloth_armor',
          name: 'Cloth Armor',
          emoji: '👕',
          type: EquipmentType.armor,
          bonuses: {'defense': 3},
        ),
        condition: const UnlockCondition(
          type: UnlockConditionType.always,
          value: 0,
          description: 'Disponible',
        ),
        isDefault: true,
      ),
      // Niveau 5
      InventoryItem(
        item: const Equipment(
          id: 'leather_armor',
          name: 'Leather Armor',
          emoji: '🥋',
          type: EquipmentType.armor,
          bonuses: {'defense': 6, 'speed': 1},
        ),
        condition: const UnlockCondition(
          type: UnlockConditionType.level,
          value: 5,
          description: 'Niveau 5 requis',
        ),
      ),
      // Niveau 10
      InventoryItem(
        item: const Equipment(
          id: 'chainmail',
          name: 'Chainmail',
          emoji: '⛓️',
          type: EquipmentType.armor,
          rarity: EquipmentRarity.uncommon,
          bonuses: {'defense': 10},
        ),
        condition: const UnlockCondition(
          type: UnlockConditionType.level,
          value: 10,
          description: 'Niveau 10 requis',
        ),
      ),
      // Niveau 15
      InventoryItem(
        item: const Equipment(
          id: 'plate_armor',
          name: 'Plate Armor',
          emoji: '🛡️',
          type: EquipmentType.armor,
          rarity: EquipmentRarity.rare,
          bonuses: {'defense': 15, 'attack': 2},
        ),
        condition: const UnlockCondition(
          type: UnlockConditionType.level,
          value: 15,
          description: 'Niveau 15 requis',
        ),
      ),
      // 3 étoiles
      InventoryItem(
        item: const Equipment(
          id: 'dragon_scale',
          name: 'Dragon Scale Armor',
          emoji: '🐉',
          type: EquipmentType.armor,
          rarity: EquipmentRarity.rare,
          bonuses: {'defense': 18, 'magic': 5},
        ),
        condition: const UnlockCondition(
          type: UnlockConditionType.stars,
          value: 3,
          description: '3★ requis',
        ),
      ),
      // 5 étoiles
      InventoryItem(
        item: const Equipment(
          id: 'celestial_armor',
          name: 'Celestial Armor',
          emoji: '✨',
          type: EquipmentType.armor,
          rarity: EquipmentRarity.legendary,
          bonuses: {'defense': 25, 'magic': 8, 'speed': 5},
        ),
        condition: const UnlockCondition(
          type: UnlockConditionType.stars,
          value: 5,
          description: '5★ requis',
        ),
      ),
    ];
  }

  static List<InventoryItem<Equipment>> _getDefaultAccessories() {
    return [
      // Disponible de base
      InventoryItem(
        item: const Equipment(
          id: 'basic_ring',
          name: 'Simple Ring',
          emoji: '💍',
          type: EquipmentType.accessory,
          bonuses: {'luck': 2},
        ),
        condition: const UnlockCondition(
          type: UnlockConditionType.level,
          value: 5,
          description: 'Niveau 5 requis',
        ),
      ),
    ];
  }

  static List<InventoryItem<Skill>> _getDefaultSkills(String className) {
    // Warrior / Knight skills
    if (className.toLowerCase().contains('warrior') || className.toLowerCase().contains('knight')) {
      return [
        // Starting skill
        InventoryItem(
          item: const Skill(
            id: 'power_strike',
            name: 'Power Strike',
            emoji: '⚔️',
            description: 'Powerful attack dealing +50% damage',
            type: SkillType.active,
            statBonuses: {'damageMultiplier': 0.50},
          ),
          condition: const UnlockCondition(
            type: UnlockConditionType.always,
            value: 0,
            description: 'Starting skill',
          ),
          isDefault: true,
        ),
        // Level 5 skill
        InventoryItem(
          item: const Skill(
            id: 'shield_bash',
            name: 'Shield Bash',
            emoji: '🛡️',
            description: 'Stuns enemy while dealing damage',
            type: SkillType.active,
            statBonuses: {'damageMultiplier': 0.30, 'defense': 0.10},
          ),
          condition: const UnlockCondition(
            type: UnlockConditionType.level,
            value: 5,
            description: 'Level 5 required',
          ),
        ),
        // Level 10 skill
        InventoryItem(
          item: const Skill(
            id: 'berserker_rage',
            name: 'Berserker Rage',
            emoji: '💢',
            description: '+30% attack, -10% defense for 3 turns',
            type: SkillType.active,
            statBonuses: {'attack': 0.30, 'defense': -0.10},
          ),
          condition: const UnlockCondition(
            type: UnlockConditionType.level,
            value: 10,
            description: 'Level 10 required',
          ),
        ),
        // Level 15 skill
        InventoryItem(
          item: const Skill(
            id: 'iron_will',
            name: 'Iron Will',
            emoji: '💪',
            description: 'Passive: +15% defense and HP',
            type: SkillType.passive,
            statBonuses: {'defense': 0.15, 'maxHp': 0.15},
          ),
          condition: const UnlockCondition(
            type: UnlockConditionType.level,
            value: 15,
            description: 'Level 15 required',
          ),
        ),
        // 3 stars skill
        InventoryItem(
          item: const Skill(
            id: 'whirlwind_attack',
            name: 'Whirlwind Attack',
            emoji: '🌪️',
            description: 'AOE attack hitting all enemies for 80% damage',
            type: SkillType.active,
            statBonuses: {'damageMultiplier': 0.80},
          ),
          condition: const UnlockCondition(
            type: UnlockConditionType.stars,
            value: 3,
            description: '3★ required',
          ),
        ),
        // Ultimate (5 stars)
        InventoryItem(
          item: const Skill(
            id: 'legendary_strike',
            name: 'Legendary Strike',
            emoji: '⚡',
            description: 'Ultimate: Devastating blow dealing +200% damage',
            type: SkillType.ultimate,
            statBonuses: {'damageMultiplier': 2.00},
          ),
          condition: const UnlockCondition(
            type: UnlockConditionType.stars,
            value: 5,
            description: '5★ required',
          ),
        ),
      ];
    }
    
    // Mage / Wizard skills
    if (className.toLowerCase().contains('mage') || className.toLowerCase().contains('wizard')) {
      return [
        // Starting skill
        InventoryItem(
          item: const Skill(
            id: 'fireball',
            name: 'Fireball',
            emoji: '🔥',
            description: 'Launches a magical fireball (+30% magic damage)',
            type: SkillType.active,
            statBonuses: {'damageMultiplier': 0.30},
          ),
          condition: const UnlockCondition(
            type: UnlockConditionType.always,
            value: 0,
            description: 'Starting skill',
          ),
          isDefault: true,
        ),
        // Level 5 skill
        InventoryItem(
          item: const Skill(
            id: 'frost_bolt',
            name: 'Frost Bolt',
            emoji: '❄️',
            description: 'Ice attack that slows enemy (-20% speed)',
            type: SkillType.active,
            statBonuses: {'damageMultiplier': 0.25},
          ),
          condition: const UnlockCondition(
            type: UnlockConditionType.level,
            value: 5,
            description: 'Level 5 required',
          ),
        ),
        // Level 10 skill
        InventoryItem(
          item: const Skill(
            id: 'mana_shield',
            name: 'Mana Shield',
            emoji: '🔮',
            description: 'Magic barrier absorbing damage (+20% defense)',
            type: SkillType.active,
            statBonuses: {'defense': 0.20},
          ),
          condition: const UnlockCondition(
            type: UnlockConditionType.level,
            value: 10,
            description: 'Level 10 required',
          ),
        ),
        // Level 15 skill
        InventoryItem(
          item: const Skill(
            id: 'arcane_mastery',
            name: 'Arcane Mastery',
            emoji: '✨',
            description: 'Passive: +20% magic power',
            type: SkillType.passive,
            statBonuses: {'magic': 0.20},
          ),
          condition: const UnlockCondition(
            type: UnlockConditionType.level,
            value: 15,
            description: 'Level 15 required',
          ),
        ),
        // 3 stars skill
        InventoryItem(
          item: const Skill(
            id: 'chain_lightning',
            name: 'Chain Lightning',
            emoji: '⚡',
            description: 'Lightning that jumps between enemies',
            type: SkillType.active,
            statBonuses: {'damageMultiplier': 0.60},
          ),
          condition: const UnlockCondition(
            type: UnlockConditionType.stars,
            value: 3,
            description: '3★ required',
          ),
        ),
        // Ultimate (5 stars)
        InventoryItem(
          item: const Skill(
            id: 'meteor_storm',
            name: 'Meteor Storm',
            emoji: '☄️',
            description: 'Ultimate: Rains meteors on all enemies (+250% damage)',
            type: SkillType.ultimate,
            statBonuses: {'damageMultiplier': 2.50},
          ),
          condition: const UnlockCondition(
            type: UnlockConditionType.stars,
            value: 5,
            description: '5★ required',
          ),
        ),
      ];
    }

    // Archer / Ranger skills
    if (className.toLowerCase().contains('archer') || className.toLowerCase().contains('ranger')) {
      return [
        // Starting skill
        InventoryItem(
          item: const Skill(
            id: 'precise_shot',
            name: 'Precise Shot',
            emoji: '🎯',
            description: 'Accurate shot with +40% damage',
            type: SkillType.active,
            statBonuses: {'damageMultiplier': 0.40},
          ),
          condition: const UnlockCondition(
            type: UnlockConditionType.always,
            value: 0,
            description: 'Starting skill',
          ),
          isDefault: true,
        ),
        // Level 5 skill
        InventoryItem(
          item: const Skill(
            id: 'rapid_fire',
            name: 'Rapid Fire',
            emoji: '🏹',
            description: 'Multiple quick shots (+15% speed)',
            type: SkillType.active,
            statBonuses: {'damageMultiplier': 0.35, 'speed': 0.15},
          ),
          condition: const UnlockCondition(
            type: UnlockConditionType.level,
            value: 5,
            description: 'Level 5 required',
          ),
        ),
        // Level 10 skill
        InventoryItem(
          item: const Skill(
            id: 'hunters_mark',
            name: 'Hunter\'s Mark',
            emoji: '🔍',
            description: 'Marks target for +25% damage from all sources',
            type: SkillType.active,
            statBonuses: {'damageMultiplier': 0.25},
          ),
          condition: const UnlockCondition(
            type: UnlockConditionType.level,
            value: 10,
            description: 'Level 10 required',
          ),
        ),
        // Level 15 skill
        InventoryItem(
          item: const Skill(
            id: 'eagle_eye',
            name: 'Eagle Eye',
            emoji: '🦅',
            description: 'Passive: +20% speed and luck',
            type: SkillType.passive,
            statBonuses: {'speed': 0.20, 'luck': 0.20},
          ),
          condition: const UnlockCondition(
            type: UnlockConditionType.level,
            value: 15,
            description: 'Level 15 required',
          ),
        ),
        // 3 stars skill
        InventoryItem(
          item: const Skill(
            id: 'multi_shot',
            name: 'Multi Shot',
            emoji: '🎯',
            description: 'Shoots multiple arrows at once',
            type: SkillType.active,
            statBonuses: {'damageMultiplier': 0.70},
          ),
          condition: const UnlockCondition(
            type: UnlockConditionType.stars,
            value: 3,
            description: '3★ required',
          ),
        ),
        // Ultimate (5 stars)
        InventoryItem(
          item: const Skill(
            id: 'arrow_rain',
            name: 'Arrow Rain',
            emoji: '☔',
            description: 'Ultimate: Rain of arrows covering battlefield (+180% damage)',
            type: SkillType.ultimate,
            statBonuses: {'damageMultiplier': 1.80},
          ),
          condition: const UnlockCondition(
            type: UnlockConditionType.stars,
            value: 5,
            description: '5★ required',
          ),
        ),
      ];
    }

    // Thief / Rogue skills
    if (className.toLowerCase().contains('thief') || className.toLowerCase().contains('rogue')) {
      return [
        // Starting skill
        InventoryItem(
          item: const Skill(
            id: 'backstab',
            name: 'Backstab',
            emoji: '🗡️',
            description: 'Sneaky attack with critical damage (+100%)',
            type: SkillType.active,
            statBonuses: {'damageMultiplier': 1.00},
          ),
          condition: const UnlockCondition(
            type: UnlockConditionType.always,
            value: 0,
            description: 'Starting skill',
          ),
          isDefault: true,
        ),
        // Level 5 skill
        InventoryItem(
          item: const Skill(
            id: 'smoke_bomb',
            name: 'Smoke Bomb',
            emoji: '💨',
            description: 'Escapes and increases evasion (+30% speed)',
            type: SkillType.active,
            statBonuses: {'speed': 0.30},
          ),
          condition: const UnlockCondition(
            type: UnlockConditionType.level,
            value: 5,
            description: 'Level 5 required',
          ),
        ),
        // Level 10 skill
        InventoryItem(
          item: const Skill(
            id: 'poison_blade',
            name: 'Poison Blade',
            emoji: '🐍',
            description: 'Applies poison dealing damage over time',
            type: SkillType.active,
            statBonuses: {'damageMultiplier': 0.40},
          ),
          condition: const UnlockCondition(
            type: UnlockConditionType.level,
            value: 10,
            description: 'Level 10 required',
          ),
        ),
        // Level 15 skill
        InventoryItem(
          item: const Skill(
            id: 'shadow_step',
            name: 'Shadow Step',
            emoji: '🌑',
            description: 'Passive: +25% speed and evasion',
            type: SkillType.passive,
            statBonuses: {'speed': 0.25, 'luck': 0.15},
          ),
          condition: const UnlockCondition(
            type: UnlockConditionType.level,
            value: 15,
            description: 'Level 15 required',
          ),
        ),
        // 3 stars skill
        InventoryItem(
          item: const Skill(
            id: 'blade_dance',
            name: 'Blade Dance',
            emoji: '⚔️',
            description: 'Series of quick strikes with daggers',
            type: SkillType.active,
            statBonuses: {'damageMultiplier': 0.75, 'speed': 0.20},
          ),
          condition: const UnlockCondition(
            type: UnlockConditionType.stars,
            value: 3,
            description: '3★ required',
          ),
        ),
        // Ultimate (5 stars)
        InventoryItem(
          item: const Skill(
            id: 'assassinate',
            name: 'Assassinate',
            emoji: '💀',
            description: 'Ultimate: Instant kill attempt (+300% damage)',
            type: SkillType.ultimate,
            statBonuses: {'damageMultiplier': 3.00},
          ),
          condition: const UnlockCondition(
            type: UnlockConditionType.stars,
            value: 5,
            description: '5★ required',
          ),
        ),
      ];
    }

    // Cleric / Priest skills
    if (className.toLowerCase().contains('cleric') || className.toLowerCase().contains('priest')) {
      return [
        // Starting skill
        InventoryItem(
          item: const Skill(
            id: 'heal',
            name: 'Heal',
            emoji: '💚',
            description: 'Heals an ally (30% max HP)',
            type: SkillType.active,
            statBonuses: {'healMultiplier': 0.30},
          ),
          condition: const UnlockCondition(
            type: UnlockConditionType.always,
            value: 0,
            description: 'Starting skill',
          ),
          isDefault: true,
        ),
        // Level 5 skill
        InventoryItem(
          item: const Skill(
            id: 'bless',
            name: 'Bless',
            emoji: '✨',
            description: 'Increases ally stats (+15% all stats)',
            type: SkillType.active,
            statBonuses: {
              'attack': 0.15,
              'defense': 0.15,
              'magic': 0.15,
              'speed': 0.15,
            },
          ),
          condition: const UnlockCondition(
            type: UnlockConditionType.level,
            value: 5,
            description: 'Level 5 required',
          ),
        ),
        // Level 10 skill
        InventoryItem(
          item: const Skill(
            id: 'holy_light',
            name: 'Holy Light',
            emoji: '☀️',
            description: 'Deals magic damage to undead enemies (+50%)',
            type: SkillType.active,
            statBonuses: {'damageMultiplier': 0.50},
          ),
          condition: const UnlockCondition(
            type: UnlockConditionType.level,
            value: 10,
            description: 'Level 10 required',
          ),
        ),
        // Level 15 skill
        InventoryItem(
          item: const Skill(
            id: 'divine_protection',
            name: 'Divine Protection',
            emoji: '🛡️',
            description: 'Passive: +20% defense and magic resistance',
            type: SkillType.passive,
            statBonuses: {'defense': 0.20, 'magic': 0.20},
          ),
          condition: const UnlockCondition(
            type: UnlockConditionType.level,
            value: 15,
            description: 'Level 15 required',
          ),
        ),
        // 3 stars skill
        InventoryItem(
          item: const Skill(
            id: 'mass_heal',
            name: 'Mass Heal',
            emoji: '💚',
            description: 'Heals all allies (25% max HP each)',
            type: SkillType.active,
            statBonuses: {'healMultiplier': 0.25},
          ),
          condition: const UnlockCondition(
            type: UnlockConditionType.stars,
            value: 3,
            description: '3★ required',
          ),
        ),
        // Ultimate (5 stars)
        InventoryItem(
          item: const Skill(
            id: 'resurrection',
            name: 'Resurrection',
            emoji: '⚕️',
            description: 'Ultimate: Revives fallen ally with 50% HP',
            type: SkillType.ultimate,
            statBonuses: {'healMultiplier': 0.50},
          ),
          condition: const UnlockCondition(
            type: UnlockConditionType.stars,
            value: 5,
            description: '5★ required',
          ),
        ),
      ];
    }

    // Default/Peasant skills
    return [
      InventoryItem(
        item: const Skill(
          id: 'basic_attack',
          name: 'Basic Attack',
          emoji: '👊',
          description: 'Simple attack with +20% damage',
          type: SkillType.active,
          statBonuses: {'damageMultiplier': 0.20},
        ),
        condition: const UnlockCondition(
          type: UnlockConditionType.always,
          value: 0,
          description: 'Starting skill',
        ),
        isDefault: true,
      ),
      InventoryItem(
        item: const Skill(
          id: 'determination',
          name: 'Determination',
          emoji: '💪',
          description: 'Passive: +10% all stats',
          type: SkillType.passive,
          statBonuses: {
            'attack': 0.10,
            'defense': 0.10,
            'magic': 0.10,
            'speed': 0.10,
          },
        ),
        condition: const UnlockCondition(
          type: UnlockConditionType.level,
          value: 10,
          description: 'Level 10 required',
        ),
      ),
    ];
  }
}
