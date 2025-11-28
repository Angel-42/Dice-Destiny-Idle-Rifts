import '../models/character.dart';
import '../models/persona.dart';

/// Database des ennemis du jeu
class EnemyDatabase {
  /// Crée une instance d'ennemi à partir de son ID
  static Character createEnemy(String enemyId, {int level = 1}) {
    final template = _enemies[enemyId];
    if (template == null) {
      throw Exception('Enemy ID "$enemyId" not found in database');
    }
    
    return template(level);
  }

  /// Récupère tous les IDs d'ennemis disponibles
  static List<String> getAllEnemyIds() => _enemies.keys.toList();

  /// Map des ennemis disponibles (fonction qui génère l'ennemi selon le niveau)
  static final Map<String, Character Function(int level)> _enemies = {
    'wolf': _createWolf,
    'robber': _createRobber,
  };

  // ============================================================================
  // WOLF - Loup sauvage
  // ============================================================================
  static Character _createWolf(int level) {
    final baseHp = 40;
    final baseAtk = 12;
    final baseDef = 6;
    final baseSpd = 15;
    
    return Character(
      name: 'Wolf',
      level: level,
      persona: Persona(
        race: PersonaRace.orc, // Utiliser une race existante
        characterClass: PersonaClass.warrior,
        region: PersonaRegion.north,
        origin: PersonaOrigin.peasant,
      ),
      stats: CharacterStats(
        maxHp: baseHp + (level * 8),
        attack: baseAtk + (level * 2),
        defense: baseDef + (level * 1),
        speed: baseSpd + (level * 2),
        magic: 0,
        range: 1,
        luck: 5,
        movement: 5, // Rapide
      ),
      appearance: CharacterAppearance(
        headshot: '🐺',
        lheadshot: 'assets/ennemies/wolf/headshot.png',
        pixel: 'assets/ennemies/wolf/pixel.png',
        fullsize: 'assets/ennemies/wolf/fullsize.png',
        description: 'Loup sauvage et agressif',
        colorValue: 0xFF8B4513, // Brun
      ),
    );
  }

  // ============================================================================
  // ROBBER - Brigand
  // ============================================================================
  static Character _createRobber(int level) {
    final baseHp = 50;
    final baseAtk = 15;
    final baseDef = 8;
    final baseSpd = 12;
    
    return Character(
      name: 'Robber',
      level: level,
      persona: Persona(
        race: PersonaRace.human,
        characterClass: PersonaClass.peasant,
        region: PersonaRegion.south,
        origin: PersonaOrigin.peasant,
      ),
      stats: CharacterStats(
        maxHp: baseHp + (level * 10),
        attack: baseAtk + (level * 3),
        defense: baseDef + (level * 2),
        speed: baseSpd + (level * 2),
        magic: 0,
        range: 1,
        luck: 8,
        movement: 4, // Standard
      ),
      appearance: CharacterAppearance(
        headshot: '🗡️',
        lheadshot: 'assets/ennemies/robber/robber_headshot.png',
        pixel: 'assets/ennemies/robber/robber_pixel.png',
        fullsize: 'assets/ennemies/robber/robber_fullsize.png',
        description: 'Brigand sans scrupules',
        colorValue: 0xFF8B0000, // Rouge foncé
      ),
    );
  }

  // ============================================================================
  // HELPERS
  // ============================================================================
  
  /// Génère une liste d'ennemis aléatoires pour une map
  static List<Character> generateEnemiesForMap({
    required int count,
    required int averageLevel,
    List<String>? allowedEnemyIds,
  }) {
    final ids = allowedEnemyIds ?? getAllEnemyIds();
    final enemies = <Character>[];
    
    for (int i = 0; i < count; i++) {
      // Variation de niveau ±1
      final levelVariance = (i % 3) - 1; // -1, 0, 1
      final enemyLevel = (averageLevel + levelVariance).clamp(1, 99);
      
      // Choisir un ennemi au hasard
      final enemyId = ids[i % ids.length];
      enemies.add(createEnemy(enemyId, level: enemyLevel));
    }
    
    return enemies;
  }
}
