import 'bestiary_entry.dart';
import 'codex_entry.dart';

class Player {
  final String userId;
  String displayName;
  int accountLevel;
  int accountXP;

  // Currencies
  int gold;
  int gems;
  int summonTokens;

  // Progression
  double storyChapter; // Chapitre de l'histoire débloqué (based with 1,01 = Chapitre 1 stage 1 ; 1,02 = Chapitre 1 stage 2, etc.)
  int arenaRank;
  int highestRiftFloor;

  // Bestiaire - Ennemis découverts
  Map<String, BestiaryEntry> bestiary;

  // Codex - Personnages obtenus
  Map<String, CodexEntry> codex;

  // Daily Missions (reset daily)
  int dailyEnemiesDefeated;
  int dailyGoldCollected;
  int dailyAdventuresCompleted;
  DateTime? lastDailyReset;

  // Stats totales
  int totalEnemiesDefeated;
  int totalGoldEarned;
  int totalAdventuresCompleted;
  int totalBattlesWon;

  // Daily
  DateTime? lastDailyReward;
  int loginStreak;

  // Settings
  bool soundEnabled;
  bool musicEnabled;
  double masterVolume;
  bool notificationsEnabled;

  // Timestamps
  DateTime createdAt;
  DateTime lastLogin;

  Player({
    required this.userId,
    required this.displayName,
    this.accountLevel = 1,
    this.accountXP = 0,
    this.gold = 100,
    this.gems = 50,
    this.summonTokens = 0,
    this.storyChapter = 1.01,
    this.arenaRank = 0,
    this.highestRiftFloor = 0,
    Map<String, BestiaryEntry>? bestiary,
    Map<String, CodexEntry>? codex,
    this.dailyEnemiesDefeated = 0,
    this.dailyGoldCollected = 0,
    this.dailyAdventuresCompleted = 0,
    this.lastDailyReset,
    this.totalEnemiesDefeated = 0,
    this.totalGoldEarned = 0,
    this.totalAdventuresCompleted = 0,
    this.totalBattlesWon = 0,
    this.lastDailyReward,
    this.loginStreak = 0,
    this.soundEnabled = true,
    this.musicEnabled = true,
    this.masterVolume = 0.8,
    this.notificationsEnabled = true,
    DateTime? createdAt,
    DateTime? lastLogin,
  })  : bestiary = bestiary ?? {},
        codex = codex ?? {},
        createdAt = createdAt ?? DateTime.now(),
        lastLogin = lastLogin ?? DateTime.now();

  // Convert to JSON for Firestore
  Map<String, dynamic> toJson() => {
        'userId': userId,
        'displayName': displayName,
        'accountLevel': accountLevel,
        'accountXP': accountXP,
        'gold': gold,
        'gems': gems,
        'summonTokens': summonTokens,
        'storyChapter': storyChapter,
        'arenaRank': arenaRank,
        'highestRiftFloor': highestRiftFloor,
        'bestiary': bestiary.map((key, value) => MapEntry(key, value.toJson())),
        'codex': codex.map((key, value) => MapEntry(key, value.toJson())),
        'dailyEnemiesDefeated': dailyEnemiesDefeated,
        'dailyGoldCollected': dailyGoldCollected,
        'dailyAdventuresCompleted': dailyAdventuresCompleted,
        'lastDailyReset': lastDailyReset?.toIso8601String(),
        'totalEnemiesDefeated': totalEnemiesDefeated,
        'totalGoldEarned': totalGoldEarned,
        'totalAdventuresCompleted': totalAdventuresCompleted,
        'totalBattlesWon': totalBattlesWon,
        'lastDailyReward': lastDailyReward?.toIso8601String(),
        'loginStreak': loginStreak,
        'soundEnabled': soundEnabled,
        'musicEnabled': musicEnabled,
        'masterVolume': masterVolume,
        'notificationsEnabled': notificationsEnabled,
        'createdAt': createdAt.toIso8601String(),
        'lastLogin': lastLogin.toIso8601String(),
      };

