import 'package:dice_destiny_idle_rifts/src/models/character.dart';
import '../models/persona.dart';
import '../models/equipment.dart';
import '../models/preset_character.dart';
import '../models/character_inventory.dart';
import '../models/skill.dart';
import 'weapons_database.dart';
import 'skills_database.dart';
import 'armors_database.dart';

/// Bibliothèque de personnages prédéfinis
class CharacterDatabase {
  // ============================================================================
  // HELPERS POUR CRÉER DES INVENTAIRES PERSONNALISÉS
  // ============================================================================

  /// Crée un inventaire personnalisé pour un personnage
  static CharacterInventory _createCustomInventory({
    required List<Equipment> weapons,
    required List<UnlockCondition> weaponConditions,
    List<Equipment>? armors,
    List<UnlockCondition>? armorConditions,
    List<Equipment>? accessories,
    List<UnlockCondition>? accessoryConditions,
    List<Skill>? skills,
    List<UnlockCondition>? skillConditions,
  }) {
    return CharacterInventory(
      weapons: _createInventoryItems(weapons, weaponConditions),
      armors: armors != null && armorConditions != null
          ? _createInventoryItems(armors, armorConditions)
          : [],
      accessories: accessories != null && accessoryConditions != null
          ? _createInventoryItems(accessories, accessoryConditions)
          : [],
      skills: skills != null && skillConditions != null
          ? _createInventoryItemsSkills(skills, skillConditions)
          : [],
    );
  }

  static List<InventoryItem<Equipment>> _createInventoryItems(
    List<Equipment> items,
    List<UnlockCondition> conditions,
  ) {
    assert(items.length == conditions.length);
    return List.generate(
      items.length,
      (i) => InventoryItem(
        item: items[i],
        condition: conditions[i],
        isDefault: conditions[i].type == UnlockConditionType.always,
      ),
    );
  }

  static List<InventoryItem<Skill>> _createInventoryItemsSkills(
    List<Skill> items,
    List<UnlockCondition> conditions,
  ) {
    assert(items.length == conditions.length);
    return List.generate(
      items.length,
      (i) => InventoryItem(
        item: items[i],
        condition: conditions[i],
        isDefault: conditions[i].type == UnlockConditionType.always,
      ),
    );
  }

  // Conditions de déblocage communes
  static const _alwaysUnlocked = UnlockCondition(
    type: UnlockConditionType.always,
    value: 0,
    description: 'Débloqué par défaut',
  );

  static UnlockCondition _levelCondition(int level) => UnlockCondition(
    type: UnlockConditionType.level,
    value: level,
    description: 'Niveau $level requis',
  );

  static UnlockCondition _starsCondition(int stars) => UnlockCondition(
    type: UnlockConditionType.stars,
    value: stars,
    description: '$stars★ requis',
  );

  // ============================================================================
  // LÉGENDAIRES (5★) - 3% de drop
  // ============================================================================

  static final PresetCharacter seleneEcho = PresetCharacter(
    id: 'selene_001',
    name: 'Séléné',
    title: 'L\'Écho d\'Oméga',
    headshot: '👑',
    colorValue: 0xFF9C27B0,
    rarity: CharacterRarity.legendary,
    description: 'Une entité fragmentée issue d\'une faille temporelle.',
    backstory: 'Séléné ne se souvient pas de sa création, seulement du silence éternel de l\'Oméga avant son éveil dans le Rift.',
    persona: Persona(
      race: PersonaRace.human, // Peut-être autre chose, mais pour l'instant humain (=unknown)
      region: PersonaRegion.west, // Peu importe la région d\'origine (unknown)
      origin: PersonaOrigin.scholar, // Son origine est mystérieuse
      characterClass: PersonaClass.mage,
    ),
    baseStats: {
      'maxHp': 90,
      'attack': 5,
      'defense': 12,
      'speed': 25,
      'magic': 38,
      'luck': 45,
      'movement': 5,
    },
    starterWeapon: WeaponsDatabase.mysticWand,
    voiceLines: ['Le temps est une boucle... je vais la briser.', 'Ressentez l\'écho du vide.'],
    tags: ['Mage', 'Time Control', 'Burst'],
    customInventory: _createCustomInventory(
      // ARMES (max 1 équipée)
      weapons: [
        WeaponsDatabase.mysticWand,
        WeaponsDatabase.crystalStaff,
        WeaponsDatabase.necronomiconEx,
      ],
      weaponConditions: [
        _alwaysUnlocked,
        _levelCondition(5),
        _starsCondition(6),
      ],
      // ARMURES (max 1 équipée)
      armors: [
        ArmorsDatabase.wizardRobe,
        ArmorsDatabase.astralCloak,
      ],
      armorConditions: [
        _alwaysUnlocked,
        _levelCondition(15),
      ],
      // ACCESSOIRES (max 1 équipé - mutuellement exclusif avec armure)
      accessories: [
        AccessoriesDatabase.magicRing,
        AccessoriesDatabase.infinityGauntlet,
      ],
      accessoryConditions: [
        _levelCondition(5),
        _starsCondition(6),
      ],
      // COMPÉTENCES : 1 active + 3 passives max
      skills: [
        SkillsDatabase.arcaneBlast,
        SkillsDatabase.magicMastery,
        SkillsDatabase.timeStop,
        SkillsDatabase.apocalypse,
      ],
      skillConditions: [
        _alwaysUnlocked,
        _alwaysUnlocked,
        _levelCondition(10),
        _starsCondition(6),
      ],
    ),
  );

