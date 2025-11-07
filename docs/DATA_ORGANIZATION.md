# Organisation des Données du Jeu

Ce document explique comment les armes, compétences, armures et personnages sont organisés dans le projet.

## Structure

### Bases de Données Centralisées

Tous les équipements et compétences sont définis dans des fichiers centralisés :

- **`lib/src/data/weapons_database.dart`** - Toutes les armes du jeu
- **`lib/src/data/armors_database.dart`** - Toutes les armures et accessoires
- **`lib/src/data/skills_database.dart`** - Toutes les compétences

### Inventaires des Personnages

Les inventaires sont organisés en deux niveaux :

#### 1. Inventaire par Défaut (`character_inventory.dart`)
- Contient **uniquement les armes de base** pour chaque classe
- Une armure de départ basique (Cloth Armor)
- Pas d'accessoire par défaut
- Utilisé pour les personnages génériques ou nouvellement créés

#### 2. Inventaire Personnalisé (dans `character_database.dart`)
- Chaque personnage prédéfini (PresetCharacter) peut avoir son propre inventaire unique
- Défini avec la propriété `customInventory` du PresetCharacter
- Les items sont débloqués selon des conditions (niveau, étoiles, etc.)

## Exemple d'Utilisation

### Limitations d'Équipement

Chaque personnage peut équiper :
- **1 arme** (choix parmi son inventaire)
- **1 armure** (choix parmi son inventaire)
- **1 accessoire** (choix parmi son inventaire)
- **1 compétence active** (choix parmi ses compétences actives disponibles)
- **3 compétences passives** (choix parmi ses compétences passives disponibles)

L'inventaire personnalisé contient les items **disponibles** pour le personnage, mais il ne peut en équiper qu'un nombre limité à la fois.

### Créer un Inventaire Personnalisé pour un Personnage

```dart
static final PresetCharacter myHero = PresetCharacter(
  id: 'hero_001',
  name: 'Mon Héros',
  // ... autres propriétés ...
  customInventory: _createCustomInventory(
    // Le personnage peut choisir UNE arme parmi celles-ci
    weapons: [
      WeaponsDatabase.ironSword,
      WeaponsDatabase.steelSword,
      WeaponsDatabase.excalibur,
    ],
    weaponConditions: [
      _alwaysUnlocked,
      _levelCondition(5),
      _starsCondition(5),
    ],
    // Le personnage peut choisir UNE armure parmi celles-ci
    armors: [
      ArmorsDatabase.chainmail,
      ArmorsDatabase.plateArmor,
    ],
    armorConditions: [
      _alwaysUnlocked,
      _levelCondition(10),
    ],
    // Le personnage peut choisir UN accessoire parmi ceux-ci
    accessories: [
      AccessoriesDatabase.strengthRing,
    ],
    accessoryConditions: [
      _levelCondition(5),
    ],
    // 1 active + 3 passives (max 4 équipées au total)
    skills: [
      // Actives (équipe 1 parmi)
      SkillsDatabase.powerStrike,
      SkillsDatabase.whirlwind,
      // Passives (équipe 3 parmi)
      SkillsDatabase.nobleLeadership,
      SkillsDatabase.criticalHit,
      SkillsDatabase.ironSkin,
      SkillsDatabase.weaponMaster,
    ],
    skillConditions: [
      _alwaysUnlocked,
      _levelCondition(10),
      _alwaysUnlocked,
      _starsCondition(3),
      _levelCondition(8),
      _starsCondition(4),
    ],
  ),
);
```

## Types de Conditions de Déblocage

