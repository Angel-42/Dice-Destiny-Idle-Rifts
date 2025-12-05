# 🎲 Système de Dés - Guide de Design

## 📋 Philosophie Générale

**Dice Destiny** est un jeu tactique où les dés doivent être **impactants et mémorables**, pas **omniprésents et frustrants**.

### Règle d'Or : **"Rare mais Décisif"**

Les dés doivent apparaître dans des **moments clés** où :
1. Le joueur **attend** le résultat (anticipation)
2. Le résultat a un **impact significatif** (stratégique)
3. L'animation est **gratifiante** (feedback visuel fort)
4. La stat **Luck** joue un rôle **mesurable** (pas du hasard pur)

---

## ✅ OÙ UTILISER LES DÉS (Liste Approuvée)

### 🎰 1. Gacha (Invocation de Personnages)
**Type de Dé** : D20  
**Fréquence** : Rare (1-3 fois par jour)  
**Impact** : 🔥🔥🔥 Critique  
**Animation** : 3-5 secondes, spectaculaire

**Justification** :
- C'est LE moment où l'aléatoire doit briller
- Le joueur s'attend à du suspense
- Peu fréquent donc pas répétitif
- Influence de Luck optionnelle (pity system)

**Implémentation** :
```dart
final roll = DiceService.roll(DiceType.d20);
if (roll.total >= 19) {
  rarity = CharacterRarity.legendary; // 10%
} else if (roll.total >= 15) {
  rarity = CharacterRarity.epic; // 20%
} else if (roll.total >= 8) {
  rarity = CharacterRarity.rare; // 35%
} else {
  rarity = CharacterRarity.common; // 35%
}
```

---

### 💎 2. Loot de Boss (Fin de Niveau)
**Type de Dé** : D12 + Luck  
**Fréquence** : Après chaque boss (1x par niveau)  
**Impact** : 🔥🔥 Élevé  
**Animation** : 2 secondes

**Justification** :
- Récompense l'accomplissement
- Justifie l'investissement en Luck
- Rare (fin de niveau uniquement)
- Crée de l'excitation post-victoire

**Implémentation** :
```dart
final roll = DiceService.roll(DiceType.d12, luckBonus: playerLuck);
if (roll.isCritical || roll.total >= 11) {
  return Equipment.legendary();
} else if (roll.total >= 9) {
  return Equipment.epic();
} else if (roll.total >= 6) {
  return Equipment.rare();
} else {
  return Equipment.common();
}
```

---

### ⚔️ 3. Critique d'Attaque
**Type de Dé** : % Calculé (pas de D20 visible à chaque coup)  
**Fréquence** : 5-15% des attaques  
**Impact** : 🔥 Moyen  
**Animation** : 1 seconde (uniquement si critique)

**Justification** :
- Apporte du suspense au combat
- Pas trop fréquent (5-15% avec Luck)
- Animation uniquement si succès (pas répétitif)
- Récompense les builds Luck

**Implémentation** :
```dart
bool isCriticalHit() {
  double critChance = 0.05; // 5% de base
  critChance += (totalLuck * 0.005); // +0.5% par point de Luck
  
  final roll = Random().nextInt(100);
  if (roll < (critChance * 100)) {
    // Afficher animation D20 uniquement maintenant
    showDiceAnimation(DiceType.d20, result: 20);
    return true;
  }
  return false;
}
```

---

### ⚡ 4. Début de Combat (Buff/Debuff Global)
**Type de Dé** : D6  
**Fréquence** : 1x par combat (pas par tour !)  
**Impact** : 🔥 Moyen  
**Animation** : 2 secondes au début uniquement

**Justification** :
- Un seul moment de suspense (pas répétitif)
- Influence tout le combat (stratégique)
- Court et efficace

**Implémentation** :
```dart
void startBattle() {
  final roll = DiceService.roll(DiceType.d6);
  
  if (roll.isCritical) {
    applyTeamBuff(1.25); // +25% stats pour TOUT le combat
  } else if (roll.isCriticalFailure) {
    applyTeamDebuff(0.9); // -10% stats
  } else if (roll.result >= 4) {
    applyTeamBuff(1.1); // +10% stats
  }
  // Sinon : neutre
}
```

---

### 📖 5. Événements Narratifs (Choix Scénarisés)
**Type de Dé** : D6 ou D12  
**Fréquence** : Occasionnel (campagne uniquement)  
**Impact** : ⭐ Faible à Moyen  
**Animation** : 2 secondes

**Justification** :
- Ajoute de la variété narrative
- Peu fréquent (événements spéciaux)
- Luck peut influencer le résultat
- Optionnel (pas core gameplay)

