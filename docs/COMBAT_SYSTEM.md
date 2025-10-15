# Système de Combat et Calcul de Dégâts

## 📊 Formule Complète des Stats

### Stats Finales = (Base + Équipement) × Compétences Passives

```dart
// Exemple: Orc Warrior niveau 5 avec Iron Sword
stats.attack = 15                    // Stat de base
weapon.bonuses['attack'] = 5         // Bonus d'équipement
subtotal = 20                        // 15 + 5

// Compétence passive "Orcish Fury" : +15% attaque
skillMultiplier = 1.15               // 1.0 + 0.15
totalAttack = 23                     // 20 × 1.15 = 23 ✨
```

### Ordre de Calcul

1. **Stats de base** : Déterminées par classe/race/niveau
2. **+ Bonus d'équipement** : Arme + Armure + Accessoire (additif)
3. **× Bonus de compétences** : Toutes les passives (multiplicatif)

## ⚔️ Système de Dégâts Physiques

### Formule
```
Dégâts = [(Attaque × Maîtrise × Skill active) - (Défense cible × 0.5)]
```

### Détail des Composants

#### 1. Attaque de Base
```dart
totalAttack = (stats.attack + equipment) × passives
// Exemple: 23 (voir ci-dessus)
```

#### 2. Bonus de Maîtrise d'Arme
```dart
Rang E (lvl 0) = +0%   (×1.00)
Rang D (lvl 1) = +5%   (×1.05)
Rang C (lvl 2) = +10%  (×1.10)
Rang B (lvl 3) = +15%  (×1.15)
Rang A (lvl 4) = +20%  (×1.20)
Rang S (lvl 5) = +25%  (×1.25)
```

**Exemple** : Warrior avec Sword rank D
```dart
damage = 23 × 1.05 = 24.15
```

#### 3. Compétence Active (optionnel)
```dart
Power Strike (Warrior) = +50%  (×1.50)
Backstab (Rogue)       = +100% (×2.00)
```

**Exemple** : Utilise Power Strike
```dart
damage = 24.15 × 1.50 = 36.22
```

#### 4. Réduction de Défense
```dart
defense_reduction = target.totalDefense × 0.5
final_damage = damage - defense_reduction
```

**Exemple** : Cible a 12 de défense
```dart
reduction = 12 × 0.5 = 6
final_damage = 36.22 - 6 = 30.22 ≈ 30 dégâts
```

### Exemple Complet

**Attaquant** : Orc Warrior niveau 5
- Stats de base : 15 Atk
- Iron Sword : +5 Atk
- Orcish Fury (passive) : +15% Atk
- **Total Attaque : 23**
- Sword Mastery : Rank D (+5%)
- Compétence : Power Strike (+50%)

**Défenseur** : Elf Cleric niveau 5
- Defense totale : 12

**Calcul** :
```
1. Attaque de base : 23
2. × Maîtrise (D)   : 23 × 1.05 = 24.15
3. × Power Strike   : 24.15 × 1.50 = 36.22
4. - Défense cible  : 36.22 - (12 × 0.5) = 30.22
5. Dégâts finaux    : 30
```

## 🔮 Système de Dégâts Magiques

### Formule
```
Dégâts = [(Magie × Skill active) - (Résistance cible × 0.3)]
```

### Différences avec Physique

- ❌ **Pas de bonus de maîtrise d'arme** pour la magie pure
- ✅ **Résistance réduite** : ×0.3 au lieu de ×0.5 (la magie pénètre mieux)

### Exemple

**Attaquant** : Elf Mage niveau 5
- Stats de base : 18 Mag
- Wooden Staff : +5 Mag
- Elven Grace (passive) : +0% Mag (pas de bonus magie)
- Scholar Wisdom (origine) : +10% Mag
- **Total Magie : 25**
- Compétence : Fireball (+30%)

**Défenseur** : Dwarf Warrior niveau 5
- Magie (résistance) : 8
- Dwarven Resilience : +10% résistance
- **Total Résistance : 9**

**Calcul** :
```
1. Magie de base    : 25
2. × Fireball       : 25 × 1.30 = 32.5
3. - Résistance     : 32.5 - (9 × 0.3) = 29.8
4. Dégâts finaux    : 30
```

## 🎯 Bonus de Compétences Passives

### Toutes les Passives Disponibles

| Compétence            | Source  | Bonus                          |
|-----------------------|---------|--------------------------------|
| **Orcish Fury**       | Orc     | +15% Attaque                   |
| **Elven Grace**       | Elf     | +5% Vitesse, +5% Esquive       |
| **Dwarven Resilience**| Dwarf   | +10% Défense, +10% Résistance  |
| **Adaptability**      | Human   | +10% XP                        |
| **Leadership**        | Noble   | +5% TOUTES stats               |
| **Lucky Trade**       | Merchant| +20% Butin                     |
| **Endurance**         | Peasant | +15% HP Max                    |
| **Scholar Wisdom**    | Scholar | +10% Magie                     |

