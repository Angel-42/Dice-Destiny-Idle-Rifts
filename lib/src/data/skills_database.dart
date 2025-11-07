import '../models/skill.dart';

/// Base de données centralisée de toutes les compétences du jeu
class SkillsDatabase {
  // ============================================================================
  // COMPÉTENCES ACTIVES - GUERRIER
  // ============================================================================

  static const Skill powerStrike = Skill(
    id: 'power_strike',
    name: 'Power Strike',
    emoji: '⚔️',
    description: 'Attaque puissante infligeant +50% de dégâts',
    type: SkillType.active,
    statBonuses: {'damageMultiplier': 0.50},
  );

  static const Skill whirlwind = Skill(
    id: 'whirlwind',
    name: 'Whirlwind',
    emoji: '🌪️',
    description: 'Attaque tournoyante frappant tous les ennemis proches (+40% dégâts)',
    type: SkillType.active,
    statBonuses: {'damageMultiplier': 0.40},
  );

  static const Skill berserk = Skill(
    id: 'berserk',
    name: 'Berserk',
    emoji: '😡',
    description: 'Entre en rage : +80% attaque, -20% défense pendant 3 tours',
    type: SkillType.active,
    statBonuses: {'damageMultiplier': 0.80, 'defense': -0.20},
  );

  static const Skill shieldBash = Skill(
    id: 'shield_bash',
    name: 'Shield Bash',
    emoji: '🛡️',
    description: 'Coup de bouclier étourdissant (+30% dégâts, étourdit 1 tour)',
    type: SkillType.active,
    statBonuses: {'damageMultiplier': 0.30},
  );

  static const Skill executionStrike = Skill(
    id: 'execution_strike',
    name: 'Execution Strike',
    emoji: '💀',
    description: 'Frappe mortelle : dégâts doublés si l\'ennemi a moins de 30% HP',
    type: SkillType.active,
    statBonuses: {'damageMultiplier': 1.00},
  );

  // ============================================================================
  // COMPÉTENCES ACTIVES - MAGE
  // ============================================================================

  static const Skill fireball = Skill(
    id: 'fireball',
    name: 'Fireball',
    emoji: '🔥',
    description: 'Lance une boule de feu magique (+60% dégâts magiques)',
    type: SkillType.active,
    statBonuses: {'damageMultiplier': 0.60},
  );

  static const Skill iceLance = Skill(
    id: 'ice_lance',
    name: 'Ice Lance',
    emoji: '❄️',
    description: 'Lance de glace perforante (+50% dégâts magiques, ralentit)',
    type: SkillType.active,
    statBonuses: {'damageMultiplier': 0.50},
  );

  static const Skill lightning = Skill(
    id: 'lightning',
    name: 'Lightning',
    emoji: '⚡',
    description: 'Éclair fulgurant (+70% dégâts magiques, ignore 20% résistance)',
    type: SkillType.active,
    statBonuses: {'damageMultiplier': 0.70},
  );

  static const Skill meteor = Skill(
    id: 'meteor',
    name: 'Meteor',
    emoji: '☄️',
    description: 'Invoque une météorite (+120% dégâts magiques de zone)',
    type: SkillType.ultimate,
    statBonuses: {'damageMultiplier': 1.20},
  );

  static const Skill arcaneBlast = Skill(
    id: 'arcane_blast',
    name: 'Arcane Blast',
    emoji: '✨',
    description: 'Explosion d\'énergie arcanique pure (+80% dégâts magiques)',
    type: SkillType.active,
    statBonuses: {'damageMultiplier': 0.80},
  );

  static const Skill manaDrain = Skill(
    id: 'mana_drain',
    name: 'Mana Drain',
    emoji: '🌀',
    description: 'Draine l\'énergie de l\'ennemi (+40% dégâts, restaure HP)',
    type: SkillType.active,
    statBonuses: {'damageMultiplier': 0.40, 'healMultiplier': 0.20},
  );

  // ============================================================================
  // COMPÉTENCES ACTIVES - ARCHER/ROGUE
  // ============================================================================

