/// Entrée du codex pour un personnage découvert
class CodexEntry {
  final int unlockCount; // Nombre de fois obtenu
  final DateTime firstUnlock; // Date de premier unlock
  final DateTime lastUnlock; // Date de dernier unlock
  final int maxLevel; // Niveau max atteint avec ce personnage
  final int totalBattles; // Nombre de combats avec ce personnage

  const CodexEntry({
    required this.unlockCount,
    required this.firstUnlock,
    required this.lastUnlock,
    required this.maxLevel,
    required this.totalBattles,
  });

  CodexEntry copyWith({
    int? unlockCount,
    DateTime? firstUnlock,
    DateTime? lastUnlock,
    int? maxLevel,
    int? totalBattles,
  }) {
    return CodexEntry(
      unlockCount: unlockCount ?? this.unlockCount,
      firstUnlock: firstUnlock ?? this.firstUnlock,
      lastUnlock: lastUnlock ?? this.lastUnlock,
      maxLevel: maxLevel ?? this.maxLevel,
      totalBattles: totalBattles ?? this.totalBattles,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'unlockCount': unlockCount,
      'firstUnlock': firstUnlock.toIso8601String(),
      'lastUnlock': lastUnlock.toIso8601String(),
      'maxLevel': maxLevel,
      'totalBattles': totalBattles,
    };
  }

  factory CodexEntry.fromJson(Map<String, dynamic> json) {
    return CodexEntry(
      unlockCount: json['unlockCount'] as int,
      firstUnlock: DateTime.parse(json['firstUnlock'] as String),
      lastUnlock: DateTime.parse(json['lastUnlock'] as String),
      maxLevel: json['maxLevel'] as int,
      totalBattles: json['totalBattles'] as int,
    );
  }

  factory CodexEntry.initial() {
    final now = DateTime.now();
    return CodexEntry(
      unlockCount: 1,
      firstUnlock: now,
      lastUnlock: now,
      maxLevel: 1,
      totalBattles: 0,
    );
  }
}
