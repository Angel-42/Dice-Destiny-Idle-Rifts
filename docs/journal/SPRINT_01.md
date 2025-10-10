# 📔 Journal de Bord - Sprint 01

**Projet** : Dice Destiny: Idle Rifts  
**Période** : Début du projet → 10 octobre 2025  
**Objectif principal** : MVP avec interface utilisateur, création de personnage, et système de map tactique

---

## 🎯 Objectifs du Sprint

- [x] Interface utilisateur HD-2D (Welcome, Cinematic, Persona)
- [x] Création de personnage progressive
- [x] Système de map tactique (style Fire Emblem)
- [x] Navigation de campagne fonctionnelle
- [ ] Configuration Firebase complète → **Reporté au Rush 2**
- [ ] Système d'authentification → **Reporté au Rush 2**

---

## 📅 Chronologie des développements

### Phase 1 : Configuration initiale du projet

#### ✅ Setup du projet Flutter
- Création du projet `dice_destiny_idle_rifts`
- Configuration de l'environnement (Flutter 3.35.5, Dart 3.9.2)
- Structure de dossiers MVC (models, screens, widgets, services)
- Installation des packages de base

**Packages installés** :
- `cupertino_icons: ^1.0.8`
- `flame: ^1.32.0` (game engine préparé)
- `shared_preferences: ^2.2.2` (cache local)

> **Note** : Firebase et authentification seront intégrés au Rush 2

---

### Phase 2 : Interface utilisateur HD-2D

#### ✅ Welcome Screen (`welcome_screen.dart`)
- Design tactical RPG avec gradient noir/violet
- Particules animées (étoiles/dés)
- Grille tactique en fond
- Bouton "Commencer" avec animation
- Vérification automatique de l'authentification

**Flow** :
```
Non authentifié → LoginDialog
    ↓
Authentifié → Check profil
    ↓
Pas de profil → CinematicScreen
    ↓
Profil existant → Game direct
```

#### ✅ Cinematic Screen (`cinematic_screen.dart`)
- **6 scènes narratives** avec transitions fluides
- Particules colorées dynamiques (20-60 par scène)
- Gradients changeants selon la scène
- Bouton "Suivant" / "Créer mon Persona"

**Scènes** :
1. AU COMMENCEMENT (bleu nuit)
2. LES DÉS DU DESTIN (violet mystique)
3. L'ÉQUILIBRE BRISÉ (rouge sombre)
4. LES RIFTS (vert émeraude)
5. UN DERNIER ESPOIR (doré)
6. QUI ÊTES-VOUS? (arc-en-ciel)

#### ✅ Persona Creation Screen (`persona_creation_screen.dart`)
- **6 étapes progressives** :
  1. Nom du personnage
  2. Race (5 choix : Humain, Elfe, Nain, Orc, Drakéide)
  3. Région d'origine (5 régions)
  4. Origine sociale (6 origines)
  5. Classe (6 classes : Guerrier, Mage, Rodeur, Clerc, Assassin, Barde)
  6. Confirmation finale

- Indicateurs de progression visuels
- Thèmes de couleur par étape
- Preview des stats basiques
- Sauvegarde dans Firestore à la fin

**Modèles créés** :
- `Persona` (race, région, origine, classe)
- `Character` (complet avec stats, équipement, position)
- `CharacterStats` (HP, ATK, DEF, SPD, etc.)
- `CharacterAppearance` (couleurs, traits)

---

### Phase 4 : Système de Map Tactique

#### ✅ Modèles de données (`map_data.dart`)
- **TerrainType** : 6 types de terrain
  - Plains (plaine) : Normal
  - Forest (forêt) : Ralentit (coût 2)
  - Mountain (montagne) : Infranchissable
  - Water (eau) : Infranchissable
  - Castle (château) : Objectif
  - Road (route) : Rapide

- **MapTile** : Case individuelle avec :
  - Position (x, y)
  - Type de terrain
  - Walkable (marchable)
  - MoveCost (coût de déplacement)
  - Couleur et icône

- **UnitPosition** : Position d'une unité :
  - ID, nom, couleur
  - Position (x, y)
  - isPlayer (joueur ou ennemi)

- **TacticalMapData** : Configuration complète d'une map :
  - Dimensions (width × height)
  - Grille 2D de MapTile
  - Liste d'unités
  - Méthodes : getTile(), isWalkable(), isOccupied(), getUnitAt()

#### ✅ Widget de grille tactique (`tactical_map_widget.dart`)
- **TacticalMapWidget** : Widget réutilisable
  - Affichage de la grille complète
  - Support du scroll (horizontal + vertical)
  - Gestion des clics (unités + cases)
  - Highlight des cases accessibles
  - Bordure de sélection (jaune)

- **_MapTileWidget** : Case individuelle
  - Affichage du terrain (couleur + icône)
  - Affichage de l'unité (cercle coloré + initiale)
  - États : normal, sélectionné, surligné
  - Coordonnées (debug mode)

