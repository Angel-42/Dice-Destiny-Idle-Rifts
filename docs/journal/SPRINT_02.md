# Journal de Développement - Dice Destiny: Idle Rifts

## 📅 Session du 15 octobre 2025

### 🎯 Objectifs accomplis

#### 1. Système de Stats et Compétences
- ✅ **Correction de l'overflow** dans l'affichage des compétences (4 pixels)
- ✅ **Implémentation du système de bonus de compétences passives**
  - Les stats sont calculées dynamiquement : `(Base + Équipement) × Compétences`
  - Compétences raciales actives (Orcish Fury, Elven Grace, etc.)
  - Compétences d'origine actives (Leadership, Scholar Wisdom, etc.)
- ✅ **Système de calcul de dégâts complet**
  - Dégâts physiques : `(Attaque × Maîtrise × Skill) - (Défense × 0.5)`
  - Dégâts magiques : `(Magie × Skill) - (Résistance × 0.3)`
  - Bonus de maîtrise d'arme (Rank E à S : +0% à +25%)
- ✅ **Documentation créée**
  - `docs/STATS_SYSTEM.md` : Système de stats détaillé
  - `docs/COMBAT_SYSTEM.md` : Formules de combat

#### 2. Migration des Données
- ✅ **Service de migration des compétences vers v2**
  - Ajout automatique du champ `statBonuses` manquant
  - Migration au démarrage de l'app
  - Gestion des valeurs null en lecture

#### 4. Refonte de la Navigation (Style Fire Emblem Heroes)
- ✅ **Nouvelle Navbar avec 6 onglets**
  - 🏠 **Home** : Écran d'accueil avec menu principal
  - 🔥 **Battle** : Sélection Story/Arena/Campaign
  - 👥 **Allies** : Gestion des personnages (anciennement Characters)
  - ✨ **Summon** : Invocation de héros (orbs)
  - 🛒 **Shop** : Boutique d'équipement et IAP
  - ⚙️ **Misc.** : Settings, Events, Rankings, Logout
- ✅ **Design inspiré de Fire Emblem Heroes**
  - Gradient sombre avec icônes colorées
  - Animation de sélection avec bordure
  - SafeArea pour les encoches

#### 5. Système d'Authentification
- ✅ **AuthWrapper avec StreamBuilder**
  - Écoute automatique de l'état d'authentification
  - Redirection automatique après login/logout
- ✅ **Correction du logout**
  - Navigation forcée vers `WelcomeScreen` avec `pushAndRemoveUntil`
  - Suppression de toute la stack de navigation
  - Logs de debug ajoutés

#### 6. Système d'Équipe (Team)
- ✅ **Gestion d'équipe (max 4 personnages)**
  - Champs ajoutés dans `Character` : `isInTeam`, `teamPosition`
  - `GameDataService.getTeamCharacters()` : Récupération de l'équipe
  - `GameDataService.updateTeam()` : Mise à jour de l'équipe
- ✅ **Index Firestore composite créé**
  - Collection : `characters`
  - Champs : `isInTeam` (Ascending) + `teamPosition` (Ascending)
- ✅ **Fallback côté client** si index non disponible
  - Chargement de tous les personnages puis tri local
  - Logs informatifs pour debug

#### 7. Écran de Campagne (Campaign)
- ✅ **Refonte pour accepter une team complète**
  - `CampaignScreen` prend maintenant `List<Character> team`
  - Placement automatique de tous les membres de l'équipe sur la map
  - Position de départ : ligne du bas, espacés (max 4)
- ✅ **Navigation depuis Battle Screen**
  - Bouton "Campaign Mode" récupère la team et lance la campagne
  - Gestion des erreurs (pas de personnage, index manquant)
- ✅ **Map tactique fonctionnelle**
  - Sélection d'unité
  - Déplacement sur cases adjacentes
  - Highlight des cases valides
  - Gestion des obstacles et ennemis
