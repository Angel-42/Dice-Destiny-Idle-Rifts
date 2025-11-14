import '../models/equipment.dart';

/// Base de données centralisée de toutes les armes du jeu
class WeaponsDatabase {
  // ============================================================================
  // ÉPÉES (Swords) - Pour Guerriers/Chevaliers
  // ============================================================================
  
  static const Equipment ironSword = Equipment(
    id: 'iron_sword',
    name: 'Iron Sword',
    emoji: '⚔️',
    sprite: 'assets/weapons/swords/iron_sword_save.png',
    type: EquipmentType.weapon,
    rarity: EquipmentRarity.common,
    bonuses: {'attack': 5},
  );

  static const Equipment steelSword = Equipment(
    id: 'steel_sword',
    name: 'Steel Sword',
    emoji: '⚔️',
    sprite: 'assets/weapons/swords/steel_sword_save.png',
    type: EquipmentType.weapon,
    rarity: EquipmentRarity.uncommon,
    bonuses: {'attack': 10, 'defense': 2},
  );

  static const Equipment silverSword = Equipment(
    id: 'silver_sword',
    name: 'Silver Sword',
    emoji: '⚔️',
    sprite: 'assets/weapons/swords/silver_sword_save.png',
    type: EquipmentType.weapon,
    rarity: EquipmentRarity.rare,
    bonuses: {'attack': 16, 'speed': 4},
  );

  static const Equipment flameBlade = Equipment(
    id: 'flame_blade',
    name: 'Flame Blade',
    emoji: '🔥',
    sprite: 'assets/weapons/swords/flame_blade_save.png',
    type: EquipmentType.weapon,
    rarity: EquipmentRarity.rare,
    bonuses: {'attack': 18, 'magic': 5},
  );

  static const Equipment excalibur = Equipment(
    id: 'excalibur',
    name: 'Excalibur',
    emoji: '⚔️',
    sprite: 'assets/weapons/swords/excalibur_save.png',
    type: EquipmentType.weapon,
    rarity: EquipmentRarity.legendary,
    bonuses: {'attack': 25, 'defense': 8, 'speed': 7},
  );

  static const Equipment falchion = Equipment(
    id: 'falchion',
    name: 'Falchion',
    emoji: '⚔️',
    sprite: 'assets/weapons/swords/falchion_save.png',
    type: EquipmentType.weapon,
    rarity: EquipmentRarity.legendary,
    bonuses: {'attack': 15, 'luck': 5},
  );

  static const Equipment shadowSword = Equipment(
    id: 'shadow_sword',
    name: 'Shadow Sword',
    emoji: '🌑',
    sprite: 'assets/weapons/swords/shadow_sword_save.png',
    type: EquipmentType.weapon,
    rarity: EquipmentRarity.epic,
    bonuses: {'attack': 20, 'speed': 6, 'luck': 4},
  );

  static const Equipment dragonSlayer = Equipment(
    id: 'dragon_slayer',
    name: 'Dragon Slayer',
    emoji: '🐉',
    sprite: 'assets/weapons/swords/dragon_slayer_save.png',
    type: EquipmentType.weapon,
    rarity: EquipmentRarity.legendary,
    bonuses: {'attack': 28, 'defense': 5, 'magic': 3},
  );

  // ============================================================================
  // HACHES (Axes) - Pour Guerriers
  // ============================================================================

  static const Equipment bronzeAxe = Equipment(
    id: 'bronze_axe',
    name: 'Bronze Axe',
    emoji: '🪓',
    sprite: 'assets/weapons/axes/bronze_axe_save.png',
    type: EquipmentType.weapon,
    rarity: EquipmentRarity.common,
    bonuses: {'attack': 7, 'defense': 1},
  );

  static const Equipment steelAxe = Equipment(
    id: 'steel_axe',
    name: 'Steel Axe',
    emoji: '🪓',
    sprite: 'assets/weapons/axes/steel_axe_save.png',
    type: EquipmentType.weapon,
    rarity: EquipmentRarity.uncommon,
    bonuses: {'attack': 12, 'defense': 2},
  );