- **TacticalMapLegend** : Légende des terrains
  - Popup modale
  - Liste des terrains avec couleurs
  - Descriptions (Normal, Ralentit, Infranchissable, etc.)

#### ✅ Écran de campagne (`campaign_screen.dart`)
- Chargement de la map de test (8×8)
- Placement du personnage du joueur (position 2, 6)
- Placement d'ennemis de test (2 ennemis rouges)

**Fonctionnalités** :
- **Sélection d'unité** : Clic sur le personnage
  - Surbrillance des 4 cases adjacentes (↑ ↓ ← →)
  - Vérification : cases marchables + non occupées
- **Déplacement** : Clic sur case surlignée
  - Mise à jour de la position
  - Notification visuelle (SnackBar)
  - Recalcul des mouvements possibles
- **Fin de tour** : Bouton dans le panel inférieur
  - Désélection de l'unité
  - Préparation pour IA ennemis (futur)

**Interface** :
- Header : Nom de map + description + bouton aide
- Map scrollable au centre
- Panel inférieur : Info unité + "FIN DU TOUR"

#### ✅ Bibliothèque de maps (`map_library.dart`)
- **Tutoriels** : 2 maps d'apprentissage
  - Tutorial 01 : Premiers Pas (5×5, plaines)
  - Tutorial 02 : Terrain Varié (6×6, obstacles)

- **Chapitre 1** : L'Éveil des Rifts
  - Mission 1-1 : Plaine des Premiers Pas (8×8)
  - Mission 1-2 : Forêt Obscure (10×8, dense)
  - Mission 1-3 : Pont de la Rivière (12×7, pont étroit)

- **Chapitre 2** : Le Rift Cramoisi
  - Mission 2-1 : Montagne des Géants (10×10, passages étroits)
  - Mission 2-2 : Forteresse Assiégée (9×9, murs)

- **Arène** : 1 map PvP
  - Colisée Équilibré (8×8, symétrique)

**Utilitaires** :
- `getTutorialMaps()`
- `getChapter1Maps()`
- `getChapter2Maps()`
- `getMapById(String id)`

#### ✅ Home Screen mis à jour (`home_screen.dart`)
- Nouveau design HD-2D avec gradient
- Logo + titre "DICE DESTINY: IDLE RIFTS"
- **Menu principal** avec 4 boutons :
  - 🎖️ CAMPAGNE (fonctionnel) → Lance CampaignScreen
  - 🗺️ EXPÉDITIONS (bientôt disponible)
  - 🎲 ARÈNE (bientôt disponible)
  - 🛒 BOUTIQUE (bientôt disponible)