  // Create from JSON
  factory Player.fromJson(Map<String, dynamic> json) {
    // Désérialiser le bestiaire
    Map<String, BestiaryEntry> bestiaryMap = {};
    if (json['bestiary'] != null) {
      final bestiaryData = json['bestiary'] as Map<String, dynamic>;
      bestiaryMap = bestiaryData.map(
        (key, value) => MapEntry(key, BestiaryEntry.fromJson(value as Map<String, dynamic>)),
      );
    }
    
    // Désérialiser le codex
    Map<String, CodexEntry> codexMap = {};
    if (json['codex'] != null) {
      final codexData = json['codex'] as Map<String, dynamic>;
      codexMap = codexData.map(
        (key, value) => MapEntry(key, CodexEntry.fromJson(value as Map<String, dynamic>)),
      );
    }
    
    return Player(
      userId: json['userId'] as String,
      displayName: json['displayName'] as String,
      accountLevel: json['accountLevel'] as int? ?? 1,
      accountXP: json['accountXP'] as int? ?? 0,
      gold: json['gold'] as int? ?? 100,
      gems: json['gems'] as int? ?? 50,
      summonTokens: json['summonTokens'] as int? ?? 0,
      storyChapter: json['storyChapter'] as double? ?? 1.01,
      arenaRank: json['arenaRank'] as int? ?? 0,
      highestRiftFloor: json['highestRiftFloor'] as int? ?? 0,
      bestiary: bestiaryMap,
      codex: codexMap,
      dailyEnemiesDefeated: json['dailyEnemiesDefeated'] as int? ?? 0,
      dailyGoldCollected: json['dailyGoldCollected'] as int? ?? 0,
      dailyAdventuresCompleted: json['dailyAdventuresCompleted'] as int? ?? 0,
      lastDailyReset: json['lastDailyReset'] != null
          ? DateTime.parse(json['lastDailyReset'] as String)
          : null,
      totalEnemiesDefeated: json['totalEnemiesDefeated'] as int? ?? 0,
      totalGoldEarned: json['totalGoldEarned'] as int? ?? 0,
      totalAdventuresCompleted: json['totalAdventuresCompleted'] as int? ?? 0,
      totalBattlesWon: json['totalBattlesWon'] as int? ?? 0,
      lastDailyReward: json['lastDailyReward'] != null
          ? DateTime.parse(json['lastDailyReward'] as String)
          : null,
      loginStreak: json['loginStreak'] as int? ?? 0,
      soundEnabled: json['soundEnabled'] as bool? ?? true,
      musicEnabled: json['musicEnabled'] as bool? ?? true,
      masterVolume: (json['masterVolume'] as num?)?.toDouble() ?? 0.8,
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      lastLogin: json['lastLogin'] != null
          ? DateTime.parse(json['lastLogin'] as String)
          : DateTime.now(),
    );
  }

  int get xpForNextLevel => accountLevel * 100;
  double get levelProgress => accountXP / xpForNextLevel;

  void addXP(int amount) {
    accountXP += amount;
    while (accountXP >= xpForNextLevel) {
      accountXP -= xpForNextLevel;
      accountLevel++;
    }
  }

  // Ajouter de l'or
  void addGold(int amount) {
    gold += amount;
  }

  // Dépenser de l'or
bool spendGold(int amount) {
  if (amount < 0) throw ArgumentError('Amount must be positive');
  if (gold >= amount) {
    gold -= amount;
    return true;
  }
  return false;
}

  // Ajouter des gemmes
  void addGems(int amount) {
    gems += amount;
  }

  // Dépenser des gemmes
  bool spendGems(int amount) {
    if (amount < 0) throw ArgumentError('Amount must be positive');
    if (gems >= amount) {
      gems -= amount;
      return true;
    }
    return false;
  }

  // Vérifier si peut réclamer récompense quotidienne
  bool canClaimDailyReward() {
    if (lastDailyReward == null) return true;
    final now = DateTime.now();
    return now.difference(lastDailyReward!).inHours >= 24;
  }

  // Réclamer récompense quotidienne
  void claimDailyReward() {
    lastDailyReward = DateTime.now();
    loginStreak++;
    // Récompenses basées sur le streak
    addGold(50 * loginStreak);
    addGems(5 * loginStreak);
  }

  // Vérifier et reset les missions quotidiennes si nécessaire
  void checkAndResetDailyMissions() {
    final now = DateTime.now();
    if (lastDailyReset == null || 
        now.difference(lastDailyReset!).inHours >= 24) {
      dailyEnemiesDefeated = 0;
      dailyGoldCollected = 0;
      dailyAdventuresCompleted = 0;
      lastDailyReset = now;
    }
  }

  // Ajouter progression missions quotidiennes
  void addEnemyDefeated() {
    checkAndResetDailyMissions();
    dailyEnemiesDefeated++;
    totalEnemiesDefeated++;
  }

  void addGoldCollected(int amount) {
    checkAndResetDailyMissions();
    dailyGoldCollected += amount;
    totalGoldEarned += amount;
  }

  void addAdventureCompleted() {
    checkAndResetDailyMissions();
    dailyAdventuresCompleted++;
    totalAdventuresCompleted++;
  }

  void addBattleWon() {
    totalBattlesWon++;
  }

  // === BESTIARY METHODS ===
  
