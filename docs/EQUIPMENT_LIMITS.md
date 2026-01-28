# Limitations d'Équipement - Mise à Jour

## 🎮 Règles d'Équipement

Chaque personnage est maintenant limité à :

### Équipement
- ✅ **1 arme** (maximum équipée à la fois)
- ✅ **1 armure OU 1 accessoire** (mutuellement exclusif - le joueur choisit)

### Compétences
- ✅ **1 compétence active** (maximum équipée à la fois)
- ✅ **3 compétences passives** (maximum équipées à la fois)

**Total : 4 compétences équipées** (1 active + 3 passives)

## 📊 Inventaires Mis à Jour

Tous les personnages ont été ajustés pour respecter ces limitations tout en offrant des choix intéressants :

### Chrom (Légendaire 5★)
- **Armes disponibles** : 5 choix (Falchion, Steel Sword, Silver Sword, Excalibur, Dragon Slayer)
- **Armures disponibles** : 4 choix (Knight Armor, Plate Armor, Dragon Scale, Celestial Armor)
- **Accessoires disponibles** : 3 choix (Strength Ring, Champion Belt, Crown of Kings)
- **Compétences actives** : 3 choix (Power Strike, Shield Bash, Whirlwind)
- **Compétences passives** : 3 choix (Noble Leadership, Critical Hit, Weapon Master)

### Envia (Épique 4★)
- **Armes disponibles** : 4 choix (Katana, Steel Sword, Shadow Sword, Flame Blade)
- **Armures disponibles** : 3 choix (Leather Armor, Shadow Cloak, Mythril Chain)
- **Accessoires disponibles** : 3 choix (Speed Ring, Swift Boots, Hermes Boots)
- **Compétences actives** : 2 choix (Power Strike, Backstab)
- **Compétences passives** : 3 choix (Peasant Endurance, Swiftness, Critical Hit)

### Elio (Rare 3★)
- **Armes disponibles** : 4 choix (Flame Blade, Iron Sword, Steel Sword, Silver Sword)
- **Armures disponibles** : 3 choix (Chainmail, Knight Armor, Plate Armor)
- **Accessoires disponibles** : 3 choix (Defense Ring, Champion Belt, Giant Belt)
- **Compétences actives** : 2 choix (Power Strike, Shield Bash)
- **Compétences passives** : 3 choix (Noble Leadership, Iron Skin, Counter Attack)

### Ragor (Commun 2★)
- **Armes disponibles** : 4 choix (Short Bow, Hunting Bow, Longbow, Composite Bow)
- **Armures disponibles** : 3 choix (Leather Armor, Reinforced Leather, Elven Robe)
- **Accessoires disponibles** : 3 choix (Speed Ring, Lucky Clover, Windwalker Boots)
- **Compétences actives** : 2 choix (Multi-Shot, Snipe)
- **Compétences passives** : 3 choix (Peasant Endurance, Swiftness, Evasion)

### Aria (Commun 2★)
- **Armes disponibles** : 4 choix (Wooden Staff, Apprentice Tome, Mystic Wand, Crystal Staff)
- **Armures disponibles** : 3 choix (Cloth Armor, Wizard Robe, Archmage Robe)
- **Accessoires disponibles** : 3 choix (Magic Ring, Sage's Amulet, Magic Orb)
- **Compétences actives** : 2 choix (Fireball, Ice Lance)
- **Compétences passives** : 3 choix (Scholar Wisdom, Magic Mastery, Swiftness)

## 🎯 Gameplay

### Progression
Les joueurs devront faire des choix stratégiques :
- Quelle arme équiper selon l'ennemi ?
- Quelle compétence active utiliser ?
- Quelles 3 passives combiner pour un build optimal ?

### Déblocage
Les items et compétences se débloquent progressivement :
- Par niveau (ex: niveau 5, 10, 15...)
- Par rareté (ex: 3★, 4★, 5★)

### Variété
Chaque personnage a suffisamment d'options pour créer différents builds sans être submergé de choix.

## 💡 Avantages du Système

✅ **Choix significatifs** - Le joueur doit réfléchir à son équipement
✅ **Gestion simple** - Pas de surcharge de l'interface
✅ **Rejouabilité** - Plusieurs builds possibles par personnage
✅ **Progression claire** - Déblocage progressif de nouveaux items
✅ **Équilibré** - Pas trop d'options, pas trop peu

## 🔄 Changement de Build

Le joueur peut changer son équipement et ses compétences équipées à tout moment en accédant au menu du personnage, permettant de s'adapter à différentes situations de combat.

## 📝 Notes Techniques

### Dans le Code
- L'inventaire (`CharacterInventory`) contient tous les items **disponibles**
- Le personnage (`Character`) contient les items **équipés** :
  - `weapon: Equipment?`
  - `armor: Equipment?`
  - `accessory: Equipment?`
  - `equippedSkills: List<Skill>` (max 4 : 1 active + 3 passives)

### Validation
Il faudra ajouter de la validation pour s'assurer que :
- 1 seule compétence active est équipée
- Maximum 3 compétences passives sont équipées
- Les items équipés font partie de l'inventaire disponible
- Les items sont débloqués selon les conditions
