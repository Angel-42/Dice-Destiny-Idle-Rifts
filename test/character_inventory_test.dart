import 'package:flutter_test/flutter_test.dart';
import 'package:dice_destiny_idle_rifts/src/models/character_inventory.dart';
import 'package:dice_destiny_idle_rifts/src/models/skill.dart';

void main() {
  group('CharacterInventory Skills Tests', () {
    test('Warrior class should have default skills', () {
      final inventory = CharacterInventory.createDefault('warrior');
      
      expect(inventory.skills, isNotEmpty);
      expect(inventory.skills.length, equals(6));
      
      // Check starting skill exists
      final startingSkills = inventory.skills.where((item) => item.isDefault).toList();
      expect(startingSkills.length, equals(1));
      expect(startingSkills.first.item.id, equals('power_strike'));
      expect(startingSkills.first.item.type, equals(SkillType.active));
    });

    test('Mage class should have default skills', () {
      final inventory = CharacterInventory.createDefault('mage');
      
      expect(inventory.skills, isNotEmpty);
      expect(inventory.skills.length, equals(6));
      
      // Check starting skill exists
      final startingSkills = inventory.skills.where((item) => item.isDefault).toList();
      expect(startingSkills.length, equals(1));
      expect(startingSkills.first.item.id, equals('fireball'));
    });

    test('Archer class should have default skills', () {
      final inventory = CharacterInventory.createDefault('archer');
      
      expect(inventory.skills, isNotEmpty);
      expect(inventory.skills.length, equals(6));
      
      // Check starting skill exists
      final startingSkills = inventory.skills.where((item) => item.isDefault).toList();
      expect(startingSkills.length, equals(1));
      expect(startingSkills.first.item.id, equals('precise_shot'));
    });

    test('Rogue class should have default skills', () {
      final inventory = CharacterInventory.createDefault('rogue');
      
      expect(inventory.skills, isNotEmpty);
      expect(inventory.skills.length, equals(6));
      
      // Check starting skill exists
      final startingSkills = inventory.skills.where((item) => item.isDefault).toList();
      expect(startingSkills.length, equals(1));
      expect(startingSkills.first.item.id, equals('backstab'));
    });

    test('Cleric class should have default skills', () {
      final inventory = CharacterInventory.createDefault('cleric');
      
      expect(inventory.skills, isNotEmpty);
      expect(inventory.skills.length, equals(6));
      
      // Check starting skill exists
      final startingSkills = inventory.skills.where((item) => item.isDefault).toList();
      expect(startingSkills.length, equals(1));
      expect(startingSkills.first.item.id, equals('heal'));
      expect(startingSkills.first.item.type, equals(SkillType.active));
    });

    test('Unknown class should have default peasant skills', () {
      final inventory = CharacterInventory.createDefault('unknown');
      
      expect(inventory.skills, isNotEmpty);
      expect(inventory.skills.length, equals(2));
      
      // Check basic attack exists
      final startingSkills = inventory.skills.where((item) => item.isDefault).toList();
      expect(startingSkills.length, equals(1));
      expect(startingSkills.first.item.id, equals('basic_attack'));
    });

    test('Skills should have proper unlock conditions', () {
      final inventory = CharacterInventory.createDefault('warrior');
      
      // Starting skill should be always unlocked
      final startingSkill = inventory.skills.first;
      expect(startingSkill.condition.type, equals(UnlockConditionType.always));
      
      // Check that there are level-based unlocks
      final levelUnlocks = inventory.skills
          .where((item) => item.condition.type == UnlockConditionType.level)
          .toList();
      expect(levelUnlocks, isNotEmpty);
      
      // Check that there are star-based unlocks
      final starUnlocks = inventory.skills
          .where((item) => item.condition.type == UnlockConditionType.stars)
          .toList();
      expect(starUnlocks, isNotEmpty);
    });

    test('Unlocked skills should filter correctly by character level', () {
      final inventory = CharacterInventory.createDefault('warrior');
      
      // Level 1 character should only have starting skill
      final level1Skills = inventory.getUnlockedSkills(
        characterLevel: 1,
        characterStars: 1,
      );
      expect(level1Skills.length, equals(1));
      expect(level1Skills.first.id, equals('power_strike'));
      
      // Level 10 character should have more skills
      final level10Skills = inventory.getUnlockedSkills(
        characterLevel: 10,
        characterStars: 2,
      );
      expect(level10Skills.length, greaterThan(1));
      
      // Level 20 with 5 stars should have all skills
      final maxLevelSkills = inventory.getUnlockedSkills(
        characterLevel: 20,
        characterStars: 5,
      );
      expect(maxLevelSkills.length, equals(6));
    });

    test('Skills should have valid stat bonuses', () {
      final inventory = CharacterInventory.createDefault('warrior');
      
      for (final skillItem in inventory.skills) {
        final skill = skillItem.item;
        
        // Each skill should have at least one stat bonus
        expect(skill.statBonuses, isNotEmpty);
        
        // Stat bonuses should be valid numbers
        for (final bonus in skill.statBonuses.values) {
          expect(bonus, isA<double>());
          expect(bonus.isFinite, isTrue);
        }
      }
    });
  });
}
