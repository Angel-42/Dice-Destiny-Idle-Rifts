import '../models/persona.dart';

/// Represents a playable character with stats and appearance
class Character {
  final String id; // Unique identifier
  final String name;
  final Persona persona;
  final CharacterStats stats;
  final CharacterAppearance appearance;
  
  // Position on game map
  int x;
  int y;
  
  // Game state
  int currentHp;
  int level;
  
  Character({
    String? id,
    required this.name,
    required this.persona,
    required this.stats,
    required this.appearance,
    this.x = 0,
    this.y = 0,
    this.level = 1,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
       currentHp = stats.maxHp;
  
  // Convert to/from JSON for storage
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'persona': persona.toJson(),
    'stats': stats.toJson(),
    'x': x,
    'y': y,
    'currentHp': currentHp,
    'level': level,
  };
  
  factory Character.fromJson(Map<String, dynamic> json) {
    final persona = Persona.fromJson(json['persona']);
    return Character(
      id: json['id'],
      name: json['name'],
      persona: persona,
      stats: CharacterStats.fromJson(json['stats']),
      appearance: CharacterAppearance.fromRace(persona.race),
      x: json['x'] ?? 0,
      y: json['y'] ?? 0,
      level: json['level'] ?? 1,
    )..currentHp = json['currentHp'] ?? 100;
  }
  
  String get displayName => '$name (${persona.race.displayName})';
  bool get isAlive => currentHp > 0;
  double get hpPercentage => currentHp / stats.maxHp;
}

/// Character stats based on persona choices
class CharacterStats {
  final int maxHp;
  final int attack;
  final int defense;
  final int speed;
  final int magic;
  final int luck;
  final int gold;
  
  const CharacterStats({
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