**Exemple** :
```dart
// Événement : "Vous trouvez un coffre mystérieux"
final roll = DiceService.roll(DiceType.d6, luckBonus: playerLuck);

if (roll.total >= 5) {
  giveReward(Equipment.rare());
  showMessage("Le coffre contenait un trésor !");
} else if (roll.total <= 2) {
  triggerTrap();
  showMessage("C'était un piège !");
} else {
  giveReward(gold: 50);
  showMessage("Vous trouvez quelques pièces d'or.");
}
```

---

## ❌ OÙ NE PAS UTILISER LES DÉS (Liste Interdite)

### 🚫 1. Début de CHAQUE Tour de Personnage
**Problème** : Trop fréquent, casse le flow  
**Solution** : 1 dé au début du combat (buff global)

**Pourquoi c'est mauvais** :
- ❌ Animation toutes les 10 secondes → répétitif
- ❌ Ralentit le combat → frustrant
- ❌ Trop d'aléatoire → perte de contrôle stratégique
- ❌ Le joueur arrête de regarder les animations

---

### 🚫 2. Esquive Systématique
**Problème** : Frustrant si trop aléatoire  
**Solution** : % fixe basé sur Speed

**Pourquoi c'est mauvais** :
- ❌ "J'ai raté 3 attaques d'affilée" → rage quit
- ❌ Pas stratégique, juste du RNG
- ❌ Speed devient inutile si c'est du hasard pur

**Alternative** :
```dart
// Esquive = % fixe, pas de dé
double dodgeChance = 0.05; // 5% de base
dodgeChance += (totalSpeed * 0.01); // +1% par point de Speed
```

---

### 🚫 3. Mouvement sur la Carte
**Problème** : Déplacement aléatoire = cauchemar UX  
**Solution** : Mouvement déterministe (stat fixe)

**Pourquoi c'est mauvais** :
- ❌ "Je voulais aller là mais le dé dit non" → frustration totale
- ❌ Impossible de planifier sa stratégie
- ❌ Fire Emblem ne le fait pas, donc nous non plus

**Alternative** :
```dart
// Mouvement = stat fixe de classe
final movement = character.stats.movement; // 4, 5 ou 6 cases fixes
```

---

### 🚫 4. Dégâts de Base (Variance Totale)
**Problème** : Trop d'aléatoire tue la stratégie  
**Solution** : Variance ±10% autour des dégâts calculés

**Pourquoi c'est mauvais** :
- ❌ "Je devais faire 100 dégâts, j'ai fait 30" → WTF
- ❌ Impossible de calculer si on peut tuer l'ennemi
- ❌ La stratégie devient inutile

**Alternative** :
```dart
// Variance légère, pas de dé visible
final baseDamage = calculateDamage(attacker, defender);
final variance = Random().nextDouble() * 0.2 - 0.1; // ±10%
final finalDamage = (baseDamage * (1 + variance)).round();
```

---

### 🚫 5. Actions Répétitives
**Problème** : Animation fatigue  
**Solution** : Réserver les dés aux moments clés

**Exemples d'actions à NE PAS diceifier** :
- ❌ Ramasser de l'or
- ❌ Ouvrir un coffre commun
- ❌ Marcher sur la carte
- ❌ Parler à un PNJ
- ❌ Sauvegarder

---

## 📊 Tableau de Décision Rapide

| Feature | Dé ? | Type | Fréquence | Impact | Priorité |
|---------|------|------|-----------|--------|----------|
| **Gacha** | ✅ | D20 | Rare | 🔥🔥🔥 | Très Haute |
| **Loot Boss** | ✅ | D12 + Luck | Fin de niveau | 🔥🔥 | Haute |
| **Critique** | ✅ | % + Luck | 5-15% | 🔥 | Haute |
| **Début Combat** | ✅ | D6 | 1x/combat | 🔥 | Moyenne |
| **Événements** | ⚠️ | D6/D12 | Rare | ⭐ | Basse |
| **Début Tour** | ❌ | - | - | - | **ÉVITER** |
| **Esquive** | ❌ | % fixe | - | - | **ÉVITER** |
| **Mouvement** | ❌ | Stat fixe | - | - | **ÉVITER** |
| **Dégâts Base** | ❌ | Variance | - | - | **ÉVITER** |

---

## 🎯 Checklist Avant d'Ajouter un Dé

Avant d'ajouter un lancer de dé, vérifie **TOUS** ces points :

- [ ] **Fréquence** : Est-ce que ça arrive moins de 5 fois par session ?
- [ ] **Impact** : Est-ce que le résultat change vraiment quelque chose ?
- [ ] **Animation** : Est-ce que l'animation dure moins de 3 secondes ?
- [ ] **Luck** : Est-ce que Luck influence le résultat ?
- [ ] **Frustration** : Est-ce que rater ne rend pas le joueur fou ?
- [ ] **Stratégie** : Est-ce que ça reste un bonus, pas le core gameplay ?
- [ ] **Alternative** : Est-ce qu'un % fixe ne serait pas mieux ?

