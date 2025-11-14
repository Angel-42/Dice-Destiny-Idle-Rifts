import '../models/equipment.dart';

/// Base de données centralisée de toutes les armures et accessoires du jeu
class ArmorsDatabase {
  // ============================================================================
  // ARMURES LÉGÈRES
  // ============================================================================

  static const Equipment clothArmor = Equipment(
    id: 'cloth_armor',
    name: 'Cloth Armor',
    emoji: '👕',
    sprite: 'assets/equipments/armors/lightarmors/cloth_armor_save.png',
    type: EquipmentType.armor,
    rarity: EquipmentRarity.common,
    bonuses: {'defense': 3},
  );

  static const Equipment leatherArmor = Equipment(
    id: 'leather_armor',
    name: 'Leather Armor',
    emoji: '🥋',
    sprite: 'assets/equipments/armors/lightarmors/leather_armor_save.png',
    type: EquipmentType.armor,
    rarity: EquipmentRarity.common,
    bonuses: {'defense': 6, 'speed': 1},
  );

  static const Equipment reinforcedLeather = Equipment(
    id: 'reinforced_leather',
    name: 'Reinforced Leather',
    emoji: '🥋',
    sprite: 'assets/equipments/armors/lightarmors/reinforced_leather_save.png',
    type: EquipmentType.armor,
    rarity: EquipmentRarity.uncommon,
    bonuses: {'defense': 9, 'speed': 2},
  );

  static const Equipment shadowCloak = Equipment(
    id: 'shadow_cloak',
    name: 'Shadow Cloak',
    emoji: '🌑',
    sprite: 'assets/equipments/armors/lightarmors/shadow_cloak_save.png',
    type: EquipmentType.armor,
    rarity: EquipmentRarity.rare,
    bonuses: {'defense': 10, 'speed': 5, 'luck': 3},
  );

  static const Equipment elvenRobe = Equipment(
    id: 'elven_robe',
    name: 'Elven Robe',
    emoji: '🧥',
    sprite: 'assets/equipments/armors/lightarmors/elven_robe_save.png',
    type: EquipmentType.armor,
    rarity: EquipmentRarity.rare,
    bonuses: {'defense': 11, 'magic': 6, 'speed': 3},
  );

  // ============================================================================
  // ARMURES MOYENNES
  // ============================================================================

  static const Equipment chainmail = Equipment(
    id: 'chainmail',
    name: 'Chainmail',
    emoji: '⛓️',
    sprite: 'assets/equipments/armors/mediumarmors/chainmail_save.png',
    type: EquipmentType.armor,
    rarity: EquipmentRarity.uncommon,
    bonuses: {'defense': 10},
  );

  static const Equipment scaleArmor = Equipment(
    id: 'scale_armor',
    name: 'Scale Armor',
    emoji: '🐟',
    sprite: 'assets/equipments/armors/mediumarmors/scale_armor_save.png',
    type: EquipmentType.armor,
    rarity: EquipmentRarity.uncommon,
    bonuses: {'defense': 12, 'magic': 2},
  );

  static const Equipment knightArmor = Equipment(
    id: 'knight_armor',
    name: 'Knight Armor',
    emoji: '🛡️',
    sprite: 'assets/equipments/armors/mediumarmors/knight_armor_save.png',
    type: EquipmentType.armor,
    rarity: EquipmentRarity.rare,
    bonuses: {'defense': 16, 'attack': 2},
  );

  static const Equipment mythrilChain = Equipment(
    id: 'mythril_chain',
    name: 'Mythril Chain',
    emoji: '✨',
    sprite: 'assets/equipments/armors/mediumarmors/mythril_chain_save.png',
    type: EquipmentType.armor,
    rarity: EquipmentRarity.rare,
    bonuses: {'defense': 14, 'magic': 4, 'speed': 2},
  );

  // ============================================================================
  // ARMURES LOURDES
  // ============================================================================

  static const Equipment plateArmor = Equipment(
    id: 'plate_armor',
    name: 'Plate Armor',
    emoji: '🛡️',
    sprite: 'assets/equipments/armors/heavyarmors/plate_armor_save.png',
    type: EquipmentType.armor,
    rarity: EquipmentRarity.rare,
    bonuses: {'defense': 15, 'attack': 2},
  );

