import 'dart:math';
import '../models/character.dart';
import '../models/persona.dart';

/// Factory for creating characters based on persona choices
class CharacterFactory {
  static Character createFromPersona(Persona persona, String name) {
    // Calculate base stats from persona choices
    final stats = _calculateStats(persona);
    
    // Create appearance based on class with sprites
    final appearance = _createAppearanceFromClass(persona);
    
    return Character(
      name: name,
      persona: persona,
      stats: stats,
      appearance: appearance,
      basedRarity: CharacterRarity.legendary,
      currentRarity: CharacterRarity.legendary,
    );
  }
  
  /// Get sprite folder name based on character class
  static String _getSpriteFolder(PersonaClass characterClass) {
    switch (characterClass) {
      case PersonaClass.mage:
        return 'MCM';
      case PersonaClass.rogue:
        return 'MCA';
      case PersonaClass.warrior:
        return 'MCS';
      case PersonaClass.cleric:
        return 'MCC';
    }
  }
  
  /// Create appearance with class-specific sprites
  static CharacterAppearance _createAppearanceFromClass(Persona persona) {
    final folder = _getSpriteFolder(persona.characterClass);
    
    // Get color based on race
    int colorValue;
    switch (persona.race) {
      case PersonaRace.human:
        colorValue = 0xFF2196F3;
        break;
      case PersonaRace.elf:
        colorValue = 0xFF4CAF50;
        break;
      case PersonaRace.dwarf:
        colorValue = 0xFF795548;
        break;
      case PersonaRace.orc:
        colorValue = 0xFFFF5722;
        break;
    }
    
    return CharacterAppearance(
      headshot: 'assets/characters/$folder/headshot.png',
      lheadshot: 'assets/characters/$folder/lheadshot.png',
      pixel: 'assets/characters/$folder/pixel.png',
      fullsize: 'assets/characters/$folder/fullsize.png',
      colorValue: colorValue,
      description: _getClassDescription(persona.characterClass),
    );
  }
  
  /// Get description based on character class
  static String _getClassDescription(PersonaClass characterClass) {
    switch (characterClass) {
      case PersonaClass.warrior:
        return 'Guerrier puissant et résistant';
      case PersonaClass.mage:
        return 'Mage aux puissants sorts';
      case PersonaClass.rogue:
        return 'Voleur agile et chanceux';
      case PersonaClass.cleric:
        return 'Clerc soigneur et protecteur';
    }
  }
  
  static CharacterStats _calculateStats(Persona persona) {
    // Base stats
    int maxHp = 100;
    int attack = 10;
    int defense = 8;
    int speed = 6;
    int magic = 5;
    int range = 1;
    int luck = 5;
    int gold = 100; // Starting gold
    
    // Regional bonuses
    switch (persona.region) {
      case PersonaRegion.west:
        // Medieval - balanced
        attack += 2;
        defense += 2;
        break;
      case PersonaRegion.east:
        // Asian - speed and magic
        speed += 3;
        magic += 2;
        break;
      case PersonaRegion.north:
        // Nordic - strength and endurance
        maxHp += 15;
        attack += 3;
        break;
      case PersonaRegion.south:
        // Egyptian - magic and luck
        magic += 3;
        luck += 3;
        break;
    }
    
    // Racial bonuses
    switch (persona.race) {
      case PersonaRace.human:
        // Balanced - bonus to all stats
        maxHp += 5;
        attack += 1;
        defense += 1;
        speed += 1;
        magic += 1;
        luck += 1;
        break;
      case PersonaRace.elf:
        // Magical and agile
        magic += 4;
        speed += 3;
        luck += 2;
        defense -= 1; // Fragile
        break;
      case PersonaRace.dwarf:
        // Tank-like
        maxHp += 20;
        defense += 4;
        attack += 2;
        speed -= 2; // Slow
        break;
      case PersonaRace.orc:
        // Aggressive
        attack += 5;
        maxHp += 10;
        magic -= 2;
        luck -= 1;
        break;
    }
    
    // Origin bonuses
    switch (persona.origin) {
      case PersonaOrigin.noble:
        // Rich and educated
        gold += 50;
        magic += 2;
        luck += 2;
        break;
      case PersonaOrigin.merchant:
        // Business savvy
        gold += 75;
        luck += 3;
        speed += 1;
        break;
      case PersonaOrigin.peasant:
        // Hardy worker
        maxHp += 10;
        defense += 2;
        attack += 1;
        gold -= 25; // Poor start
        break;
      case PersonaOrigin.scholar:
        // Learned
        magic += 4;
        luck += 1;
        defense -= 1; // Bookish
        break;
    }
    
    // Class bonuses (major impact)
    switch (persona.characterClass) {
      case PersonaClass.warrior:
        // Combat specialist
        attack += 6;
        defense += 4;
        maxHp += 15;
        magic -= 2;
        break;
      case PersonaClass.mage:
        // Magic user
        magic += 8;
        luck += 2;
        range += 1;
        maxHp -= 10;
        defense -= 2;
        break;
      case PersonaClass.rogue:
        // Stealthy and lucky
        speed += 6;
        luck += 4;
        attack += 2;
        defense -= 1;
        maxHp -= 5;
        break;
      case PersonaClass.cleric:
        // Support healer
        magic += 4;
        defense += 3;
        maxHp += 10;
        range += 1;
        luck += 2;
        attack -= 1;
        break;
    }
    
    // Ensure minimum values
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
}