  static final PresetCharacter masterZhou = PresetCharacter(
    id: 'zhou_001',
    name: 'Maître Zhou',
    title: 'L\Arbitre du Flux',
    headshot: '👑',
    colorValue: 0xFF00BCD4,
    rarity: CharacterRarity.legendary,
    description: 'Un moine qui harmonise les énergies instables des Rifts.',
    backstory: 'Gardien du temple suspendu, il a passé des siècles à méditer sur la nature du destin avant de rejoindre le combat.',
    persona: Persona(
      race: PersonaRace.human,
      region: PersonaRegion.west,
      origin: PersonaOrigin.noble,
      characterClass: PersonaClass.cleric,
    ),
    baseStats: {
      'maxHp': 120,
      'attack': 10,
      'defense': 18,
      'speed': 18,
      'magic': 30,
      'luck': 35,
      'movement': 4,
    },
    starterWeapon: WeaponsDatabase.mysticWand,
    voiceLines: ['Le flux mène à la victoire.', 'Gardez votre calme, le destin s\'occupe du reste.'],
    tags: ['Healer', 'Buffer', 'Holy'],
    customInventory: _createCustomInventory(
      // ARMES (max 1 équipée)
      weapons: [
        WeaponsDatabase.mysticWand,
        WeaponsDatabase.holyGrail,
      ],
      weaponConditions: [
        _alwaysUnlocked,
        _starsCondition(6),
      ],
      // ARMURES (max 1 équipée)
      armors: [
        ArmorsDatabase.mythrilChain,
        ArmorsDatabase.aegisArmor,
      ],
      armorConditions: [
        _alwaysUnlocked,
        _starsCondition(6),
      ],
      // ACCESSOIRES (max 1 équipé - mutuellement exclusif avec armure)
      accessories: [
        AccessoriesDatabase.fortuneRing,
        AccessoriesDatabase.crownOfKings,
      ],
      accessoryConditions: [
        _alwaysUnlocked,
        _levelCondition(20),
      ],
      // COMPÉTENCES : 1 active + 3 passives max
      skills: [
        // Active (peut en équiper 1 seule)
        SkillsDatabase.regeneration,
        SkillsDatabase.bless,
        SkillsDatabase.divineIntervention,
        SkillsDatabase.massHeal,
      ],
      skillConditions: [
        // Actives
        _alwaysUnlocked,
        _alwaysUnlocked,
        _levelCondition(15),
        _starsCondition(6),
      ],
    ),
  );

