import 'persona.dart';

/// Système de maîtrise des armes
class WeaponMastery {
  final WeaponType type;
  final int level; // 0-5 (E, D, C, B, A, S)

  const WeaponMastery({
    required this.type,
    this.level = 0,
  });

  String get rank {
    switch (level) {
      case 0: return 'E';
      case 1: return 'D';
      case 2: return 'C';
      case 3: return 'B';
      case 4: return 'A';
      case 5: return 'S';
      default: return 'E';
    }
  }

  Map<String, dynamic> toJson() => {
    'type': type.name,
    'level': level,
  };

  factory WeaponMastery.fromJson(Map<String, dynamic> json) => WeaponMastery(
    type: WeaponType.values.byName(json['type']),
    level: json['level'] ?? 0,
  );
}

enum WeaponType {
  sword('Sword', '⚔️'),
  axe('Axe', '🪓'),
  lance('Lance', '🔱'),
  bow('Bow', '🏹'),
  staff('Staff', '🪄'),
  dagger('Dagger', '🗡️'),
  tome('Tome', '📖'),
  rod('Rod', '⚕️');

  const WeaponType(this.displayName, this.emoji);
  final String displayName;
  final String emoji;
}

/// Maîtrises d'armes par défaut selon la classe
class DefaultWeaponMasteries {
  static const Map<String, List<WeaponType>> byClass = {
    'warrior': [WeaponType.sword, WeaponType.axe, WeaponType.lance],
    'mage': [WeaponType.staff, WeaponType.tome],
    'rogue': [WeaponType.dagger, WeaponType.bow],
    'cleric': [WeaponType.rod, WeaponType.staff],
  };

  /// Récupère les maîtrises de départ pour une classe
  static List<WeaponMastery> getForClass(PersonaClass characterClass) {
    final weaponTypes = byClass[characterClass.name] ?? [];
    return weaponTypes.map((type) {
      // L'arme principale commence à D, les secondaires à E
      final isMainWeapon = weaponTypes.indexOf(type) == 0;
      return WeaponMastery(
        type: type,
        level: isMainWeapon ? 1 : 0,
      );
    }).toList();
  }
}
