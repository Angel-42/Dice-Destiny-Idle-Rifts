import 'package:flutter/foundation.dart';
import '../models/skill.dart';
import '../models/character_inventory.dart';
import '../models/class_tree.dart';
import '../models/character.dart';
import '../models/preset_character.dart';
import '../data/character_database.dart';
import 'game_data_service.dart';

/// Service de migration des données pour les mises à jour de schéma
class DataMigrationService {
  /// Migre tous les personnages vers le nouveau format avec statBonuses
  static Future<void> migrateSkillsToV2() async {
    try {
      debugPrint('🔄 Début migration skills v2...');
      
      final characters = await GameDataService.getAllCharacters();
      int migratedCount = 0;
      
      for (final character in characters) {
        bool needsMigration = false;
        
        // Vérifier si les skills ont besoin de migration
        final updatedSkills = <Skill>[];
        for (final skill in character.equippedSkills) {
          if (skill.statBonuses.isEmpty && _shouldHaveBonuses(skill.id)) {
            // Recréer la skill avec les bons bonus
            final newSkill = _getSkillWithBonuses(skill.id);
            if (newSkill != null) {
              updatedSkills.add(newSkill);
              needsMigration = true;
            } else {
              updatedSkills.add(skill);
            }
          } else {
            updatedSkills.add(skill);
          }
        }
        
        // Si migration nécessaire, sauvegarder
        if (needsMigration) {
          character.equippedSkills.clear();
          character.equippedSkills.addAll(updatedSkills);
          await GameDataService.saveCharacter(character);
          migratedCount++;
          debugPrint('  ✅ Migré: ${character.name}');
        }
      }
      
      debugPrint('✅ Migration terminée: $migratedCount/${ characters.length} personnages migrés');
    } catch (e) {
      debugPrint('❌ Erreur migration: $e');
    }
  }

  /// Migre les personnages existants pour utiliser le nouveau système de ClassTree
  static Future<void> migrateCharactersToClassTree() async {
    try {
      debugPrint('🔄 Début migration ClassTree...');
      final characters = await GameDataService.getAllCharacters();
  final tree = ClassTree.instance;
      int migrated = 0;

      for (final character in characters) {
        if (character.ownedClassIds.isEmpty) {
          // Déterminer la novice correspondant au persona
          final noviceId = character.persona.characterClass.noviceId;

          character.ownedClassIds.add(noviceId);

          if (character.basedRarity == CharacterRarity.epic) {
            final noviceNode = tree.get(noviceId);
            if (noviceNode != null && noviceNode.children.isNotEmpty) {
              final advId = noviceNode.children.first;
              character.ownedClassIds.add(advId);
              character.activeClassId = advId;
            }
          }

          character.activeClassId ??= noviceId;
          await GameDataService.saveCharacter(character);
          migrated++;
        }
      }

      debugPrint('✅ Migration ClassTree terminée: $migrated/${characters.length} personnages migrés');
    } catch (e) {
      debugPrint('❌ Erreur migration ClassTree: $e');
    }
  }
  
  /// Vérifie si une compétence devrait avoir des bonus
  static bool _shouldHaveBonuses(String skillId) {
    return const [
      'orcish_fury',
      'elven_grace',
      'dwarven_resilience',
      'adaptability',
      'noble_leadership',
      'merchant_luck',
      'peasant_endurance',
      'scholar_wisdom',
      'power_strike',
      'fireball',
      'backstab',
      'heal',
    ].contains(skillId);
  }
  