  static final PresetCharacter valerius = PresetCharacter(
    id: 'valerius_001',
    name: 'Valerius',
    title: 'Le Lion d\'Or',
    headshot: '👑',
    colorValue: 0xFFFFD700,
    rarity: CharacterRarity.legendary,
    description: 'Ancien commandant de la garde solaire, dernier rempart contre le chaos.',
    backstory: 'Son armure a été forgée dans les forges stellaires pour briller même dans l\'obscurité des failles.',
    persona: Persona(
      race: PersonaRace.human,
      region: PersonaRegion.west,
      origin: PersonaOrigin.noble,
      characterClass: PersonaClass.warrior,
    ),
    baseStats: {
      'maxHp': 200,
      'attack': 25,
      'defense': 30,
      'speed': 10,
      'magic': 15,
      'luck': 25,
      'movement': 3,
    },
    starterWeapon: WeaponsDatabase.goldSword,
    voiceLines: ['La lumière guide mes pas.', 'Je suis le bouclier du royaume.'],
    tags: ['Tank', 'Leader', 'Holy'],
    customInventory: _createCustomInventory(
      weapons: [
        WeaponsDatabase.goldSword,
        WeaponsDatabase.holyGrail,
      ],
      weaponConditions: [
        _alwaysUnlocked,
        _starsCondition(6),
      ],
      armors: [
        ArmorsDatabase.plateArmor,
        ArmorsDatabase.aegisArmor,
      ],
      armorConditions: [
        _alwaysUnlocked,
        _starsCondition(6),
      ],
      accessories: [
        AccessoriesDatabase.crownOfKings,
        AccessoriesDatabase.championBelt,
      ],
      accessoryConditions: [
        _alwaysUnlocked,
        _levelCondition(20),
      ],
      skills: [
        SkillsDatabase.shieldBash,
        SkillsDatabase.divineIntervention,
        SkillsDatabase.nobleLeadership,
        SkillsDatabase.ironSkin,
        SkillsDatabase.guardianSpirit,
      ],
      skillConditions: [
        _alwaysUnlocked,
        _levelCondition(10),
        _alwaysUnlocked,
        _levelCondition(15),
        _starsCondition(6),
      ],
    ),
  );

  // ============================================================================
  // ÉPIQUES (4★) - 12% de drop
  // ============================================================================

  static final PresetCharacter envia = PresetCharacter(
    id: 'envia_001',
    name: 'Envia',
    title: 'Sabreuse des Ombres',
    headshot: '~/assets/characters/Envia/headshot.png',
    lheadshot: '~/assets/characters/Envia/lheadshot.png',
    pixel: 'assets/characters/Envia/pixel.png',
    fullsize: '~/assets/characters/Envia/fullsize.png',
    colorValue: 0xFF1E88E5,
    rarity: CharacterRarity.epic,
    description: 'Sabreuse d\'une triste renommée, elle cherche la rédemption.',
    backstory: '''
Envia est une ancienne mercenaire devenue chasseuse de primes,
recherchant la rédemption pour son passé tumultueux.
Elle manie deux sabres avec une précision mortelle
et utilise la furtivité pour surprendre ses ennemis.
Malgré son extérieur dur, elle a un sens profond de la justice
et protège les innocents contre les oppresseurs.
''',
    persona: Persona(
      race: PersonaRace.human,
      region: PersonaRegion.east,
      origin: PersonaOrigin.peasant,
      characterClass: PersonaClass.warrior,
    ),
    baseStats: {
      'maxHp': 120,
      'attack': 26,
      'defense': 16,
      'speed': 22,
      'magic': 4,
      'range': 1,
      'luck': 18,
      'movement': 5, // Warrior rapide
    },
    starterWeapon: WeaponsDatabase.katana,
    voiceLines: [
      'Le passé ne définit pas l\'avenir.',
      'Mes lames ne connaissent pas la pitié.',
      'Pour la rédemption !',
    ],
    tags: ['DPS', 'Physique', 'Vitesse'],
    customInventory: _createCustomInventory(
      // ARMES (max 1 équipée)
      weapons: [
        WeaponsDatabase.katana,
        WeaponsDatabase.steelSword,
        WeaponsDatabase.shadowSword,
        WeaponsDatabase.flameBlade,
      ],
      weaponConditions: [
        _alwaysUnlocked,
        _levelCondition(5),
        _levelCondition(10),
        _levelCondition(15),
      ],
      // ARMURES (max 1 équipée)
      armors: [
        ArmorsDatabase.leatherArmor,
        ArmorsDatabase.shadowCloak,
        ArmorsDatabase.mythrilChain,
      ],
      armorConditions: [
        _alwaysUnlocked,
        _levelCondition(10),
        _levelCondition(15),
      ],
      // ACCESSOIRES (max 1 équipé - mutuellement exclusif avec armure)
      accessories: [
        AccessoriesDatabase.speedRing,
        AccessoriesDatabase.swiftBoots,
        AccessoriesDatabase.hermesBoots,
      ],
      accessoryConditions: [
        _levelCondition(5),
        _levelCondition(10),
        _levelCondition(20),
      ],
      // COMPÉTENCES : 1 active + 3 passives max
      skills: [
        // Active (peut en équiper 1 seule)
        SkillsDatabase.powerStrike,
        SkillsDatabase.backstab,
        // Passives (peut en équiper 3)
        SkillsDatabase.peasantEndurance,
        SkillsDatabase.swiftness,
        SkillsDatabase.criticalHit,
      ],
      skillConditions: [
        // Actives
        _alwaysUnlocked,
        _levelCondition(5),
        // Passives
        _alwaysUnlocked, // Passive de peasant
        _starsCondition(3),
        _starsCondition(4),
      ],
    ),
  );