  /// Enregistre une rencontre avec un ennemi
  void encounterEnemy(String enemyId) {
    if (!bestiary.containsKey(enemyId)) {
      bestiary[enemyId] = BestiaryEntry.initial();
    }
    bestiary[enemyId] = bestiary[enemyId]!.copyWith(
      discovered: true,
      encounterCount: bestiary[enemyId]!.encounterCount + 1,
      lastEncounter: DateTime.now(),
    );
  }
  
  /// Enregistre la défaite d'un ennemi
  void defeatEnemy(String enemyId) {
    if (!bestiary.containsKey(enemyId)) {
      bestiary[enemyId] = BestiaryEntry.initial();
    }
    bestiary[enemyId] = bestiary[enemyId]!.copyWith(
      discovered: true,
      defeatedCount: bestiary[enemyId]!.defeatedCount + 1,
      lastEncounter: DateTime.now(),
    );
  }
  
  /// Vérifie si un ennemi a été découvert
  bool hasDiscovered(String enemyId) {
    return bestiary.containsKey(enemyId) && bestiary[enemyId]!.discovered;
  }
  
  /// Nombre total d'ennemis découverts
  int get totalEnemiesDiscovered {
    return bestiary.values.where((entry) => entry.discovered).length;
  }
  
  /// Calcule le pourcentage de complétion du bestiaire
  double bestiaryCompletion(int totalEnemies) {
    if (totalEnemies == 0) return 0.0;
    return (totalEnemiesDiscovered / totalEnemies) * 100;
  }
  
  // === CODEX METHODS ===
  
  /// Enregistre l'obtention d'un personnage
  void unlockCharacter(String characterName, int level) {
    if (!codex.containsKey(characterName)) {
      codex[characterName] = CodexEntry.initial();
    }
    codex[characterName] = codex[characterName]!.copyWith(
      unlockCount: codex[characterName]!.unlockCount + 1,
      maxLevel: level > codex[characterName]!.maxLevel ? level : codex[characterName]!.maxLevel,
      lastUnlock: DateTime.now(),
    );
  }
  
  /// Met à jour le niveau maximum d'un personnage
  void updateCharacterLevel(String characterName, int newLevel) {
    if (codex.containsKey(characterName) && newLevel > codex[characterName]!.maxLevel) {
      codex[characterName] = codex[characterName]!.copyWith(maxLevel: newLevel);
    }
  }
  
  /// Incrémente le nombre de combats avec un personnage
  void incrementCharacterBattles(String characterName) {
    if (codex.containsKey(characterName)) {
      codex[characterName] = codex[characterName]!.copyWith(
        totalBattles: codex[characterName]!.totalBattles + 1,
      );
    }
  }
  
  /// Vérifie si un personnage a été débloqué
  bool hasUnlocked(String characterName) {
    return codex.containsKey(characterName) && codex[characterName]!.unlockCount > 0;
  }
  
  /// Nombre total de personnages différents obtenus
  int get totalCharactersUnlocked {
    return codex.values.where((entry) => entry.unlockCount > 0).length;
  }
  
  /// Calcule le pourcentage de complétion du codex
  double codexCompletion(int totalCharacters) {
    if (totalCharacters == 0) return 0.0;
    return (totalCharactersUnlocked / totalCharacters) * 100;
  }

  // Copier avec modifications
  Player copyWith({
    String? displayName,
    int? accountLevel,
    int? accountXP,
    int? gold,
    int? gems,
    int? summonTokens,
    double? storyChapter,
    int? arenaRank,
    int? highestRiftFloor,
    DateTime? lastDailyReward,
    int? loginStreak,
    bool? soundEnabled,
    bool? musicEnabled,
    double? masterVolume,
    bool? notificationsEnabled,
    DateTime? lastLogin,
  }) {
    return Player(
      userId: userId,
      displayName: displayName ?? this.displayName,
      accountLevel: accountLevel ?? this.accountLevel,
      accountXP: accountXP ?? this.accountXP,
      gold: gold ?? this.gold,
      gems: gems ?? this.gems,
      summonTokens: summonTokens ?? this.summonTokens,
      storyChapter: storyChapter ?? this.storyChapter,
      arenaRank: arenaRank ?? this.arenaRank,
      highestRiftFloor: highestRiftFloor ?? this.highestRiftFloor,
      bestiary: bestiary,
      codex: codex,
      lastDailyReward: lastDailyReward ?? this.lastDailyReward,
      loginStreak: loginStreak ?? this.loginStreak,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      musicEnabled: musicEnabled ?? this.musicEnabled,
      masterVolume: masterVolume ?? this.masterVolume,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      createdAt: createdAt,
      lastLogin: lastLogin ?? this.lastLogin,
    );
  }
}