**Si tu as coché moins de 5 cases → N'utilise PAS de dé**

---

## 🚀 Phases d'Implémentation

### Phase 1 : Essentiels (MVP)
```
✅ Gacha avec animation D20 spectaculaire
✅ Critique d'attaque (% calculé, animation si succès)
```

### Phase 2 : Combat
```
✅ Dé de bataille unique (début de combat)
✅ Loot de boss (D12 + Luck)
```

### Phase 3 : Polish
```
⚠️ Événements narratifs (optionnel)
⚠️ Buffs spéciaux (si besoin)
```

---

## 💡 Exemples de Référence

### ✅ Bons Exemples (Jeux qui le font bien)
- **Fire Emblem** : % d'attaque/critique fixes, pas de dé visible
- **Darkest Dungeon** : Dés pour critiques uniquement
- **Hearthstone** : Aléatoire sur cartes spéciales, pas core gameplay
- **Slay the Spire** : Dés pour reliques, pas pour attaques

### ❌ Mauvais Exemples (À éviter)
- **Mario Party** : Dé pour TOUT → frustrant
- **Monopoly** : Mouvement 100% dé → pas stratégique
- **Certains gatcha** : Trop de RNG → pay-to-win ressenti

---

## 🎲 Règles de Conception Finale

### DO ✅
1. **Rare** : Moins c'est utilisé, plus c'est impactant
2. **Visible** : Animation claire et satisfaisante
3. **Influençable** : Luck ou stratégie peut améliorer les chances
4. **Optionnel** : Le dé améliore l'expérience, ne la remplace pas
5. **Gratifiant** : Même un mauvais résultat doit être acceptable

### DON'T ❌
1. **Répétitif** : Jamais plus de 1x par minute
2. **Core Gameplay** : Le jeu doit fonctionner sans les dés
3. **Frustrant** : Rater ne doit pas bloquer la progression
4. **Invisible** : Si le dé ne s'affiche pas, c'est juste du RNG caché
5. **Inutile** : Si Luck n'influence pas, pourquoi un dé ?

---

## 📈 Métriques de Succès

Un bon système de dés doit :
- ✅ **Excitation** : Le joueur sourit quand le dé apparaît
- ✅ **Anticipation** : Le joueur attend le résultat avec suspense
- ✅ **Acceptation** : Un mauvais résultat est décevant mais pas ragequit
- ✅ **Stratégie** : Le joueur peut optimiser ses chances (Luck, équipement)
- ✅ **Rareté** : Le joueur ne se lasse jamais de l'animation

---

## 🔄 Exemples de Refactoring

### ❌ Avant (Mauvais)
```dart
// Dé à chaque tour
void startTurn(Character character) {
  final roll = DiceService.roll(DiceType.d6);
  if (roll.result == 1) {
    character.skipTurn(); // Frustrant !
  }
}
```

### ✅ Après (Bon)
```dart
// Dé au début du combat uniquement
void startBattle() {
  final roll = DiceService.roll(DiceType.d6);
  if (roll.isCritical) {
    applyTeamBuff(1.25); // Gratifiant !
  }
}
```

---

## 📝 Notes pour Développeurs

### Quand tu veux ajouter un dé, demande-toi :
1. **"Est-ce que Fire Emblem le ferait ?"**  
   → Si non, c'est probablement une mauvaise idée

2. **"Est-ce que le joueur verra cette animation 100 fois par jour ?"**  
   → Si oui, n'utilise PAS de dé

3. **"Est-ce que rater ce dé va énerver le joueur ?"**  
   → Si oui, utilise un % fixe ou un système de pity

4. **"Est-ce que Luck change vraiment quelque chose ici ?"**  
   → Si non, c'est juste du RNG déguisé

---

## 🎯 Conclusion

**Le système de dés de Dice Destiny doit être :**
- 🎲 **Thématique** : Les dés sont au cœur de l'identité du jeu
- ⚡ **Impactant** : Chaque lancer compte vraiment
- 🎨 **Spectaculaire** : Animations soignées et satisfaisantes
- 🧠 **Stratégique** : Luck influence les résultats de manière claire
- 😊 **Agréable** : Jamais frustrant, toujours excitant

**Nombre de lancers par session idéal : 3-7**
- 1-2 gacha (si le joueur invoque)
- 1-2 critiques (si combat)
- 1 début de combat
- 0-2 loot de boss

**Si tu dépasses 10 lancers de dés par session, c'est trop.**

---

*Dernière mise à jour : 4 décembre 2025*  
*Auteur : Angel-42*  
*Référence : docs/DICE_SYSTEM.md*