  static const Skill backstab = Skill(
    id: 'backstab',
    name: 'Backstab',
    emoji: '🗡️',
    description: 'Attaque sournoise avec dégâts critiques (+100% dégâts)',
    type: SkillType.active,
    statBonuses: {'damageMultiplier': 1.00},
  );

  static const Skill multiShot = Skill(
    id: 'multi_shot',
    name: 'Multi-Shot',
    emoji: '🏹',
    description: 'Tire plusieurs flèches (+30% dégâts par cible)',
    type: SkillType.active,
    statBonuses: {'damageMultiplier': 0.30},
  );

  static const Skill snipe = Skill(
    id: 'snipe',
    name: 'Snipe',
    emoji: '🎯',
    description: 'Tir de précision : +150% dégâts critiques garantis',
    type: SkillType.active,
    statBonuses: {'damageMultiplier': 1.50},
  );

  static const Skill poisonArrow = Skill(
    id: 'poison_arrow',
    name: 'Poison Arrow',
    emoji: '🐍',
    description: 'Flèche empoisonnée : dégâts sur la durée (3 tours)',
    type: SkillType.active,
    statBonuses: {'damageMultiplier': 0.40},
  );

  static const Skill shadowStep = Skill(
    id: 'shadow_step',
    name: 'Shadow Step',
    emoji: '👤',
    description: 'Se téléporte derrière l\'ennemi (+70% dégâts)',
    type: SkillType.active,
    statBonuses: {'damageMultiplier': 0.70, 'evasion': 0.50},
  );

  // ============================================================================
  // COMPÉTENCES ACTIVES - CLERC/SUPPORT
  // ============================================================================

  static const Skill heal = Skill(
    id: 'heal',
    name: 'Heal',
    emoji: '💚',
    description: 'Soigne un allié (40% HP max)',
    type: SkillType.active,
    statBonuses: {'healMultiplier': 0.40},
  );

  static const Skill massHeal = Skill(
    id: 'mass_heal',
    name: 'Mass Heal',
    emoji: '💖',
    description: 'Soigne tous les alliés (25% HP max)',
    type: SkillType.active,
    statBonuses: {'healMultiplier': 0.25},
  );

  static const Skill resurrection = Skill(
    id: 'resurrection',
    name: 'Resurrection',
    emoji: '✝️',
    description: 'Ressuscite un allié tombé au combat (50% HP)',
    type: SkillType.ultimate,
    statBonuses: {'healMultiplier': 0.50},
  );

  static const Skill bless = Skill(
    id: 'bless',
    name: 'Bless',
    emoji: '🙏',
    description: 'Bénédiction : +20% toutes stats pour 3 tours',
    type: SkillType.active,
    statBonuses: {
      'attack': 0.20,
      'defense': 0.20,
      'magic': 0.20,
      'speed': 0.20,
    },
  );

  static const Skill holySmite = Skill(
    id: 'holy_smite',
    name: 'Holy Smite',
    emoji: '⚡',
    description: 'Châtiment divin : +90% dégâts magiques contre les morts-vivants',
    type: SkillType.active,
    statBonuses: {'damageMultiplier': 0.90},
  );

  // ============================================================================
  // COMPÉTENCES PASSIVES - RACE
  // ============================================================================

  static const Skill humanAdaptability = Skill(
    id: 'adaptability',
    name: 'Adaptability',
    emoji: '👤',
    description: '+10% XP gagné',
    type: SkillType.passive,
    statBonuses: {'xpGain': 0.10},
  );

  static const Skill elvenGrace = Skill(
    id: 'elven_grace',
    name: 'Elven Grace',
    emoji: '🧝',
    description: '+5% vitesse et esquive',
    type: SkillType.passive,
    statBonuses: {'speed': 0.05, 'evasion': 0.05},
  );

  static const Skill dwarvenResilience = Skill(
    id: 'dwarven_resilience',
    name: 'Dwarven Resilience',
    emoji: '🎯',
    description: '+10% défense et résistance magique',
    type: SkillType.passive,
    statBonuses: {'defense': 0.10, 'magic': 0.10},
  );

  static const Skill orcishFury = Skill(
    id: 'orcish_fury',
    name: 'Orcish Fury',
    emoji: '👹',
    description: '+15% attaque physique',
    type: SkillType.passive,
    statBonuses: {'attack': 0.15},
  );

