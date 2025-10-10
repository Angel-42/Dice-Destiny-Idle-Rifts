import '../models/map_data.dart';

/// Collection de maps prédéfinies pour les campagnes
class MapLibrary {
  // ============================================================================
  // TUTORIEL - Missions d'apprentissage
  // ============================================================================

  /// Tutorial 1: Déplacement de base
  static TacticalMapData tutorial01() {
    return TacticalMapData.custom(
      id: 'tutorial_01',
      name: 'Premiers Pas',
      width: 5,
      height: 5,
      terrainLayout: [
        [TerrainType.plains, TerrainType.plains, TerrainType.plains, TerrainType.plains, TerrainType.plains],
        [TerrainType.plains, TerrainType.plains, TerrainType.plains, TerrainType.plains, TerrainType.plains],
        [TerrainType.plains, TerrainType.plains, TerrainType.castle, TerrainType.plains, TerrainType.plains],
        [TerrainType.plains, TerrainType.plains, TerrainType.plains, TerrainType.plains, TerrainType.plains],
        [TerrainType.plains, TerrainType.plains, TerrainType.plains, TerrainType.plains, TerrainType.plains],
      ],
      description: 'Apprenez à vous déplacer sur la grille. Atteignez le château au centre !',
    );
  }

  /// Tutorial 2: Obstacles et terrain
  static TacticalMapData tutorial02() {
    return TacticalMapData.custom(
      id: 'tutorial_02',
      name: 'Terrain Varié',
      width: 6,
      height: 6,
      terrainLayout: [
        [TerrainType.plains, TerrainType.forest, TerrainType.forest, TerrainType.forest, TerrainType.plains, TerrainType.plains],
        [TerrainType.plains, TerrainType.forest, TerrainType.mountain, TerrainType.mountain, TerrainType.forest, TerrainType.plains],
        [TerrainType.plains, TerrainType.road, TerrainType.road, TerrainType.road, TerrainType.road, TerrainType.plains],
        [TerrainType.plains, TerrainType.forest, TerrainType.mountain, TerrainType.mountain, TerrainType.forest, TerrainType.plains],
        [TerrainType.plains, TerrainType.forest, TerrainType.forest, TerrainType.forest, TerrainType.forest, TerrainType.plains],
        [TerrainType.plains, TerrainType.plains, TerrainType.plains, TerrainType.plains, TerrainType.plains, TerrainType.castle],
      ],
      description: 'Contournez les montagnes et traversez la forêt. La route est plus rapide !',
    );
  }

  // ============================================================================
  // CAMPAGNE - Chapitre 1: L'Éveil des Rifts
  // ============================================================================

  /// Mission 1-1: Plaine des Premiers Pas
  static TacticalMapData chapter1Mission1() {
    return TacticalMapData.createTestMap(); // Map par défaut
  }

  /// Mission 1-2: Forêt Obscure
  static TacticalMapData chapter1Mission2() {
    return TacticalMapData.custom(
      id: 'chapter_1_mission_2',
      name: 'Forêt Obscure',
      width: 10,
      height: 8,
      terrainLayout: [
        [TerrainType.forest, TerrainType.forest, TerrainType.forest, TerrainType.forest, TerrainType.forest, TerrainType.forest, TerrainType.forest, TerrainType.forest, TerrainType.forest, TerrainType.forest],
        [TerrainType.forest, TerrainType.plains, TerrainType.plains, TerrainType.forest, TerrainType.forest, TerrainType.forest, TerrainType.forest, TerrainType.plains, TerrainType.plains, TerrainType.forest],
        [TerrainType.forest, TerrainType.plains, TerrainType.road, TerrainType.road, TerrainType.forest, TerrainType.forest, TerrainType.road, TerrainType.road, TerrainType.plains, TerrainType.forest],
        [TerrainType.forest, TerrainType.forest, TerrainType.road, TerrainType.forest, TerrainType.forest, TerrainType.forest, TerrainType.forest, TerrainType.road, TerrainType.forest, TerrainType.forest],
        [TerrainType.forest, TerrainType.forest, TerrainType.road, TerrainType.road, TerrainType.road, TerrainType.road, TerrainType.road, TerrainType.road, TerrainType.forest, TerrainType.forest],
        [TerrainType.forest, TerrainType.plains, TerrainType.plains, TerrainType.forest, TerrainType.forest, TerrainType.forest, TerrainType.forest, TerrainType.plains, TerrainType.plains, TerrainType.forest],
        [TerrainType.forest, TerrainType.plains, TerrainType.castle, TerrainType.forest, TerrainType.forest, TerrainType.forest, TerrainType.forest, TerrainType.plains, TerrainType.plains, TerrainType.forest],
        [TerrainType.forest, TerrainType.forest, TerrainType.forest, TerrainType.forest, TerrainType.forest, TerrainType.forest, TerrainType.forest, TerrainType.forest, TerrainType.forest, TerrainType.forest],
      ],
      description: 'Une forêt dense avec un ancien château abandonné. Des gobelins rôdent dans les parages...',
    );
  }