  static const Equipment fullPlate = Equipment(
    id: 'full_plate',
    name: 'Full Plate',
    emoji: '🛡️',
    sprite: 'assets/equipments/armors/heavyarmors/full_plate_save.png',
    type: EquipmentType.armor,
    rarity: EquipmentRarity.epic,
    bonuses: {'defense': 20, 'attack': 3},
  );

  static const Equipment dragonScaleArmor = Equipment(
    id: 'dragon_scale',
    name: 'Dragon Scale Armor',
    emoji: '🐉',
    sprite: 'assets/equipments/armors/heavyarmors/dragon_scale_armor_save.png',
    type: EquipmentType.armor,
    rarity: EquipmentRarity.rare,
    bonuses: {'defense': 18, 'magic': 5},
  );

  static const Equipment titanPlate = Equipment(
    id: 'titan_plate',
    name: 'Titan Plate',
    emoji: '⚒️',
    sprite: 'assets/equipments/armors/heavyarmors/titan_plate_save.png',
    type: EquipmentType.armor,
    rarity: EquipmentRarity.epic,
    bonuses: {'defense': 22, 'attack': 4, 'magic': 3},
  );

  // ============================================================================
  // ARMURES MAGIQUES
  // ============================================================================

  static const Equipment wizardRobe = Equipment(
    id: 'wizard_robe',
    name: 'Wizard Robe',
    emoji: '🧙',
    sprite: 'assets/equipments/armors/magicalarmors/wizard_robe_save.png',
    type: EquipmentType.armor,
    rarity: EquipmentRarity.uncommon,
    bonuses: {'defense': 8, 'magic': 8},
  );

  static const Equipment archmageRobe = Equipment(
    id: 'archmage_robe',
    name: 'Archmage Robe',
    emoji: '🧙‍♂️',
    sprite: 'assets/equipments/armors/magicalarmors/archmage_robe_save.png',
    type: EquipmentType.armor,
    rarity: EquipmentRarity.rare,
    bonuses: {'defense': 12, 'magic': 14, 'speed': 3},
  );

  static const Equipment astralCloak = Equipment(
    id: 'astral_cloak',
    name: 'Astral Cloak',
    emoji: '🌌',
    sprite: 'assets/equipments/armors/magicalarmors/astral_cloak_save.png',
    type: EquipmentType.armor,
    rarity: EquipmentRarity.epic,
    bonuses: {'defense': 14, 'magic': 18, 'speed': 5},
  );

  // ============================================================================
  // ARMURES LÉGENDAIRES
  // ============================================================================

  static const Equipment celestialArmor = Equipment(
    id: 'celestial_armor',
    name: 'Celestial Armor',
    emoji: '✨',
    sprite: 'assets/equipments/armors/legendaryarmors/celestial_armor_save.png',
    type: EquipmentType.armor,
    rarity: EquipmentRarity.legendary,
    bonuses: {'defense': 25, 'magic': 8, 'speed': 5},
  );

  static const Equipment demonPlate = Equipment(
    id: 'demon_plate',
    name: 'Demon Plate',
    emoji: '😈',
    sprite: 'assets/equipments/armors/legendaryarmors/demon_plate_save.png',
    type: EquipmentType.armor,
    rarity: EquipmentRarity.legendary,
    bonuses: {'defense': 23, 'attack': 10, 'magic': 5},
  );

  static const Equipment phoenixMail = Equipment(
    id: 'phoenix_mail',
    name: 'Phoenix Mail',
    emoji: '🔥',
    sprite: 'assets/equipments/armors/legendaryarmors/phoenix_mail_save.png',
    type: EquipmentType.armor,
    rarity: EquipmentRarity.legendary,
    bonuses: {'defense': 24, 'magic': 10, 'attack': 6},
  );

  static const Equipment aegisArmor = Equipment(
    id: 'aegis_armor',
    name: 'Aegis Armor',
    emoji: '🛡️',
    sprite: 'assets/equipments/armors/legendaryarmors/aegis_armor_save.png',
    type: EquipmentType.armor,
    rarity: EquipmentRarity.legendary,
    bonuses: {'defense': 30, 'magic': 5, 'luck': 5},
  );

  // ============================================================================
  // LISTE COMPLÈTE DES ARMURES
  // ============================================================================

