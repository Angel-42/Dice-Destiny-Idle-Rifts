import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth_service.dart';

/// Service qui gère les revenus passifs (idle income)
/// Le joueur gagne de l'or automatiquement, même hors ligne
class IdleIncomeService {
  static Timer? _timer;
  static bool _isRunning = false;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Configuration
  static const int goldPerTick = 50; // Or gagné toutes les 10 secondes
  static const Duration tickDuration = Duration(seconds: 10);

  /// Référence au document du joueur
  static DocumentReference? get _playerDoc {
    final userId = AuthService.currentUserId;
    if (userId == null) return null;
    return _firestore.collection('users').doc(userId);
  }

  /// Démarre le service de revenu passif
  static void start() {
    if (_isRunning) {
      debugPrint('⚠️ IdleIncomeService déjà en cours');
      return;
    }

    debugPrint('💰 Démarrage IdleIncomeService (${goldPerTick} gold / ${tickDuration.inSeconds}s)');
    _isRunning = true;

    // Petit délai avant de calculer les revenus offline
    // Pour laisser le temps aux StreamBuilders de se charger
    Future.delayed(const Duration(milliseconds: 500), () {
      _calculateOfflineIncome();
    });

    // Démarrer le timer pour les revenus online
    _timer = Timer.periodic(tickDuration, (timer) async {
      await _giveIdleGold();
    });
  }

  /// Arrête le service et sauvegarde le timestamp
  static void stop() {
    if (!_isRunning) return;

    debugPrint('⏸️ Arrêt IdleIncomeService');
    _timer?.cancel();
    _timer = null;
    _isRunning = false;

    // Sauvegarder le timestamp de déconnexion (pas besoin d'attendre)
    _saveLastOnlineTimestamp();
  }

  /// Calcule et attribue les revenus accumulés pendant l'absence du joueur
  static Future<void> _calculateOfflineIncome() async {
    try {
      if (_playerDoc == null) {
        debugPrint('⚠️ Pas de joueur connecté');
        return;
      }

      // Récupérer le dernier timestamp sauvegardé (FORCER depuis le serveur)
      final doc = await _playerDoc!.get(const GetOptions(source: Source.server));
      if (!doc.exists) {
        debugPrint('⚠️ Document joueur inexistant');
        return;
      }

      final data = doc.data() as Map<String, dynamic>?;
      if (data == null) {
        debugPrint('⚠️ Données joueur nulles');
        return;
      }

      final lastOnlineTimestampStr = data['lastOnlineTimestamp'] as String?;
      if (lastOnlineTimestampStr == null) {
        debugPrint('💰 Première connexion, pas de revenus offline');
        // Sauvegarder le timestamp initial
        await _playerDoc!.update({
          'lastOnlineTimestamp': DateTime.now().toIso8601String(),
        });
        return;
      }

      final lastOnline = DateTime.parse(lastOnlineTimestampStr);
      final now = DateTime.now();
      
      debugPrint('🕐 Dernière connexion: $lastOnline');
      debugPrint('🕐 Connexion actuelle: $now');
      
      // Calculer le temps écoulé depuis la dernière connexion
      final timeDifference = now.difference(lastOnline);
      debugPrint('⏱️ Temps d\'absence: ${timeDifference.inSeconds} secondes (${timeDifference.inMinutes} minutes)');
      
      // Calculer combien de ticks se sont écoulés (10 secondes par tick)
      final ticksElapsed = (timeDifference.inSeconds / tickDuration.inSeconds).floor();
      debugPrint('🎫 Ticks écoulés: $ticksElapsed');
      
      if (ticksElapsed > 0) {
        // Limiter à 24 heures maximum (pour éviter des sommes astronomiques)
        final maxTicks = (Duration(hours: 24).inSeconds / tickDuration.inSeconds).floor();
        final cappedTicks = ticksElapsed > maxTicks ? maxTicks : ticksElapsed;
        
        final offlineGold = cappedTicks * goldPerTick;
        
        debugPrint('💰 Calcul: $cappedTicks ticks × $goldPerTick gold = $offlineGold gold');
        
        // Ajouter l'or gagné directement dans Firestore ET mettre à jour le timestamp
        await _playerDoc!.update({
          'gold': FieldValue.increment(offlineGold),
          'lastOnlineTimestamp': now.toIso8601String(),
        });
        
        final hours = (cappedTicks * tickDuration.inSeconds / 3600).toStringAsFixed(1);
        debugPrint('✅ Revenus offline appliqués: +$offlineGold gold (${hours}h d\'absence)');
        
        // Si le joueur était absent plus de 24h, l'informer
        if (ticksElapsed > maxTicks) {
          final actualHours = (timeDifference.inHours).toStringAsFixed(1);
          debugPrint('ℹ️ Temps d\'absence: ${actualHours}h (limité à 24h pour les revenus)');
        }
      } else {
        debugPrint('💰 Pas de revenus offline (dernière connexion: ${timeDifference.inSeconds}s)');
        // Mettre à jour le timestamp quand même
        await _playerDoc!.update({
          'lastOnlineTimestamp': now.toIso8601String(),
        });
      }

    } catch (e) {
      debugPrint('❌ Erreur calcul revenus offline: $e');
      debugPrint('Stack trace: ${StackTrace.current}');
    }
  }

  /// Donne de l'or au joueur (tick automatique)
  static Future<void> _giveIdleGold() async {
    try {
      if (_playerDoc == null) return;
      
      await _playerDoc!.update({
        'gold': FieldValue.increment(goldPerTick),
      });
      debugPrint('💰 +$goldPerTick gold (idle income)');
    } catch (e) {
      debugPrint('❌ Erreur idle income: $e');
    }
  }

  /// Sauvegarde le timestamp actuel de déconnexion
  static void _saveLastOnlineTimestamp() {
    try {
      if (_playerDoc == null) return;

      final now = DateTime.now().toIso8601String();
      _playerDoc!.update({
        'lastOnlineTimestamp': now,
      }).then((_) {
        debugPrint('💾 Timestamp de déconnexion sauvegardé: $now');
      }).catchError((e) {
        debugPrint('❌ Erreur sauvegarde timestamp: $e');
      });
    } catch (e) {
      debugPrint('❌ Erreur sauvegarde timestamp: $e');
    }
  }

  /// Retourne le taux de revenu par seconde
  static double get goldPerSecond => goldPerTick / tickDuration.inSeconds;

  /// Retourne le taux de revenu par heure
  static int get goldPerHour => (goldPerSecond * 3600).round();

  /// Vérifie si le service est actif
  static bool get isRunning => _isRunning;
}
