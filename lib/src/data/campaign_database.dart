import 'package:dice_destiny_idle_rifts/src/models/campaign_data.dart';

/// Base de données des chapitres et stages de la campagne
class CampaignDatabase {
  static final List<CampaignChapter> chapters = [
    // Chapitre 1 : Forêt Mystérieuse
    CampaignChapter(
      chapterNumber: 1,
      chapterName: 'Forêt Mystérieuse',
      description: 'Des bandits terrorisent les villages aux abords de la forêt.',
      theme: 'forest',
      stages: [
        CampaignStage(
          chapter: 1,
          stage: 1,
          name: 'Première Rencontre',
          description: 'Des bandits bloquent le passage.',
          mapTheme: 'forest',
          enemies: [
            EnemySpawn(enemyId: 'robber', x: 6, y: 3),
            EnemySpawn(enemyId: 'robber', x: 7, y: 5),
          ],
          rewardGold: 100,
          rewardXP: 50,
        ),
        CampaignStage(
          chapter: 1,
          stage: 2,
          name: 'L\'Embuscade',
          description: 'Plus d\'ennemis vous attendent en embuscade.',
          mapTheme: 'forest',
          enemies: [
            EnemySpawn(enemyId: 'robber', x: 5, y: 2),
            EnemySpawn(enemyId: 'robber', x: 6, y: 4),
            EnemySpawn(enemyId: 'wolf', x: 7, y: 3),
          ],
          rewardGold: 150,
          rewardXP: 75,
        ),
        CampaignStage(
          chapter: 1,
          stage: 3,
          name: 'Le Chef des Bandits',
          description: 'Affrontez le chef des bandits.',
          mapTheme: 'forest',
          enemies: [
            EnemySpawn(enemyId: 'robber', x: 5, y: 2),
            EnemySpawn(enemyId: 'robber', x: 7, y: 2),
            EnemySpawn(enemyId: 'wolf', x: 6, y: 3),
            EnemySpawn(enemyId: 'wolf', x: 6, y: 5),
          ],
          rewardGold: 250,
          rewardXP: 100,
        ),
      ],
    ),

    // Chapitre 2 : Plaines Ouvertes
    CampaignChapter(
      chapterNumber: 2,
      chapterName: 'Plaines Ouvertes',
      description: 'Les plaines sont infestées de créatures sauvages.',
      theme: 'plains',
      stages: [
        CampaignStage(
          chapter: 2,
          stage: 1,
          name: 'Meute de Loups',
          description: 'Une meute de loups affamés rôde.',
          mapTheme: 'plains',
          enemies: [
            EnemySpawn(enemyId: 'wolf', x: 6, y: 4),
            EnemySpawn(enemyId: 'wolf', x: 8, y: 3),
            EnemySpawn(enemyId: 'wolf', x: 7, y: 6),
          ],
          rewardGold: 200,
          rewardXP: 100,
        ),
        CampaignStage(
          chapter: 2,
          stage: 2,
          name: 'Bandits Organisés',
          description: 'Les bandits ont établi un campement.',
          mapTheme: 'plains',
          enemies: [
            EnemySpawn(enemyId: 'robber', x: 5, y: 3),
            EnemySpawn(enemyId: 'robber', x: 7, y: 3),
            EnemySpawn(enemyId: 'robber', x: 6, y: 5),
            EnemySpawn(enemyId: 'wolf', x: 8, y: 4),
          ],
          rewardGold: 300,
          rewardXP: 125,
        ),
        CampaignStage(
          chapter: 2,
          stage: 3,
          name: 'Défense du Village',
          description: 'Protégez le village contre l\'assaut.',
          mapTheme: 'plains',
          enemies: [
            EnemySpawn(enemyId: 'robber', x: 4, y: 2),
            EnemySpawn(enemyId: 'robber', x: 8, y: 2),
            EnemySpawn(enemyId: 'wolf', x: 5, y: 4),
            EnemySpawn(enemyId: 'wolf', x: 7, y: 4),
            EnemySpawn(enemyId: 'wolf', x: 6, y: 6),
          ],
          rewardGold: 400,
          rewardXP: 150,
        ),
      ],
    ),

    // Chapitre 3 : Pics Escarpés
    CampaignChapter(
      chapterNumber: 3,
      chapterName: 'Pics Escarpés',
      description: 'La montagne cache des dangers mortels.',
      theme: 'mountain',
      stages: [
        CampaignStage(
          chapter: 3,
          stage: 1,
          name: 'Ascension Périlleuse',
          description: 'Les sentiers de montagne sont gardés.',
          mapTheme: 'mountain',
          enemies: [
            EnemySpawn(enemyId: 'wolf', x: 5, y: 3),
            EnemySpawn(enemyId: 'wolf', x: 6, y: 5),
            EnemySpawn(enemyId: 'robber', x: 7, y: 4),
          ],
          rewardGold: 350,
          rewardXP: 150,
        ),
        CampaignStage(
          chapter: 3,
          stage: 2,
          name: 'Le Col Maudit',
          description: 'Un passage étroit contrôlé par des bandits.',
          mapTheme: 'mountain',
          enemies: [
            EnemySpawn(enemyId: 'robber', x: 4, y: 3),
            EnemySpawn(enemyId: 'robber', x: 6, y: 3),
            EnemySpawn(enemyId: 'robber', x: 5, y: 5),
            EnemySpawn(enemyId: 'wolf', x: 7, y: 4),
          ],
          rewardGold: 450,
          rewardXP: 175,
        ),
        CampaignStage(
          chapter: 3,
          stage: 3,
          name: 'Le Seigneur de la Montagne',
          description: 'Le chef des bandits de montagne vous attend.',
          mapTheme: 'mountain',
          enemies: [
            EnemySpawn(enemyId: 'robber', x: 3, y: 3),
            EnemySpawn(enemyId: 'robber', x: 7, y: 3),
            EnemySpawn(enemyId: 'wolf', x: 4, y: 5),
            EnemySpawn(enemyId: 'wolf', x: 6, y: 5),
            EnemySpawn(enemyId: 'wolf', x: 5, y: 6),
          ],
          rewardGold: 600,
          rewardXP: 200,
        ),
      ],
    ),
  ];

  /// Récupère un chapitre par son numéro
  static CampaignChapter? getChapter(int chapterNumber) {
    try {
      return chapters.firstWhere((c) => c.chapterNumber == chapterNumber);
    } catch (e) {
      return null;
    }
  }

  /// Récupère un stage spécifique
  static CampaignStage? getStage(int chapter, int stage) {
    final chap = getChapter(chapter);
    return chap?.getStage(stage);
  }

  /// Récupère le stage à partir de l'ID (ex: 1.02 -> chapitre 1, stage 2)
  static CampaignStage? getStageById(double stageId) {
    final chapter = stageId.floor();
    final stage = ((stageId - chapter) * 100).round();
    return getStage(chapter, stage);
  }

  /// Récupère le stage suivant
  static CampaignStage? getNextStage(double currentStageId) {
    final chapter = currentStageId.floor();
    final stage = ((currentStageId - chapter) * 100).round();

    final currentChapter = getChapter(chapter);
    if (currentChapter == null) return null;

    // Vérifier s'il y a un stage suivant dans ce chapitre
    final nextStageInChapter = currentChapter.stages
        .where((s) => s.stage == stage + 1)
        .firstOrNull;

    if (nextStageInChapter != null) {
      return nextStageInChapter;
    }

    // Sinon, passer au premier stage du chapitre suivant
    final nextChapter = getChapter(chapter + 1);
    return nextChapter?.stages.firstOrNull;
  }
}