  static const List<Equipment> allArmors = [
    // Légères
    clothArmor,
    leatherArmor,
    reinforcedLeather,
    shadowCloak,
    elvenRobe,
    // Moyennes
    chainmail,
    scaleArmor,
    knightArmor,
    mythrilChain,
    // Lourdes
    plateArmor,
    fullPlate,
    dragonScaleArmor,
    titanPlate,
    // Magiques
    wizardRobe,
    archmageRobe,
    astralCloak,
    // Légendaires
    celestialArmor,
    demonPlate,
    phoenixMail,
    aegisArmor,
  ];

  /// Récupère une armure par son ID
  static Equipment? getById(String id) {
    try {
      return allArmors.firstWhere((a) => a.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Filtre par rareté
  static List<Equipment> getByRarity(EquipmentRarity rarity) {
    return allArmors.where((a) => a.rarity == rarity).toList();
  }
}

/// Base de données des accessoires
class AccessoriesDatabase {
  // ============================================================================
  // ANNEAUX (Rings)
  // ============================================================================

  static const Equipment basicRing = Equipment(
    id: 'basic_ring',
    name: 'Simple Ring',
    emoji: '💍',
    sprite: 'assets/equipments/accessories/rings/basic_ring_save.png',
    type: EquipmentType.accessory,
    rarity: EquipmentRarity.common,
    bonuses: {'luck': 2},
  );

  static const Equipment strengthRing = Equipment(
    id: 'strength_ring',
    name: 'Ring of Strength',
    emoji: '💪',
    sprite: 'assets/equipments/accessories/rings/strength_ring_save.png',
    type: EquipmentType.accessory,
    rarity: EquipmentRarity.uncommon,
    bonuses: {'attack': 5},
  );

  static const Equipment defenseRing = Equipment(
    id: 'defense_ring',
    name: 'Ring of Defense',
    emoji: '🛡️',
    sprite: 'assets/equipments/accessories/rings/defense_ring_save.png',
    type: EquipmentType.accessory,
    rarity: EquipmentRarity.uncommon,
    bonuses: {'defense': 5},
  );

  static const Equipment magicRing = Equipment(
    id: 'magic_ring',
    name: 'Ring of Magic',
    emoji: '✨',
    sprite: 'assets/equipments/accessories/rings/magic_ring_save.png',
    type: EquipmentType.accessory,
    rarity: EquipmentRarity.uncommon,
    bonuses: {'magic': 5},
  );

  static const Equipment speedRing = Equipment(
    id: 'speed_ring',
    name: 'Ring of Speed',
    emoji: '⚡',
    sprite: 'assets/equipments/accessories/rings/speed_ring_save.png',
    type: EquipmentType.accessory,
    rarity: EquipmentRarity.uncommon,
    bonuses: {'speed': 5},
  );

  static const Equipment fortuneRing = Equipment(
    id: 'fortune_ring',
    name: 'Ring of Fortune',
    emoji: '🍀',
    sprite: 'assets/equipments/accessories/rings/fortune_ring_save.png',
    type: EquipmentType.accessory,
    rarity: EquipmentRarity.rare,
    bonuses: {'luck': 8},
  );

  static const Equipment powerRing = Equipment(
    id: 'power_ring',
    name: 'Ring of Power',
    emoji: '💎',
    sprite: 'assets/equipments/accessories/rings/power_ring_save.png',
    type: EquipmentType.accessory,
    rarity: EquipmentRarity.rare,
    bonuses: {'attack': 8, 'magic': 8},
  );

  static const Equipment dragonRing = Equipment(
    id: 'dragon_ring',
    name: 'Dragon Ring',
    emoji: '🐲',
    sprite: 'assets/equipments/accessories/rings/dragon_ring_save.png',
    type: EquipmentType.accessory,
    rarity: EquipmentRarity.epic,
    bonuses: {'attack': 10, 'magic': 10, 'defense': 5},
  );

  static const Equipment phoenixRing = Equipment(
    id: 'phoenix_ring',
    name: 'Phoenix Ring',
    emoji: '🔥',
    sprite: 'assets/equipments/accessories/rings/phoenix_ring_save.png',
    type: EquipmentType.accessory,
    rarity: EquipmentRarity.epic,
    bonuses: {'magic': 12, 'speed': 6},
  );

  // ============================================================================
  // AMULETTES (Amulets)
  // ============================================================================

  static const Equipment leatherCharm = Equipment(
    id: 'leather_charm',
    name: 'Leather Charm',
    emoji: '🔖',
    sprite: 'assets/equipments/accessories/amulets/leather_charm_save.png',
    type: EquipmentType.accessory,
    rarity: EquipmentRarity.common,
    bonuses: {'defense': 3},
  );

  static const Equipment vitalityAmulet = Equipment(
    id: 'vitality_amulet',
    name: 'Amulet of Vitality',
    emoji: '❤️',
    sprite: 'assets/equipments/accessories/amulets/vitality_amulet_save.png',
    type: EquipmentType.accessory,
    rarity: EquipmentRarity.uncommon,
    bonuses: {'maxHp': 20},
  );

  static const Equipment protectionAmulet = Equipment(
    id: 'protection_amulet',
    name: 'Amulet of Protection',
    emoji: '🛡️',
    sprite: 'assets/equipments/accessories/amulets/protection_amulet_save.png',
    type: EquipmentType.accessory,
    rarity: EquipmentRarity.rare,
    bonuses: {'defense': 8, 'magic': 4},
  );

  static const Equipment sagesAmulet = Equipment(
    id: 'sages_amulet',
    name: 'Sage\'s Amulet',
    emoji: '📿',
    sprite: 'assets/equipments/accessories/amulets/sages_amulet_save.png',
    type: EquipmentType.accessory,
    rarity: EquipmentRarity.rare,
    bonuses: {'magic': 10, 'luck': 4},
  );

  static const Equipment holySymbol = Equipment(
    id: 'holy_symbol',
    name: 'Holy Symbol',
    emoji: '✝️',
    sprite: 'assets/equipments/accessories/amulets/holy_symbol_save.png',
    type: EquipmentType.accessory,
    rarity: EquipmentRarity.epic,
    bonuses: {'magic': 12, 'defense': 6, 'luck': 5},
  );

  static const Equipment soulCrystal = Equipment(
    id: 'soul_crystal',
    name: 'Soul Crystal',
    emoji: '💎',
    sprite: 'assets/equipments/accessories/amulets/soul_crystal_save.png',
    type: EquipmentType.accessory,
    rarity: EquipmentRarity.legendary,
    bonuses: {'attack': 10, 'magic': 10, 'speed': 8, 'luck': 6},
  );

  // ============================================================================
  // CEINTURES (Belts)
  // ============================================================================

  static const Equipment leatherBelt = Equipment(
    id: 'leather_belt',
    name: 'Leather Belt',
    emoji: '🎗️',
    sprite: 'assets/equipments/accessories/belts/leather_belt_save.png',
    type: EquipmentType.accessory,
    rarity: EquipmentRarity.common,
    bonuses: {'defense': 2, 'attack': 1},
  );

  static const Equipment championBelt = Equipment(
    id: 'champion_belt',
    name: 'Champion Belt',
    emoji: '🥋',
    sprite: 'assets/equipments/accessories/belts/champion_belt_save.png',
    type: EquipmentType.accessory,
    rarity: EquipmentRarity.uncommon,
    bonuses: {'attack': 6, 'defense': 3},
  );

  static const Equipment giantBelt = Equipment(
    id: 'giant_belt',
    name: 'Giant Belt',
    emoji: '⚒️',
    sprite: 'assets/equipments/accessories/belts/giant_belt_save.png',
    type: EquipmentType.accessory,
    rarity: EquipmentRarity.rare,
    bonuses: {'attack': 9, 'defense': 6, 'maxHp': 15},
  );

  static const Equipment dragonBelt = Equipment(
    id: 'dragon_belt',
    name: 'Dragon Belt',
    emoji: '🐉',
    sprite: 'assets/equipments/accessories/belts/dragon_belt_save.png',
    type: EquipmentType.accessory,
    rarity: EquipmentRarity.epic,
    bonuses: {'attack': 12, 'defense': 8, 'magic': 5},
  );

  // ============================================================================
  // BOTTES (Boots)
  // ============================================================================

  static const Equipment travelBoots = Equipment(
    id: 'travel_boots',
    name: 'Travel Boots',
    emoji: '👢',
    sprite: 'assets/equipments/accessories/boots/travel_boots_save.png',
    type: EquipmentType.accessory,
    rarity: EquipmentRarity.common,
    bonuses: {'speed': 3},
  );

  static const Equipment swiftBoots = Equipment(
    id: 'swift_boots',
    name: 'Swift Boots',
    emoji: '🥾',
    sprite: 'assets/equipments/accessories/boots/swift_boots_save.png',
    type: EquipmentType.accessory,
    rarity: EquipmentRarity.uncommon,
    bonuses: {'speed': 6},
  );

  static const Equipment windwalkerBoots = Equipment(
    id: 'windwalker_boots',
    name: 'Windwalker Boots',
    emoji: '🌪️',
    sprite: 'assets/equipments/accessories/boots/windwalker_boots_save.png',
    type: EquipmentType.accessory,
    rarity: EquipmentRarity.rare,
    bonuses: {'speed': 10, 'luck': 3},
  );

  static const Equipment hermesBoots = Equipment(
    id: 'hermes_boots',
    name: 'Hermes Boots',
    emoji: '⚡',
    sprite: 'assets/equipments/accessories/boots/hermes_boots_save.png',
    type: EquipmentType.accessory,
    rarity: EquipmentRarity.epic,
    bonuses: {'speed': 15, 'attack': 5},
  );

  // ============================================================================
  // ACCESSOIRES SPÉCIAUX
  // ============================================================================

  static const Equipment luckyClover = Equipment(
    id: 'lucky_clover',
    name: 'Lucky Clover',
    emoji: '🍀',
    sprite: 'assets/equipments/accessories/special/lucky_clover_save.png',
    type: EquipmentType.accessory,
    rarity: EquipmentRarity.rare,
    bonuses: {'luck': 10},
  );

  static const Equipment warHorn = Equipment(
    id: 'war_horn',
    name: 'War Horn',
    emoji: '📯',
    sprite: 'assets/equipments/accessories/special/war_horn_save.png',
    type: EquipmentType.accessory,
    rarity: EquipmentRarity.rare,
    bonuses: {'attack': 8, 'luck': 4},
  );

  static const Equipment magicOrb = Equipment(
    id: 'magic_orb',
    name: 'Magic Orb',
    emoji: '🔮',
    sprite: 'assets/equipments/accessories/special/magic_orb_save.png',
    type: EquipmentType.accessory,
    rarity: EquipmentRarity.rare,
    bonuses: {'magic': 12, 'speed': 3},
  );

  static const Equipment crownOfKings = Equipment(
    id: 'crown_of_kings',
    name: 'Crown of Kings',
    emoji: '👑',
    sprite: 'assets/equipments/accessories/special/crown_of_kings_save.png',
    type: EquipmentType.accessory,
    rarity: EquipmentRarity.legendary,
    bonuses: {
      'attack': 8,
      'defense': 8,
      'magic': 8,
      'speed': 8,
      'luck': 8,
    },
  );

  static const Equipment infinityGauntlet = Equipment(
    id: 'infinity_gauntlet',
    name: 'Infinity Gauntlet',
    emoji: '💎',
    sprite: 'assets/equipments/accessories/special/infinity_gauntlet_save.png',
    type: EquipmentType.accessory,
    rarity: EquipmentRarity.legendary,
    bonuses: {
      'attack': 15,
      'magic': 15,
      'defense': 10,
    },
  );

  // ============================================================================
  // LISTE COMPLÈTE DES ACCESSOIRES
  // ============================================================================

  static const List<Equipment> allAccessories = [
    // Anneaux
    basicRing,
    strengthRing,
    defenseRing,
    magicRing,
    speedRing,
    fortuneRing,
    powerRing,
    dragonRing,
    phoenixRing,
    // Amulettes
    leatherCharm,
    vitalityAmulet,
    protectionAmulet,
    sagesAmulet,
    holySymbol,
    soulCrystal,
    // Ceintures
    leatherBelt,
    championBelt,
    giantBelt,
    dragonBelt,
    // Bottes
    travelBoots,
    swiftBoots,
    windwalkerBoots,
    hermesBoots,
    // Spéciaux
    luckyClover,
    warHorn,
    magicOrb,
    crownOfKings,
    infinityGauntlet,
  ];

  /// Récupère un accessoire par son ID
  static Equipment? getById(String id) {
    try {
      return allAccessories.firstWhere((a) => a.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Filtre par rareté
  static List<Equipment> getByRarity(EquipmentRarity rarity) {
    return allAccessories.where((a) => a.rarity == rarity).toList();
  }
}
