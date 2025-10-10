# Configuration de l'authentification Firebase

## � Versions des packages

- **firebase_core:** ^3.8.1
- **firebase_auth:** ^5.3.3
- **cloud_firestore:** ^5.5.2
- **google_sign_in:** ^6.2.2

> ⚠️ **Important** : firebase_auth ^5.3.3+ est requis pour éviter l'erreur `type 'List<Object?>' is not a subtype of type 'PigeonUserDetails?'`

---

## �📋 Méthodes d'authentification disponibles

1. **Connexion Anonyme** ✅ (temporaire - données perdues si app désinstallée)
2. **Connexion Email/Password** ✅ (compte permanent)
3. **Connexion Google** ✅ (compte permanent)

---

## 🔧 Configuration Firebase Console

### 1. Activer les méthodes d'authentification

1. Va sur [Firebase Console](https://console.firebase.google.com/)
2. Sélectionne ton projet : **`tactical-dice-bpro`**
3. Menu latéral → **Authentication**
4. Onglet **Sign-in method**
5. Active les providers suivants :

#### ✅ Anonymous (Anonyme)
- Clique sur **Anonymous**
- Active le provider
- Clique **Save**

#### ✅ Email/Password
- Clique sur **Email/Password**
- Active **Email/Password** (première option)
- *(Optionnel)* Active **Email link (passwordless sign-in)**
- Clique **Save**

#### ✅ Google
- Clique sur **Google**
- Active le provider
- Renseigne un **nom public du projet** (ex: "Dice Destiny")
- Renseigne une **adresse e-mail d'assistance du projet**
- Clique **Save**

---

## 📱 Configuration Android (pour Google Sign-In)

### 1. Obtenir l'empreinte SHA-1

```bash
cd android
./gradlew signingReport
```

Copie la clé **SHA-1** de `Variant: debug` et `Config: debug`.

Exemple de sortie :
```
Variant: debug
Config: debug
Store: ~/.android/debug.keystore
Alias: AndroidDebugKey
MD5: XX:XX:XX:...
SHA1: AA:BB:CC:DD:EE:FF:11:22:33:44:55:66:77:88:99:00:AA:BB:CC:DD
SHA-256: ...
```

### 2. Ajouter l'empreinte SHA-1 dans Firebase

1. Firebase Console → **Project Settings** (⚙️)
2. Onglet **General**
3. Scroll vers **Your apps** → Section **Android**
4. Clique sur ton app `com.example.dice_destiny_idle_rifts`
5. Scroll vers **SHA certificate fingerprints**
6. Clique **Add fingerprint**
7. Colle ton **SHA-1**
8. Clique **Save**

### 3. Télécharger le nouveau google-services.json

1. Dans Firebase Console → **Project Settings**
2. Scroll vers ton app Android
3. Clique **Download google-services.json**
4. Remplace le fichier existant :
   ```bash
   mv ~/Downloads/google-services.json android/app/
   ```

---

## 🍎 Configuration iOS (pour Google Sign-In)

### 1. Ajouter l'URL Scheme

Le fichier `ios/Runner/Info.plist` doit contenir :

```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <!-- Remplace par ton REVERSED_CLIENT_ID depuis GoogleService-Info.plist -->
            <string>com.googleusercontent.apps.YOUR-CLIENT-ID</string>
        </array>
    </dict>
</array>
```

### 2. Télécharger GoogleService-Info.plist

1. Firebase Console → **Project Settings**
2. Section **iOS**
3. Clique **Download GoogleService-Info.plist**
4. Place-le dans `ios/Runner/`

---

## 🌐 Configuration Web (pour Google Sign-In)

### 1. Ajouter le domaine autorisé

1. Firebase Console → **Authentication** → **Settings**
2. Onglet **Authorized domains**
3. Ajoute `localhost` (déjà présent par défaut)

### 2. Obtenir le Client ID Web

1. Firebase Console → **Project Settings**
2. Section **Web apps**
3. Copie le **Web client ID**

### 3. Mettre à jour web/index.html

Ajoute dans `<head>` :

```html
<meta name="google-signin-client_id" content="TON_WEB_CLIENT_ID.apps.googleusercontent.com">
```

---

## 🧪 Tester l'authentification

### 1. Nettoyer le cache et reconstruire

```bash
# Nettoyer le cache Flutter
flutter clean
flutter pub get

# Nettoyer le cache Gradle (Android)
cd android && ./gradlew clean && cd ..

# Rebuild l'application
flutter run
```

### 2. Vider le cache pour tester à nouveau

Si tu veux tester la connexion depuis zéro (effacer l'authentification et les données) :

**Sur un émulateur/appareil Android :**
```bash
# Méthode 1 : Désinstaller complètement l'app
adb uninstall com.example.dice_destiny_idle_rifts

# Méthode 2 : Vider uniquement les données de l'app
adb shell pm clear com.example.dice_destiny_idle_rifts

# Méthode 3 : Vider le cache Firebase Auth spécifiquement
flutter run --clear-cache
```

**Sur iOS :**
```bash
# Désinstaller l'app de l'émulateur
xcrun simctl uninstall booted com.example.diceDestinyIdleRifts

# Ou réinitialiser complètement l'émulateur
xcrun simctl erase all
```

### 3. Vérifier les logs

Lors de la connexion, tu devrais voir dans les logs :

**Connexion Anonyme :**
```
🔐 Connexion anonyme en cours...
✅ Connexion anonyme réussie: abc123xyz
```

**Connexion Email :**
```
📧 Connexion avec email: user@example.com
✅ Connexion email réussie: def456uvw
```

**Connexion Google :**
```
🔍 Connexion Google en cours...
📱 Utilisateur Google sélectionné: user@gmail.com
✅ Connexion Google réussie: ghi789rst
```

**En cas d'échec Google (fallback vers Anonyme) :**
```
⚠️ Connexion Google annulée ou échouée: Erreur...
🔄 Fallback vers connexion anonyme...
✅ Connexion anonyme réussie (fallback): xyz789abc
```

### 4. Vérifier dans Firebase Console

1. **Authentication** → Onglet **Users**
2. Tu devrais voir ton utilisateur avec :
   - **Provider** : Anonymous / Password / google.com
   - **UID** : L'identifiant unique
   - **Created** : Date de création

---

## 🔗 Lier un compte anonyme (upgrade vers compte permanent)

Si un utilisateur joue en mode anonyme et veut sauvegarder sa progression :

### Exemple d'implémentation dans AuthService :

```dart
// Lier avec Email/Password
Future<User?> linkAnonymousWithEmail(String email, String password) async {
  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && user.isAnonymous) {
      final credential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );
      final userCredential = await user.linkWithCredential(credential);
      print('✅ Compte anonyme lié avec email: ${userCredential.user?.email}');
      return userCredential.user;
    }
  } catch (e) {
    print('❌ Erreur lors du lien avec email: $e');
  }
  return null;
}

// Lier avec Google
Future<User?> linkAnonymousWithGoogle() async {
  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && user.isAnonymous) {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser != null) {
        final googleAuth = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        final userCredential = await user.linkWithCredential(credential);
        print('✅ Compte anonyme lié avec Google: ${userCredential.user?.email}');
        return userCredential.user;
      }
    }
  } catch (e) {
    print('❌ Erreur lors du lien avec Google: $e');
  }
  return null;
}
```

### Utilisation :

```dart
// Dans un widget ou écran
try {
  final linkedUser = await AuthService.linkAnonymousWithEmail(
    'user@example.com',
    'password123',
  );
  if (linkedUser != null) {
    // Compte lié avec succès !
    // Les données Firebase sont préservées sous le même UID
  }
} catch (e) {
  // Gérer l'erreur (ex: email déjà utilisé)
}
```

---

## 🚨 Erreurs courantes

### ❌ "type 'List<Object?>' is not a subtype of type 'PigeonUserDetails?'"
**Cause** : Incompatibilité de version entre `firebase_auth` et d'autres packages Firebase.
**Solution** : Utilise **firebase_auth ^5.3.3** ou supérieur. Mets à jour ton `pubspec.yaml` :
```yaml
dependencies:
  firebase_auth: ^5.3.3
  firebase_core: ^3.8.1
```
Puis exécute :
```bash
flutter clean
flutter pub get
```

### ❌ "operation-not-allowed"
**Cause** : La méthode d'authentification n'est pas activée dans Firebase Console.
**Solution** : Active Anonymous/Email/Google dans Authentication → Sign-in method.

### ❌ Google Sign-In échoue sur Android
**Cause** : SHA-1 manquant ou incorrect.
**Solution** : Vérifie que le SHA-1 est bien ajouté dans Firebase Console et que tu as téléchargé le nouveau `google-services.json`.

### ❌ "DEVELOPER_ERROR" (Google Sign-In)
**Cause** : Client ID OAuth incorrect ou manquant.
**Solution** : Recharge le `google-services.json` depuis Firebase Console.

### ❌ "email-already-in-use"
**Cause** : L'email est déjà utilisé par un autre compte.
**Solution** : Utilise la fonctionnalité "Mot de passe oublié" ou connecte-toi avec le compte existant.

### ❌ Permission denied sur Firestore
**Cause** : Les règles Firestore bloquent l'accès ou l'utilisateur n'est pas authentifié.
**Solution** : Vérifie que l'utilisateur est bien authentifié et que les règles Firestore permettent l'accès (voir section Règles Firestore ci-dessous).

---

## 📚 Règles Firestore recommandées

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Seul l'utilisateur authentifié peut accéder à ses propres données
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
      
      match /characters/{characterId} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
    }
  }
}
```

Ces règles garantissent que :
- ✅ Seuls les utilisateurs authentifiés peuvent lire/écrire leurs données
- ✅ Chaque utilisateur ne peut accéder qu'à son propre document (`/users/{userId}`)
- ✅ Les personnages sont protégés sous le profil utilisateur

Déploie avec :
```bash
firebase deploy --only firestore:rules
```

Ou modifie directement dans Firebase Console → **Firestore Database** → **Rules**.

---

## ✅ Checklist finale

- [x] Anonymous Auth activé dans Firebase Console ✅
- [x] Email/Password activé dans Firebase Console ✅
- [x] Google Sign-In activé dans Firebase Console ✅
- [x] SHA-1 ajouté pour Android ✅
- [x] `google-services.json` mis à jour ✅
- [ ] `GoogleService-Info.plist` téléchargé (iOS) - si tu développes pour iOS
- [x] Règles Firestore déployées ✅
- [x] Test de connexion Anonyme ✅
- [x] Test de connexion Email ✅
- [x] Test de connexion Google ✅
- [x] Fallback Anonyme en cas d'échec Google ✅
- [x] Persistence de l'authentification ✅

---

## 🎮 Utilisation dans l'app

### Flow complet :

1. **Lancement de l'app** → `WelcomeScreen`
   - Vérification automatique de l'authentification
   
2. **Si non authentifié** → `LoginDialog` apparaît
   - Options : **Anonyme**, **Email/Password**, **Google**
   
3. **Après connexion réussie** :
   - Vérification du profil utilisateur (Firestore)
   - **Nouveau joueur** → `CinematicScreen` (6 scènes) → `PersonaCreationScreen` → Jeu
   - **Joueur existant** → Accès direct au jeu avec ses personnages

4. **Mécanisme de fallback** :
   - Si Google Sign-In échoue (annulation, erreur) → Connexion anonyme automatique
   - Délais de synchronisation de 500ms après chaque authentification pour stabilité Firebase

### Architecture des services :

**`AuthService`** (`lib/src/services/auth_service.dart`) :
- `signInAnonymously()` : Connexion temporaire
- `signInWithEmail(email, password)` : Connexion par email
- `signUpWithEmail(email, password)` : Création de compte
- `signInWithGoogle()` : Connexion Google avec fallback
- `signOut()` : Déconnexion complète
- `currentUser` : Utilisateur Firebase actuel
- `currentUserId` : UID de l'utilisateur

**`GameDataService`** (`lib/src/services/game_data_service.dart`) :
- `hasProfile(userId)` : Vérifie l'existence du profil
- `createPlayer(userId, username)` : Crée le profil Firestore
- `createCharacter(userId, characterData)` : Sauvegarde le personnage
- `getPlayer(userId)` : Récupère les données du joueur
- `getCharacters(userId)` : Liste des personnages

---

## 🔗 Fonctionnalités supplémentaires (optionnelles)

### Lier un compte anonyme (upgrade vers compte permanent)

Si un utilisateur joue en mode anonyme et veut sauvegarder sa progression, tu peux implémenter :

```dart
// Dans AuthService
Future<User?> linkAnonymousWithEmail(String email, String password) async {
  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && user.isAnonymous) {
      final credential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );
      final userCredential = await user.linkWithCredential(credential);
      return userCredential.user;
    }
  } catch (e) {
    print('❌ Erreur lors du lien avec email: $e');
  }
  return null;
}

Future<User?> linkAnonymousWithGoogle() async {
  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && user.isAnonymous) {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser != null) {
        final googleAuth = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        final userCredential = await user.linkWithCredential(credential);
        return userCredential.user;
      }
    }
  } catch (e) {
    print('❌ Erreur lors du lien avec Google: $e');
  }
  return null;
}
```

---

**Note finale** : La connexion anonyme est pratique pour tester ou jouer sans contrainte, mais recommande aux joueurs de lier leur compte (Email ou Google) pour ne pas perdre leur progression en cas de désinstallation ! 🎲✨
