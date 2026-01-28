import 'map_data.dart';

/// Chemins narratifs possibles
enum StoryPath {
  order,      // ORDRE
  chaos,      // CHAOS  
  balance,    // ÉQUILIBRE
  knowledge,  // CONNAISSANCE
}

/// Type de dialogue
enum DialogueType {
  intro,      // Début de niveau
  event,      // Événement pendant le niveau
  choice,     // Choix narratif
  outro,      // Fin de niveau
}

/// Choix narratif possible
class StoryChoice {
  final String id;
  final String text;
  final String description;
  final StoryPath path;
  final Map<String, int> rewards; // 'gold': 100, 'xp': 50, 'attack': 5
  final List<String> unlocksEnemies; // Ennemis ajoutés si ce choix
  final List<String> removeEnemies; // Ennemis supprimés si ce choix
  
  const StoryChoice({
    required this.id,
    required this.text,
    required this.description,
    required this.path,
    this.rewards = const {},
    this.unlocksEnemies = const [],
    this.removeEnemies = const [],
  });
}

/// Dialogue ou événement narratif
class StoryEvent {
  final String id;
  final DialogueType type;
  final String speaker; // 'player', 'elio', 'aria', 'narrator', etc.
  final String text;
  final String? speakerAvatar; // Chemin vers l'avatar
  final List<StoryChoice> choices;
  final StoryPath? requiredPath; // Seulement visible pour ce chemin
  
  const StoryEvent({
    required this.id,
    required this.type,
    required this.speaker,
    required this.text,
    this.speakerAvatar,
    this.choices = const [],
    this.requiredPath,
  });
}

/// Version alternative d'un stage selon le chemin narratif
class StageVariant {
  final StoryPath path;
  final String name;
  final String description;
  final String mapTheme;
  final List<EnemySpawn> enemies;
  final Map<String, int> rewards;
  final List<StoryEvent> events;
  
  const StageVariant({
    required this.path,
    required this.name,
    required this.description,
    required this.mapTheme,
    required this.enemies,
    this.rewards = const {},
    this.events = const [],
  });
}

/// Représente un stage individuel dans un chapitre
class CampaignStage {
  final int chapter;
  final int stage;
  final String baseName;
  final String baseDescription;
  final List<StageVariant> variants; // Différentes voies possibles
  final List<StoryEvent> commonEvents; // Événements communs à toutes les voies
  
  CampaignStage({
    required this.chapter,
    required this.stage,
    required this.baseName,
    required this.baseDescription,
    required this.variants,
    this.commonEvents = const [],
  });
  
  /// Retourne l'ID unique du stage (ex: 1.01 pour chapitre 1, stage 1)
  double get stageId => chapter + (stage / 100);
  
  /// Récupère la variante pour un chemin donné
  StageVariant? getVariant(StoryPath path) {
    try {
      return variants.firstWhere((v) => v.path == path);
    } catch (e) {
      return variants.isNotEmpty ? variants.first : null;
    }
  }
  
  /// Retourne les récompenses pour un chemin donné (or, XP)
  (int gold, int xp) getRewards(StoryPath path) {
    final variant = getVariant(path);
    if (variant == null) return (50, 25); // Récompenses par défaut
    
    final gold = variant.rewards['gold'] ?? 50;
    final xp = variant.rewards['xp'] ?? 25;
    
    return (gold, xp);
  }
  
  /// Retourne le nom pour un chemin donné
  String getName(StoryPath path) {
    final variant = getVariant(path);
    return variant?.name ?? baseName;
  }
  
  /// Retourne la description pour un chemin donné
  String getDescription(StoryPath path) {
    final variant = getVariant(path);
    return variant?.description ?? baseDescription;
  }
  
  /// Retourne les ennemis pour un chemin donné
  List<EnemySpawn> getEnemies(StoryPath path) {
    final variant = getVariant(path);
    return variant?.enemies ?? [];
  }
  
  /// Génère la map tactique pour ce stage selon le chemin
  TacticalMapData generateMap(StoryPath path) {
    final variant = getVariant(path);
    final theme = variant?.mapTheme ?? 'default';
    
    switch (theme) {
      case 'forest':
        return TacticalMapData.createForestMap();
      case 'plains':
        return TacticalMapData.createPlainsMap();
      case 'mountain':
        return TacticalMapData.createMountainMap();
      case 'dungeon':
        return TacticalMapData.createDungeonMap();
      case 'town':
        return TacticalMapData.createTownMap();
      case 'breach':
        return TacticalMapData.createBreachMap();
      case 'stairs':
        return TacticalMapData.createStairsMap();
      case 'relay':
        return TacticalMapData.createRelayMap();
      case 'canyon':
        return TacticalMapData.createCanyonMap();
      case 'void':
        return TacticalMapData.createVoidMap();
      case 'celestial':
        return TacticalMapData.createCelestialMap();
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
  final int level; // Niveau de l'ennemi
  
  EnemySpawn({
    required this.enemyId,
    required this.x,
    required this.y,
    this.level = 1,
  });
}

/// Représente un chapitre entier de la campagne
class CampaignChapter {
  final int chapterNumber;
  final String chapterName;
  final String description;
  final String theme;
  final List<CampaignStage> stages;
  final List<StoryEvent> chapterEvents; // Événements au début/fin du chapitre
  
  CampaignChapter({
    required this.chapterNumber,
    required this.chapterName,
    required this.description,
    required this.theme,
    required this.stages,
    this.chapterEvents = const [],
  });
  
  /// Retourne le stage correspondant au numéro
  CampaignStage? getStage(int stageNumber) {
    try {
      return stages.firstWhere((s) => s.stage == stageNumber);
    } catch (e) {
      return null;
    }
  }
}
