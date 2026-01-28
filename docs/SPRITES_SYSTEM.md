# 🎨 Système de Sprites pour Skills et Equipment

## 📋 Vue d'ensemble

Les `Skill` et `Equipment` supportent maintenant des **sprites** (images PNG) en plus des emojis, comme pour les personnages.

## 🔧 Fonctionnement

### Modèles mis à jour

#### `Skill`
```dart
const Skill(
  id: 'fireball',
  name: 'Fireball',
  emoji: '🔥',                               // Emoji de fallback
  sprite: 'assets/skills/mage/fireball.png', // Sprite optionnel
  description: 'Lance une boule de feu',
  type: SkillType.active,
  statBonuses: {'damageMultiplier': 0.60},
)
```

#### `Equipment`
```dart
const Equipment(
  id: 'excalibur',
  name: 'Excalibur',
  emoji: '⚔️',                                // Emoji de fallback
  sprite: 'assets/weapons/swords/excalibur.png', // Sprite optionnel
  type: EquipmentType.weapon,
  rarity: EquipmentRarity.legendary,
  bonuses: {'attack': 25},
)
```

### Propriétés ajoutées

- `sprite?: String` - Chemin optionnel vers l'image PNG
- `displayIcon: String` - Getter qui retourne `sprite ?? emoji`
- `hasSprite: bool` - Getter qui vérifie si un sprite existe

## 🎯 Utilisation dans l'UI

### Avec le widget `IconDisplay`

```dart
import '../widgets/icon_display.dart';

// Affiche automatiquement le sprite si disponible, sinon l'emoji
IconDisplay(
  icon: skill.displayIcon,
  size: 48,
)

// Ou pour un équipement
IconDisplay(
  icon: weapon.displayIcon,
  size: 64,
)
```

### Exemple complet

```dart
// Dans un widget d'affichage de compétence
Card(
  child: Row(
    children: [
      IconDisplay(
        icon: skill.displayIcon,
        size: 48,
      ),
      const SizedBox(width: 8),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(skill.name),
          Text(skill.description),
        ],
      ),
    ],
  ),
)
```

## 📁 Structure des Assets

```
assets/
  skills/
    warrior/
      power_strike.png
      whirlwind.png
      berserk.png
      shield_bash.png
    mage/
      fireball.png
      ice_lance.png
      lightning.png
      meteor.png
    rogue/
      backstab.png
      multi_shot.png
      snipe.png
    cleric/
      heal.png
      mass_heal.png
      bless.png
    general/
      critical_hit.png
      evasion.png
      regeneration.png
    race/
      elven_grace.png
      dwarven_resilience.png
      orcish_fury.png
    origin/
      noble_leadership.png
      merchant_luck.png
      peasant_endurance.png
      scholar_wisdom.png
    ultimate/
      apocalypse.png
      divine_intervention.png
      time_stop.png
      
  weapons/
    swords/
      iron_sword.png
      steel_sword.png
      excalibur.png
    axes/
      battle_axe.png
      great_axe.png
    bows/
      hunting_bow.png
      longbow.png
    staffs/
      wooden_staff.png
      archmage_staff.png
    daggers/
      iron_dagger.png
      shadow_dagger.png
    spears/
      iron_spear.png
      lance.png
    rods/
      healing_rod.png
      holy_rod.png
    books/
      apprentice_tome.png
      arcane_grimoire.png
    special/
      falchion.png
      dragon_slayer.png
```

## 🎨 Convention de Nommage

- **Nom du fichier** = `{id}.png`
- **Taille recommandée** : 64x64px ou 128x128px
- **Format** : PNG avec transparence
- **Style** : Cohérent avec le style pixel-art du jeu

## ✅ Checklist d'Ajout

Pour ajouter un sprite à une skill/équipement :

1. ✅ Créer l'image PNG (64x64px)
2. ✅ Placer dans le bon dossier (`assets/skills/{category}/` ou `assets/weapons/{type}/`)
3. ✅ Nommer le fichier selon l'ID (ex: `power_strike.png`)
4. ✅ Ajouter le paramètre `sprite` dans la database :
   ```dart
   sprite: 'assets/skills/warrior/power_strike.png',
   ```
5. ✅ Vérifier que le sprite s'affiche correctement dans l'UI

## 🔄 Fallback Automatique

Si le sprite n'existe pas ou ne peut pas être chargé :
- Le widget `IconDisplay` affiche automatiquement **l'emoji de fallback** (❓ si emoji manquant)
- Aucune erreur ne casse l'app
- Tu peux développer avec des emojis et ajouter les sprites progressivement

## 📝 Migration Progressive

Tu peux :
1. **Garder les emojis** pour les skills/équipements sans sprite
2. **Ajouter les sprites progressivement** selon tes priorités
3. **Mélanger** : certaines skills avec sprites, d'autres avec emojis

Exemple :
```dart
// Avec sprite (prioritaire)
static const Skill fireball = Skill(
  emoji: '🔥',
  sprite: 'assets/skills/mage/fireball.png', // Utilisé en priorité
  ...
);

// Sans sprite (fallback sur emoji)
static const Skill timeStop = Skill(
  emoji: '⏱️', // Utilisé comme icône
  ...
);
```

## 🎮 Exemple d'Utilisation dans les Screens

### `CharactersScreen` - Affichage des skills équipées
```dart
// Avant (emoji only)
Text(skill.emoji, style: TextStyle(fontSize: 24))

// Après (sprite ou emoji)
IconDisplay(icon: skill.displayIcon, size: 32)
```

### `ShopScreen` - Affichage des armes à vendre
```dart
// Avant
Text(weapon.emoji, style: TextStyle(fontSize: 32))

// Après
IconDisplay(icon: weapon.displayIcon, size: 48)
```

### `BattleScreen` - Affichage des compétences actives
```dart
// Avant
CircleAvatar(child: Text(skill.emoji))

// Après
CircleAvatar(
  child: IconDisplay(icon: skill.displayIcon, size: 24),
)
```

## 🚀 Avantages

✅ **Flexibilité** : Emoji ou sprite au choix  
✅ **Fallback automatique** : Pas de crash si sprite manquant  
✅ **Cohérence visuelle** : Même système que les personnages  
✅ **Migration progressive** : Pas besoin de tout faire d'un coup  
✅ **Performance** : Images chargées depuis les assets (cache Flutter)  

## 🎨 Ressources pour Créer des Sprites

- [Itch.io - Game Assets](https://itch.io/game-assets/free)
- [OpenGameArt](https://opengameart.org/)
- [Kenney Assets](https://kenney.nl/assets)
- [Piskel](https://www.piskelapp.com/) - Éditeur pixel-art en ligne