  static final PresetCharacter skar = PresetCharacter(
    id: 'skar_001',
    name: 'Skar',
    title: 'Dévoreur de Failles',
    headshot: '💀',
    colorValue: 0xFF8B0000,
    rarity: CharacterRarity.epic,
    description: 'Survivant d\'une exposition directe au noyau d\'un Rift.',
    backstory: 'Une rage dévorante coule dans ses veines, le rendant plus fort à chaque blessure reçue.',
    persona: Persona(
      race: PersonaRace.human,
      region: PersonaRegion.east,
      origin: PersonaOrigin.peasant,
      characterClass: PersonaClass.warrior,
    ),
    baseStats: {
      'maxHp': 170,
      'attack': 38,
      'defense': 10,
      'speed': 12,
      'magic': 0,
      'luck': 5,
      'movement': 4,
    },
    starterWeapon: WeaponsDatabase.battleAxe,
    voiceLines: ['RAGE!', 'Plus fort... PLUS FORT!'],
    tags: ['DPS', 'Berserker', 'Brute'],
    customInventory: _createCustomInventory(
      weapons: [
        WeaponsDatabase.battleAxe,
        WeaponsDatabase.greatAxe,
        WeaponsDatabase.demonAxe,
      ],
      weaponConditions: [
        _alwaysUnlocked,
        _levelCondition(5),
        _starsCondition(5),
      ],
      armors: [
        ArmorsDatabase.leatherArmor,
        ArmorsDatabase.barbarianFur,
      ],
      armorConditions: [
        _alwaysUnlocked,
        _levelCondition(10),
      ],
      accessories: [
        AccessoriesDatabase.rageRing,
        AccessoriesDatabase.berserkerTotem,
      ],
      accessoryConditions: [
        _levelCondition(5),
        _starsCondition(4),
      ],
      skills: [
        SkillsDatabase.berserkerRage,
        SkillsDatabase.bloodthirst,
        SkillsDatabase.peasantEndurance,
        SkillsDatabase.criticalHit,
      ],
      skillConditions: [
        _alwaysUnlocked,
        _levelCondition(10),
        _alwaysUnlocked,
        _starsCondition(4),
      ],
    ),
  );

  static final PresetCharacter ignis = PresetCharacter(
    id: 'ignis_001',
    name: 'Ignis',
    title: 'L\'Étincelle du Chaos',
    headshot: '🔥',
    colorValue: 0xFFFF4500,
    rarity: CharacterRarity.epic,
    description: 'Pyromancien volatile aux pouvoirs destructeurs.',
    backstory: 'Son contrôle du feu est instable, mais sa puissance brute est redoutable.',
    persona: Persona(
      race: PersonaRace.human,
      region: PersonaRegion.east,
      origin: PersonaOrigin.scholar,
      characterClass: PersonaClass.mage,
    ),
    baseStats: {
      'maxHp': 100,
      'attack': 10,
      'defense': 8,
      'speed': 20,
      'magic': 35,
      'luck': 15,
      'movement': 5,
    },
    starterWeapon: WeaponsDatabase.flameStaff,
    voiceLines: ['Brûlez!', 'Le feu purifie tout!'],
    tags: ['Mage', 'Fire', 'AOE'],
    customInventory: _createCustomInventory(
      weapons: [
        WeaponsDatabase.flameStaff,
        WeaponsDatabase.infernalTome,
        WeaponsDatabase.phoenixWand,
      ],
      weaponConditions: [
        _alwaysUnlocked,
        _levelCondition(8),
        _starsCondition(5),
      ],
      armors: [
        ArmorsDatabase.wizardRobe,
        ArmorsDatabase.emberRobe,
      ],
      armorConditions: [
        _alwaysUnlocked,
        _levelCondition(12),
      ],
      accessories: [
        AccessoriesDatabase.magicRing,
        AccessoriesDatabase.flameOrb,
      ],
      accessoryConditions: [
        _levelCondition(5),
        _starsCondition(4),
      ],
      skills: [
        SkillsDatabase.fireball,
        SkillsDatabase.meteor,
        SkillsDatabase.scholarWisdom,
        SkillsDatabase.magicMastery,
      ],
      skillConditions: [
        _alwaysUnlocked,
        _levelCondition(12),
        _alwaysUnlocked,
        _starsCondition(4),
      ],
    ),
  );

