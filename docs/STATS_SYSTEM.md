# Système de Stats et Équipement

## 📊 Stats de Base vs Stats Totales

### Stats de Base (`character.stats`)
Stats pures du personnage, augmentées uniquement par :
- Niveau de départ (déterminé par classe/race)
- Montée de niveau (level up)
- Rareté de base

### Stats Totales (calculées dynamiquement)
```dart
character.totalAttack    // stats.attack + bonus d'équipement
character.totalDefense   // stats.defense + bonus d'équipement
character.totalMagic     // stats.magic + bonus d'équipement
character.totalSpeed     // stats.speed + bonus d'équipement
character.totalLuck      // stats.luck + bonus d'équipement
character.totalMaxHp     // stats.maxHp + bonus d'équipement
```

## 🗡️ Système d'Équipement

### Types d'équipement
- **Arme** (weapon) : Principale source de bonus d'attaque/magie
- **Armure** (armor) : Principale source de bonus de défense/HP
- **Accessoire** (accessory) : Bonus variés (chance, vitesse, etc.)

### Armes de départ par classe

| Classe   | Arme de départ | Bonus                    |
|----------|----------------|--------------------------|
| Warrior  | Iron Sword ⚔️  | +5 Attack                |
| Mage     | Wooden Staff 🪄 | +5 Magic                 |
| Rogue    | Iron Dagger 🗡️ | +3 Attack, +2 Speed      |
| Cleric   | Healing Rod ⚕️ | +3 Magic, +2 Defense     |

### Calcul des bonus
```dart
// Exemple : Guerrier niveau 5 avec Iron Sword
stats.attack = 15         // Stat de base
weapon.bonuses['attack'] = 5
totalAttack = 20          // Affiché dans l'UI

// Si on équipe une meilleure épée avec +10 Atk
totalAttack = 25          // Mis à jour automatiquement
```

## 🎯 Compétences (Skills)

### Types de compétences
- **Active** : Compétence activable en combat
- **Passive** : Bonus permanent
- **Ultimate** : Compétence puissante avec cooldown

### Compétences de départ (3 par personnage)

#### Par Classe (Active)
| Classe   | Compétence     | Effet                           |
|----------|----------------|---------------------------------|
| Warrior  | Power Strike ⚔️ | Attaque +50% dégâts            |
| Mage     | Fireball 🔥    | Boule de feu magique           |
| Rogue    | Backstab 🗡️   | Attaque sournoise critique     |
| Cleric   | Heal 💚        | Soigne un allié                |

#### Par Race (Passive)
| Race   | Compétence           | Effet                    |
|--------|----------------------|--------------------------|
| Human  | Adaptability 👤      | +10% XP                  |
| Elf    | Elven Grace 🧝       | +5% vitesse/esquive      |
| Dwarf  | Dwarven Resilience 🎯| +10% défense/résistance  |
| Orc    | Orcish Fury 👹       | +15% attaque physique    |

#### Par Origine (Passive)
| Origine  | Compétence    | Effet                      |
|----------|---------------|----------------------------|
| Noble    | Leadership 👑  | +5% stats pour l'équipe    |
| Merchant | Lucky Trade 💰 | +20% butin après combat    |
| Peasant  | Endurance 🌾   | +15% HP max                |
| Scholar  | Wisdom 📚      | +10% puissance magique     |

## ⚔️ Maîtrise des Armes

### Rangs de maîtrise
- **E** (niveau 0) : Débutant
- **D** (niveau 1) : Apprenti
- **C** (niveau 2) : Compétent
- **B** (niveau 3) : Expert
- **A** (niveau 4) : Maître
- **S** (niveau 5) : Légende

### Maîtrises par classe

| Classe   | Armes maîtrisées          | Niveau de départ    |
|----------|---------------------------|---------------------|
| Warrior  | Sword ⚔️, Axe 🪓, Lance 🔱 | D, E, E            |
| Mage     | Staff 🪄, Tome 📖         | D, E               |
| Rogue    | Dagger 🗡️, Bow 🏹        | D, E               |
| Cleric   | Rod ⚕️, Staff 🪄          | D, E               |

### Influence sur les stats
- Plus le rang est élevé, plus les bonus avec ce type d'arme sont importants
- Un Warrior avec Sword rank A fera +20% de dégâts avec une épée
- Permet aussi de débloquer des armes plus puissantes

## 💾 Sauvegarde Firebase

### Structure de données

```json
{
  "users": {
    "userId123": {
      "displayName": "Player1",
      "gold": 1000,
      "gems": 50,
      "characters": {
        "char_001": {
          "id": "char_001",
          "name": "Chrom",
          "level": 5,
          "stats": {
            "attack": 15,
            "defense": 12,
            "magic": 8,
            "speed": 10,
            "luck": 7,
            "maxHp": 100
          },
          "weapon": {
            "id": "iron_sword",
            "name": "Iron Sword",
            "emoji": "⚔️",
            "type": "weapon",
            "bonuses": {
              "attack": 5
            }
          },
          "armor": null,
          "accessory": null,
          "equippedSkills": [
            {
              "id": "power_strike",
              "name": "Power Strike",
              "emoji": "⚔️",
              "type": "active"
            },
            {
              "id": "adaptability",
              "name": "Adaptability",
              "emoji": "👤",
              "type": "passive"
            },
            {
              "id": "noble_leadership",
              "name": "Leadership",
              "emoji": "👑",
              "type": "passive"
            }
          ],
          "weaponMasteries": [
            {
              "type": "sword",
              "level": 1
            },
            {
              "type": "axe",
              "level": 0
            }
          ]
        }
      }
    }
  }
}
```

### Méthodes de sauvegarde

```dart
// Sauvegarder un personnage (auto-save après modifications)
await GameDataService.saveCharacter(character);

// Charger tous les personnages
final characters = await GameDataService.getAllCharacters();

// Charger un personnage spécifique
final character = await GameDataService.getCharacter('char_001');
```

## 🎮 Affichage dans l'UI

### CharacterDetailScreen
- **Stats** : Affiche `totalAttack` au lieu de `stats.attack`
- **Format** : `15 +5 = 20` (base + bonus = total)
- **Couleur** : Vert pour les stats boostées
- **Équipement** : Affiche nom + emoji + bonus
- **Compétences** : Grid 5 max (3 au départ)
- **Maîtrises** : Liste avec emoji + rang

### CharactersScreen
- **Stats rapides** : Utilise `totalAttack`, `totalDefense`, `totalSpeed`
- **Affichage** : Stats totales, pas besoin de détail

## 🔄 Mise à jour automatique

Quand on équipe/déséquipe un item :
```dart
character.weapon = newWeapon;
// Les getters totalAttack, totalDefense, etc. se mettent à jour automatiquement
await GameDataService.saveCharacter(character); // Sauvegarde Firebase
```

## ✅ État actuel

- ✅ Stats totales calculées dynamiquement
- ✅ Bonus d'équipement appliqués
- ✅ Affichage UI avec bonus visuels
- ✅ Sauvegarde Firebase complète
- ✅ Compétences de départ automatiques
- ✅ Maîtrises d'armes par défaut
- ✅ Arme de départ selon classe

## 📝 À implémenter

- [ ] Équiper/déséquiper des items via UI
- [ ] Système de loot d'équipements
- [ ] Progression des maîtrises d'armes
- [ ] Débloquer nouvelles compétences
- [ ] Amélioration de rareté (montée en étoiles)
- [ ] Bonus de compétences passives appliqués aux stats
git 