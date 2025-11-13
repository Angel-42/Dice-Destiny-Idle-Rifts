/// Système d'équipement pour les personnages
class Equipment {
  final String id;
  final String name;
  final String emoji;
  final String? sprite; // Chemin vers le sprite (optionnel)
  final EquipmentType type;
  final EquipmentRarity rarity;
  final Map<String, int> bonuses; // 'attack', 'defense', 'magic', 'speed', 'luck'

  const Equipment({
    required this.id,
    required this.name,
    required this.emoji,
    this.sprite,
    required this.type,
    this.rarity = EquipmentRarity.common,
    this.bonuses = const {},
  });

  /// Retourne le sprite si disponible, sinon l'emoji
  String get displayIcon => sprite ?? emoji;
  
  /// Vérifie si c'est un sprite (chemin de fichier)
  bool get hasSprite => sprite != null && sprite!.isNotEmpty;

  String get bonusDescription {
    if (bonuses.isEmpty) return '';
    return bonuses.entries
        .map((e) => '+${e.value} ${_statName(e.key)}')
        .join(', ');
  }

  String _statName(String key) {
    switch (key) {
      case 'attack': return 'Atk';
      case 'defense': return 'Def';
      case 'magic': return 'Mag';
      case 'speed': return 'Spd';
      case 'luck': return 'Lck';
      default: return key;
    }
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'emoji': emoji,
    'sprite': sprite,
    'type': type.name,
    'rarity': rarity.name,
    'bonuses': bonuses,
  };

  factory Equipment.fromJson(Map<String, dynamic> json) => Equipment(
    id: json['id'],
    name: json['name'],
    emoji: json['emoji'],
    sprite: json['sprite'],
    type: EquipmentType.values.byName(json['type']),
    rarity: EquipmentRarity.values.byName(json['rarity'] ?? 'common'),
    bonuses: Map<String, int>.from(json['bonuses'] ?? {}),
  );
}

enum EquipmentType {
  weapon,
  armor,
  accessory,
}

enum EquipmentRarity {
  common,
  uncommon,
  rare,
  epic,
  legendary,
}

/// Armes de départ par classe
class DefaultWeapons {
  static const Map<String, Equipment> byClass = {
    'warrior': Equipment(
      id: 'iron_sword',
      name: 'Iron Sword',
      emoji: '⚔️',
      type: EquipmentType.weapon,
      bonuses: {'attack': 5},
    ),
    'mage': Equipment(
      id: 'wooden_staff',
      name: 'Wooden Staff',
      emoji: '🪄',
      type: EquipmentType.weapon,
      bonuses: {'magic': 5},
    ),
    'rogue': Equipment(
      id: 'iron_dagger',
      name: 'Iron Dagger',
      emoji: '🗡️',
      type: EquipmentType.weapon,
      bonuses: {'attack': 3, 'speed': 2},
    ),
    'cleric': Equipment(
      id: 'healing_rod',
      name: 'Healing Rod',
      emoji: '⚕️',
      type: EquipmentType.weapon,
      bonuses: {'magic': 3, 'defense': 2},
    ),
  };

  static Equipment? getForClass(String className) => byClass[className];
}
