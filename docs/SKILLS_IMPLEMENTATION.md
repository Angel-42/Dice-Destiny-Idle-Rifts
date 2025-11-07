# Character Inventory Skills Implementation

## Overview
This implementation adds a comprehensive skills system to the character inventory. Each character class now has access to class-specific skills that unlock progressively based on character level and rarity.

## Features

### Implemented Classes
- **Warrior/Knight**: 6 skills focused on physical combat and defense
- **Mage/Wizard**: 6 skills focused on magical attacks and buffs
- **Archer/Ranger**: 6 skills focused on ranged attacks and speed
- **Thief/Rogue**: 6 skills focused on stealth and critical strikes
- **Cleric/Priest**: 6 skills focused on healing and support
- **Default/Peasant**: 2 basic skills for unspecified classes

### Unlock System
Skills are unlocked based on:
- **Always Available**: Starting skills every character gets
- **Level-based**: Skills unlock at levels 5, 10, and 15
- **Star-based**: Special skills at 3★ and ultimate skills at 5★

### Skill Types
- **Active**: Combat skills that can be used in battle
- **Passive**: Permanent stat bonuses
- **Ultimate**: Powerful 5★ skills with massive effects

## Example Skills by Class

### Warrior/Knight
1. **Power Strike** (Starting) - Powerful attack dealing +50% damage
2. **Shield Bash** (Level 5) - Stuns enemy while dealing damage
3. **Berserker Rage** (Level 10) - +30% attack, -10% defense
4. **Iron Will** (Level 15) - Passive: +15% defense and HP
5. **Whirlwind Attack** (3★) - AOE attack hitting all enemies
6. **Legendary Strike** (5★) - Ultimate: +200% damage

### Mage/Wizard
1. **Fireball** (Starting) - Launches a magical fireball
2. **Frost Bolt** (Level 5) - Ice attack that slows enemy
3. **Mana Shield** (Level 10) - Magic barrier absorbing damage
4. **Arcane Mastery** (Level 15) - Passive: +20% magic power
5. **Chain Lightning** (3★) - Lightning that jumps between enemies
6. **Meteor Storm** (5★) - Ultimate: Rains meteors on all enemies

### Cleric/Priest
1. **Heal** (Starting) - Heals an ally (30% max HP)
2. **Bless** (Level 5) - Increases ally stats
3. **Holy Light** (Level 10) - Deals magic damage to undead
4. **Divine Protection** (Level 15) - Passive: +20% defense and magic resistance
5. **Mass Heal** (3★) - Heals all allies
6. **Resurrection** (5★) - Ultimate: Revives fallen ally

## Code Integration

### Automatic Initialization
When a character is created, their inventory is automatically populated with class-specific skills:

```dart
final character = Character(
  name: 'Hero',
  persona: Persona(characterClass: PersonaClass.warrior, ...),
  ...
);
// character.inventory.skills now contains 6 warrior skills
```

### Getting Skills
```dart
// Get all skills (including locked ones)
final allSkills = character.inventory.getAllSkills();

// Get only unlocked skills
final unlockedSkills = character.inventory.getUnlockedSkills(
  characterLevel: character.level,
  characterStars: character.currentRarity.stars,
);
```

### Checking Unlock Status
```dart
final skillItem = character.inventory.skills.first;
final isUnlocked = skillItem.isUnlocked(
  characterLevel: 10,
  characterStars: 3,
);
```

## Implementation Details

### Files Modified
- `lib/src/models/character_inventory.dart`: Added `_getDefaultSkills()` implementation

### Files Added
- `test/character_inventory_test.dart`: Comprehensive unit tests

### Total Statistics
- **32 unique skills** across all classes
- **65 inventory items** (including unlock variants)
- **10 character classes** supported
- **3 unlock condition types** (always, level, stars)
- **3 skill types** (active, passive, ultimate)

## Testing

Run the unit tests:
```bash
flutter test test/character_inventory_test.dart
```

Tests cover:
- ✓ All character classes have proper default skills
- ✓ Skills have correct unlock conditions
- ✓ Unlocked skills filter properly by level and stars
- ✓ Skills have valid stat bonuses
- ✓ Proper skill type distribution

## Future Enhancements
- UI screens to display available and locked skills
- Skill equipping interface (currently max 5 equipped)
- Skill upgrade/evolution system
- Skill synergies between equipped skills
- Visual effects for skill usage
- Skill cooldown system
- Mana/resource costs for skills

## Compatibility
- Compatible with existing character system
- Works with class tree system
- Integrates with combat calculations
- Supports JSON serialization for save/load