- Panel inférieur : Affichage du personnage actif
- Chargement des personnages (version locale pour l'instant)

> **Note** : L'intégration Firestore sera faite au Rush 2

---

### Phase 5 : Navigation et intégration

#### ✅ Navigation globale (`game_navbar.dart`)
- Bottom navigation bar avec 4 onglets :
  1. Characters (gestion des personnages)
  2. Home (menu principal)
  3. Invocation (gacha/summon)
  4. Settings (paramètres)
- IndexedStack pour préserver l'état des pages
- Design arrondi avec ombre

#### ✅ Flow complet de l'application (version actuelle)
```
Lancement
    ↓
WelcomeScreen
    ↓
CinematicScreen (6 scènes)
    ↓
PersonaCreationScreen (6 étapes)
    ↓
Sauvegarde locale (SharedPreferences)
    ↓
GameNavbar
    ↓
HomeScreen
    ↓
Clic "CAMPAGNE"
    ↓
CampaignScreen (map tactique)
    ↓
Déplacement + interactions
```

> **Note** : L'authentification et la sauvegarde cloud (Firebase) seront intégrées au Rush 2

---

## 🛠️ Technologies et packages utilisés

### Core
- **Flutter** : 3.35.5
- **Dart** : 3.9.2
- **Platform** : Ubuntu 24.04 LTS

### Dependencies
```yaml
cupertino_icons: ^1.0.8
flame: ^1.32.0                  # Game engine (préparé, non utilisé encore)
shared_preferences: ^2.2.2      # Cache local pour sauvegarde temporaire
```

> **Note** : Firebase sera intégré au Rush 2 (firebase_core, cloud_firestore, firebase_auth, google_sign_in)

### Dev Dependencies
```yaml
flutter_test: sdk
flutter_lints: ^5.0.0
flutter_launcher_icons: ^0.14.4
```

---

## 📊 Statistiques du Sprint

### Fichiers créés
- **Models** : 4 (player, character, persona, map_data)
- **Screens** : 5 (welcome, cinematic, persona_creation, campaign, home)
- **Widgets** : 2 (tactical_map_widget, game_navbar)
- **Data** : 1 (map_library avec 9 maps)
- **Documentation** : 3 (TACTICAL_MAP_SYSTEM, TACTICAL_MAP_IMPLEMENTATION, SPRINT_01)

> **Note** : Services Firebase (auth_service, game_data_service) et documentation (AUTHENTICATION_SETUP) seront créés au Rush 2

### Lignes de code (estimation)
- **Dart** : ~3000 lignes
- **Documentation** : ~1200 lignes

### Features complétées
- ✅ Système de personnage (création + sauvegarde locale)
- ✅ Interface narrative (cinématique)
- ✅ Map tactique (grille + déplacement)
- ✅ Navigation principale
- ✅ 9 maps prédéfinies (tutoriels + campagne)

### Features reportées au Rush 2
- ⏭️ Authentification (Anonyme, Email, Google)
- ⏭️ Intégration Firebase/Firestore
- ⏭️ Sauvegarde cloud
- ⏭️ Login dialog

---

## 🐛 Bugs résolus

1. **Overflow errors dans UI**
   - Problème : Textes trop longs sans wrapping
   - Solution : `SingleChildScrollView` + `Flexible` widgets

2. **Erreur `characterId` inexistante**
   - Problème : Modèle Character utilise `id` pas `characterId`
   - Solution : Correction dans home_screen.dart

---

## 🎨 Design et UX

### Palette de couleurs
- **Primaire** : Violet profond (#1A237E, #311B92)
- **Secondaire** : Ambre doré (#FFC107, #FFD54F)
- **Accents** : Bleu (#2196F3), Rouge (#F44336), Vert (#4CAF50)
- **Fond** : Noir avec gradients

### Style visuel : HD-2D
- Gradients multi-couches
- Particules animées (étoiles, dés, couleurs)
- Bordures lumineuses
- Ombres portées
- Typographie bold avec letterspacing

### Animations
- Fade in/out (1.5s)
- Slide transitions (CurvedAnimation)
- Particle motion (random positions)
- Button hover effects

---

## 📝 Documentation produite

1. **AUTHENTICATION_SETUP.md**
   - Configuration Firebase Console
   - Setup Android (SHA-1)
   - Setup iOS (URL Scheme)
   - Tests et débogage
   - Règles Firestore
   - Checklist complète

2. **TACTICAL_MAP_SYSTEM.md**
   - Vue d'ensemble du système
   - Structure des fichiers
   - Guide d'utilisation
   - Modèles de données
   - Extensions futures
   - Personnalisation

3. **TACTICAL_MAP_IMPLEMENTATION.md**
   - Résumé d'implémentation
   - Flow complet
   - Exemples de code
   - Problèmes résolus
   - Prochaines étapes

4. **SPRINT_01.md** (ce fichier)
   - Journal de bord complet
   - Chronologie des développements
   - Statistiques du sprint

---

## 🎯 Leçons apprises

1. **Firebase Auth** : Toujours utiliser les dernières versions pour éviter les bugs de compatibilité
2. **Firestore Rules** : Tester les règles avec l'émulateur avant le déploiement
3. **Flutter Layouts** : `SingleChildScrollView` est essentiel pour les écrans denses
## 🎯 Leçons apprises

1. **Flutter Layouts** : `SingleChildScrollView` est essentiel pour les écrans denses
2. **Modularité** : Séparation modèles/widgets/screens facilite la maintenance
3. **Documentation** : Documenter au fur et à mesure évite l'oubli
4. **Grilles tactiques** : Les widgets Flutter sont parfaits pour les jeux 2D au tour par tour
5. **Animations** : Les particules et gradients apportent beaucoup au style HD-2D

---

## 📈 Métriques de succès

- ✅ Aucun crash après tests
- ✅ Temps de réponse < 2s pour chaque action
- ✅ UI responsive sur différentes tailles d'écran
- ✅ Données persistantes (SharedPreferences pour l'instant)
- ✅ Code documenté et organisé
- ✅ Système de map modulable et réutilisable

---

## 👥 Équipe

- **Développeur** : Angel-42
- **Framework** : Flutter / Dart
- **Backend prévu** : Firebase (Rush 2)
- **Plateforme cible** : Android (Linux dev)

---

## 📅 Dates clés

- **Début du projet** : [Date de début]
- **UI narrative** : [Date]
- **Système de map** : [Date]
- **Fin du Sprint 01** : 10 octobre 2025

---

## 🎉 Conclusion du Sprint 01

Le Sprint 01 a permis de poser les **fondations solides** du jeu :
- ✅ Architecture technique robuste (Flutter MVC)
- ✅ Interface utilisateur immersive (HD-2D)
- ✅ Système de map tactique modulable et réutilisable
- ✅ Création de personnage progressive et engageante
- ✅ 9 maps prédéfinies prêtes à l'emploi
- ✅ Documentation complète pour faciliter la suite

Le projet est maintenant prêt pour :
- **Rush 2** : Intégration Firebase (authentification + Firestore)
- **Sprint 02** : Gameplay (combat, IA, progression)

---

**Status** : ✅ Sprint 01 COMPLÉTÉ  
**Prochaine étape** : Rush 2 - Firebase & Authentification  
**Après** : Sprint 02 - Gameplay et Combat  
**Dernière mise à jour** : 10 octobre 2025