  /// Récupère une skill avec ses bonus corrects
  static Skill? _getSkillWithBonuses(String skillId) {
    // Skills de classe
    if (skillId == 'power_strike') {
      return const Skill(
        id: 'power_strike',
        name: 'Power Strike',
        emoji: '⚔️',
        description: 'Attaque puissante infligeant +50% de dégâts',
        type: SkillType.active,
        statBonuses: {'damageMultiplier': 0.50},
      );
    }
    if (skillId == 'fireball') {
      return const Skill(
        id: 'fireball',
        name: 'Fireball',
        emoji: '🔥',
        description: 'Lance une boule de feu magique (+30% dégâts magiques)',
        type: SkillType.active,
        statBonuses: {'damageMultiplier': 0.30},
      );
    }
    if (skillId == 'backstab') {
      return const Skill(
        id: 'backstab',
        name: 'Backstab',
        emoji: '🗡️',
        description: 'Attaque sournoise avec dégâts critiques (+100%)',
        type: SkillType.active,
        statBonuses: {'damageMultiplier': 1.00},
      );
    }
    if (skillId == 'heal') {
      return const Skill(
        id: 'heal',
        name: 'Heal',
        emoji: '💚',
        description: 'Soigne un allié (30% HP max)',
        type: SkillType.active,
        statBonuses: {'healMultiplier': 0.30},
      );
    }
    
    // Skills de race
    if (skillId == 'adaptability') {
      return const Skill(
        id: 'adaptability',
        name: 'Adaptability',
        emoji: '👤',
        description: '+10% XP gagné',
        type: SkillType.passive,
        statBonuses: {'xpGain': 0.10},
      );
    }
    if (skillId == 'elven_grace') {
      return const Skill(
        id: 'elven_grace',
        name: 'Elven Grace',
        emoji: '🧝',
        description: '+5% vitesse et esquive',
        type: SkillType.passive,
        statBonuses: {'speed': 0.05, 'evasion': 0.05},
      );
    }
    if (skillId == 'dwarven_resilience') {
      return const Skill(
        id: 'dwarven_resilience',
        name: 'Dwarven Resilience',
        emoji: '🎯',
        description: '+10% défense et résistance',
        type: SkillType.passive,
        statBonuses: {'defense': 0.10, 'magic': 0.10},
      );
    }
    if (skillId == 'orcish_fury') {
      return const Skill(
        id: 'orcish_fury',
        name: 'Orcish Fury',
        emoji: '👹',
        description: '+15% attaque physique',
        type: SkillType.passive,
        statBonuses: {'attack': 0.15},
      );
    }
    
    // Skills d'origine
    if (skillId == 'noble_leadership') {
      return const Skill(
        id: 'noble_leadership',
        name: 'Leadership',
        emoji: '👑',
        description: '+5% toutes stats',
        type: SkillType.passive,
        statBonuses: {
          'attack': 0.05,
          'defense': 0.05,
          'magic': 0.05,
          'speed': 0.05,
          'luck': 0.05,
        },
      );
    }
    if (skillId == 'merchant_luck') {
      return const Skill(
        id: 'merchant_luck',
        name: 'Lucky Trade',
        emoji: '💰',
        description: '+20% butin après combat',
        type: SkillType.passive,
        statBonuses: {'lootBonus': 0.20},
      );
    }
    if (skillId == 'peasant_endurance') {
      return const Skill(
        id: 'peasant_endurance',
        name: 'Endurance',
        emoji: '🌾',
        description: '+15% HP max',
        type: SkillType.passive,
        statBonuses: {'maxHp': 0.15},
      );
    }
    if (skillId == 'scholar_wisdom') {
      return const Skill(
        id: 'scholar_wisdom',
        name: 'Wisdom',
        emoji: '📚',
        description: '+10% puissance magique',
        type: SkillType.passive,
        statBonuses: {'magic': 0.10},
      );
    }
    
    return null;
  }

  /// Migre les compétences des personnages existants pour utiliser celles de leur inventaire custom
  static Future<void> migrateCharacterSkills() async {
    try {
      debugPrint('🔄 Début de la migration des compétences...');
      
      final characters = await GameDataService.getAllCharacters();
      
      int migrated = 0;
      for (final character in characters) {
        // Chercher le preset correspondant par nom dans CharacterDatabase
        PresetCharacter? preset;
        try {
          preset = CharacterDatabase.allCharacters.firstWhere(
            (p) => p.name == character.name,
          );
        } catch (e) {
          // Pas de preset trouvé pour ce personnage
          continue;
        }
        
        // Si le preset n'a pas d'inventaire custom, on ne fait rien
        if (preset.customInventory == null) continue;
        
        // Vérifier si le personnage a les bonnes compétences
        final inventory = preset.customInventory!;
        final allSkills = inventory.getAllSkills();
        
        // Trouver les compétences équipées qui ne sont PAS dans l'inventaire
        bool needsMigration = false;
        for (final equippedSkill in character.equippedSkills) {
          if (equippedSkill.id.startsWith('empty_')) continue;
          
          final isInInventory = allSkills.any((item) => item.item.id == equippedSkill.id);
          if (!isInInventory) {
            needsMigration = true;
            break;
          }
        }
        
        if (needsMigration) {
          debugPrint('🔄 Migration compétences pour ${character.name}');
          
          // Récupérer les compétences par défaut de l'inventaire custom
          final activeSkills = allSkills
              .where((item) => 
                  item.item.type == SkillType.active && 
                  item.condition.type == UnlockConditionType.always)
              .map((item) => item.item)
              .toList();
          
          final passiveSkills = allSkills
              .where((item) => 
                  item.item.type == SkillType.passive && 
                  item.condition.type == UnlockConditionType.always)
              .map((item) => item.item)
              .toList();
          
          // Construire la nouvelle liste de compétences
          final newSkills = <Skill>[
            if (activeSkills.isNotEmpty) activeSkills.first,
            ...passiveSkills.take(3),
          ];
          
          final updatedCharacter = Character(
            id: character.id,
            name: character.name,
            persona: character.persona,
            stats: character.stats,
            appearance: character.appearance,
            level: character.level,
            xp: character.xp,
            x: character.x,
            y: character.y,
            weapon: character.weapon,
            armorOrAccessory: character.armorOrAccessory,
            equippedSkills: newSkills,
            weaponMasteries: character.weaponMasteries,
            inventory: preset.customInventory,
            initialOwnedClassIds: character.ownedClassIds,
            activeClassId: character.activeClassId,
            basedRarity: character.basedRarity,
            currentRarity: character.currentRarity,
            isInTeam: character.isInTeam,
            teamPosition: character.teamPosition,
            obtainedAt: character.obtainedAt,
          );
          updatedCharacter.currentHp = character.currentHp;
          
          await GameDataService.saveCharacter(updatedCharacter);
          migrated++;
        }
      }
      
      debugPrint('✅ Migration compétences terminée: $migrated/${characters.length} personnages migrés');
    } catch (e) {
      debugPrint('❌ Erreur lors de la migration des compétences: $e');
    }
  }
}
