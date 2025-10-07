import '../models/persona.dart';

/// Représente un personnage jouable (héros invocable via Gacha)
class Character {
  final String id; // Unique identifier
  final String name;
  final Persona persona;
  final CharacterStats stats;
  final CharacterAppearance appearance;
  
  // Niveau et progression du personnage
  int level;
  int xp;
  
  // Position sur la carte de jeu
  int x;
  int y;
  
  // État en combat
  int currentHp;
  
  // Équipement (IDs des items)
  String? weaponId;
  String? armorId;
  String? accessoryId;
  
  // Compétences débloquées
  List<String> unlockedSkills;
  
  // Méta-données
  CharacterRarity rarity;
  bool isInTeam;
  int teamPosition; // 0 = non dans l'équipe, 1-3 = position
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
    this.rarity = CharacterRarity.common,
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
        'rarity': rarity.name,
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
      rarity: CharacterRarity.values.firstWhere(
        (r) => r.name == json['rarity'],
        orElse: () => CharacterRarity.common,
      ),
      isInTeam: json['isInTeam'] ?? false,
      teamPosition: json['teamPosition'] ?? 0,
      obtainedAt: json['obtainedAt'] != null
          ? DateTime.parse(json['obtainedAt'])
          : DateTime.now(),
    )..currentHp = json['currentHp'] ?? 100;
  }
  
  String get displayName => '$name (${persona.race.displayName})';
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
  
  // Augmenter les stats à chaque niveau
  void _levelUpStats() {
    // Augmentation basée sur la classe
    switch (persona.characterClass) {
      case PersonaClass.warrior:
        stats.attack += 3;
        stats.defense += 2;
        stats.maxHp += 10;
        break;
      case PersonaClass.mage:
        stats.magic += 4;
        stats.attack += 1;
        stats.maxHp += 5;
        break;
      case PersonaClass.rogue:
        stats.speed += 3;
        stats.attack += 2;
        stats.luck += 1;
        break;
      case PersonaClass.cleric:
        stats.magic += 2;
        stats.defense += 2;
        stats.maxHp += 8;
        break;
    }
    currentHp = stats.maxHp; // Heal complet à chaque niveau
  }
  
  // Puissance totale du personnage
  int get power => stats.attack + stats.defense + stats.magic + stats.speed + stats.luck + (level * 10);
}

/// Rareté des personnages (pour le système Gacha)
enum CharacterRarity {
  common,    // 60% - 1-3 étoiles
  rare,      // 25% - 3-4 étoiles  
  epic,      // 12% - 4-5 étoiles
  legendary; // 3%  - 5 étoiles
  
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

/// Character stats based on persona choices
class CharacterStats {
  int maxHp;
  int attack;
  int defense;
  int speed;
  int magic;
  int luck;
  int gold;
  
  CharacterStats({
    required this.maxHp,
    required this.attack,
    required this.defense,
    required this.speed,
    required this.magic,
    required this.luck,
    this.gold = 100,
  });
  
  Map<String, dynamic> toJson() => {
    'maxHp': maxHp,
    'attack': attack,
    'defense': defense,
    'speed': speed,
    'magic': magic,
    'luck': luck,
    'gold': gold,
  };
  
  factory CharacterStats.fromJson(Map<String, dynamic> json) => CharacterStats(
    maxHp: json['maxHp'],
    attack: json['attack'],
    defense: json['defense'],
    speed: json['speed'],
    magic: json['magic'],
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
          colorValue: 0xFF2196F3, // Blue
          description: 'Polyvalent et équilibré',
        );
      case PersonaRace.elf:
        return const CharacterAppearance(
          emoji: '🧝',
          colorValue: 0xFF4CAF50, // Green
          description: 'Agile et magique',
        );
      case PersonaRace.dwarf:
        return const CharacterAppearance(
          emoji: '🎯', // or 🛡️
          colorValue: 0xFF795548, // Brown
          description: 'Robuste et résistant',
        );
      case PersonaRace.orc:
        return const CharacterAppearance(
          emoji: '👹',
          colorValue: 0xFFFF5722, // Deep Red
          description: 'Puissant et féroce',
        );
    }
  }
}
