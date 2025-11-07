# 🎯 Système de Slots de Compétences

## Vue d'ensemble

Chaque personnage dispose de **4 slots de compétences** avec des règles strictes pour garantir l'équilibre du jeu.

## 📋 Structure des Slots

```
┌─────────────────────────────────────┐
│ Slot 1: Active Skill (⚡)           │  ← Compétences ACTIVES uniquement
├─────────────────────────────────────┤
│ Slot 2: Passive Skill (🔰)          │  ← Compétences PASSIVES uniquement
├─────────────────────────────────────┤
│ Slot 3: Passive Skill (🔰)          │  ← Compétences PASSIVES uniquement
├─────────────────────────────────────┤
│ Slot 4: Passive Skill (🔰)          │  ← Compétences PASSIVES uniquement
└─────────────────────────────────────┘
```

## 🔒 Règles d'Équipement

### 1. Restriction par Type
- **Slot 1** : Accepte UNIQUEMENT les compétences de type `SkillType.active`
- **Slots 2-4** : Acceptent UNIQUEMENT les compétences de type `SkillType.passive`

### 2. Pas de Doublons
- ❌ **Impossible d'équiper deux fois la même compétence** sur un personnage
- ✅ Chaque compétence équipée doit être unique (vérification par `skill.id`)
- ⚠️ Les compétences déjà équipées apparaissent grisées avec le message "⚠️ Déjà équipé"

### 3. Gestion des Slots Vides
- Retirer une compétence d'un slot ne décale pas les autres compétences
- Le slot devient vide (placeholder avec `id: 'empty_X'`)
- L'affichage montre :
  - Slot 1 vide : "⚡ Active"
  - Slots 2-4 vides : "🔰 Passive X"

### 4. Inventaire Personnalisé
- Chaque personnage preset a son propre `customInventory`
- Les compétences équipées par défaut proviennent de cet inventaire
- Les compétences génériques ne sont plus utilisées

## 💡 Comportement Utilisateur

### Équiper une Compétence
1. Cliquer sur un slot de compétence
2. Le dialogue affiche **uniquement les compétences du bon type** :
   - Slot 1 → Actives uniquement
   - Slots 2-4 → Passives uniquement
3. Les compétences déjà équipées ailleurs sont **grisées et non cliquables**
4. Les compétences verrouillées affichent "🔒 [Condition]"

### Retirer une Compétence
1. Cliquer sur un slot équipé
2. Sélectionner "❌ Aucun" en haut de la liste
3. Le slot devient vide mais **ne décale pas les autres**

### Remplacer une Compétence
1. Cliquer sur un slot équipé
2. Choisir une nouvelle compétence dans la liste
3. La nouvelle compétence remplace directement l'ancienne

## 🎮 Exemples

### ✅ Configuration Valide
```
Slot 1: ⚡ Power Strike (Active)
Slot 2: 🔰 Iron Skin (Passive)
Slot 3: 🔰 Critical Hit (Passive)
Slot 4: 🔰 Swiftness (Passive)
```

### ❌ Configuration Invalide (Impossible)
```
Slot 1: 🔰 Iron Skin (Passive)     ← Erreur : Passive dans slot Active
Slot 2: ⚡ Power Strike (Active)   ← Erreur : Active dans slot Passive
Slot 3: 🔰 Iron Skin (Passive)     ← Erreur : Doublon (déjà en Slot 1)
Slot 4: 🔰 Critical Hit (Passive)
```

## 🔧 Implémentation Technique

### Vérification des Doublons
```dart
final alreadyEquippedIds = <String>{};
for (int i = 0; i < character.equippedSkills.length; i++) {
  if (i != skillSlotIndex) {
    final skill = character.equippedSkills[i];
    if (!skill.id.startsWith('empty_')) {
      alreadyEquippedIds.add(skill.id);
    }
  }
}
```

### Filtrage par Type
```dart
final requiredType = skillSlotIndex == 0 ? SkillType.active : SkillType.passive;
final allSkills = character.inventory.getAllSkills()
    .where((item) => item.item.type == requiredType)
    .toList();
```

### Gestion des Slots Vides
```dart
if (selectedSkill == null) {
  // Créer un placeholder au lieu de supprimer
  character.equippedSkills[index] = Skill(
    id: 'empty_$index',
    name: '-',
    emoji: '🔰',
    description: 'Slot vide',
    type: index == 0 ? SkillType.active : SkillType.passive,
  );
}
```

### Équipement par Défaut depuis Inventaire
```dart
// Dans PresetCharacter.toCharacter()
List<Skill>? startingSkills;
if (customInventory != null) {
  final allSkills = customInventory!.getAllSkills();
  
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
  
  startingSkills = [
    if (activeSkills.isNotEmpty) activeSkills.first,
    ...passiveSkills.take(3),
  ];
}
```

## 🔄 Migration des Données

Pour mettre à jour les personnages existants, utilisez :

```dart
await DataMigrationService.migrateCharacterSkills();
```

Cette migration :
1. Vérifie si les compétences équipées sont dans l'inventaire du personnage
2. Si non, remplace par les compétences par défaut de l'inventaire custom
3. Garantit que chaque personnage a des compétences cohérentes avec son inventaire

## 🎯 Avantages du Système

1. **Équilibre** : Empêche les builds trop puissants (pas de stack du même skill)
2. **Clarté** : Séparation claire entre compétences actives et passives
3. **Stabilité** : Les slots ne se décalent pas, préservant l'ordre choisi
4. **Cohérence** : Chaque personnage n'utilise que ses propres compétences
5. **Flexibilité** : Possibilité de laisser des slots vides si besoin

## 📊 Stats Affichées

Dans l'écran de détail du personnage, seules les **vraies compétences** sont prises en compte :
- Les skills avec `id.startsWith('empty_')` sont ignorées
- Affichage : ⚡ pour slot active vide, 🔰 pour slots passives vides
