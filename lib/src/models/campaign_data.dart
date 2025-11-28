import 'map_data.dart';

/// Représente un stage individuel dans un chapitre
class CampaignStage {
  final int chapter;
  final int stage;
  final String name;
  final String description;
  final String mapTheme; // "forest", "plains", "mountain", etc.
  final List<EnemySpawn> enemies;
  final int rewardGold;
  final int rewardXP;
  
  CampaignStage({
    required this.chapter,
    required this.stage,
    required this.name,
    required this.description,
    required this.mapTheme,
    required this.enemies,
    this.rewardGold = 100,
    this.rewardXP = 50,
  });
  
  /// Retourne l'ID unique du stage (ex: 1.01 pour chapitre 1, stage 1)
  double get stageId => chapter + (stage / 100);
  
  /// Génère la map tactique pour ce stage
  TacticalMapData generateMap() {
    switch (mapTheme) {
      case 'forest':
        return TacticalMapData.createForestMap();
      case 'plains':
        return TacticalMapData.createPlainsMap();
      case 'mountain':
        return TacticalMapData.createMountainMap();
      default:
        return TacticalMapData.createTestMap();
    }
  }
}

/// Position d'apparition d'un ennemi sur la map
class EnemySpawn {
  final String enemyId; // ID de l'ennemi dans enemy_database
  final int x;
  final int y;
  
  EnemySpawn({
    required this.enemyId,
    required this.x,
    required this.y,
  });
}

/// Représente un chapitre entier de la campagne
class CampaignChapter {
  final int chapterNumber;
  final String chapterName;
  final String description;
  final String theme;
  final List<CampaignStage> stages;
  
  CampaignChapter({
    required this.chapterNumber,
    required this.chapterName,
    required this.description,
    required this.theme,
    required this.stages,
  });
  
  /// Retourne le stage correspondant au numéro
  CampaignStage? getStage(int stageNumber) {
    return stages.firstWhere(
      (s) => s.stage == stageNumber,
      orElse: () => stages.first,
    );
  }
}