  // ============================================================================
  // RARES (3★) - 25% de drop
  // ============================================================================

  static final PresetCharacter elio = PresetCharacter(
    id: 'elio_001',
    name: 'Elio',
    title: 'Défenseur du Soleil',
    headshot: '~/assets/characters/Elio/headshot.png',
    lheadshot: '~/assets/characters/Elio/lheadshot.png',
    pixel: 'assets/characters/Elio/pixel.jpg',
    fullsize: '~/assets/characters/Elio/fullsize.png',
    colorValue: 0xFFFFA726,
    rarity: CharacterRarity.rare,
    description: 'Chevalier solaire, il protège les faibles avec bravoure.',
    backstory: '''
Elio est un chevalier dévoué au service du royaume solaire.
Armé de son épée flamboyante, il combat les forces des ténèbres
et protège les innocents. Sa foi inébranlable dans la justice
et son courage font de lui un leader respecté parmi ses pairs.
Il aspire à ramener la paix dans un monde en proie au chaos.
''',
    persona: Persona(
      race: PersonaRace.human,
      region: PersonaRegion.west,
      origin: PersonaOrigin.noble,
      characterClass: PersonaClass.warrior,
    ),
    baseStats: {
      'maxHp': 130,
      'attack': 24,
      'defense': 22,
      'speed': 16,
      'magic': 6,
      'range': 1,
      'luck': 14,
      'movement': 4, // Warrior tank - lourd
    },
    starterWeapon: WeaponsDatabase.flameBlade,
    voiceLines: [
      'La lumière triomphera toujours !',
      'Je suis le bouclier des innocents.',
      'Pour l\'honneur et la justice !',
    ],
    tags: ['Tank', 'Défense', 'Paladin'],
    customInventory: _createCustomInventory(
      weapons: [
        WeaponsDatabase.flameBlade,
        WeaponsDatabase.ironSword,
        WeaponsDatabase.steelSword,
        WeaponsDatabase.silverSword,
      ],
      weaponConditions: [
        _alwaysUnlocked,
        _levelCondition(3),
        _levelCondition(8),
        _levelCondition(15),
      ],
      armors: [
        ArmorsDatabase.chainmail,
        ArmorsDatabase.knightArmor,
        ArmorsDatabase.plateArmor,
      ],
      armorConditions: [
        _alwaysUnlocked,
        _levelCondition(8),
        _levelCondition(15),
      ],
      accessories: [
        AccessoriesDatabase.defenseRing,
        AccessoriesDatabase.championBelt,
        AccessoriesDatabase.giantBelt,
      ],
      accessoryConditions: [
        _levelCondition(5),
        _levelCondition(10),
        _levelCondition(15),
      ],
      skills: [
        // Active (peut en équiper 1 seule)
        SkillsDatabase.powerStrike,
        SkillsDatabase.shieldBash,
        // Passives (peut en équiper 3)
        SkillsDatabase.nobleLeadership,
        SkillsDatabase.ironSkin,
        SkillsDatabase.counterAttack,
      ],
      skillConditions: [
        // Actives
        _alwaysUnlocked,
        _levelCondition(5),
        // Passives
        _alwaysUnlocked,
        _starsCondition(3),
        _starsCondition(4),
      ],
    ),
  );

