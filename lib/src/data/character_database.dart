import 'package:dice_destiny_idle_rifts/src/models/character.dart';
import '../models/persona.dart';
import '../models/equipment.dart';
import '../models/preset_character.dart';

/// Bibliothèque de personnages prédéfinis
class CharacterDatabase {
  // ============================================================================
  // LÉGENDAIRES (5★) - 3% de drop
  // ============================================================================

  static const PresetCharacter chromLordOfBlades = PresetCharacter(
    id: 'chrom_001',
    name: 'Chrom',
    title: 'Le Prince Exalté',
    sprite: '👑',
    colorValue: 0xFF1E88E5,
    rarity: CharacterRarity.legendary,
    description: 'Prince héritier d\'Ylisse, il manie Falchion avec bravoure.',
    backstory: '''
Chrom est le prince d'Ylisse et le descendant du légendaire Héros-Roi. 
Après la mort de son père, il prend la tête des Bergers pour protéger son royaume 
des invasions voisines et des forces obscures qui menacent le continent.

Sa loyauté envers ses compagnons et son sens du devoir en font un leader naturel.
Il porte l'épée sacrée Falchion, transmise de génération en génération.
''',
    persona: Persona(
      race: PersonaRace.human,
      region: PersonaRegion.west,
      origin: PersonaOrigin.noble,
      characterClass: PersonaClass.warrior,
    ),
    baseStats: {
      'maxHp': 140,
      'attack': 28,
      'defense': 20,
      'speed': 18,
      'magic': 5,
      'range': 1,
      'luck': 22,
    },
    starterWeapon: Equipment(
      id: 'falchion',
      name: 'Falchion',
      emoji: '⚔️',
      type: EquipmentType.weapon,
      rarity: EquipmentRarity.legendary,
      bonuses: {'attack': 15, 'luck': 5},
    ),
    voiceLines: [
      'Tout le monde mérite une seconde chance !',
      'Je protégerai mes alliés, quoi qu\'il arrive.',
      'Pour Ylisse !',
    ],
    tags: ['Leader', 'DPS', 'Physique'],
  );

  // ============================================================================
  // ÉPIQUES (4★) - 12% de drop
  // ============================================================================

  static const PresetCharacter envia = PresetCharacter(
    id: 'envia_001',
    name: 'Envia',
    title: 'Sabreuse des Ombres',
    sprite: '~/assets/characters/Envia/headshot.png',
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
      'maxHp': 140,
      'attack': 28,
      'defense': 20,
      'speed': 18,
      'magic': 5,
      'range': 1,
      'luck': 22,
    },
    starterWeapon: Equipment(
      id: 'falchion',
      name: 'Falchion',
      emoji: '⚔️',
      type: EquipmentType.weapon,
      rarity: EquipmentRarity.legendary,
      bonuses: {'attack': 15, 'luck': 5},
    ),
    voiceLines: [
      'Tout le monde mérite une seconde chance !',
      'Je protégerai mes alliés, quoi qu\'il arrive.',
      'Pour Ylisse !',
    ],
    tags: ['DPS', 'Physique'],
  );

  // ============================================================================
  // RARES (3★) - 25% de drop
  // ============================================================================

  // ============================================================================
  // COMMUNS (2★) - 60% de drop
  // ============================================================================

  // ============================================================================
  // LISTE COMPLÈTE
  // ============================================================================

  static const List<PresetCharacter> allCharacters = [
    // Légendaires
    chromLordOfBlades,
    
    // Épiques
    envia,
    
    // Rares
    
    // Communs
  ];

  /// Récupère un personnage par ID
  static PresetCharacter? getById(String id) {
    try {
      return allCharacters.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Filtre par rareté
  static List<PresetCharacter> getByRarity(CharacterRarity rarity) {
    return allCharacters.where((c) => c.rarity == rarity).toList();
  }

  /// Filtre par classe
  static List<PresetCharacter> getByClass(PersonaClass characterClass) {
    return allCharacters.where((c) => c.persona.characterClass == characterClass).toList();
  }

  /// Filtre par tag
  static List<PresetCharacter> getByTag(String tag) {
    return allCharacters.where((c) => c.tags.contains(tag)).toList();
  }
}