  static const Equipment battleHammer = Equipment(
    id: 'battle_hammer',
    name: 'Battle Hammer',
    emoji: '🔨',
    sprite: 'assets/weapons/axes/battle_hammer_save.png',
    type: EquipmentType.weapon,
    rarity: EquipmentRarity.uncommon,
    bonuses: {'attack': 13, 'defense': 3},
  );

  static const Equipment titanAxe = Equipment(
    id: 'titan_axe',
    name: 'Titan Axe',
    emoji: '⚒️',
    sprite: 'assets/weapons/axes/titan_axe_save.png',
    type: EquipmentType.weapon,
    rarity: EquipmentRarity.rare,
    bonuses: {'attack': 19, 'defense': 4},
  );

  static const Equipment stormbreaker = Equipment(
    id: 'stormbreaker',
    name: 'Stormbreaker',
    emoji: '⚡',
    sprite: 'assets/weapons/axes/stormbreaker_save.png',
    type: EquipmentType.weapon,
    rarity: EquipmentRarity.legendary,
    bonuses: {'attack': 26, 'defense': 6, 'magic': 5},
  );

  // ============================================================================
  // BÂTONS (Staffs) - Pour Mages
  // ============================================================================

  static const Equipment woodenStaff = Equipment(
    id: 'wooden_staff',
    name: 'Wooden Staff',
    emoji: '🪄',
    sprite: 'assets/weapons/staffs/wooden_staff_save.png',
    type: EquipmentType.weapon,
    rarity: EquipmentRarity.common,
    bonuses: {'magic': 6},
  );

  static const Equipment mysticWand = Equipment(
    id: 'mystic_wand',
    name: 'Mystic Wand',
    emoji: '🪄',
    sprite: 'assets/weapons/staffs/mystic_wand_save.png',
    type: EquipmentType.weapon,
    rarity: EquipmentRarity.uncommon,
    bonuses: {'magic': 12, 'speed': 3},
  );

  static const Equipment crystalStaff = Equipment(
    id: 'crystal_staff',
    name: 'Crystal Staff',
    emoji: '✨',
    sprite: 'assets/weapons/staffs/crystal_staff_save.png',
    type: EquipmentType.weapon,
    rarity: EquipmentRarity.rare,
    bonuses: {'magic': 18, 'speed': 5},
  );

  static const Equipment staffOfEternity = Equipment(
    id: 'staff_of_eternity',
    name: 'Staff of Eternity',
    emoji: '🌟',
    sprite: 'assets/weapons/staffs/staff_of_eternity_save.png',
    type: EquipmentType.weapon,
    rarity: EquipmentRarity.legendary,
    bonuses: {'magic': 30, 'speed': 8, 'defense': 5},
  );

  static const Equipment elderWand = Equipment(
    id: 'elder_wand',
    name: 'Elder Wand',
    emoji: '🪄',
    sprite: 'assets/weapons/staffs/elder_wand_save.png',
    type: EquipmentType.weapon,
    rarity: EquipmentRarity.legendary,
    bonuses: {'magic': 28, 'luck': 7},
  );

  // ============================================================================
  // TOMES (Books) - Pour Mages
  // ============================================================================

  static const Equipment apprenticeTome = Equipment(
    id: 'apprentice_tome',
    name: 'Apprentice Tome',
    emoji: '📖',
    sprite: 'assets/weapons/books/apprentice_tome_save.png',
    type: EquipmentType.weapon,
    rarity: EquipmentRarity.common,
    bonuses: {'magic': 8, 'speed': 2},
  );

  static const Equipment archmageGrimoire = Equipment(
    id: 'archmage_grimoire',
    name: 'Archmage Grimoire',
    emoji: '📚',
    sprite: 'assets/weapons/books/archmage_grimoire_save.png',
    type: EquipmentType.weapon,
    rarity: EquipmentRarity.rare,
    bonuses: {'magic': 22, 'speed': 6, 'defense': 3},
  );