  // ============================================================================
  // COMPÉTENCES PASSIVES - ORIGINE
  // ============================================================================

  static const Skill nobleLeadership = Skill(
    id: 'noble_leadership',
    name: 'Leadership',
    emoji: '👑',
    description: '+5% toutes stats',
    type: SkillType.passive,
    statBonuses: {
      'attack': 0.05,
      'defense': 0.05,
      'magic': 0.05,
      'speed': 0.05,
      'luck': 0.05,
    },
  );

  static const Skill merchantLuck = Skill(
    id: 'merchant_luck',
    name: 'Lucky Trade',
    emoji: '💰',
    description: '+20% butin après combat',
    type: SkillType.passive,
    statBonuses: {'lootBonus': 0.20},
  );

  static const Skill peasantEndurance = Skill(
    id: 'peasant_endurance',
    name: 'Endurance',
    emoji: '🌾',
    description: '+15% HP max',
    type: SkillType.passive,
    statBonuses: {'maxHp': 0.15},
  );

  static const Skill scholarWisdom = Skill(
    id: 'scholar_wisdom',
    name: 'Wisdom',
    emoji: '📚',
    description: '+10% puissance magique',
    type: SkillType.passive,
    statBonuses: {'magic': 0.10},
  );

  // ============================================================================
  // COMPÉTENCES PASSIVES - GÉNÉRALES
  // ============================================================================

  static const Skill criticalHit = Skill(
    id: 'critical_hit',
    name: 'Critical Hit',
    emoji: '💥',
    description: '+15% chance de coup critique',
    type: SkillType.passive,
    statBonuses: {'critChance': 0.15},
  );

  static const Skill doubleAttack = Skill(
    id: 'double_attack',
    name: 'Double Attack',
    emoji: '⚔️⚔️',
    description: '20% de chance de frapper deux fois',
    type: SkillType.passive,
    statBonuses: {'doubleAttackChance': 0.20},
  );

  static const Skill counterAttack = Skill(
    id: 'counter_attack',
    name: 'Counter Attack',
    emoji: '🔄',
    description: '30% de chance de contre-attaquer',
    type: SkillType.passive,
    statBonuses: {'counterChance': 0.30},
  );

  static const Skill evasion = Skill(
    id: 'evasion',
    name: 'Evasion',
    emoji: '💨',
    description: '+10% esquive',
    type: SkillType.passive,
    statBonuses: {'evasion': 0.10},
  );

  static const Skill regeneration = Skill(
    id: 'regeneration',
    name: 'Regeneration',
    emoji: '💚',
    description: 'Régénère 5% HP par tour',
    type: SkillType.passive,
    statBonuses: {'hpRegen': 0.05},
  );

  static const Skill ironSkin = Skill(
    id: 'iron_skin',
    name: 'Iron Skin',
    emoji: '🛡️',
    description: '+20% défense',
    type: SkillType.passive,
    statBonuses: {'defense': 0.20},
  );

  static const Skill swiftness = Skill(
    id: 'swiftness',
    name: 'Swiftness',
    emoji: '⚡',
    description: '+15% vitesse',
    type: SkillType.passive,
    statBonuses: {'speed': 0.15},
  );

  static const Skill fortuneFavor = Skill(
    id: 'fortune_favor',
    name: 'Fortune\'s Favor',
    emoji: '🍀',
    description: '+25% chance',
    type: SkillType.passive,
    statBonuses: {'luck': 0.25},
  );

  static const Skill magicMastery = Skill(
    id: 'magic_mastery',
    name: 'Magic Mastery',
    emoji: '✨',
    description: '+20% puissance magique',
    type: SkillType.passive,
    statBonuses: {'magic': 0.20},
  );

  static const Skill weaponMaster = Skill(
    id: 'weapon_master',
    name: 'Weapon Master',
    emoji: '⚔️',
    description: '+15% attaque physique',
    type: SkillType.passive,
    statBonuses: {'attack': 0.15},
  );

  // ============================================================================
  // COMPÉTENCES ULTIMES
  // ============================================================================