  /// Mission 1-3: Pont de la Rivière
  static TacticalMapData chapter1Mission3() {
    return TacticalMapData.custom(
      id: 'chapter_1_mission_3',
      name: 'Pont de la Rivière',
      width: 12,
      height: 7,
      terrainLayout: [
        [TerrainType.plains, TerrainType.plains, TerrainType.plains, TerrainType.water, TerrainType.water, TerrainType.water, TerrainType.water, TerrainType.water, TerrainType.plains, TerrainType.plains, TerrainType.plains, TerrainType.plains],
        [TerrainType.plains, TerrainType.forest, TerrainType.plains, TerrainType.water, TerrainType.water, TerrainType.water, TerrainType.water, TerrainType.water, TerrainType.plains, TerrainType.forest, TerrainType.plains, TerrainType.plains],
        [TerrainType.plains, TerrainType.plains, TerrainType.plains, TerrainType.water, TerrainType.water, TerrainType.water, TerrainType.water, TerrainType.water, TerrainType.plains, TerrainType.plains, TerrainType.plains, TerrainType.castle],
        [TerrainType.plains, TerrainType.road, TerrainType.road, TerrainType.road, TerrainType.road, TerrainType.road, TerrainType.road, TerrainType.road, TerrainType.road, TerrainType.road, TerrainType.road, TerrainType.road],
        [TerrainType.plains, TerrainType.plains, TerrainType.plains, TerrainType.water, TerrainType.water, TerrainType.water, TerrainType.water, TerrainType.water, TerrainType.plains, TerrainType.plains, TerrainType.plains, TerrainType.plains],
        [TerrainType.plains, TerrainType.forest, TerrainType.plains, TerrainType.water, TerrainType.water, TerrainType.water, TerrainType.water, TerrainType.water, TerrainType.plains, TerrainType.forest, TerrainType.plains, TerrainType.plains],
        [TerrainType.plains, TerrainType.plains, TerrainType.plains, TerrainType.water, TerrainType.water, TerrainType.water, TerrainType.water, TerrainType.water, TerrainType.plains, TerrainType.plains, TerrainType.plains, TerrainType.plains],
      ],
      description: 'Traversez le pont étroit pour atteindre le fort ennemi. Attention aux embuscades !',
    );
  }

  // ============================================================================
  // CAMPAGNE - Chapitre 2: Le Rift Cramoisi
  // ============================================================================