  static const Equipment necronomiconEx = Equipment(
    id: 'necronomicon_ex',
    name: 'Necronomicon Ex',
    emoji: '📕',
    sprite: 'assets/weapons/books/necronomicon_ex_save.png',
    type: EquipmentType.weapon,
    rarity: EquipmentRarity.legendary,
    bonuses: {'magic': 32, 'speed': 4, 'luck': 5},
  );

  // ============================================================================
  // ARCS (Bows) - Pour Archers
  // ============================================================================

  static const Equipment shortBow = Equipment(
    id: 'short_bow',
    name: 'Short Bow',
    emoji: '🏹',
    sprite: 'assets/weapons/bows/short_bow_save.png',
    type: EquipmentType.weapon,
    rarity: EquipmentRarity.common,
    bonuses: {'attack': 4, 'speed': 3},
  );

  static const Equipment huntingBow = Equipment(
    id: 'hunting_bow',
    name: 'Hunting Bow',
    emoji: '🏹',
    sprite: 'assets/weapons/bows/hunting_bow_save.png',
    type: EquipmentType.weapon,
    rarity: EquipmentRarity.common,
    bonuses: {'attack': 8, 'speed': 5},
  );

  static const Equipment longbow = Equipment(
    id: 'longbow',
    name: 'Longbow',
    emoji: '🏹',
    sprite: 'assets/weapons/bows/longbow_save.png',
    type: EquipmentType.weapon,
    rarity: EquipmentRarity.uncommon,
    bonuses: {'attack': 12, 'speed': 7},
  );

  static const Equipment compositeBow = Equipment(
    id: 'composite_bow',
    name: 'Composite Bow',
    emoji: '🏹',
    sprite: 'assets/weapons/bows/composite_bow_save.png',
    type: EquipmentType.weapon,
    rarity: EquipmentRarity.rare,
    bonuses: {'attack': 16, 'speed': 9},
  );

  static const Equipment silverHawk = Equipment(
    id: 'silver_hawk',
    name: 'Silver Hawk',
    emoji: '🦅',
    sprite: 'assets/weapons/bows/silver_hawk_save.png',
    type: EquipmentType.weapon,
    rarity: EquipmentRarity.legendary,
    bonuses: {'attack': 24, 'speed': 12, 'luck': 5},
  );

  static const Equipment windcutter = Equipment(
    id: 'windcutter',
    name: 'Windcutter',
    emoji: '🌪️',
    sprite: 'assets/weapons/bows/windcutter_save.png',
    type: EquipmentType.weapon,
    rarity: EquipmentRarity.epic,
    bonuses: {'attack': 20, 'speed': 11, 'magic': 3},
  );

  // ============================================================================
  // DAGUES (Daggers) - Pour Voleurs/Assassins
  // ============================================================================

  static const Equipment rustyDagger = Equipment(
    id: 'rusty_dagger',
    name: 'Rusty Dagger',
    emoji: '🗡️',
    sprite: 'assets/weapons/daggers/rusty_dagger_save.png',
    type: EquipmentType.weapon,
    rarity: EquipmentRarity.common,
    bonuses: {'attack': 3, 'speed': 5},
  );

  static const Equipment ironDagger = Equipment(
    id: 'iron_dagger',
    name: 'Iron Dagger',
    emoji: '🗡️',
    sprite: 'assets/weapons/daggers/iron_dagger_save.png',
    type: EquipmentType.weapon,
    rarity: EquipmentRarity.common,
    bonuses: {'attack': 5, 'speed': 6},
  );

  static const Equipment steelDagger = Equipment(
    id: 'steel_dagger',
    name: 'Steel Dagger',
    emoji: '🗡️',
    sprite: 'assets/weapons/daggers/steel_dagger_save.png',
    type: EquipmentType.weapon,
    rarity: EquipmentRarity.uncommon,
    bonuses: {'attack': 7, 'speed': 7},
  );

