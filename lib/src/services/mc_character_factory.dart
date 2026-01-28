import 'dart:math';
import '../models/character.dart';
import '../models/persona.dart';
import '../models/equipment.dart';
import '../models/character_inventory.dart';
import '../models/skill.dart';
import '../data/weapons_database.dart';
import '../data/skills_database.dart';

/// Factory pour créer des Main Characters avec variantes par race/région/classe
/// Contrairement aux personnages gacha prédéfinis, les MC sont générés dynamiquement
class MCCharacterFactory {
  static Character createMC(Persona persona, String name) {
    final stats = _calculateStats(persona);
    final appearance = _createAppearance(persona);
    final starterWeapon = _getStarterWeapon(persona.characterClass);
    final inventory = _createMCInventory(persona);
    
    // Équiper les compétences de départ : 1 active + 2 passives
    final skills = _getStartingSkills(persona);
    
    return Character(
      name: name,
      persona: persona,
      stats: stats,
      appearance: appearance,
      weapon: starterWeapon,
      equippedSkills: skills,
      basedRarity: _calculateRarity(persona),
      currentRarity: _calculateRarity(persona),
      inventory: inventory,
    );
  }

  static CharacterStats _calculateStats(Persona persona) {
    int maxHp = 100;
    int attack = 10;
    int defense = 8;
    int speed = 6;
    int magic = 5;
    int range = 1;
    int luck = 5;
    int gold = 100;
    
    // ============================================================
    // BONUS RÉGIONAUX
    // ============================================================
    switch (persona.region) {
      case PersonaRegion.west:
        attack += 2;
        defense += 2;
        break;
      case PersonaRegion.east:
        speed += 3;
        magic += 2;
        break;
      case PersonaRegion.north:
        maxHp += 15;
        attack += 3;
        break;
      case PersonaRegion.south:
        magic += 3;
        luck += 3;
        break;
    }
    
    // ============================================================
    // BONUS RACIAUX
    // ============================================================
    switch (persona.race) {
      case PersonaRace.human:
        // Équilibré
        maxHp += 5;
        attack += 1;
        defense += 1;
        speed += 1;
        magic += 1;
        luck += 1;
        break;
      case PersonaRace.elf:
        // Magique/Agile
        magic += 4;
        speed += 3;
        luck += 2;
        defense -= 1;
        break;
      case PersonaRace.dwarf:
        // Tank
        maxHp += 20;
        defense += 4;
        attack += 2;
        speed -= 2;
        break;
      case PersonaRace.orc:
        // Agressif
        attack += 5;
        maxHp += 10;
        magic -= 2;
        luck -= 1;
        break;
    }
    
    // ============================================================
    // BONUS D'ORIGINE
    // ============================================================
    switch (persona.origin) {
      case PersonaOrigin.noble:
        gold += 50;
        magic += 2;
        luck += 2;
        break;
      case PersonaOrigin.merchant:
        gold += 75;
        luck += 3;
        speed += 1;
        break;
      case PersonaOrigin.peasant:
        maxHp += 10;
        defense += 2;
        attack += 1;
        gold -= 25;
        break;
      case PersonaOrigin.scholar:
        magic += 4;
        luck += 1;
        defense -= 1;
        break;
    }
    
    // ============================================================
    // BONUS DE CLASSE (MAJEURS)
    // ============================================================
    switch (persona.characterClass) {
      case PersonaClass.warrior:
        attack += 6;
        defense += 4;
        maxHp += 15;
        range = 1;
        break;
      case PersonaClass.mage:
        magic += 8;
        luck += 2;
        range = 2;
        maxHp -= 10;
        defense -= 2;
        break;
      case PersonaClass.peasant:
        speed += 6;
        luck += 4;
        attack += 2;
        defense -= 1;
        maxHp -= 5;
        range = 1;
        break;
      case PersonaClass.cleric:
        magic += 4;
        defense += 3;
        maxHp += 10;
        range = 1;
        luck += 2;
        break;
    }
    
    // Valeurs minimales
    maxHp = max(50, maxHp);
    attack = max(5, attack);
    defense = max(3, defense);
    speed = max(3, speed);
    magic = max(2, magic);
    range = max(1, range);
    luck = max(2, luck);
    gold = max(25, gold);
    
    return CharacterStats(
      maxHp: maxHp,
      attack: attack,
      defense: defense,
      speed: speed,
      magic: magic,
      range: range,
      luck: luck,
      gold: gold,
    );
  }

