import 'dart:math';

/// Type de dé disponible dans le jeu
enum DiceType {
  d4,   // 1-4 (petits bonus)
  d6,   // 1-6 (standard)
  d8,   // 1-8 (moyen)
  d10,  // 1-10 (puissant)
  d12,  // 1-12 (très puissant)
  d20,  // 1-20 (critique/gacha)
}

/// Résultat d'un lancer de dé
class DiceRoll {
  final DiceType type;
  final int result;
  final int bonus; // Bonus de Luck appliqué
  final bool isCritical; // Valeur max du dé
  final bool isCriticalFailure; // Valeur 1

  DiceRoll({
    required this.type,
    required this.result,
    this.bonus = 0,
    this.isCritical = false,
    this.isCriticalFailure = false,
  });

  /// Total avec bonus
  int get total => result + bonus;
  
  /// Valeur maximale du dé
  int get maxValue {
    switch (type) {
      case DiceType.d4:
        return 4;
      case DiceType.d6:
        return 6;
      case DiceType.d8:
        return 8;
      case DiceType.d10:
        return 10;
      case DiceType.d12:
        return 12;
      case DiceType.d20:
        return 20;
    }
  }

  /// Emoji selon le résultat
  String get emoji {
    if (isCritical) return '🎲✨'; // Critique (max)
    if (isCriticalFailure) return '🎲💀'; // Échec critique (1)
    return '🎲';
  }

  /// Description textuelle du résultat
  String get description {
    final base = 'D$maxValue: $result';
    if (bonus > 0) return '$base +$bonus = $total';
    return '$base = $total';
  }

  /// Couleur selon le résultat
  DiceResultColor get resultColor {
    if (isCritical) return DiceResultColor.legendary;
    if (isCriticalFailure) return DiceResultColor.failure;
    if (total >= maxValue * 0.75) return DiceResultColor.epic;
    if (total >= maxValue * 0.5) return DiceResultColor.rare;
    if (total >= maxValue * 0.25) return DiceResultColor.common;
    return DiceResultColor.poor;
  }
}

/// Couleur du résultat de dé
enum DiceResultColor {
  legendary, // Doré (critique)
  epic,      // Violet (très bon)
  rare,      // Bleu (bon)
  common,    // Vert (moyen)
  poor,      // Gris (mauvais)
  failure,   // Rouge (échec critique)
}

/// Service de lancer de dés
class DiceService {
  static final Random _random = Random();

  /// Lance un dé avec bonus de Luck optionnel
  static DiceRoll roll(DiceType type, {int luckBonus = 0}) {
    final maxValue = _getMaxValue(type);
    final result = _random.nextInt(maxValue) + 1;
    
    // Calculer le bonus de Luck (1 point de Luck = ~0.1 bonus de dé)
    final bonus = (luckBonus * 0.1).round();
    
    final isCritical = result == maxValue;
    final isCriticalFailure = result == 1;

    return DiceRoll(
      type: type,
      result: result,
      bonus: bonus,
      isCritical: isCritical,
      isCriticalFailure: isCriticalFailure,
    );
  }

  /// Lance plusieurs dés et retourne le meilleur (avantage)
  static DiceRoll rollAdvantage(DiceType type, {int luckBonus = 0}) {
    final roll1 = roll(type, luckBonus: luckBonus);
    final roll2 = roll(type, luckBonus: luckBonus);
    return roll1.total >= roll2.total ? roll1 : roll2;
  }

  /// Lance plusieurs dés et retourne le pire (désavantage)
  static DiceRoll rollDisadvantage(DiceType type, {int luckBonus = 0}) {
    final roll1 = roll(type, luckBonus: luckBonus);
    final roll2 = roll(type, luckBonus: luckBonus);
    return roll1.total <= roll2.total ? roll1 : roll2;
  }

  /// Obtenir la valeur max d'un type de dé
  static int _getMaxValue(DiceType type) {
    switch (type) {
      case DiceType.d4:
        return 4;
      case DiceType.d6:
        return 6;
      case DiceType.d8:
        return 8;
      case DiceType.d10:
        return 10;
      case DiceType.d12:
        return 12;
      case DiceType.d20:
        return 20;
    }
  }

  /// Calcule si une attaque est critique (RNG caché avec influence Luck)
  static bool rollCriticalHit(int attackerLuck) {
    double critChance = 0.05; // 5% de base
    critChance += (attackerLuck * 0.005); // +0.5% par point de Luck
    
    final roll = _random.nextInt(100);
    return roll < (critChance * 100);
  }
}
