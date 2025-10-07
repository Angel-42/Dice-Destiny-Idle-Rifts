# Système de Progression Lié à Firebase

## 🎯 Vue d'ensemble

Tous les systèmes de progression du jeu sont maintenant liés à Firebase et sauvegardés automatiquement en temps réel.

## 📊 Données Trackées dans Player

### Missions Quotidiennes (Reset toutes les 24h)
```dart
int dailyEnemiesDefeated;      // Ennemis vaincus aujourd'hui
int dailyGoldCollected;         // Or collecté aujourd'hui  
int dailyAdventuresCompleted;   // Aventures terminées aujourd'hui
DateTime? lastDailyReset;       // Dernière reset des missions
```

### Statistiques Totales (Permanentes)
```dart
int totalEnemiesDefeated;       // Total ennemis vaincus
int totalGoldEarned;            // Total or gagné
int totalAdventuresCompleted;   // Total aventures
int totalBattlesWon;            // Total victoires
```

## 🎮 Fonctionnalités Implémentées

### 1. **Missions Quotidiennes dans Game Hub**

Trois missions quotidiennes avec progression réelle :
- 🗡️ **Vaincre 10 ennemis** → Récompense : 10 💎
- 💰 **Collecter 500 or** → Récompense : 15 💎
- 🏆 **Terminer 5 aventures** → Récompense : 20 💎

**Caractéristiques :**
- ✅ Progression sauvegardée en Firebase
- ✅ Reset automatique toutes les 24h
- ✅ Bouton "Claim" apparaît quand la mission est complétée
- ✅ Récompenses ajoutées automatiquement
- ✅ Indicateur visuel de complétion

### 2. **Progression Idle Automatique**

Le système idle gagne maintenant de l'or toutes les 100 secondes :
```dart
void _startIdleProgress() {
  // Toutes les 100 secondes
  if (_idleProgress == 0) {
    _player.addGold(10);
    _player.addGoldCollected(10); // Compte pour mission
    _savePlayer(); // Sauvegarde Firebase automatique
  }
}
```

**Caractéristiques :**
- ✅ Compte pour la mission "Collecter 500 or"
- ✅ Sauvegardé automatiquement dans Firebase
- ✅ Continue même si l'app est fermée (via Firebase)

### 3. **Système de Combat Tactique**

Dans `TacticalBattleScreen`, chaque combat track maintenant :

**Bouton "Combat" :**
- Tue 1-3 ennemis aléatoires
- Gagne 10-30 or
- Met à jour `dailyEnemiesDefeated`
- Met à jour `dailyGoldCollected`
- Sauvegarde automatiquement

**Bouton "Terminer" :**
- Marque l'aventure comme complétée
- Incrémente `dailyAdventuresCompleted`
- Incrémente `totalBattlesWon`
- Affiche un résumé des gains
- Retourne au Game Hub

### 4. **Sauvegarde Automatique**

Toutes les actions importantes sont sauvegardées automatiquement :
```dart
void _savePlayer() {
  GameDataService.savePlayer(_player).catchError((e) {
    debugPrint('⚠️ Erreur sauvegarde: $e');
  });
}
```

**Sauvegardé automatiquement :**
- ✅ Progression idle (toutes les 100s)
- ✅ Combat (chaque ennemi vaincu)
- ✅ Aventures terminées
- ✅ Récompenses de missions réclamées
- ✅ Or et gemmes ajoutés/dépensés

## 🔧 Méthodes Player Disponibles

### Progression des Missions
```dart
player.checkAndResetDailyMissions();  // Auto-reset si >24h
player.addEnemyDefeated();             // +1 ennemi vaincu
player.addGoldCollected(amount);       // +X or collecté
player.addAdventureCompleted();        // +1 aventure
player.addBattleWon();                 // +1 victoire
```

### Économie
```dart
player.addGold(amount);      // Ajouter or
player.spendGold(amount);    // Dépenser or
player.addGems(amount);      // Ajouter gemmes
player.spendGems(amount);    // Dépenser gemmes
```

### XP et Niveaux
```dart
player.addXP(amount);        // Ajouter XP (auto level-up)
```

## 📱 Expérience Utilisateur

### Feedback Visuel
- 🎨 Missions complétées ont une bordure colorée
- ✅ Icône de check apparaît quand complété
- 🔘 Bouton "Claim" s'affiche uniquement si complété
- 📊 Barres de progression en temps réel
- 🎉 SnackBar de confirmation après récompense

### Persistance
- 💾 Toutes les données sont sauvegardées dans Firestore
- ☁️ Sync entre appareils automatique
- 🔄 Aucune perte de données même si l'app crash
- 📊 Historique complet des stats disponible

## 🚀 Prochaines Étapes

### À Implémenter
1. **Récompenses de Mission Variables**
   - Missions différentes chaque jour
   - Récompenses scaling avec niveau compte
   
2. **Achievements Permanents**
   - "Vaincre 1000 ennemis au total"
   - "Collecter 100,000 or au total"
   - Récompenses spéciales
   
3. **Leaderboards**
   - Classement par totalEnemiesDefeated
   - Classement par arenaRank
   - Classement par highestRiftFloor
   
4. **Statistiques Détaillées**
   - Screen "Stats" affichant toutes les stats
   - Graphiques de progression
   - Historique des sessions

## 🧪 Comment Tester

1. **Lancer l'app** : `flutter run`
2. **Créer un personnage** si premier lancement
3. **Game Hub** :
   - Attendre 100s pour voir l'or auto-gagné
   - Vérifier que "Collecter 500 or" progresse
4. **Mode Aventure** :
   - Cliquer sur "Combat" plusieurs fois
   - Vérifier "Vaincre 10 ennemis" progresse
   - Cliquer "Terminer" pour compléter l'aventure
5. **Vérifier Missions** :
   - Bouton "Claim" apparaît si >=objectif
   - Cliquer pour recevoir gemmes
   - Vérifier les gemmes dans top bar

## 🐛 Débogage

Toutes les sauvegardes Firebase ont des logs :
```dart
debugPrint('💾 Sauvegarde Player...');
debugPrint('✅ Player sauvegardé');
debugPrint('⚠️ Erreur sauvegarde: $error');
```

Vérifier Firestore Console pour voir les données en temps réel :
`https://console.firebase.google.com/project/YOUR_PROJECT/firestore`

## 📝 Structure Firestore

```
users/{userId}
  ├── gold: 150
  ├── gems: 65
  ├── dailyEnemiesDefeated: 7
  ├── dailyGoldCollected: 320
  ├── dailyAdventuresCompleted: 2
  ├── lastDailyReset: "2025-10-07T..."
  ├── totalEnemiesDefeated: 47
  ├── totalGoldEarned: 2450
  ├── totalAdventuresCompleted: 15
  ├── totalBattlesWon: 12
  └── characters/{characterId}/
      └── (Character data)
```
