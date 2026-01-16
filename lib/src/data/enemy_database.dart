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
    // GÉNÉRIQUES - Créatures communes
    'wolf': _createWolf,
    'robber': _createRobber,
    'crystal_wolf': _createCrystalWolf,
    'shadow_negation': _createShadowNegation,
    
    // AETHELGARD - Anomalies du royaume ancien
    'iron_sentinel': _createIronSentinel,
    'blind_inquisitor': _createBlindInquisitor,
    
    // FLUX DE SYLLA - Marché corrompu
    'merchant_shadow': _createMerchantShadow,
    'corruption_doll': _createCorruptionDoll,
    
    // CŒUR DE FERRO - Forges industrielles
    'ticking_golem': _createTickingGolem,
    'furnace_wraith': _createFurnaceWraith,
    
    // FORÊT DES BRUMES - Manifestations organiques
    'sap_scout': _createSapScout,
    'corrupt_ent': _createCorruptEnt,
    
    // FLUX CÉLESTE - Entités éthérées
    'calligraphy_specter': _createCalligraphySpecter,
    'jade_golem': _createJadeGolem,
    
    // BOSS FINAL - Gardien du Rift Core
    'threshold_guardian': _createThresholdGuardian,
  };

  // ============================================================================
  // GÉNÉRIQUES - Créatures communes
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
        race: PersonaRace.orc,
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
        movement: 5,
      ),
      appearance: CharacterAppearance(
        headshot: '🐺',
        lheadshot: 'assets/ennemies/wolf/headshot.png',
        pixel: 'assets/ennemies/wolf/pixel.png',
        fullsize: 'assets/ennemies/wolf/fullsize.png',
        description: 'Loup sauvage et agressif',
        colorValue: 0xFF8B4513,
      ),
    );
  }

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
        characterClass: PersonaClass.warrior,
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
        movement: 4,
      ),
      appearance: CharacterAppearance(
        headshot: '🗡️',
        lheadshot: 'assets/ennemies/robber/robber_headshot.png',
        pixel: 'assets/ennemies/robber/robber_pixel.png',
        fullsize: 'assets/ennemies/robber/robber_fullsize.png',
        description: 'Brigand sans scrupules',
        colorValue: 0xFF8B0000,
      ),
    );
  }

  static Character _createCrystalWolf(int level) {
    final baseHp = 55;
    final baseAtk = 14;
    final baseDef = 8;
    final baseSpd = 16;
    
    return Character(
      name: 'Loup de Cristal',
      level: level,
      persona: Persona(
        race: PersonaRace.orc,
        characterClass: PersonaClass.warrior,
        region: PersonaRegion.north,
        origin: PersonaOrigin.peasant,
      ),
      stats: CharacterStats(
        maxHp: baseHp + (level * 9),
        attack: baseAtk + (level * 3),
        defense: baseDef + (level * 2),
        speed: baseSpd + (level * 2),
        magic: 5,
        range: 1,
        luck: 6,
        movement: 5,
      ),
      appearance: CharacterAppearance(
        headshot: '🐺',
        lheadshot: 'assets/ennemies/wolf/headshot.png',
        pixel: 'assets/ennemies/wolf/pixel.png',
        fullsize: 'assets/ennemies/wolf/fullsize.png',
        description: 'Prédateur infecté par la Négation. Ses yeux brillent d\'un éclat violet instable. '
                     'Capacité : Explosion Cristalline - À sa mort, explose en infligeant des dégâts de zone.',
        colorValue: 0xFF9C27B0,
      ),
    );
  }

  static Character _createShadowNegation(int level) {
    final baseHp = 45;
    final baseAtk = 10;
    final baseDef = 5;
    final baseSpd = 18;
    
    return Character(
      name: 'Ombre de Négation',
      level: level,
      persona: Persona(
        race: PersonaRace.elf,
        characterClass: PersonaClass.mage,
        region: PersonaRegion.west,
        origin: PersonaOrigin.scholar,
      ),
      stats: CharacterStats(
        maxHp: baseHp + (level * 7),
        attack: baseAtk + (level * 2),
        defense: baseDef + (level * 1),
        speed: baseSpd + (level * 3),
        magic: 8,
        range: 1,
        luck: 12,
        movement: 6,
      ),
      appearance: CharacterAppearance(
        headshot: '👤',
        lheadshot: 'assets/ennemies/shadow_of_negation/headshot.png',
        pixel: 'assets/ennemies/shadow_of_negation/pixel.png',
        fullsize: 'assets/ennemies/shadow_of_negation/fullsize.png',
        description: 'Silhouette humanoïde sans visage, faite de fumée noire et de particules de dés. '
                     'Capacité : Miroir - Renvoie 10% des dégâts reçus à l\'attaquant.',
        colorValue: 0xFF212121,
      ),
    );
  }

  // ============================================================================
  // AETHELGARD - Ennemis du royaume ancien
  // ============================================================================

  static Character _createIronSentinel(int level) {
    final baseHp = 80;
    final baseAtk = 18;
    final baseDef = 20;
    final baseSpd = 6;
    
    return Character(
      name: 'Sentinelle de Fer',
      level: level,
      persona: Persona(
        race: PersonaRace.dwarf,
        characterClass: PersonaClass.warrior,
        region: PersonaRegion.west,
        origin: PersonaOrigin.noble,
      ),
      stats: CharacterStats(
        maxHp: baseHp + (level * 15),
        attack: baseAtk + (level * 3),
        defense: baseDef + (level * 4),
        speed: baseSpd + (level * 1),
        magic: 0,
        range: 1,
        luck: 3,
        movement: 3,
      ),
      appearance: CharacterAppearance(
        headshot: '🛡️',
        lheadshot: 'assets/ennemies/iron_sentinel/headshot.png',
        pixel: 'assets/ennemies/iron_sentinel/pixel.png',
        fullsize: 'assets/ennemies/iron_sentinel/fullsize.png',
        description: 'Armure vide animée par une volonté d\'ordre fanatique. '
                     'Capacité : Mur de Fer - Réduit les dégâts physiques de 50% subis de face.',
        colorValue: 0xFFC0C0C0,
      ),
    );
  }

  static Character _createBlindInquisitor(int level) {
    final baseHp = 60;
    final baseAtk = 8;
    final baseDef = 12;
    final baseSpd = 10;
    
    return Character(
      name: 'Inquisiteur Aveugle',
      level: level,
      persona: Persona(
        race: PersonaRace.human,
        characterClass: PersonaClass.cleric,
        region: PersonaRegion.west,
        origin: PersonaOrigin.noble,
      ),
      stats: CharacterStats(
        maxHp: baseHp + (level * 11),
        attack: baseAtk + (level * 2),
        defense: baseDef + (level * 2),
        speed: baseSpd + (level * 2),
        magic: 20 + (level * 4),
        range: 2,
        luck: 5,
        movement: 4,
      ),
      appearance: CharacterAppearance(
        headshot: '⚖️',
        lheadshot: 'assets/ennemies/blind_inquisitor/headshot.png',
        pixel: 'assets/ennemies/blind_inquisitor/pixel.png',
        fullsize: 'assets/ennemies/blind_inquisitor/fullsize.png',
        description: 'Humain corrompu maniant des chaînes de lumière solide. '
                     'Capacité : Entrave - Immobilise un compagnon pendant 2 tours avec des chaînes sacrées.',
        colorValue: 0xFFFFD700,
      ),
    );
  }

  // ============================================================================
  // FLUX DE SYLLA - Ennemis du marché corrompu
  // ============================================================================

  static Character _createMerchantShadow(int level) {
    final baseHp = 55;
    final baseAtk = 12;
    final baseDef = 10;
    final baseSpd = 14;
    
    return Character(
      name: 'Merchant Shadow',
      level: level,
      persona: Persona(
        race: PersonaRace.human,
        characterClass: PersonaClass.mage,
        region: PersonaRegion.south,
        origin: PersonaOrigin.merchant,
      ),
      stats: CharacterStats(
        maxHp: baseHp + (level * 10),
        attack: baseAtk + (level * 2),
        defense: baseDef + (level * 2),
        speed: baseSpd + (level * 2),
        magic: 5,
        range: 1,
        luck: 15,
        movement: 5,
      ),
      appearance: CharacterAppearance(
        headshot: '💰',
        lheadshot: 'assets/ennemies/merchant_shadow/headshot.png',
        pixel: 'assets/ennemies/merchant_shadow/pixel.png',
        fullsize: 'assets/ennemies/merchant_shadow/fullsize.png',
        description: 'Marchand Cupide',
        colorValue: 0xFFFFB300,
      ),
    );
  }

  static Character _createCorruptionDoll(int level) {
    final baseHp = 50;
    final baseAtk = 16;
    final baseDef = 7;
    final baseSpd = 13;
    
    return Character(
      name: 'Corruption Doll',
      level: level,
      persona: Persona(
        race: PersonaRace.elf,
        characterClass: PersonaClass.mage,
        region: PersonaRegion.south,
        origin: PersonaOrigin.scholar,
      ),
      stats: CharacterStats(
        maxHp: baseHp + (level * 8),
        attack: baseAtk + (level * 3),
        defense: baseDef + (level * 1),
        speed: baseSpd + (level * 2),
        magic: 12 + (level * 3),
        range: 1,
        luck: 8,
        movement: 4,
      ),
      appearance: CharacterAppearance(
        headshot: '🎎',
        lheadshot: 'assets/ennemies/corruption_doll/headshot.png',
        pixel: 'assets/ennemies/corruption_doll/pixel.png',
        fullsize: 'assets/ennemies/corruption_doll/fullsize.png',
        description: 'Poupée Corrompue',
        colorValue: 0xFFE91E63,
      ),
    );
  }

  // ============================================================================
  // CŒUR DE FERRO - Ennemis industriels
  // ============================================================================

  static Character _createTickingGolem(int level) {
    final baseHp = 90;
    final baseAtk = 22;
    final baseDef = 18;
    final baseSpd = 5;
    
    return Character(
      name: 'Ticking Golem',
      level: level,
      persona: Persona(
        race: PersonaRace.dwarf,
        characterClass: PersonaClass.warrior,
        region: PersonaRegion.east,
        origin: PersonaOrigin.scholar,
      ),
      stats: CharacterStats(
        maxHp: baseHp + (level * 16),
        attack: baseAtk + (level * 4),
        defense: baseDef + (level * 3),
        speed: baseSpd + (level * 1),
        magic: 0,
        range: 1,
        luck: 2,
        movement: 2,
      ),
      appearance: CharacterAppearance(
        headshot: '⚙️',
        lheadshot: 'assets/ennemies/ticking_golem/headshot.png',
        pixel: 'assets/ennemies/ticking_golem/pixel.png',
        fullsize: 'assets/ennemies/ticking_golem/fullsize.png',
        description: 'Golem Mécanique',
        colorValue: 0xFF795548,
      ),
    );
  }

  static Character _createFurnaceWraith(int level) {
    final baseHp = 65;
    final baseAtk = 10;
    final baseDef = 8;
    final baseSpd = 12;
    
    return Character(
      name: 'Furnace Wraith',
      level: level,
      persona: Persona(
        race: PersonaRace.human,
        characterClass: PersonaClass.mage,
        region: PersonaRegion.east,
        origin: PersonaOrigin.peasant,
      ),
      stats: CharacterStats(
        maxHp: baseHp + (level * 11),
        attack: baseAtk + (level * 2),
        defense: baseDef + (level * 1),
        speed: baseSpd + (level * 2),
        magic: 18 + (level * 4),
        range: 2,
        luck: 6,
        movement: 4,
      ),
      appearance: CharacterAppearance(
        headshot: '🔥',
        lheadshot: 'assets/ennemies/furnace_wraith/headshot.png',
        pixel: 'assets/ennemies/furnace_wraith/pixel.png',
        fullsize: 'assets/ennemies/furnace_wraith/fullsize.png',
        description: 'Esprit des Forges',
        colorValue: 0xFFFF5722,
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
  
  /// Obtient les ennemis par région/thème selon le bestiaire
  static List<String> getEnemiesByTheme(String theme) {
    switch (theme) {
      case 'general':
        // Créatures errantes des failles mineures
        return ['wolf', 'crystal_wolf', 'shadow_negation'];
      case 'aethelgard': 
        // Anomalies du royaume ancien et son fanatisme
        return ['iron_sentinel', 'blind_inquisitor', 'robber'];
      case 'forest':
        // Manifestations organiques de la Forêt des Brumes
        return ['sap_scout', 'corrupt_ent', 'wolf'];
      case 'celestial':
        // Entités éthérées du Flux Céleste 
        return ['calligraphy_specter', 'jade_golem', 'shadow_negation'];
      case 'sylla':
        // Marché corrompu du Flux de Sylla
        return ['merchant_shadow', 'corruption_doll', 'shadow_negation'];
      case 'ferro':
        // Forges industrielles du Cœur de Ferro
        return ['ticking_golem', 'furnace_wraith', 'robber'];
      case 'boss':
        // Gardien colossal du Rift Core
        return ['threshold_guardian'];
      case 'all':
      default:
        return getAllEnemyIds();
    }
  }

  // ============================================================================
  // FORÊT DES BRUMES - Manifestations organiques
  // ============================================================================

  static Character _createSapScout(int level) {
    final baseHp = 50;
    final baseAtk = 14;
    final baseDef = 10;
    final baseSpd = 18;
    
    return Character(
      name: 'Éclaireur de Sève',
      level: level,
      persona: Persona(
        race: PersonaRace.orc,
        characterClass: PersonaClass.peasant,
        region: PersonaRegion.south,
        origin: PersonaOrigin.peasant,
      ),
      stats: CharacterStats(
        maxHp: baseHp + (level * 8),
        attack: baseAtk + (level * 2),
        defense: baseDef + (level * 2),
        speed: baseSpd + (level * 2),
        magic: 5 + level,
        range: 1,
        luck: 10 + level,
        movement: 6,
      ),
      appearance: CharacterAppearance(
        headshot: '🕷️',
        lheadshot: 'assets/ennemies/sap_scout/headshot.png',
        pixel: 'assets/ennemies/sap_scout/pixel.png',
        fullsize: 'assets/ennemies/sap_scout/fullsize.png',
        description: 'Araignée géante mélange de bois pétrifié et cristal de faille. '
                     'Capacité : Toile Probabiliste - Réduit les chances de coup critique.',
        colorValue: 0xFF228B22,
      ),
    );
  }

  static Character _createCorruptEnt(int level) {
    final baseHp = 120;
    final baseAtk = 18;
    final baseDef = 22;
    final baseSpd = 8;
    
    return Character(
      name: 'Ent Corrompu',
      level: level,
      persona: Persona(
        race: PersonaRace.orc,
        characterClass: PersonaClass.warrior,
        region: PersonaRegion.south,
        origin: PersonaOrigin.noble,
      ),
      stats: CharacterStats(
        maxHp: baseHp + (level * 15),
        attack: baseAtk + (level * 3),
        defense: baseDef + (level * 3),
        speed: baseSpd + level,
        magic: 8 + level,
        range: 1,
        luck: 5 + level ~/ 2,
        movement: 3,
      ),
      appearance: CharacterAppearance(
        headshot: '🌳',
        lheadshot: 'assets/ennemies/corrupt_ent/headshot.png',
        pixel: 'assets/ennemies/corrupt_ent/pixel.png',
        fullsize: 'assets/ennemies/corrupt_ent/fullsize.png',
        description: 'Arbre millénaire dont le cœur a été remplacé par une Rift. '
                     'Capacité : Drain de Vie - Se soigne en volant l\'énergie vitale.',
        colorValue: 0xFF8B4513,
      ),
    );
  }

  // ============================================================================
  // FLUX CÉLESTE - Entités éthérées
  // ============================================================================

  static Character _createCalligraphySpecter(int level) {
    final baseHp = 55;
    final baseAtk = 10;
    final baseDef = 8;
    final baseSpd = 16;
    
    return Character(
      name: 'Spectre de Calligraphie',
      level: level,
      persona: Persona(
        race: PersonaRace.human,
        characterClass: PersonaClass.mage,
        region: PersonaRegion.south,
        origin: PersonaOrigin.scholar,
      ),
      stats: CharacterStats(
        maxHp: baseHp + (level * 7),
        attack: baseAtk + level,
        defense: baseDef + level,
        speed: baseSpd + (level * 2),
        magic: 20 + (level * 2),
        range: 2,
        luck: 12 + level,
        movement: 5,
      ),
      appearance: CharacterAppearance(
        headshot: '📜',
        lheadshot: 'assets/ennemies/calligraphy_specter/headshot.png',
        pixel: 'assets/ennemies/calligraphy_specter/pixel.png',
        fullsize: 'assets/ennemies/calligraphy_specter/fullsize.png',
        description: 'Esprit d\'encre flottante écrivant des malédictions. '
                     'Capacité : Silence - Scelle les sorts magiques.',
        colorValue: 0xFF4B0082,
      ),
    );
  }

  static Character _createJadeGolem(int level) {
    final baseHp = 100;
    final baseAtk = 25;
    final baseDef = 28;
    final baseSpd = 6;
    
    return Character(
      name: 'Golem de Jade',
      level: level,
      persona: Persona(
        race: PersonaRace.dwarf,
        characterClass: PersonaClass.warrior,
        region: PersonaRegion.south,
        origin: PersonaOrigin.merchant,
      ),
      stats: CharacterStats(
        maxHp: baseHp + (level * 12),
        attack: baseAtk + (level * 4),
        defense: baseDef + (level * 4),
        speed: baseSpd + (level ~/ 2),
        magic: 5 + (level ~/ 2),
        range: 1,
        luck: 3 + (level ~/ 3),
        movement: 3,
      ),
      appearance: CharacterAppearance(
        headshot: '🗿',
        lheadshot: 'assets/ennemies/jade_golem/headshot.png',
        pixel: 'assets/ennemies/jade_golem/pixel.png',
        fullsize: 'assets/ennemies/jade_golem/fullsize.png',
        description: 'Statue sacrée activée par erreur. Lente mais dévastatrice. '
                     'Capacité : Écrasement - Dégâts lourds basés sur la défense.',
        colorValue: 0xFF00FF7F,
      ),
    );
  }

  // ============================================================================
  // BOSS FINAL - Gardien du Rift Core
  // ============================================================================

  static Character _createThresholdGuardian(int level) {
    final baseHp = 300;
    final baseAtk = 35;
    final baseDef = 30;
    final baseSpd = 20;
    
    return Character(
      name: 'Gardien du Seuil',
      level: level,
      persona: Persona(
        race: PersonaRace.elf,
        characterClass: PersonaClass.cleric,
        region: PersonaRegion.west,
        origin: PersonaOrigin.noble,
      ),
      stats: CharacterStats(
        maxHp: baseHp + (level * 25),
        attack: baseAtk + (level * 5),
        defense: baseDef + (level * 4),
        speed: baseSpd + (level * 3),
        magic: 30 + (level * 3),
        range: 2,
        luck: 25 + (level * 2),
        movement: 4,
      ),
      appearance: CharacterAppearance(
        headshot: '🎲',
        lheadshot: 'assets/ennemies/threshold_guardian/headshot.png',
        pixel: 'assets/ennemies/threshold_guardian/pixel.png',
        fullsize: 'assets/ennemies/threshold_guardian/fullsize.png',
        description: 'Entité colossale à six bras tenant des dés de platine. '
                     'Capacité : Jet de Destin - Altération d\'état aléatoire pour l\'équipe.',
        colorValue: 0xFFFFD700,
      ),
    );
  }
}