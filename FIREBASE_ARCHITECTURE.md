# 🎮 Architecture Firebase - Dice Destiny: Idle Rifts

## 📊 Structure Firestore

```
users (collection)
  └── {userId} (document) ← Profil du joueur (Player)
      ├── userId: string
      ├── displayName: string
      ├── accountLevel: number
      ├── accountXP: number
      │
      ├── gold: number 💰
      ├── gems: number 💎
      ├── summonTokens: number 🎟️
      │
      ├── storyChapter: number
      ├── arenaRank: number
      ├── highestRiftFloor: number
      │
      ├── lastDailyReward: timestamp
      ├── loginStreak: number
      │
      ├── soundEnabled: boolean
      ├── musicEnabled: boolean
      ├── masterVolume: number
      ├── notificationsEnabled: boolean
      │
      ├── createdAt: timestamp
      ├── lastLogin: timestamp
      │
      └── characters (sous-collection) ⭐
          └── {characterId} (document)
              ├── id: string
              ├── name: string
              ├── level: number
              ├── xp: number
              │
              ├── persona: map
              │   ├── race: string
              │   ├── region: string
              │   ├── origin: string
              │   └── class: string
              │
              ├── stats: map
              │   ├── maxHp: number
              │   ├── attack: number
              │   ├── defense: number
              │   ├── speed: number
              │   ├── magic: number
              │   └── luck: number
              │
              ├── appearance: map
              │   ├── emoji: string
              │   └── colorValue: number
              │
              ├── equipment: map
              │   ├── weaponId: string (nullable)
              │   ├── armorId: string (nullable)
              │   └── accessoryId: string (nullable)
              │
              ├── unlockedSkills: array<string>
              ├── rarity: string (common, rare, epic, legendary)
              │
              ├── isInTeam: boolean
              ├── teamPosition: number (0 = non dans l'équipe, 1-3 = position)
              │
              ├── x: number (position sur la carte)
              ├── y: number (position sur la carte)
              ├── currentHp: number
              │
              └── obtainedAt: timestamp
```

## 🔑 Concepts Clés