  /// Crée l'apparence selon la classe avec couleur selon la race
  static CharacterAppearance _createAppearance(Persona persona) {
    final folder = _getSpriteFolder(persona.characterClass);
    final color = _getRaceColor(persona.race);
    
    return CharacterAppearance(
      headshot: 'assets/characters/$folder/headshot.png',
      lheadshot: 'assets/characters/$folder/lheadshot.png',
      pixel: 'assets/characters/$folder/pixel.png',
      fullsize: 'assets/characters/$folder/fullsize.png',
      colorValue: color,
      description: _getDescription(persona),
    );
  }

  /// Retourne le dossier de sprites selon la classe
  static String _getSpriteFolder(PersonaClass characterClass) {
    switch (characterClass) {
      case PersonaClass.warrior:
        return 'MCS'; // Main Character Swordsman/Warrior
      case PersonaClass.mage:
        return 'MCM'; // Main Character Mage
      case PersonaClass.peasant:
        return 'MCA'; // Main Character Archer/Peasant
      case PersonaClass.cleric:
        return 'MCC'; // Main Character Cleric
    }
  }

  /// Retourne une couleur distinctive selon la race
  static int _getRaceColor(PersonaRace race) {
    switch (race) {
      case PersonaRace.human:
        return 0xFF2196F3; // Bleu
      case PersonaRace.elf:
        return 0xFF4CAF50; // Vert
      case PersonaRace.dwarf:
        return 0xFF795548; // Marron
      case PersonaRace.orc:
        return 0xFFFF5722; // Rouge-orange
    }
  }

  /// Génère une description selon le Persona
  static String _getDescription(Persona persona) {
    final raceDesc = persona.race.displayName;
    final classDesc = persona.characterClass.displayName;
    final originDesc = persona.origin.displayName;
    
    return 'Un $raceDesc $classDesc d\'origine $originDesc, forgé par l\'adversité.';
  }

  /// Retourne l'arme de départ selon la classe
  static Equipment _getStarterWeapon(PersonaClass characterClass) {
    switch (characterClass) {
      case PersonaClass.warrior:
        return WeaponsDatabase.ironSword;
      case PersonaClass.mage:
        return WeaponsDatabase.woodenStaff;
      case PersonaClass.peasant:
        return WeaponsDatabase.huntingBow;
      case PersonaClass.cleric:
        return WeaponsDatabase.healingRod;
    }
  }

  /// Crée un inventaire basique pour le MC avec compétences de départ
  static CharacterInventory _createMCInventory(Persona persona) {
    // Compétences de classe (active)
    final Skill classSkill;
    switch (persona.characterClass) {
      case PersonaClass.warrior:
        classSkill = SkillsDatabase.powerStrike;
        break;
      case PersonaClass.mage:
        classSkill = SkillsDatabase.fireball;
        break;
      case PersonaClass.peasant:
        classSkill = SkillsDatabase.multiShot;
        break;
      case PersonaClass.cleric:
        classSkill = SkillsDatabase.heal;
        break;
    }

    // Compétences de race (passive)
    final Skill raceSkill;
    switch (persona.race) {
      case PersonaRace.human:
        raceSkill = SkillsDatabase.humanAdaptability;
        break;
      case PersonaRace.elf:
        raceSkill = SkillsDatabase.elvenGrace;
        break;
      case PersonaRace.dwarf:
        raceSkill = SkillsDatabase.dwarvenResilience;
        break;
      case PersonaRace.orc:
        raceSkill = SkillsDatabase.orcishFury;
        break;
    }

    // Compétences d'origine (passive)
    final Skill originSkill;
    switch (persona.origin) {
      case PersonaOrigin.noble:
        originSkill = SkillsDatabase.nobleLeadership;
        break;
      case PersonaOrigin.merchant:
        originSkill = SkillsDatabase.merchantLuck;
        break;
      case PersonaOrigin.peasant:
        originSkill = SkillsDatabase.peasantEndurance;
        break;
      case PersonaOrigin.scholar:
        originSkill = SkillsDatabase.scholarWisdom;
        break;
    }

    return CharacterInventory(
      weapons: [
        InventoryItem(
          item: _getStarterWeapon(persona.characterClass),
          condition: const UnlockCondition(
            type: UnlockConditionType.always,
            value: 0,
            description: 'Débloqué par défaut',
          ),
          isDefault: true,
        ),
      ],
      armors: [],
      accessories: [],
      skills: [
        // Compétence active de classe
        InventoryItem(
          item: classSkill,
          condition: const UnlockCondition(
            type: UnlockConditionType.always,
            value: 0,
            description: 'Débloqué par défaut',
          ),
          isDefault: true,
        ),
        // Compétences passives
        InventoryItem(
          item: raceSkill,
          condition: const UnlockCondition(
            type: UnlockConditionType.always,
            value: 0,
            description: 'Débloqué par défaut',
          ),
          isDefault: true,
        ),
        InventoryItem(
          item: originSkill,
          condition: const UnlockCondition(
            type: UnlockConditionType.always,
            value: 0,
            description: 'Débloqué par défaut',
          ),
          isDefault: true,
        ),
      ],
    );
  }