  static const Skill divineIntervention = Skill(
    id: 'divine_intervention',
    name: 'Divine Intervention',
    emoji: '🌟',
    description: 'Restaure tous les alliés à 100% HP et supprime les effets négatifs',
    type: SkillType.ultimate,
    statBonuses: {'healMultiplier': 1.00},
  );

  static const Skill apocalypse = Skill(
    id: 'apocalypse',
    name: 'Apocalypse',
    emoji: '🌋',
    description: 'Inflige +200% dégâts magiques à tous les ennemis',
    type: SkillType.ultimate,
    statBonuses: {'damageMultiplier': 2.00},
  );

  static const Skill lastStand = Skill(
    id: 'last_stand',
    name: 'Last Stand',
    emoji: '⚔️',
    description: 'Augmente attaque et défense de +100% pendant 5 tours',
    type: SkillType.ultimate,
    statBonuses: {'attack': 1.00, 'defense': 1.00},
  );

  static const Skill timeStop = Skill(
    id: 'time_stop',
    name: 'Time Stop',
    emoji: '⏱️',
    description: 'Arrête le temps : 3 actions gratuites',
    type: SkillType.ultimate,
    statBonuses: {},
  );

  // ============================================================================
  // ORGANISATION DES COMPÉTENCES
  // ============================================================================

  static const Map<String, List<Skill>> byType = {
    'warrior_active': [
      powerStrike,
      whirlwind,
      berserk,
      shieldBash,
      executionStrike,
    ],
    'mage_active': [
      fireball,
      iceLance,
      lightning,
      meteor,
      arcaneBlast,
      manaDrain,
    ],
    'rogue_active': [
      backstab,
      multiShot,
      snipe,
      poisonArrow,
      shadowStep,
    ],
    'cleric_active': [
      heal,
      massHeal,
      resurrection,
      bless,
      holySmite,
    ],
    'race_passive': [
      humanAdaptability,
      elvenGrace,
      dwarvenResilience,
      orcishFury,
    ],
    'origin_passive': [
      nobleLeadership,
      merchantLuck,
      peasantEndurance,
      scholarWisdom,
    ],
    'general_passive': [
      criticalHit,
      doubleAttack,
      counterAttack,
      evasion,
      regeneration,
      ironSkin,
      swiftness,
      fortuneFavor,
      magicMastery,
      weaponMaster,
    ],
    'ultimate': [
      divineIntervention,
      apocalypse,
      lastStand,
      timeStop,
      meteor,
      resurrection,
    ],
  };

  /// Liste de toutes les compétences
  static List<Skill> get allSkills {
    return byType.values.expand((list) => list).toList();
  }

  /// Récupère une compétence par son ID
  static Skill? getById(String id) {
    try {
      return allSkills.firstWhere((s) => s.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Filtre par type de compétence
  static List<Skill> getBySkillType(SkillType type) {
    return allSkills.where((s) => s.type == type).toList();
  }

  /// Filtre par catégorie
  static List<Skill> getByCategory(String category) {
    return byType[category] ?? [];
  }

  /// Récupère les compétences recommandées pour une classe
  static List<Skill> getRecommendedForClass(String className) {
    switch (className.toLowerCase()) {
      case 'warrior':
      case 'knight':
        return [
          ...byType['warrior_active']!,
          ...byType['general_passive']!.where((s) => 
            s.id == 'weapon_master' || 
            s.id == 'iron_skin' || 
            s.id == 'critical_hit'
          ),
        ];
      case 'mage':
      case 'wizard':
        return [
          ...byType['mage_active']!,
          ...byType['general_passive']!.where((s) => 
            s.id == 'magic_mastery' || 
            s.id == 'swiftness'
          ),
        ];
      case 'rogue':
      case 'thief':
      case 'archer':
        return [
          ...byType['rogue_active']!,
          ...byType['general_passive']!.where((s) => 
            s.id == 'evasion' || 
            s.id == 'critical_hit' || 
            s.id == 'swiftness'
          ),
        ];
      case 'cleric':
      case 'healer':
        return [
          ...byType['cleric_active']!,
          ...byType['general_passive']!.where((s) => 
            s.id == 'regeneration' || 
            s.id == 'iron_skin'
          ),
        ];
      default:
        return [];
    }
  }
}