  static final PresetCharacter nyx = PresetCharacter(
    id: 'nyx_001',
    name: 'Nyx',
    title: 'Colporteur de Failles',
    headshot: '💰',
    colorValue: 0xFFDAA520,
    rarity: CharacterRarity.rare,
    description: 'Opportuniste rusé qui parcourt les dimensions.',
    backstory: 'Pour lui, les monstres sont simplement des coffres sur pattes.',
    persona: Persona(
      race: PersonaRace.human,
      region: PersonaRegion.west,
      origin: PersonaOrigin.peasant,
      characterClass: PersonaClass.cleric,
    ),
    baseStats: {
      'maxHp': 100,
      'attack': 8,
      'defense': 12,
      'speed': 15,
      'magic': 20,
      'luck': 55,
      'movement': 5,
    },
    starterWeapon: WeaponsDatabase.mysticWand,
    voiceLines: ['L\'or brille plus que l\'acier!', 'Mes poches sont pleines!'],
    tags: ['Support', 'Loot', 'Luck'],
    customInventory: _createCustomInventory(
      weapons: [
        WeaponsDatabase.mysticWand,
        WeaponsDatabase.goldStaff,
      ],
      weaponConditions: [
        _alwaysUnlocked,
        _levelCondition(10),
      ],
      armors: [
        ArmorsDatabase.merchantRobe,
        ArmorsDatabase.luckyVest,
      ],
      armorConditions: [
        _alwaysUnlocked,
        _levelCondition(8),
      ],
      accessories: [
        AccessoriesDatabase.fortuneRing,
        AccessoriesDatabase.luckyClover,
        AccessoriesDatabase.goldPouch,
      ],
      accessoryConditions: [
        _alwaysUnlocked,
        _levelCondition(5),
        _levelCondition(15),
      ],
      skills: [
        SkillsDatabase.goldRush,
        SkillsDatabase.fortuneFavor,
        SkillsDatabase.peasantEndurance,
        SkillsDatabase.luckBoost,
      ],
      skillConditions: [
        _alwaysUnlocked,
        _levelCondition(8),
        _alwaysUnlocked,
        _starsCondition(3),
      ],
    ),
  );

  static final PresetCharacter bjorne = PresetCharacter(
    id: 'bjorne_001',
    name: 'Bjorne',
    title: 'Le Mur du Nord',
    headshot: '🐻',
    colorValue: 0xFF8B4513,
    rarity: CharacterRarity.rare,
    description: 'Guerrier massif du nord aux méthodes brutales.',
    backstory: 'Sa force brute et son endurance légendaire en font un rempart infranchissable.',
    persona: Persona(
      race: PersonaRace.human,
      region: PersonaRegion.north,
      origin: PersonaOrigin.peasant,
      characterClass: PersonaClass.warrior,
    ),
    baseStats: {
      'maxHp': 180,
      'attack': 22,
      'defense': 20,
      'speed': 8,
      'magic': 0,
      'luck': 10,
      'movement': 3,
    },
    starterWeapon: WeaponsDatabase.warHammer,
    voiceLines: ['ROOOOAR!', 'Bjorne écrase!'],
    tags: ['Tank', 'Bruiser'],
    customInventory: _createCustomInventory(
      weapons: [
        WeaponsDatabase.warHammer,
        WeaponsDatabase.ironMace,
        WeaponsDatabase.giantClub,
      ],
      weaponConditions: [
        _alwaysUnlocked,
        _levelCondition(5),
        _levelCondition(12),
      ],
      armors: [
        ArmorsDatabase.leatherArmor,
        ArmorsDatabase.chainmail,
        ArmorsDatabase.bearPelt,
      ],
      armorConditions: [
        _alwaysUnlocked,
        _levelCondition(8),
        _levelCondition(15),
      ],
      accessories: [
        AccessoriesDatabase.giantBelt,
        AccessoriesDatabase.strengthRing,
      ],
      accessoryConditions: [
        _levelCondition(5),
        _levelCondition(10),
      ],
      skills: [
        SkillsDatabase.earthShaker,
        SkillsDatabase.brutality,
        SkillsDatabase.peasantEndurance,
        SkillsDatabase.ironSkin,
      ],
      skillConditions: [
        _alwaysUnlocked,
        _levelCondition(10),
        _alwaysUnlocked,
        _starsCondition(3),
      ],
    ),
  );

  // ============================================================================
  // COMMUNS (2★) - 60% de drop
  // ============================================================================

