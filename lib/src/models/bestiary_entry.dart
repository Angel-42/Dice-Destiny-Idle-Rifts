/// Entrée du bestiaire pour un ennemi découvert
class BestiaryEntry {
  final String enemyId;
  final bool discovered;
  final int encounterCount;
  final int defeatedCount;
  final DateTime? firstEncounter;
  final DateTime? lastEncounter;

  const BestiaryEntry({
    required this.enemyId,
    this.discovered = false,
    this.encounterCount = 0,
    this.defeatedCount = 0,
    this.firstEncounter,
    this.lastEncounter,
  });

  /// Crée une entrée initiale vide
  factory BestiaryEntry.initial() {
    return const BestiaryEntry(
      enemyId: '',
      discovered: false,
      encounterCount: 0,
      defeatedCount: 0,
    );
  }

  BestiaryEntry copyWith({
    String? enemyId,
    bool? discovered,
    int? encounterCount,
    int? defeatedCount,
    DateTime? firstEncounter,
    DateTime? lastEncounter,
  }) {
    return BestiaryEntry(
      enemyId: enemyId ?? this.enemyId,
      discovered: discovered ?? this.discovered,
      encounterCount: encounterCount ?? this.encounterCount,
      defeatedCount: defeatedCount ?? this.defeatedCount,
      firstEncounter: firstEncounter ?? this.firstEncounter,
      lastEncounter: lastEncounter ?? this.lastEncounter,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'enemyId': enemyId,
      'discovered': discovered,
      'encounterCount': encounterCount,
      'defeatedCount': defeatedCount,
      'firstEncounter': firstEncounter?.toIso8601String(),
      'lastEncounter': lastEncounter?.toIso8601String(),
    };
  }

  factory BestiaryEntry.fromJson(Map<String, dynamic> json) {
    return BestiaryEntry(
      enemyId: json['enemyId'] as String,
      discovered: json['discovered'] as bool? ?? false,
      encounterCount: json['encounterCount'] as int? ?? 0,
      defeatedCount: json['defeatedCount'] as int? ?? 0,
      firstEncounter: json['firstEncounter'] != null
          ? DateTime.parse(json['firstEncounter'] as String)
          : null,
      lastEncounter: json['lastEncounter'] != null
          ? DateTime.parse(json['lastEncounter'] as String)
          : null,
    );
  }

  /// Taux de victoire en pourcentage
  double get winRate {
    if (encounterCount == 0) return 0;
    return (defeatedCount / encounterCount) * 100;
  }
}
