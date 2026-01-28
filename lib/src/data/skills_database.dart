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
    sprite: 'assets/skills/warrior/power_strike_save.png',
    description: 'Attaque puissante infligeant +50% de dégâts',
    type: SkillType.active,
    statBonuses: {'damageMultiplier': 0.50},
  );

  static const Skill whirlwind = Skill(
    id: 'whirlwind',
    name: 'Whirlwind',
    emoji: '🌪️',
    sprite: 'assets/skills/warrior/whirlwind_save.png',
    description: 'Attaque tournoyante frappant tous les ennemis proches (+40% dégâts)',
    type: SkillType.active,
    statBonuses: {'damageMultiplier': 0.40},
  );

  static const Skill berserk = Skill(
    id: 'berserk',
    name: 'Berserk',
    emoji: '😡',
    sprite: 'assets/skills/warrior/berserk_save.png',
    description: 'Entre en rage : +80% attaque, -20% défense pendant 3 tours',
    type: SkillType.active,
    statBonuses: {'damageMultiplier': 0.80, 'defense': -0.20},
  );

  static const Skill shieldBash = Skill(
    id: 'shield_bash',
    name: 'Shield Bash',
    emoji: '🛡️',
    sprite: 'assets/skills/warrior/shield_bash_save.png',
    description: 'Coup de bouclier étourdissant (+30% dégâts, étourdit 1 tour)',
    type: SkillType.active,
    statBonuses: {'damageMultiplier': 0.30},
  );

  static const Skill executionStrike = Skill(
    id: 'execution_strike',
    name: 'Execution Strike',
    emoji: '💀',
    sprite: 'assets/skills/warrior/execution_strike_save.png',
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
    sprite: 'assets/skills/mage/fireball_save.png',
    description: 'Lance une boule de feu magique (+60% dégâts magiques)',
    type: SkillType.active,
    statBonuses: {'damageMultiplier': 0.60},
  );

  static const Skill iceLance = Skill(
    id: 'ice_lance',
    name: 'Ice Lance',
    emoji: '❄️',
    sprite: 'assets/skills/mage/ice_lance_save.png',
    description: 'Lance de glace perforante (+50% dégâts magiques, ralentit)',
    type: SkillType.active,
    statBonuses: {'damageMultiplier': 0.50},
  );

  static const Skill lightning = Skill(
    id: 'lightning',
    name: 'Lightning',
    emoji: '⚡',
    sprite: 'assets/skills/mage/lightning_save.png',
    description: 'Éclair fulgurant (+70% dégâts magiques, ignore 20% résistance)',
    type: SkillType.active,
    statBonuses: {'damageMultiplier': 0.70},
  );

  static const Skill meteor = Skill(
    id: 'meteor',
    name: 'Meteor',
    emoji: '☄️',
    sprite: 'assets/skills/mage/meteor_save.png',
    description: 'Invoque une météorite (+120% dégâts magiques de zone)',
    type: SkillType.ultimate,
    statBonuses: {'damageMultiplier': 1.20},
  );

  static const Skill arcaneBlast = Skill(
    id: 'arcane_blast',
    name: 'Arcane Blast',
    emoji: '✨',
    sprite: 'assets/skills/mage/arcane_blast_save.png',
    description: 'Explosion d\'énergie arcanique pure (+80% dégâts magiques)',
    type: SkillType.active,
    statBonuses: {'damageMultiplier': 0.80},
  );

  static const Skill manaDrain = Skill(
    id: 'mana_drain',
    name: 'Mana Drain',
    emoji: '🌀',
    sprite: 'assets/skills/mage/mana_drain_save.png',
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
    sprite: 'assets/skills/rogue/backstab_save.png',
    description: 'Attaque sournoise avec dégâts critiques (+100% dégâts)',
    type: SkillType.active,
    statBonuses: {'damageMultiplier': 1.00},
  );

  static const Skill multiShot = Skill(
    id: 'multi_shot',
    name: 'Multi-Shot',
    emoji: '🏹',
    sprite: 'assets/skills/rogue/multi_shot_save.png',
    description: 'Tire plusieurs flèches (+30% dégâts par cible)',
    type: SkillType.active,
    statBonuses: {'damageMultiplier': 0.30},
  );

  static const Skill snipe = Skill(
    id: 'snipe',
    name: 'Snipe',
    emoji: '🎯',
    sprite: 'assets/skills/rogue/snipe_save.png',
    description: 'Tir de précision : +150% dégâts critiques garantis',
    type: SkillType.active,
    statBonuses: {'damageMultiplier': 1.50},
  );

  static const Skill poisonArrow = Skill(
    id: 'poison_arrow',
    name: 'Poison Arrow',
    emoji: '🐍',
    sprite: 'assets/skills/rogue/poison_arrow_save.png',
    description: 'Flèche empoisonnée : dégâts sur la durée (3 tours)',
    type: SkillType.active,
    statBonuses: {'damageMultiplier': 0.40},
  );

  static const Skill shadowStep = Skill(
    id: 'shadow_step',
    name: 'Shadow Step',
    emoji: '👤',
    sprite: 'assets/skills/rogue/shadow_step_save.png',
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
    sprite: 'assets/skills/cleric/heal_save.png',
    description: 'Soigne un allié (40% HP max)',
    type: SkillType.active,
    statBonuses: {'healMultiplier': 0.40},
  );

  static const Skill massHeal = Skill(
    id: 'mass_heal',
    name: 'Mass Heal',
    emoji: '💖',
    sprite: 'assets/skills/cleric/mass_heal_save.png',
    description: 'Soigne tous les alliés (25% HP max)',
    type: SkillType.active,
    statBonuses: {'healMultiplier': 0.25},
  );

  static const Skill resurrection = Skill(
    id: 'resurrection',
    name: 'Resurrection',
    emoji: '✝️',
    sprite: 'assets/skills/cleric/resurrection_save.png',
    description: 'Ressuscite un allié tombé au combat (50% HP)',
    type: SkillType.ultimate,
    statBonuses: {'healMultiplier': 0.50},
  );

  static const Skill bless = Skill(
    id: 'bless',
    name: 'Bless',
    emoji: '🙏',
    sprite: 'assets/skills/cleric/bless_save.png',
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
    sprite: 'assets/skills/cleric/holy_smite_save.png',
    description: 'Châtiment divin : +90% dégâts magiques contre les morts-vivants',
    type: SkillType.active,
    statBonuses: {'damageMultiplier': 0.90},
  );

  static const Skill berserkerRage = Skill(
    id: 'berserker_rage',
    name: 'Berserker Rage',
    emoji: '💀',
    sprite: 'assets/skills/warrior/berserker_rage_save.png',
    description: 'Rage dévastatrice : +100% attaque, -50% défense, +20% vitesse',
    type: SkillType.active,
    statBonuses: {'attack': 1.00, 'defense': -0.50, 'speed': 0.20},
  );

  static const Skill bloodthirst = Skill(
    id: 'bloodthirst',
    name: 'Bloodthirst',
    emoji: '🩸',
    sprite: 'assets/skills/warrior/bloodthirst_save.png',
    description: 'Récupère de la vie en infligeant des dégâts critiques',
    type: SkillType.active,
    statBonuses: {'criticalHit': 0.25, 'healMultiplier': 0.30},
  );

  static const Skill earthShaker = Skill(
    id: 'earth_shaker',
    name: 'Earth Shaker',
    emoji: '🌍',
    sprite: 'assets/skills/warrior/earth_shaker_save.png',
    description: 'Frappe du sol créant une onde de choc',
    type: SkillType.active,
    statBonuses: {'damageMultiplier': 0.70},
  );

  static const Skill brutality = Skill(
    id: 'brutality',
    name: 'Brutality',
    emoji: '🗡️',
    sprite: 'assets/skills/warrior/brutality_save.png',
    description: '+40% chance de critique, +30% dégâts critiques',
    type: SkillType.passive,
    statBonuses: {'criticalHit': 0.40, 'criticalDamage': 0.30},
  );

  static const Skill goldRush = Skill(
    id: 'gold_rush',
    name: 'Gold Rush',
    emoji: '💰',
    sprite: 'assets/skills/general/gold_rush_save.png',
    description: '+50% d\'or obtenu après les combats',
    type: SkillType.active,
    statBonuses: {'goldMultiplier': 0.50},
  );

  static const Skill luckBoost = Skill(
    id: 'luck_boost',
    name: 'Luck Boost',
    emoji: '🍀',
    sprite: 'assets/skills/general/luck_boost_save.png',
    description: '+30% chance pour tous les événements aléatoires',
    type: SkillType.passive,
    statBonuses: {'luck': 0.30},
  );

  static const Skill guardianSpirit = Skill(
    id: 'guardian_spirit',
    name: 'Guardian Spirit',
    emoji: '👼',
    sprite: 'assets/skills/ultimate/guardian_spirit_save.png',
    description: 'Protège tous les alliés : +50% défense de l\'équipe',
    type: SkillType.passive,
    statBonuses: {'defense': 0.50},
  );

  static const Skill divineProtection = Skill(
    id: 'divine_protection',
    name: 'Divine Protection',
    emoji: '✨',
    sprite: 'assets/skills/cleric/divine_protection_save.png',
    description: 'Bénédiction : +25% résistance magique et physique',
    type: SkillType.passive,
    statBonuses: {'defense': 0.25, 'magic': 0.25},
  );

  // ============================================================================
  // COMPÉTENCES PASSIVES - RACE
  // ============================================================================

  static const Skill humanAdaptability = Skill(
    id: 'adaptability',
    name: 'Adaptability',
    emoji: '👤',
    sprite: 'assets/skills/race/adaptability_save.png',
    description: '+10% XP gagné',
    type: SkillType.passive,
    statBonuses: {'xpGain': 0.10},
  );

  static const Skill elvenGrace = Skill(
    id: 'elven_grace',
    name: 'Elven Grace',
    emoji: '🧝',
    sprite: 'assets/skills/race/elven_grace_save.png',
    description: '+5% vitesse et esquive',
    type: SkillType.passive,
    statBonuses: {'speed': 0.05, 'evasion': 0.05},
  );

  static const Skill dwarvenResilience = Skill(
    id: 'dwarven_resilience',
    name: 'Dwarven Resilience',
    emoji: '🎯',
    sprite: 'assets/skills/race/dwarven_resilience_save.png',
    description: '+10% défense et résistance magique',
    type: SkillType.passive,
    statBonuses: {'defense': 0.10, 'magic': 0.10},
  );

  static const Skill orcishFury = Skill(
    id: 'orcish_fury',
    name: 'Orcish Fury',
    emoji: '👹',
    sprite: 'assets/skills/race/orcish_fury_save.png',
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
    sprite: 'assets/skills/origin/noble_leadership_save.png',
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
    sprite: 'assets/skills/origin/merchant_luck_save.png',
    description: '+20% butin après combat',
    type: SkillType.passive,
    statBonuses: {'lootBonus': 0.20},
  );

  static const Skill peasantEndurance = Skill(
    id: 'peasant_endurance',
    name: 'Endurance',
    emoji: '🌾',
    sprite: 'assets/skills/origin/peasant_endurance_save.png',
    description: '+15% HP max',
    type: SkillType.passive,
    statBonuses: {'maxHp': 0.15},
  );

  static const Skill scholarWisdom = Skill(
    id: 'scholar_wisdom',
    name: 'Wisdom',
    emoji: '📚',
    sprite: 'assets/skills/origin/scholar_wisdom_save.png',
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
    sprite: 'assets/skills/general/critical_hit_save.png',
    description: '+15% chance de coup critique',
    type: SkillType.passive,
    statBonuses: {'critChance': 0.15},
  );

  static const Skill doubleAttack = Skill(
    id: 'double_attack',
    name: 'Double Attack',
    emoji: '⚔️⚔️',
    sprite: 'assets/skills/general/double_attack_save.png',
    description: '20% de chance de frapper deux fois',
    type: SkillType.passive,
    statBonuses: {'doubleAttackChance': 0.20},
  );

  static const Skill counterAttack = Skill(
    id: 'counter_attack',
    name: 'Counter Attack',
    emoji: '🔄',
    sprite: 'assets/skills/general/counter_attack_save.png',
    description: '30% de chance de contre-attaquer',
    type: SkillType.passive,
    statBonuses: {'counterChance': 0.30},
  );

  static const Skill evasion = Skill(
    id: 'evasion',
    name: 'Evasion',
    emoji: '💨',
    sprite: 'assets/skills/general/evasion_save.png',
    description: '+10% esquive',
    type: SkillType.passive,
    statBonuses: {'evasion': 0.10},
  );

  static const Skill regeneration = Skill(
    id: 'regeneration',
    name: 'Regeneration',
    emoji: '💚',
    sprite: 'assets/skills/general/regeneration_save.png',
    description: 'Régénère 5% HP par tour',
    type: SkillType.passive,
    statBonuses: {'hpRegen': 0.05},
  );

  static const Skill ironSkin = Skill(
    id: 'iron_skin',
    name: 'Iron Skin',
    emoji: '🛡️',
    sprite: 'assets/skills/general/iron_skin_save.png',
    description: '+20% défense',
    type: SkillType.passive,
    statBonuses: {'defense': 0.20},
  );

  static const Skill swiftness = Skill(
    id: 'swiftness',
    name: 'Swiftness',
    emoji: '⚡',
    sprite: 'assets/skills/general/swiftness_save.png',
    description: '+15% vitesse',
    type: SkillType.passive,
    statBonuses: {'speed': 0.15},
  );

  static const Skill fortuneFavor = Skill(
    id: 'fortune_favor',
    name: 'Fortune\'s Favor',
    emoji: '🍀',
    sprite: 'assets/skills/general/fortune_favor_save.png',
    description: '+25% chance',
    type: SkillType.passive,
    statBonuses: {'luck': 0.25},
  );

  static const Skill magicMastery = Skill(
    id: 'magic_mastery',
    name: 'Magic Mastery',
    emoji: '✨',
    sprite: 'assets/skills/general/magic_mastery_save.png',
    description: '+20% puissance magique',
    type: SkillType.passive,
    statBonuses: {'magic': 0.20},
  );

  static const Skill weaponMaster = Skill(
    id: 'weapon_master',
    name: 'Weapon Master',
    emoji: '⚔️',
    sprite: 'assets/skills/general/weapon_master_save.png',
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
    sprite: 'assets/skills/ultimate/divine_intervention_save.png',
    description: 'Restaure tous les alliés à 100% HP et supprime les effets négatifs',
    type: SkillType.ultimate,
    statBonuses: {'healMultiplier': 1.00},
  );

  static const Skill apocalypse = Skill(
    id: 'apocalypse',
    name: 'Apocalypse',
    emoji: '🌋',
    sprite: 'assets/skills/ultimate/apocalypse_save.png',
    description: 'Inflige +200% dégâts magiques à tous les ennemis',
    type: SkillType.ultimate,
    statBonuses: {'damageMultiplier': 2.00},
  );

  static const Skill lastStand = Skill(
    id: 'last_stand',
    name: 'Last Stand',
    emoji: '⚔️',
    sprite: 'assets/skills/ultimate/last_stand_save.png',
    description: 'Augmente attaque et défense de +100% pendant 5 tours',
    type: SkillType.ultimate,
    statBonuses: {'attack': 1.00, 'defense': 1.00},
  );

  static const Skill timeStop = Skill(
    id: 'time_stop',
    name: 'Time Stop',
    emoji: '⏱️',
    sprite: 'assets/skills/ultimate/time_stop_save.png',
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
      berserkerRage,
      bloodthirst,
      earthShaker,
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
      goldRush,
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
      brutality,
      luckBoost,
      divineProtection,
    ],
    'ultimate': [
      divineIntervention,
      apocalypse,
      lastStand,
      timeStop,
      meteor,
      resurrection,
      guardianSpirit,
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