  static final PresetCharacter ragor = PresetCharacter(
    id: 'ragor_001',
    name: 'Ragor',
    title: 'Archer des Forêts',
    headshot: '~/assets/characters/Elio/headshot.png', // TODO: Add Ragor assets
    lheadshot: '~/assets/characters/Elio/lheadshot.png',
    pixel: null, // Pas de sprite pixel pour l'instant
    fullsize: '~/assets/characters/Elio/fullsize.png',
    colorValue: 0xFF66BB6A,
    rarity: CharacterRarity.common,
    description: 'Archer agile qui traque ses proies avec patience.',
    backstory: '''
Ragor a grandi dans les forêts profondes, apprenant l'art de la chasse
auprès des meilleurs pisteurs. Sa précision légendaire et sa connexion
avec la nature en font un allié précieux, bien qu'il préfère la solitude
des bois à l'agitation des villes.
''',
    persona: Persona(
      race: PersonaRace.human,
      region: PersonaRegion.west,
      origin: PersonaOrigin.peasant,
      characterClass: PersonaClass.warrior,
    ),
    baseStats: {
      'maxHp': 100,
      'attack': 18,
      'defense': 12,
      'speed': 20,
      'magic': 3,
      'range': 2,
      'luck': 16,
      'movement': 5, // Archer - mobile
    },
    starterWeapon: WeaponsDatabase.shortBow,
    voiceLines: [
      'Patience et précision.',
      'La nature ne pardonne pas.',
      'Une flèche, une cible.',
    ],
    tags: ['DPS', 'Distance', 'Vitesse'],
    customInventory: _createCustomInventory(
      // ARMES (max 1 équipée)
      weapons: [
        WeaponsDatabase.shortBow,
        WeaponsDatabase.huntingBow,
        WeaponsDatabase.longbow,
        WeaponsDatabase.compositeBow,
      ],
      weaponConditions: [
        _alwaysUnlocked,
        _levelCondition(5),
        _levelCondition(10),
        _levelCondition(15),
      ],
      // ARMURES (max 1 équipée)
      armors: [
        ArmorsDatabase.leatherArmor,
        ArmorsDatabase.reinforcedLeather,
        ArmorsDatabase.elvenRobe,
      ],
      armorConditions: [
        _alwaysUnlocked,
        _levelCondition(8),
        _levelCondition(15),
      ],
      // ACCESSOIRES (max 1 équipé - mutuellement exclusif avec armure)
      accessories: [
        AccessoriesDatabase.speedRing,
        AccessoriesDatabase.luckyClover,
        AccessoriesDatabase.windwalkerBoots,
      ],
      accessoryConditions: [
        _levelCondition(5),
        _levelCondition(10),
        _levelCondition(15),
      ],
      // COMPÉTENCES : 1 active + 3 passives max
      skills: [
        // Active (peut en équiper 1 seule)
        SkillsDatabase.multiShot,
        SkillsDatabase.snipe,
        // Passives (peut en équiper 3)
        SkillsDatabase.peasantEndurance,
        SkillsDatabase.swiftness,
        SkillsDatabase.evasion,
      ],
      skillConditions: [
        // Actives
        _alwaysUnlocked,
        _levelCondition(8),
        // Passives
        _alwaysUnlocked, // Passive de peasant
        _starsCondition(2),
        _starsCondition(3),
      ],
    ),
  );

  static final PresetCharacter mca = PresetCharacter(
    id: 'mca_001',
    name: 'Aria',
    title: 'Mage Apprentie',
    headshot: '~/assets/characters/MCA/headshot.png',
    lheadshot: '~/assets/characters/MCA/lheadshot.png',
    pixel: null,
    fullsize: '~/assets/characters/MCA/fullsize.png',
    colorValue: 0xFF7E57C2,
    rarity: CharacterRarity.common,
    description: 'Jeune mage pleine de potentiel et d\'enthousiasme.',
    backstory: '''
Aria étudie la magie dans une académie prestigieuse. Bien qu'encore
apprentie, son talent brut et sa détermination impressionnent ses
professeurs. Elle rêve de devenir une grande archmage et de découvrir
les secrets oubliés de l'ancienne magie.
''',
    persona: Persona(
      race: PersonaRace.human,
      region: PersonaRegion.west,
      origin: PersonaOrigin.scholar,
      characterClass: PersonaClass.mage,
    ),
    baseStats: {
      'maxHp': 85,
      'attack': 6,
      'defense': 10,
      'speed': 14,
      'magic': 22,
      'range': 2,
      'luck': 12,
      'movement': 5, // Mage - mobilité standard
    },
    starterWeapon: WeaponsDatabase.woodenStaff,
    voiceLines: [
      'La connaissance est pouvoir !',
      'Je vais devenir une grande mage !',
      'Par la puissance des arcanes !',
    ],
    tags: ['DPS', 'Magie', 'Support'],
    customInventory: _createCustomInventory(
      // ARMES (max 1 équipée)
      weapons: [
        WeaponsDatabase.woodenStaff,
        WeaponsDatabase.apprenticeTome,
        WeaponsDatabase.mysticWand,
        WeaponsDatabase.crystalStaff,
      ],
      weaponConditions: [
        _alwaysUnlocked,
        _levelCondition(3),
        _levelCondition(8),
        _levelCondition(15),
      ],
      // ARMURES (max 1 équipée)
      armors: [
        ArmorsDatabase.clothArmor,
        ArmorsDatabase.wizardRobe,
        ArmorsDatabase.archmageRobe,
      ],
      armorConditions: [
        _alwaysUnlocked,
        _levelCondition(8),
        _levelCondition(15),
      ],
      // ACCESSOIRES (max 1 équipé - mutuellement exclusif avec armure)
      accessories: [
        AccessoriesDatabase.magicRing,
        AccessoriesDatabase.sagesAmulet,
        AccessoriesDatabase.magicOrb,
      ],
      accessoryConditions: [
        _levelCondition(5),
        _levelCondition(10),
        _levelCondition(15),
      ],
      // COMPÉTENCES : 1 active + 3 passives max
      skills: [
        // Active (peut en équiper 1 seule)
        SkillsDatabase.fireball,
        SkillsDatabase.iceLance,
        // Passives (peut en équiper 3)
        SkillsDatabase.scholarWisdom,
        SkillsDatabase.magicMastery,
        SkillsDatabase.swiftness,
      ],
      skillConditions: [
        // Actives
        _alwaysUnlocked,
        _levelCondition(6),
        // Passives
        _alwaysUnlocked, // Passive de scholar
        _starsCondition(3),
        _levelCondition(8),
      ],
    ),
  );

