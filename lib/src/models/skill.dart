import 'persona.dart';

/// Système de compétences pour les personnages
class Skill {
  final String id;
  final String name;
  final String emoji;
  final String? sprite; // Chemin vers le sprite (optionnel)
  final String description;
  final SkillType type;
  final Map<String, double> statBonuses; // Bonus en % ou flat

  const Skill({
    required this.id,
    required this.name,
    required this.emoji,
    this.sprite,
    required this.description,
    required this.type,
    this.statBonuses = const {},
  });

  /// Retourne le sprite si disponible, sinon l'emoji
  String get displayIcon => sprite ?? emoji;
  
  /// Vérifie si c'est un sprite (chemin de fichier)
  bool get hasSprite => sprite != null && sprite!.isNotEmpty;

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'emoji': emoji,
    'sprite': sprite,
    'description': description,
    'type': type.name,
    'statBonuses': statBonuses,
  };

  factory Skill.fromJson(Map<String, dynamic> json) {
    final bonuses = json['statBonuses'];
    return Skill(
      id: json['id'],
      name: json['name'],
      emoji: json['emoji'],
      sprite: json['sprite'],
      description: json['description'],
      type: SkillType.values.byName(json['type']),
      statBonuses: bonuses != null 
          ? Map<String, double>.from(bonuses)
          : const {},
    );
  }
}

enum SkillType {
  passive,
  active,
  ultimate,
}

/// Compétences de départ par classe et race
class DefaultSkills {
  // Compétences par classe
  static const Map<String, Skill> clasSkills = {
    'warrior': Skill(
      id: 'power_strike',
      name: 'Power Strike',
      emoji: '⚔️',
      description: 'Attaque puissante infligeant +50% de dégâts',
      type: SkillType.active,
      statBonuses: {'damageMultiplier': 0.50}, // +50% dégâts
    ),
    'mage': Skill(
      id: 'fireball',
      name: 'Fireball',
      emoji: '🔥',
      description: 'Lance une boule de feu magique (+30% dégâts magiques)',
      type: SkillType.active,
      statBonuses: {'damageMultiplier': 0.30}, // +30% dégâts magiques
    ),
    'rogue': Skill(
      id: 'backstab',
      name: 'Backstab',
      emoji: '🗡️',
      description: 'Attaque sournoise avec dégâts critiques (+100%)',
      type: SkillType.active,
      statBonuses: {'damageMultiplier': 1.00}, // +100% dégâts (critique)
    ),
    'cleric': Skill(
      id: 'heal',
      name: 'Heal',
      emoji: '💚',
      description: 'Soigne un allié (30% HP max)',
      type: SkillType.active,
      statBonuses: {'healMultiplier': 0.30}, // Soigne 30% HP
    ),
  };

  // Compétences par race
  static const Map<String, Skill> raceSkills = {
    'human': Skill(
      id: 'adaptability',
      name: 'Adaptability',
      emoji: '👤',
      description: '+10% XP gagné',
      type: SkillType.passive,
      statBonuses: {'xpGain': 0.10}, // +10% XP
    ),
    'elf': Skill(
      id: 'elven_grace',
      name: 'Elven Grace',
      emoji: '🧝',
      description: '+5% vitesse et esquive',
      type: SkillType.passive,
      statBonuses: {'speed': 0.05, 'evasion': 0.05}, // +5% speed/evasion
    ),
    'dwarf': Skill(
      id: 'dwarven_resilience',
      name: 'Dwarven Resilience',
      emoji: '🎯',
      description: '+10% défense et résistance',
      type: SkillType.passive,
      statBonuses: {'defense': 0.10, 'magic': 0.10}, // +10% def/res
    ),
    'orc': Skill(
      id: 'orcish_fury',
      name: 'Orcish Fury',
      emoji: '👹',
      description: '+15% attaque physique',
      type: SkillType.passive,
      statBonuses: {'attack': 0.15}, // +15% attack
    ),
  };

  // Compétences par origine
  static const Map<String, Skill> originSkills = {
    'noble': Skill(
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
    ),
    'merchant': Skill(
      id: 'merchant_luck',
      name: 'Lucky Trade',
      emoji: '💰',
      description: '+20% butin après combat',
      type: SkillType.passive,
      statBonuses: {'lootBonus': 0.20}, // +20% loot
    ),
    'peasant': Skill(
      id: 'peasant_endurance',
      name: 'Endurance',
      emoji: '🌾',
      description: '+15% HP max',
      type: SkillType.passive,
      statBonuses: {'maxHp': 0.15}, // +15% HP
    ),
    'scholar': Skill(
      id: 'scholar_wisdom',
      name: 'Wisdom',
      emoji: '📚',
      description: '+10% puissance magique',
      type: SkillType.passive,
      statBonuses: {'magic': 0.10}, // +10% magic
    ),
  };

  /// Récupère toutes les compétences de départ pour un persona donné
  static List<Skill> getStartingSkills(PersonaClass characterClass, PersonaRace race, PersonaOrigin origin) {
    final skills = <Skill>[];
    
    // Compétence de classe (toujours présente)
    final classSkill = clasSkills[characterClass.name];
    if (classSkill != null) skills.add(classSkill);
    
    // Compétence de race
    final raceSkill = raceSkills[race.name];
    if (raceSkill != null) skills.add(raceSkill);
    
    // Compétence d'origine
    final originSkill = originSkills[origin.name];
    if (originSkill != null) skills.add(originSkill);
    
    return skills;
  }
}