  /// Mission 2-1: Montagne des Géants
  static TacticalMapData chapter2Mission1() {
    return TacticalMapData.custom(
      id: 'chapter_2_mission_1',
      name: 'Montagne des Géants',
      width: 10,
      height: 10,
      terrainLayout: [
        [TerrainType.mountain, TerrainType.mountain, TerrainType.mountain, TerrainType.mountain, TerrainType.mountain, TerrainType.mountain, TerrainType.mountain, TerrainType.mountain, TerrainType.mountain, TerrainType.mountain],
        [TerrainType.mountain, TerrainType.plains, TerrainType.plains, TerrainType.mountain, TerrainType.mountain, TerrainType.mountain, TerrainType.mountain, TerrainType.mountain, TerrainType.mountain, TerrainType.mountain],
        [TerrainType.mountain, TerrainType.plains, TerrainType.road, TerrainType.road, TerrainType.mountain, TerrainType.mountain, TerrainType.mountain, TerrainType.mountain, TerrainType.castle, TerrainType.mountain],
        [TerrainType.mountain, TerrainType.mountain, TerrainType.mountain, TerrainType.road, TerrainType.road, TerrainType.mountain, TerrainType.mountain, TerrainType.mountain, TerrainType.road, TerrainType.mountain],
        [TerrainType.mountain, TerrainType.mountain, TerrainType.mountain, TerrainType.mountain, TerrainType.road, TerrainType.road, TerrainType.mountain, TerrainType.mountain, TerrainType.road, TerrainType.mountain],
        [TerrainType.mountain, TerrainType.mountain, TerrainType.mountain, TerrainType.mountain, TerrainType.mountain, TerrainType.road, TerrainType.road, TerrainType.road, TerrainType.road, TerrainType.mountain],
        [TerrainType.mountain, TerrainType.forest, TerrainType.forest, TerrainType.mountain, TerrainType.mountain, TerrainType.mountain, TerrainType.mountain, TerrainType.mountain, TerrainType.mountain, TerrainType.mountain],
        [TerrainType.mountain, TerrainType.forest, TerrainType.plains, TerrainType.plains, TerrainType.mountain, TerrainType.mountain, TerrainType.mountain, TerrainType.mountain, TerrainType.mountain, TerrainType.mountain],
        [TerrainType.mountain, TerrainType.plains, TerrainType.plains, TerrainType.plains, TerrainType.mountain, TerrainType.mountain, TerrainType.mountain, TerrainType.mountain, TerrainType.mountain, TerrainType.mountain],
        [TerrainType.mountain, TerrainType.mountain, TerrainType.mountain, TerrainType.mountain, TerrainType.mountain, TerrainType.mountain, TerrainType.mountain, TerrainType.mountain, TerrainType.mountain, TerrainType.mountain],
      ],
      description: 'Un passage montagneux difficile. Le chemin est étroit et dangereux.',
    );
  }

  /// Mission 2-2: Forteresse Assiégée
  static TacticalMapData chapter2Mission2() {
    return TacticalMapData.custom(
      id: 'chapter_2_mission_2',
      name: 'Forteresse Assiégée',
      width: 9,
      height: 9,
      terrainLayout: [
        [TerrainType.plains, TerrainType.plains, TerrainType.plains, TerrainType.plains, TerrainType.plains, TerrainType.plains, TerrainType.plains, TerrainType.plains, TerrainType.plains],
        [TerrainType.plains, TerrainType.mountain, TerrainType.mountain, TerrainType.mountain, TerrainType.mountain, TerrainType.mountain, TerrainType.mountain, TerrainType.mountain, TerrainType.plains],
        [TerrainType.plains, TerrainType.mountain, TerrainType.castle, TerrainType.castle, TerrainType.castle, TerrainType.castle, TerrainType.castle, TerrainType.mountain, TerrainType.plains],
        [TerrainType.plains, TerrainType.mountain, TerrainType.castle, TerrainType.plains, TerrainType.plains, TerrainType.plains, TerrainType.castle, TerrainType.mountain, TerrainType.plains],
        [TerrainType.plains, TerrainType.road, TerrainType.road, TerrainType.plains, TerrainType.castle, TerrainType.plains, TerrainType.castle, TerrainType.road, TerrainType.plains],
        [TerrainType.plains, TerrainType.mountain, TerrainType.castle, TerrainType.plains, TerrainType.plains, TerrainType.plains, TerrainType.castle, TerrainType.mountain, TerrainType.plains],
        [TerrainType.plains, TerrainType.mountain, TerrainType.castle, TerrainType.castle, TerrainType.castle, TerrainType.castle, TerrainType.castle, TerrainType.mountain, TerrainType.plains],
        [TerrainType.plains, TerrainType.mountain, TerrainType.mountain, TerrainType.mountain, TerrainType.mountain, TerrainType.mountain, TerrainType.mountain, TerrainType.mountain, TerrainType.plains],
        [TerrainType.plains, TerrainType.plains, TerrainType.plains, TerrainType.plains, TerrainType.plains, TerrainType.plains, TerrainType.plains, TerrainType.plains, TerrainType.plains],
      ],
      description: 'Assiégez la forteresse ennemie ! Infiltrez-vous par la porte principale ou contournez les murs.',
    );
  }