  static const Equipment poisonBlade = Equipment(
    id: 'poison_blade',
    name: 'Poison Blade',
    emoji: '🐍',
    sprite: 'assets/weapons/daggers/poison_blade_save.png',
    type: EquipmentType.weapon,
    rarity: EquipmentRarity.uncommon,
    bonuses: {'attack': 11, 'speed': 9},
  );

  static const Equipment shadowStrike = Equipment(
    id: 'shadow_strike',
    name: 'Shadow Strike',
    emoji: '🌑',
    sprite: 'assets/weapons/daggers/shadow_strike_save.png',
    type: EquipmentType.weapon,
    rarity: EquipmentRarity.rare,
    bonuses: {'attack': 15, 'speed': 11, 'luck': 4},
  );

  static const Equipment phantomEdge = Equipment(
    id: 'phantom_edge',
    name: 'Phantom Edge',
    emoji: '👻',
    sprite: 'assets/weapons/daggers/phantom_edge_save.png',
    type: EquipmentType.weapon,
    rarity: EquipmentRarity.legendary,
    bonuses: {'attack': 22, 'speed': 15, 'luck': 8},
  );

  static const Equipment bloodDrinker = Equipment(
    id: 'blood_drinker',
    name: 'Blood Drinker',
    emoji: '🩸',
    sprite: 'assets/weapons/daggers/blood_drinker_save.png',
    type: EquipmentType.weapon,
    rarity: EquipmentRarity.epic,
    bonuses: {'attack': 19, 'speed': 13, 'magic': 2},
  );

  // ============================================================================
  // LANCES (Spears) - Pour Lanciers
  // ============================================================================

  static const Equipment ironSpear = Equipment(
    id: 'iron_spear',
    name: 'Iron Spear',
    emoji: '🔱',
    sprite: 'assets/weapons/spears/iron_spear_save.png',
    type: EquipmentType.weapon,
    rarity: EquipmentRarity.common,
    bonuses: {'attack': 6, 'defense': 2},
  );

  static const Equipment steelLance = Equipment(
    id: 'steel_lance',
    name: 'Steel Lance',
    emoji: '🔱',
    sprite: 'assets/weapons/spears/steel_lance_save.png',
    type: EquipmentType.weapon,
    rarity: EquipmentRarity.uncommon,
    bonuses: {'attack': 11, 'defense': 3},
  );

  static const Equipment dragonLance = Equipment(
    id: 'dragon_lance',
    name: 'Dragon Lance',
    emoji: '🐲',
    sprite: 'assets/weapons/spears/dragon_lance_save.png',
    type: EquipmentType.weapon,
    rarity: EquipmentRarity.rare,
    bonuses: {'attack': 17, 'defense': 5},
  );

  static const Equipment gungnir = Equipment(
    id: 'gungnir',
    name: 'Gungnir',
    emoji: '⚡',
    sprite: 'assets/weapons/spears/gungnir_save.png',
    type: EquipmentType.weapon,
    rarity: EquipmentRarity.legendary,
    bonuses: {'attack': 27, 'defense': 7, 'luck': 6},
  );

  // ============================================================================
  // BÂTONS DE SOIN (Healing Rods) - Pour Clercs
  // ============================================================================

  static const Equipment healingRod = Equipment(
    id: 'healing_rod',
    name: 'Healing Rod',
    emoji: '⚕️',
    sprite: 'assets/weapons/staffs/healing_rod_save.png',
    type: EquipmentType.weapon,
    rarity: EquipmentRarity.common,
    bonuses: {'magic': 3, 'defense': 2},
  );

  static const Equipment sacredStaff = Equipment(
    id: 'sacred_staff',
    name: 'Sacred Staff',
    emoji: '✝️',
    sprite: 'assets/weapons/staffs/sacred_staff_save.png',
    type: EquipmentType.weapon,
    rarity: EquipmentRarity.uncommon,
    bonuses: {'magic': 8, 'defense': 4},
  );

