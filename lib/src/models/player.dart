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
  int storyChapter;
  int arenaRank;
  int highestRiftFloor;

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
    this.storyChapter = 1,
    this.arenaRank = 0,
    this.highestRiftFloor = 0,
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
  })  : createdAt = createdAt ?? DateTime.now(),
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
    return Player(
      userId: json['userId'] as String,
      displayName: json['displayName'] as String,
      accountLevel: json['accountLevel'] as int? ?? 1,
      accountXP: json['accountXP'] as int? ?? 0,
      gold: json['gold'] as int? ?? 100,
      gems: json['gems'] as int? ?? 50,
      summonTokens: json['summonTokens'] as int? ?? 0,
      storyChapter: json['storyChapter'] as int? ?? 1,
      arenaRank: json['arenaRank'] as int? ?? 0,
      highestRiftFloor: json['highestRiftFloor'] as int? ?? 0,
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

  // Copier avec modifications
  Player copyWith({
    String? displayName,
    int? accountLevel,
    int? accountXP,
    int? gold,
    int? gems,
    int? summonTokens,
    int? storyChapter,
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