  // ============================================================================
  // ARÈNE - Maps PvP
  // ============================================================================

  /// Arène 1: Colisée Équilibré
  static TacticalMapData arenaBalanced() {
    return TacticalMapData.custom(
      id: 'arena_balanced',
      name: 'Colisée Équilibré',
      width: 8,
      height: 8,
      terrainLayout: [
        [TerrainType.castle, TerrainType.plains, TerrainType.plains, TerrainType.forest, TerrainType.forest, TerrainType.plains, TerrainType.plains, TerrainType.castle],
        [TerrainType.plains, TerrainType.plains, TerrainType.forest, TerrainType.forest, TerrainType.forest, TerrainType.forest, TerrainType.plains, TerrainType.plains],
        [TerrainType.plains, TerrainType.forest, TerrainType.plains, TerrainType.plains, TerrainType.plains, TerrainType.plains, TerrainType.forest, TerrainType.plains],
        [TerrainType.forest, TerrainType.forest, TerrainType.plains, TerrainType.mountain, TerrainType.mountain, TerrainType.plains, TerrainType.forest, TerrainType.forest],
        [TerrainType.forest, TerrainType.forest, TerrainType.plains, TerrainType.mountain, TerrainType.mountain, TerrainType.plains, TerrainType.forest, TerrainType.forest],
        [TerrainType.plains, TerrainType.forest, TerrainType.plains, TerrainType.plains, TerrainType.plains, TerrainType.plains, TerrainType.forest, TerrainType.plains],
        [TerrainType.plains, TerrainType.plains, TerrainType.forest, TerrainType.forest, TerrainType.forest, TerrainType.forest, TerrainType.plains, TerrainType.plains],
        [TerrainType.castle, TerrainType.plains, TerrainType.plains, TerrainType.forest, TerrainType.forest, TerrainType.plains, TerrainType.plains, TerrainType.castle],
      ],
      description: 'Arène symétrique pour un combat équitable. Montagne au centre bloque la ligne de vue.',
    );
  }

  // ============================================================================
  // UTILITAIRES
  // ============================================================================

  /// Obtenir toutes les maps de tutoriel
  static List<TacticalMapData> getTutorialMaps() {
    return [
      tutorial01(),
      tutorial02(),
    ];
  }

  /// Obtenir toutes les maps du chapitre 1
  static List<TacticalMapData> getChapter1Maps() {
    return [
      chapter1Mission1(),
      chapter1Mission2(),
      chapter1Mission3(),
    ];
  }

  /// Obtenir toutes les maps du chapitre 2
  static List<TacticalMapData> getChapter2Maps() {
    return [
      chapter2Mission1(),
      chapter2Mission2(),
    ];
  }

  /// Obtenir une map par son ID
  static TacticalMapData? getMapById(String id) {
    final allMaps = [
      ...getTutorialMaps(),
      ...getChapter1Maps(),
      ...getChapter2Maps(),
      arenaBalanced(),
    ];

    try {
      return allMaps.firstWhere((map) => map.id == id);
    } catch (e) {
      return null;
    }
  }
}
