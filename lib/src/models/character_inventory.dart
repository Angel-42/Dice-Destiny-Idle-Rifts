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

  List<InventoryItem<Equipment>> getAllWeapons() => weapons;

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

  List<InventoryItem<Skill>> getAllSkills() => skills;

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

  static CharacterInventory createDefault(String className) {
    return CharacterInventory(
      weapons: _getDefaultWeapons(className),
      armors: _getDefaultArmors(),
      accessories: _getDefaultAccessories(),
      skills: [],
    );
  }

  /// Retourne uniquement l'arme de départ de base pour une classe
  static List<InventoryItem<Equipment>> _getDefaultWeapons(String className) {
    // Récupère l'arme de départ de la classe depuis DefaultWeapons
    final defaultWeapon = DefaultWeapons.byClass[className];
    
    if (defaultWeapon != null) {
      return [
        InventoryItem(
          item: defaultWeapon,
          condition: const UnlockCondition(
            type: UnlockConditionType.always,
            value: 0,
            description: 'Arme de départ',
          ),
          isDefault: true,
        ),
      ];
    }
    
    // Fallback générique
    return [
      InventoryItem(
        item: const Equipment(
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

  /// Retourne l'armure de départ basique
  static List<InventoryItem<Equipment>> _getDefaultArmors() {
    return [
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
          description: 'Armure de départ',
        ),
        isDefault: true,
      ),
    ];
  }

  /// Pas d'accessoire par défaut
  static List<InventoryItem<Equipment>> _getDefaultAccessories() {
    return [];
  }
}
