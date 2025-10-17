import 'dart:math';
import '../models/character.dart';
import '../models/persona.dart';

/// Factory for creating characters based on persona choices
class CharacterFactory {
  static Character createFromPersona(Persona persona, String name) {
    // Calculate base stats from persona choices
    final stats = _calculateStats(persona);
    
    // Create appearance based on race
    final appearance = CharacterAppearance.fromRace(persona.race);
    
    return Character(
      name: name,
      persona: persona,
      stats: stats,
      appearance: appearance,
      basedRarity: CharacterRarity.legendary,
      currentRarity: CharacterRarity.legendary,
    );
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