  static final PresetCharacter liana = PresetCharacter(
    id: 'liana_001',
    name: 'Liana',
    title: 'Novice de l\'Aube',
    headshot: '🌅',
    colorValue: 0xFFFFA500,
    rarity: CharacterRarity.common,
    description: 'Jeune guérisseuse aux pouvoirs naissants.',
    backstory: 'Étudiante dans un monastère, elle apprend l\'art de la guérison divine.',
    persona: Persona(
      race: PersonaRace.human,
      region: PersonaRegion.west,
      origin: PersonaOrigin.noble,
      characterClass: PersonaClass.cleric,
    ),
    baseStats: {
      'maxHp': 90,
      'attack': 4,
      'defense': 12,
      'speed': 14,
      'magic': 20,
      'luck': 22,
      'movement': 4,
    },
    starterWeapon: WeaponsDatabase.holySymbol,
    voiceLines: ['La lumière nous guide.', 'Je vais vous soigner!'],
    tags: ['Healer', 'Support'],
    customInventory: _createCustomInventory(
      weapons: [
        WeaponsDatabase.holySymbol,
        WeaponsDatabase.priestStaff,
        WeaponsDatabase.holyGrail,
      ],
      weaponConditions: [
        _alwaysUnlocked,
        _levelCondition(5),
        _levelCondition(15),
      ],
      armors: [
        ArmorsDatabase.clothArmor,
        ArmorsDatabase.priestRobe,
        ArmorsDatabase.holyVestments,
      ],
      armorConditions: [
        _alwaysUnlocked,
        _levelCondition(8),
        _levelCondition(15),
      ],
      accessories: [
        AccessoriesDatabase.holyAmulet,
        AccessoriesDatabase.blessedRing,
      ],
      accessoryConditions: [
        _levelCondition(5),
        _levelCondition(10),
      ],
      skills: [
        SkillsDatabase.heal,
        SkillsDatabase.bless,
        SkillsDatabase.nobleLeadership,
        SkillsDatabase.divineProtection,
      ],
      skillConditions: [
        _alwaysUnlocked,
        _levelCondition(5),
        _alwaysUnlocked,
        _starsCondition(2),
      ],
    ),
  );

  // ============================================================================
  // LISTE COMPLÈTE
  // ============================================================================

  static final List<PresetCharacter> allCharacters = [
    // Légendaires
    seleneEcho,
    masterZhou,
    valerius,
    
    // Épiques
    envia,
    skar,
    ignis,
    
    // Rares
    elio,
    nyx,
    bjorne,
    
    // Communs
    ragor,
    mca, // Aria
    liana,
  ];

  static PresetCharacter? getById(String id) {
    try {
      return allCharacters.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }

  static List<PresetCharacter> getByRarity(CharacterRarity rarity) {
    return allCharacters.where((c) => c.rarity == rarity).toList();
  }

  static List<PresetCharacter> getByClass(PersonaClass characterClass) {
    return allCharacters.where((c) => c.persona.characterClass == characterClass).toList();
  }

  static List<PresetCharacter> getByTag(String tag) {
    return allCharacters.where((c) => c.tags.contains(tag)).toList();
  }
}