### Cumul de Bonus

Les bonus **se multiplient** entre eux :

**Exemple** : Human Noble Warrior
- Leadership : +5% toutes stats
- Base Attack : 15
- Equipment : +5
- Subtotal : 20
- × 1.05 (Leadership) = **21**

**Exemple** : Orc Noble Warrior
- Orcish Fury : +15% attaque
- Leadership : +5% toutes stats
- Base Attack : 15
- Equipment : +5
- Subtotal : 20
- × 1.15 (Fury) × 1.05 (Leadership) = **24**

## 🛡️ Système de Défense

### Réduction de Dégâts

#### Dégâts Physiques
```
Réduction = Défense × 0.5
```
- Défense 10 → Réduit de 5
- Défense 20 → Réduit de 10
- Défense 30 → Réduit de 15

#### Dégâts Magiques
```
Réduction = Résistance × 0.3
```
- Résistance 10 → Réduit de 3
- Résistance 20 → Réduit de 6
- Résistance 30 → Réduit de 9

### Dégâts Minimum
Tous les calculs ont un **minimum de 1 dégât** (impossible de bloquer à 100%).

## 📈 Progression et Scaling

### Évolution des Stats

#### Niveau 1 → 10

| Niveau | Warrior Atk | Mage Mag | Rogue Spd |
|--------|-------------|----------|-----------|
| 1      | 10          | 15       | 12        |
| 5      | 22          | 31       | 24        |
| 10     | 37          | 51       | 39        |

#### Avec Équipement + Passives (niveau 10)

| Build                           | Attack Final |
|---------------------------------|--------------|
| Warrior + Iron Sword            | 42           |
| Orc Warrior + Iron Sword        | 48 (+15%)    |
| Orc Noble Warrior + Iron Sword  | 50 (+25%)    |

### Impact de la Maîtrise d'Arme

| Rang | Dégâts (base 30) | Différence |
|------|------------------|------------|
| E    | 30               | -          |
| D    | 31.5 (+5%)       | +1.5       |
| C    | 33 (+10%)        | +3         |
| B    | 34.5 (+15%)      | +4.5       |
| A    | 36 (+20%)        | +6         |
| S    | 37.5 (+25%)      | +7.5       |

## 🎮 Utilisation en Combat

### Code d'Exemple

```dart
// Combat physique simple
final damage = attacker.calculatePhysicalDamage(defender);
defender.currentHp -= damage;

// Combat avec compétence active
final powerStrike = attacker.equippedSkills.firstWhere(
  (s) => s.id == 'power_strike',
);
final damage = attacker.calculatePhysicalDamage(
  defender, 
  activeSkill: powerStrike,
);

// Combat magique
final damage = mage.calculateMagicDamage(defender);

// Combat magique avec Fireball
final fireball = mage.equippedSkills.firstWhere(
  (s) => s.id == 'fireball',
);
final damage = mage.calculateMagicDamage(
  defender,
  activeSkill: fireball,
);
```

### Affichage dans l'UI

```dart
// Stats détaillées dans CharacterDetailScreen
Text('Attack: ${character.totalAttack}')  // 23 (inclut tout)
Text('With Power Strike: ${character.totalAttack * 1.5}')  // 34.5

// Dégâts estimés
final estimatedDamage = character.calculatePhysicalDamage(enemy);
Text('Damage vs Enemy: ~$estimatedDamage')
```

## ⚙️ Configuration dans les Modèles

### Skill avec Bonus

```dart
const Skill(
  id: 'orcish_fury',
  name: 'Orcish Fury',
  emoji: '👹',
  description: '+15% attaque physique',
  type: SkillType.passive,
  statBonuses: {'attack': 0.15},  // 15% = 0.15
)
```

### Compétence Active

```dart
const Skill(
  id: 'power_strike',
  name: 'Power Strike',
  emoji: '⚔️',
  description: 'Attaque puissante +50%',
  type: SkillType.active,
  statBonuses: {'damageMultiplier': 0.50},  // +50%
)
```

## ✅ État Actuel

- ✅ Stats calculées avec équipement + compétences passives
- ✅ Calcul de dégâts physiques complet
- ✅ Calcul de dégâts magiques complet
- ✅ Bonus de maîtrise d'arme
- ✅ Bonus de compétences actives
- ✅ Système de défense/résistance
- ✅ Dégâts minimum garantis

## 📝 À Implémenter

- [ ] UI pour voir les dégâts estimés
- [ ] Animation de combat
- [ ] Coups critiques (basés sur Luck)
- [ ] Esquive (basée sur Speed)
- [ ] Éléments (Feu, Glace, Foudre...)
- [ ] Buff/Debuff temporaires
- [ ] Système de combo
