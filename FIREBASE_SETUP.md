# 🔥 Configuration Firebase pour Dice Destiny: Idle Rifts

## Étapes de configuration Firebase

### 1. Créer un projet Firebase

1. Allez sur [Firebase Console](https://console.firebase.google.com/)
2. Cliquez sur **"Ajouter un projet"**
3. Nommez votre projet : `Dice-Destiny-Idle-Rifts`
4. Acceptez les conditions et créez le projet

### 2. Activer Firebase Authentication

1. Dans la console Firebase, allez dans **Build → Authentication**
2. Cliquez sur **"Commencer"**
3. Dans l'onglet **"Sign-in method"**, activez :
   - ✅ **Anonymous** (authentification anonyme pour les joueurs sans compte)
4. Cliquez sur **Activer** puis **Enregistrer**

### 3. Activer Cloud Firestore

1. Dans la console Firebase, allez dans **Build → Firestore Database**
2. Cliquez sur **"Créer une base de données"**
3. Choisissez **"Démarrer en mode test"** (pour le développement)
4. Sélectionnez une région (par exemple: `europe-west1`)
5. Cliquez sur **Activer**

### 4. Configurer les règles de sécurité Firestore

1. Dans Firestore Database, allez dans l'onglet **"Règles"**
2. Remplacez les règles par :

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Chaque utilisateur peut uniquement lire/écrire ses propres données
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

3. Cliquez sur **Publier**

### 5. Ajouter Firebase à votre application Android

1. Dans la console Firebase, cliquez sur l'icône **Android** (⚙️ → Paramètres du projet → Ajouter une application)
2. Entrez le nom du package Android : `com.example.dice_destiny_idle_rifts`
3. Téléchargez le fichier `google-services.json`
4. Placez-le dans : `android/app/google-services.json`
5. Le fichier devrait déjà être configuré dans `android/build.gradle` et `android/app/build.gradle`

### 6. Ajouter Firebase à votre application iOS (optionnel)

1. Dans la console Firebase, cliquez sur l'icône **iOS**
2. Entrez le Bundle ID : `com.example.diceDestinyIdleRifts`
3. Téléchargez le fichier `GoogleService-Info.plist`
4. Placez-le dans : `ios/Runner/GoogleService-Info.plist`

### 7. Ajouter Firebase au Web (optionnel)

1. Dans la console Firebase, cliquez sur l'icône **Web**
2. Copiez la configuration Firebase
3. Mettez à jour `lib/firebase_options.dart` avec les nouvelles valeurs

## Structure de la base de données Firestore

Votre base de données aura cette structure :

```
users (collection)
  └── {userId} (document - UID Firebase Auth)
      ├── activeCharacter: {
      │     id: "string",
      │     name: "string",
      │     persona: {...},
      │     stats: {...},
      │     appearance: {...},
      │     level: number,
      │     currentHp: number
      │   }
      ├── characters: [
      │     {...}, {...}  // Liste de tous les personnages
      │   ]
      └── lastUpdated: timestamp
```

## Fonctionnalités Firebase implémentées

### ✅ Authentification Anonyme
- Les joueurs peuvent commencer sans créer de compte
- Un UID unique est généré automatiquement
- Possibilité d'ajouter d'autres méthodes d'authentification plus tard (Google, Email, etc.)

### ✅ Cloud Firestore
- **Sauvegarde cloud** : Les données sont synchronisées automatiquement
- **Multi-appareils** : Accédez à votre progression depuis n'importe quel appareil
- **Temps réel** : Possibilité d'ajouter des mises à jour en temps réel
- **Hors ligne** : Firestore met en cache les données localement

### ✅ Fonctions du service

Le `FirebaseCharacterService` propose :

| Fonction | Description |
|----------|-------------|
| `ensureAuthenticated()` | Authentifie l'utilisateur de manière anonyme |
| `hasCharacters()` | Vérifie si l'utilisateur a des personnages |
| `getActiveCharacter()` | Récupère le personnage actif |
| `saveActiveCharacter()` | Sauvegarde le personnage actif |
| `getAllCharacters()` | Récupère tous les personnages |
| `saveCharacters()` | Sauvegarde tous les personnages |
| `createCharacter()` | Crée un nouveau personnage |
| `deleteCharacter()` | Supprime un personnage |
| `resetAll()` | Réinitialise toutes les données |
| `deleteAccount()` | Supprime le compte et les données |
| `watchActiveCharacter()` | Stream temps réel du personnage actif |

## Tester localement

```bash
# Installer les dépendances
flutter pub get

# Lancer l'application
flutter run

# Les logs Firebase apparaîtront dans la console :
# 🔐 Authentification anonyme en cours...
# ✅ Authentification réussie: abc123...
# 💾 Sauvegarde du personnage: Héros123
# ✅ Personnage sauvegardé avec succès
```

## Vérifier les données dans Firebase

1. Allez dans **Firebase Console → Firestore Database**
2. Vous verrez la collection `users`
3. Cliquez sur un document utilisateur pour voir :
   - `activeCharacter` : Le personnage actif
   - `characters` : La liste de tous les personnages
   - `lastUpdated` : Timestamp de dernière modification

## Limites du plan gratuit Firebase

| Service | Limite gratuite |
|---------|----------------|
| **Authentication** | Illimité |
| **Firestore** | 50K lectures/jour, 20K écritures/jour, 1 Go stockage |
| **Fonctions Cloud** | 125K invocations/mois |

Pour un jeu en développement, c'est largement suffisant ! 🎮

## Passer en production

Avant de publier votre jeu :

1. **Changez les règles Firestore** en mode production :
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      // Plus restrictif
      allow read, write: if request.auth != null 
                         && request.auth.uid == userId
                         && request.time < timestamp.date(2026, 1, 1); // Expiration
    }
  }
}
```

2. **Activez des méthodes d'authentification supplémentaires** :
   - Google Sign-In
   - Email/Password
   - Facebook, Apple, etc.

3. **Surveillez l'utilisation** :
   - Allez dans **Firebase Console → Usage**
   - Configurez des alertes de quota

4. **Passez à un plan payant si nécessaire** :
   - Plan Blaze : Pay-as-you-go
   - Vous payez uniquement ce que vous utilisez au-delà des limites gratuites

## Avantages de Firebase vs Local Storage

| Critère | Firebase | SharedPreferences |
|---------|----------|-------------------|
| Sauvegarde cloud | ✅ Oui | ❌ Non |
| Multi-appareils | ✅ Oui | ❌ Non |
| Sécurisé | ✅ Règles serveur | ⚠️ Client-side |
| Temps réel | ✅ Oui | ❌ Non |
| Gratuit | ✅ Plan généreux | ✅ Totalement |
| Hors ligne | ✅ Cache local | ✅ Oui |

## Support

Pour toute question sur Firebase :
- [Documentation Firebase](https://firebase.google.com/docs)
- [FlutterFire Documentation](https://firebase.flutter.dev/)
- [Stack Overflow](https://stackoverflow.com/questions/tagged/firebase)

---

**✨ Votre jeu utilise maintenant Firebase !** Les données des joueurs sont sauvegardées dans le cloud et synchronisées automatiquement. 🚀