  /// Récupère les compétences de départ équipées : 1 active + 2 passives
  static List<Skill> _getStartingSkills(Persona persona) {
    // Compétence active selon la classe
    final Skill activeSkill;
    switch (persona.characterClass) {
      case PersonaClass.warrior:
        activeSkill = SkillsDatabase.powerStrike;
        break;
      case PersonaClass.mage:
        activeSkill = SkillsDatabase.fireball;
        break;
      case PersonaClass.peasant:
        activeSkill = SkillsDatabase.multiShot;
        break;
      case PersonaClass.cleric:
        activeSkill = SkillsDatabase.heal;
        break;
    }

    // Compétence passive de race
    final Skill raceSkill;
    switch (persona.race) {
      case PersonaRace.human:
        raceSkill = SkillsDatabase.humanAdaptability;
        break;
      case PersonaRace.elf:
        raceSkill = SkillsDatabase.elvenGrace;
        break;
      case PersonaRace.dwarf:
        raceSkill = SkillsDatabase.dwarvenResilience;
        break;
      case PersonaRace.orc:
        raceSkill = SkillsDatabase.orcishFury;
        break;
    }

    // Compétence passive d'origine
    final Skill originSkill;
    switch (persona.origin) {
      case PersonaOrigin.noble:
        originSkill = SkillsDatabase.nobleLeadership;
        break;
      case PersonaOrigin.merchant:
        originSkill = SkillsDatabase.merchantLuck;
        break;
      case PersonaOrigin.peasant:
        originSkill = SkillsDatabase.peasantEndurance;
        break;
      case PersonaOrigin.scholar:
        originSkill = SkillsDatabase.scholarWisdom;
        break;
    }

    // Retourne : 1 active + 2 passives (race + origine)
    return [activeSkill, raceSkill, originSkill];
  }

  /// Les MC commencent toujours en Epic (classe de base)
  /// Ils évolueront vers des classes avancées Légendaires selon race + classe
  static CharacterRarity _calculateRarity(Persona persona) {
    return CharacterRarity.epic;
  }
  
  /// Retourne la classe avancée selon race et classe de base
  /// Ces classes seront débloquées à un certain point de l'histoire
  /// Toutes les classes avancées sont Légendaires
  static String getAdvancedClass(PersonaRace race, PersonaClass baseClass) {
    switch (baseClass) {
      case PersonaClass.warrior:
        switch (race) {
          case PersonaRace.human:
            return 'Paladin';
          case PersonaRace.elf:
            return 'Blademaster';
          case PersonaRace.dwarf:
            return 'Ironguard';
          case PersonaRace.orc:
            return 'Warchief';
        }
      
      case PersonaClass.mage:
        switch (race) {
          case PersonaRace.human:
            return 'Archmage';
          case PersonaRace.elf:
            return 'Arcane Sage';
          case PersonaRace.dwarf:
            return 'Runemaster';
          case PersonaRace.orc:
            return 'Shaman';
        }
      
      case PersonaClass.peasant:
        switch (race) {
          case PersonaRace.human:
            return 'Ranger';
          case PersonaRace.elf:
            return 'Windwalker';
          case PersonaRace.dwarf:
            return 'Crossbow Master';
          case PersonaRace.orc:
            return 'Hunter';
        }
      
      case PersonaClass.cleric:
        switch (race) {
          case PersonaRace.human:
            return 'High Priest';
          case PersonaRace.elf:
            return 'Nature Priest';
          case PersonaRace.dwarf:
            return 'Forge Priest';
          case PersonaRace.orc:
            return 'Spirit Caller';
        }
    }
  }
}
