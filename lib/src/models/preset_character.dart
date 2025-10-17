import 'persona.dart';
import 'character.dart';
import 'equipment.dart';

/// Personnage prédéfini (template) pour le système de gacha
class PresetCharacter {
  final String id;
  final String name;
  final String title; // "Le Conquérant", "La Sage"...
  
  // Sprites pour différents contextes
  final String headshot;      // Icône dans la liste
  final String? lheadshot;    // Image longue pour les détails
  final String? pixel;        // Spritesheet pour les combats
  final String? fullsize;     // Image plein écran
  
  final int colorValue;
  final String description;
  final String backstory;
  final Persona persona;
  final CharacterRarity rarity;
  final Map<String, int> baseStats; // Stats de base
  final Equipment? starterWeapon;
  final List<String> voiceLines; // Phrases du personnage
  final List<String> tags; // Ex: ['Tank', 'Leader', 'DPS']

  const PresetCharacter({
    required this.id,
    required this.name,
    required this.title,
    required this.headshot,
    this.lheadshot,
    this.pixel,
    this.fullsize,
    required this.colorValue,
    required this.description,
    required this.backstory,
    required this.persona,
    required this.rarity,
    required this.baseStats,
    this.starterWeapon,
    this.voiceLines = const [],
    this.tags = const [],
  });

  /// Convertit le preset en personnage jouable
  Character toCharacter() {
    final stats = CharacterStats(
      maxHp: baseStats['maxHp'] ?? 100,
      attack: baseStats['attack'] ?? 10,
      defense: baseStats['defense'] ?? 8,
      speed: baseStats['speed'] ?? 6,
      magic: baseStats['magic'] ?? 5,
      range: baseStats['range'] ?? 1,
      luck: baseStats['luck'] ?? 5,
      gold: 100,
    );

    final appearance = CharacterAppearance(
      headshot: headshot,
      lheadshot: lheadshot,
      pixel: pixel,
      fullsize: fullsize,
      colorValue: colorValue,
      description: description,
    );

    return Character(
      name: name,
      persona: persona,
      stats: stats,
      appearance: appearance,
      weapon: starterWeapon,
      basedRarity: rarity,
      currentRarity: rarity,
    );
  }
}