  static const Equipment divineScepter = Equipment(
    id: 'divine_scepter',
    name: 'Divine Scepter',
    emoji: '🕊️',
    sprite: 'assets/weapons/staffs/divine_scepter_save.png',
    type: EquipmentType.weapon,
    rarity: EquipmentRarity.rare,
    bonuses: {'magic': 14, 'defense': 6},
  );

  static const Equipment holyGrail = Equipment(
    id: 'holy_grail',
    name: 'Holy Grail',
    emoji: '🏆',
    sprite: 'assets/weapons/staffs/holy_grail_save.png',
    type: EquipmentType.weapon,
    rarity: EquipmentRarity.legendary,
    bonuses: {'magic': 24, 'defense': 10, 'luck': 8},
  );

  // ============================================================================
  // ARMES SPÉCIALES/EXOTIQUES
  // ============================================================================

  static const Equipment katana = Equipment(
    id: 'katana',
    name: 'Katana',
    emoji: '🗾',
    sprite: 'assets/weapons/special/katana_save.png',
    type: EquipmentType.weapon,
    rarity: EquipmentRarity.rare,
    bonuses: {'attack': 17, 'speed': 8},
  );

  static const Equipment scythe = Equipment(
    id: 'scythe',
    name: 'Death Scythe',
    emoji: '🪦',
    sprite: 'assets/weapons/special/scythe_save.png',
    type: EquipmentType.weapon,
    rarity: EquipmentRarity.epic,
    bonuses: {'attack': 21, 'magic': 6, 'speed': 4},
  );

  static const Equipment chakram = Equipment(
    id: 'chakram',
    name: 'Chakram',
    emoji: '⭕',
    sprite: 'assets/weapons/special/chakram_save.png',
    type: EquipmentType.weapon,
    rarity: EquipmentRarity.rare,
    bonuses: {'attack': 15, 'speed': 10},
  );

  static const Equipment claws = Equipment(
    id: 'steel_claws',
    name: 'Steel Claws',
    emoji: '🐾',
    sprite: 'assets/weapons/special/steel_claws_save.png',
    type: EquipmentType.weapon,
    rarity: EquipmentRarity.uncommon,
    bonuses: {'attack': 9, 'speed': 8},
  );

  // ============================================================================
  // LISTE COMPLÈTE ORGANISÉE PAR CATÉGORIE
  // ============================================================================

  static const Map<String, List<Equipment>> byCategory = {
    'swords': [
      ironSword,
      steelSword,
      silverSword,
      flameBlade,
      shadowSword,
      falchion,
      excalibur,
      dragonSlayer,
    ],
    'axes': [
      bronzeAxe,
      steelAxe,
      battleHammer,
      titanAxe,
      stormbreaker,
    ],
    'staffs': [
      woodenStaff,
      mysticWand,
      crystalStaff,
      elderWand,
      staffOfEternity,
    ],
    'tomes': [
      apprenticeTome,
      archmageGrimoire,
      necronomiconEx,
    ],
    'bows': [
      shortBow,
      huntingBow,
      longbow,
      compositeBow,
      windcutter,
      silverHawk,
    ],
    'daggers': [
      rustyDagger,
      ironDagger,
      steelDagger,
      poisonBlade,
      shadowStrike,
      bloodDrinker,
      phantomEdge,
    ],
    'spears': [
      ironSpear,
      steelLance,
      dragonLance,
      gungnir,
    ],
    'rods': [
      healingRod,
      sacredStaff,
      divineScepter,
      holyGrail,
    ],
    'special': [
      katana,
      scythe,
      chakram,
      claws,
    ],
  };

  static List<Equipment> get allWeapons {
    return byCategory.values.expand((list) => list).toList();
  }

  static Equipment? getById(String id) {
    try {
      return allWeapons.firstWhere((w) => w.id == id);
    } catch (e) {
      return null;
    }
  }

  static List<Equipment> getByRarity(EquipmentRarity rarity) {
    return allWeapons.where((w) => w.rarity == rarity).toList();
  }

  static List<Equipment> getByCategory(String category) {
    return byCategory[category] ?? [];
  }
}