- **`UnlockConditionType.always`** - Toujours débloqué (item de départ)
- **`UnlockConditionType.level`** - Débloqué à un certain niveau
- **`UnlockConditionType.stars`** - Débloqué à une certaine rareté (nombre d'étoiles)
- **`UnlockConditionType.classPromotion`** - Débloqué après X promotions de classe

## Base de Données des Armes

### Catégories

Les armes sont organisées par type :

- **Épées (Swords)** - Pour guerriers/chevaliers
- **Haches (Axes)** - Pour guerriers lourds
- **Bâtons (Staffs)** - Pour mages
- **Tomes (Books)** - Pour mages érudits
- **Arcs (Bows)** - Pour archers
- **Dagues (Daggers)** - Pour voleurs/assassins
- **Lances (Spears)** - Pour lanciers
- **Bâtons de Soin (Rods)** - Pour clercs
- **Armes Spéciales** - Katana, faux, chakram, griffes...

### Raretés

- **Common** (Commun) - Armes de base
- **Uncommon** (Peu commun) - Armes améliorées
- **Rare** - Armes puissantes
- **Epic** (Épique) - Armes exceptionnelles
- **Legendary** (Légendaire) - Armes mythiques

### Accès

```dart
// Récupérer une arme par ID
final sword = WeaponsDatabase.getById('excalibur');

// Récupérer toutes les armes d'une catégorie
final swords = WeaponsDatabase.getByCategory('swords');

// Récupérer toutes les armes d'une rareté
final legendaries = WeaponsDatabase.getByRarity(EquipmentRarity.legendary);

// Accès direct
final falchion = WeaponsDatabase.falchion;
```

## Base de Données des Compétences

### Catégories

- **warrior_active** - Compétences actives de guerrier
- **mage_active** - Compétences actives de mage
- **rogue_active** - Compétences actives de voleur/archer
- **cleric_active** - Compétences actives de clerc
- **race_passive** - Compétences passives de race
- **origin_passive** - Compétences passives d'origine
- **general_passive** - Compétences passives générales
- **ultimate** - Compétences ultimes

### Types de Compétences

- **SkillType.active** - Compétence utilisable en combat
- **SkillType.passive** - Bonus permanent
- **SkillType.ultimate** - Compétence puissante à cooldown long

### Accès

```dart
// Récupérer une compétence par ID
final fireball = SkillsDatabase.getById('fireball');

// Récupérer les compétences d'une catégorie
final warriorSkills = SkillsDatabase.getByCategory('warrior_active');

// Récupérer les compétences recommandées pour une classe
final mageSkills = SkillsDatabase.getRecommendedForClass('mage');

// Accès direct
final powerStrike = SkillsDatabase.powerStrike;
```

## Base de Données des Armures et Accessoires

### Armures

Organisées par poids :
- **Légères** - Robes, cuir (bonus vitesse)
- **Moyennes** - Cotte de mailles, écailles (équilibré)
- **Lourdes** - Armure de plates (haute défense)
- **Magiques** - Robes de mage (bonus magie)
- **Légendaires** - Armures mythiques

### Accessoires

Plusieurs types :
- **Anneaux** - Petits bonus ciblés
- **Amulettes** - Bonus défensifs/magiques
- **Ceintures** - Bonus force/HP
- **Bottes** - Bonus vitesse
- **Spéciaux** - Items uniques

### Accès

```dart
// Armures
final armor = ArmorsDatabase.getById('dragon_scale');
final rares = ArmorsDatabase.getByRarity(EquipmentRarity.rare);

// Accessoires
final ring = AccessoriesDatabase.getById('strength_ring');
final epics = AccessoriesDatabase.getByRarity(EquipmentRarity.epic);
```

## Personnages Actuels

### Légendaires (5★)
- **Chrom** - Prince Exalté, guerrier noble avec Falchion
  - 5 armes disponibles, 4 armures, 3 accessoires
  - 4 compétences actives, 4 passives (équipe 1+3)

### Épiques (4★)
- **Envia** - Sabreuse des Ombres, guerrière rapide avec katana
  - 4 armes disponibles, 3 armures, 3 accessoires
  - 3 compétences actives, 4 passives (équipe 1+3)

### Rares (3★)
- **Elio** - Défenseur du Soleil, paladin tank avec lame de feu
  - 4 armes disponibles, 3 armures, 3 accessoires
  - 3 compétences actives, 4 passives (équipe 1+3)

### Communs (2★)
- **Ragor** - Archer des Forêts, DPS distance avec arc
  - 4 armes disponibles, 3 armures, 3 accessoires
  - 3 compétences actives, 4 passives (équipe 1+3)
- **Aria** - Mage Apprentie, DPS magique avec bâton
  - 4 armes disponibles, 3 armures, 3 accessoires
  - 3 compétences actives, 4 passives (équipe 1+3)

## Ajouter du Nouveau Contenu

### Ajouter une Arme

1. Ajouter la définition dans `weapons_database.dart`
2. L'ajouter à la catégorie appropriée dans `byCategory`

### Ajouter une Compétence

1. Ajouter la définition dans `skills_database.dart`
2. L'ajouter à la catégorie appropriée dans `byType`

### Ajouter un Personnage

1. Créer un `PresetCharacter` dans `character_database.dart`
2. Définir son `customInventory` avec les armes/compétences voulues
3. L'ajouter à `allCharacters`

## Avantages de cette Architecture

✅ **Pas de hardcoding** - Tous les items sont dans des bases de données centralisées
✅ **Réutilisable** - Les items peuvent être utilisés par plusieurs personnages
✅ **Flexible** - Facile d'ajouter de nouveaux items ou personnages
✅ **Modulaire** - Chaque personnage peut avoir un inventaire unique
✅ **Évolutif** - Les conditions de déblocage permettent la progression
✅ **Maintenable** - Code organisé et facile à comprendre