### **Player** (Compte Joueur)
- **Un seul par utilisateur**
- Contient toutes les données du compte :
  - Progression globale (niveau de compte, XP)
  - Ressources (or, gemmes, jetons d'invocation)
  - Progression dans les modes de jeu
  - Préférences et paramètres

### **Characters** (Personnages Jouables)
- **Plusieurs par joueur** (via Gacha)
- Chaque personnage est indépendant :
  - Son propre niveau et XP
  - Ses propres stats
  - Son équipement
  - Sa rareté (Common/Rare/Epic/Legendary)

### **Team** (Équipe)
- **Maximum 3 personnages** actifs
- Identifiés par `isInTeam` et `teamPosition`
- Position 1 = Personnage principal

## 🎯 Cas d'Usage

### 1. Nouveau Joueur

```dart
// 1. Créer le profil joueur
await GameDataService.createPlayer("Kaeltheron");

// 2. Créer le premier personnage
final character = Character(
  name: "Aiden",
  persona: Persona(...),
  stats: CharacterStats(...),
  appearance: CharacterAppearance(...),
  isInTeam: true,      // Premier personnage → équipe
  teamPosition: 1,      // Position principale
);
await GameDataService.createCharacter(character);
```

### 2. Gagner de l'Or

```dart
// Ajouter 100 or au joueur
await GameDataService.updatePlayerCurrency(gold: 100);
```

### 3. Invoquer un Personnage (Gacha)

```dart
// 1. Vérifier les jetons
final player = await GameDataService.getPlayer();
if (player.summonTokens >= 10) {
  // 2. Générer personnage aléatoire
  final newChar = generateRandomCharacter(); // Votre logique
  
  // 3. Créer le personnage
  await GameDataService.createCharacter(newChar);
  
  // 4. Déduire les jetons
  await GameDataService.updatePlayerCurrency(summonTokens: -10);
}
```

### 4. Changer l'Équipe

```dart
// Mettre 3 personnages spécifiques dans l'équipe
await GameDataService.updateTeam([
  "characterId1",  // Position 1 (principal)
  "characterId2",  // Position 2
  "characterId3",  // Position 3
]);
```

### 5. Monter de Niveau un Personnage

```dart
// 1. Récupérer le personnage
final character = await GameDataService.getCharacter("characterId");

// 2. Ajouter de l'XP (gère automatiquement les level-ups)
character.addXP(100);

// 3. Sauvegarder
await GameDataService.saveCharacter(character);
```

### 6. Récompense Quotidienne

```dart
final player = await GameDataService.getPlayer();

if (player.canClaimDailyReward()) {
  player.claimDailyReward();
  await GameDataService.savePlayer(player);
  
  // Les ressources sont déjà ajoutées dans claimDailyReward()
  // Afficher notification au joueur
}
```

## 🔐 Règles de Sécurité Firestore

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Chaque utilisateur peut uniquement accéder à ses propres données
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
      
      // Sous-collection characters
      match /characters/{characterId} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
    }
  }
}
```

## 📱 Configuration Firebase Console

### 1. Firestore Database
1. Console Firebase → **Build** → **Firestore Database**
2. **Create database** → **Start in test mode** (développement)
3. Appliquer les règles de sécurité ci-dessus

### 2. Authentication
1. Console Firebase → **Build** → **Authentication**
2. **Get started**
3. Activer **Anonymous** dans **Sign-in method**

### 3. Index Composites (si nécessaire)

Si vous filtrez/triez simultanément :
```
Collection: users/{userId}/characters
Fields: isInTeam (Ascending), teamPosition (Ascending)
```

La console vous demandera automatiquement de créer l'index si besoin.

## 🚀 Migration depuis l'Ancienne Architecture

Si vous aviez `activeCharacter` et `characters` au niveau racine du document utilisateur :

```dart
Future<void> migrateToNewStructure() async {
  // Récupérer l'ancien format
  final doc = await _currentUserDoc?.get();
  final data = doc?.data() as Map<String, dynamic>?;
  
  if (data == null) return;
  
  // Créer le profil Player
  final player = Player(
    userId: currentUserId!,
    displayName: data['activeCharacter']?['name'] ?? 'Joueur',
    gold: 100,
    gems: 50,
  );
  await GameDataService.savePlayer(player);
  
  // Migrer les personnages vers la sous-collection
  final oldChars = data['characters'] as List?;
  if (oldChars != null) {
    for (final charJson in oldChars) {
      final char = Character.fromJson(charJson);
      await GameDataService.createCharacter(char);
    }
  }
  
  // Nettoyer les anciens champs
  await _currentUserDoc?.update({
    'activeCharacter': FieldValue.delete(),
    'characters': FieldValue.delete(),
  });
}
```

## 📈 Avantages de cette Architecture

✅ **Séparation claire** : Compte VS Personnages  
✅ **Scalabilité** : Sous-collections illimitées  
✅ **Performance** : Requêtes ciblées (ex: uniquement l'équipe)  
✅ **Flexibilité** : Ajout facile de nouvelles features  
✅ **Sécurité** : Règles Firestore granulaires  
✅ **Temps réel** : Streams pour sync automatique  

## 🎮 Prochaines Étapes

1. ✅ Créer les modèles `Player` et mettre à jour `Character`
2. ✅ Créer `GameDataService` avec la nouvelle structure
3. ⏳ Mettre à jour tous les écrans pour utiliser le nouveau service
4. ⏳ Implémenter le système Gacha complet
5. ⏳ Créer le système d'inventaire et d'équipement
6. ⏳ Ajouter les quêtes et progression de l'histoire

---

**Note**: Cette architecture est conçue pour évoluer. Vous pouvez facilement ajouter :
- Sous-collection `inventory` pour les items
- Sous-collection `quests` pour les missions
- Sous-collection `friends` pour le social
- etc.
