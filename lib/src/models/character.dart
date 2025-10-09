import '../models/persona.dart';

class Character {     // est un personnage jouable (pas le player)
  final String id;
  final String name;
  final Persona persona;
  final CharacterStats stats;
  final CharacterAppearance appearance;

  // niveau et progr du personnage
  int level;
  int xp;

  // position sur la carte
  int x;
  int y;

  int currentHp;

  // équipement (IDs items)
  String? weaponId;
  String? armorId;
  String? accessoryId;

  // compétences débloquées
  List<String> unlockedSkills;

  // méta-data
  CharacterRarity basedRarity;
  CharacterRarity currentRarity;
  bool isInTeam;
  int teamPosition; // 0 = pas dans team, 1-3 = position
  DateTime obtainedAt;

  Character({
    String? id,
    required this.name,
    required this.persona,
    required this.stats,
    required this.appearance,
    this.level = 1,
    this.xp = 0,
    this.x = 0,
    this.y = 0,
    this.weaponId,
    this.armorId,
    this.accessoryId,
    List<String>? unlockedSkills,
    this.basedRarity = CharacterRarity.common,
    this.currentRarity = CharacterRarity.common,
    this.isInTeam = false,
    this.teamPosition = 0,
    DateTime? obtainedAt,
  })  : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        currentHp = stats.maxHp,
        unlockedSkills = unlockedSkills ?? [],
        obtainedAt = obtainedAt ?? DateTime.now();

  // Convert to/from JSON for storage
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'persona': persona.toJson(),
        'stats': stats.toJson(),
        'level': level,
        'xp': xp,
        'x': x,
        'y': y,
        'currentHp': currentHp,
        'weaponId': weaponId,
        'armorId': armorId,
        'accessoryId': accessoryId,
        'unlockedSkills': unlockedSkills,
        'basedRarity': basedRarity.name,
        'currentRarity': currentRarity.name,
        'isInTeam': isInTeam,
        'teamPosition': teamPosition,
        'obtainedAt': obtainedAt.toIso8601String(),
      };
  
  factory Character.fromJson(Map<String, dynamic> json) {
    final persona = Persona.fromJson(json['persona']);
    return Character(
      id: json['id'],
      name: json['name'],
      persona: persona,
      stats: CharacterStats.fromJson(json['stats']),
      appearance: CharacterAppearance.fromRace(persona.race),
      level: json['level'] ?? 1,
      xp: json['xp'] ?? 0,
      x: json['x'] ?? 0,
      y: json['y'] ?? 0,
      weaponId: json['weaponId'],
      armorId: json['armorId'],
      accessoryId: json['accessoryId'],
      unlockedSkills: (json['unlockedSkills'] as List?)?.cast<String>() ?? [],
      basedRarity: CharacterRarity.values.firstWhere(
        (r) => r.name == json['basedRarity'],
        orElse: () => CharacterRarity.common,
      ),
      currentRarity: CharacterRarity.values.firstWhere(
        (r) => r.name == json['currentRarity'],
        orElse: () => CharacterRarity.common,
      ),
      isInTeam: json['isInTeam'] ?? false,
      teamPosition: json['teamPosition'] ?? 0,
      obtainedAt: json['obtainedAt'] != null
          ? DateTime.parse(json['obtainedAt'])
          : DateTime.now(),
    )..currentHp = json['currentHp'] ?? 100;
  }

  String get displayName => '$name (${persona.displayName})';
  bool get isAlive => currentHp > 0;
  double get hpPercentage => currentHp / stats.maxHp;

  // XP nécessaire pour le niveau suivant
  int get xpForNextLevel => level * 50;

  // Progression vers le niveau suivant
  double get levelProgress => xp / xpForNextLevel;

  // Ajouter de l'XP et gérer les montées de niveau
  void addXP(int amount) {
    xp += amount;
    while (xp >= xpForNextLevel) {
      xp -= xpForNextLevel;
      level++;
      _levelUpStats();
    }
  }

  void _levelUpStats() {
    // Bonus selon la rareté de base (petite différence)
    double rarityMultiplier;
    switch (basedRarity) {
      case CharacterRarity.common:
        rarityMultiplier = 1.0;
        break;
      case CharacterRarity.rare:
        rarityMultiplier = 1.1;
        break;
      case CharacterRarity.epic:
        rarityMultiplier = 1.2;
        break;
      case CharacterRarity.legendary:
        rarityMultiplier = 1.3;
        break;
    }

    switch (persona.characterClass) {
      case PersonaClass.warrior:
        stats.attack += (3 * rarityMultiplier).round();
        stats.defense += (2 * rarityMultiplier).round();
        stats.maxHp += (10 * rarityMultiplier).round();
        break;
      case PersonaClass.mage:
        stats.magic += (4 * rarityMultiplier).round();
        stats.attack += (1 * rarityMultiplier).round();
        stats.maxHp += (5 * rarityMultiplier).round();
        break;
      case PersonaClass.rogue:
        stats.speed += (3 * rarityMultiplier).round();
        stats.attack += (2 * rarityMultiplier).round();
        stats.luck += (1 * rarityMultiplier).round();
        break;
      case PersonaClass.cleric:
        stats.magic += (2 * rarityMultiplier).round();
        stats.defense += (2 * rarityMultiplier).round();
        stats.maxHp += (8 * rarityMultiplier).round();
        break;
    }
    currentHp = stats.maxHp;
  }
  // Puissance globale du personnage
  int get power => stats.attack + stats.defense + stats.magic + stats.speed + stats.luck + (level * 10);
}

enum CharacterRarity {
  common, // 60% - 1-3 étoiles
  rare,   // 25% - 3-4 étoiles
  epic,   // 12% - 4-5 étoiles
  legendary; // 3% - 5 étoiles

  String get displayName {
    switch (this) {
      case CharacterRarity.common:
        return 'Commun';
      case CharacterRarity.rare:
        return 'Rare';
      case CharacterRarity.epic:
        return 'Épique';
      case CharacterRarity.legendary:
        return 'Légendaire';
    }
  }

  int get stars {
    switch (this) {
      case CharacterRarity.common:
        return 2;
      case CharacterRarity.rare:
        return 3;
      case CharacterRarity.epic:
        return 4;
      case CharacterRarity.legendary:
        return 5;
    }
  }
}

class CharacterStats {
  int maxHp;
  int attack;
  int defense;
  int speed;
  int magic;
  int range;
  int luck;
  int gold;
  
  CharacterStats({
    required this.maxHp,
    required this.attack,
    required this.defense,
    required this.speed,
    required this.magic,
    required this.range,
    required this.luck,
    this.gold = 100,
  });
  
  Map<String, dynamic> toJson() => {
    'maxHp': maxHp,
    'attack': attack,
    'defense': defense,
    'speed': speed,
    'magic': magic,
    'range': range,
    'luck': luck,
    'gold': gold,
  };
  
  factory CharacterStats.fromJson(Map<String, dynamic> json) => CharacterStats(
    maxHp: json['maxHp'],
    attack: json['attack'],
    defense: json['defense'],
    speed: json['speed'],
    magic: json['magic'],
    range: json['range'],
    luck: json['luck'],
    gold: json['gold'] ?? 100,
  );
}

/// Visual appearance and UI elements for character
class CharacterAppearance {
  final String emoji;
  final int colorValue;
  final String description;
  
  const CharacterAppearance({
    required this.emoji,
    required this.colorValue,
    required this.description,
  });
  
  factory CharacterAppearance.fromRace(PersonaRace race) {
    switch (race) {
      case PersonaRace.human:
        return const CharacterAppearance(
          emoji: '👤',
          colorValue: 0xFF2196F3,
          description: 'Polyvalent et équilibré',
        );
      case PersonaRace.elf:
        return const CharacterAppearance(
          emoji: '🧝',
          colorValue: 0xFF4CAF50,
          description: 'Agile et magique',
        );
      case PersonaRace.dwarf:
        return const CharacterAppearance(
          emoji: '🛡️',
          colorValue: 0xFF795548,
          description: 'Robuste et résistant',
        );
      case PersonaRace.orc:
        return const CharacterAppearance(
          emoji: '👹',
          colorValue: 0xFFFF5722,
          description: 'Puissant et féroce',
        );
    }
  }
}