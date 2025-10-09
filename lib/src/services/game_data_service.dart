import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../models/player.dart';
import '../models/character.dart';

/// Service Firebase pour gérer les données du joueur et des personnages
class GameDataService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Références
  static CollectionReference get _usersCollection => _firestore.collection('users');
  
  static DocumentReference? get _currentUserDoc {
    final user = _auth.currentUser;
    if (user == null) return null;
    return _usersCollection.doc(user.uid);
  }
  
  static CollectionReference? get _charactersCollection {
    return _currentUserDoc?.collection('characters');
  }

  // ============================================================================
  // AUTHENTIFICATION
  // ============================================================================

  /// S'assurer que l'utilisateur est authentifié (anonyme par défaut)
  static Future<void> ensureAuthenticated() async {
    if (_auth.currentUser == null) {
      debugPrint('🔐 Authentification anonyme en cours...');
      await _auth.signInAnonymously();
      debugPrint('✅ Authentification réussie: ${_auth.currentUser?.uid}');
    }
  }

  /// Obtenir l'ID utilisateur actuel
  static String? get currentUserId => _auth.currentUser?.uid;

  // ============================================================================
  // PLAYER (COMPTE JOUEUR)
  // ============================================================================

  /// Récupère le profil du joueur
  static Future<Player?> getPlayer() async {
    try {
      await ensureAuthenticated();
      final doc = await _currentUserDoc?.get();
      
      if (doc == null || !doc.exists) {
        debugPrint('📭 Aucun profil joueur trouvé');
        return null;
      }
      
      final data = doc.data() as Map<String, dynamic>?;
      if (data == null) return null;
      
      final player = Player.fromJson(data);
      debugPrint('✅ Profil joueur chargé: ${player.displayName}');
      return player;
    } catch (e) {
      debugPrint('❌ Erreur getPlayer: $e');
      return null;
    }
  }

  /// Crée un nouveau profil joueur
  static Future<void> createPlayer(String displayName) async {
    try {
      await ensureAuthenticated();
      
      final player = Player(
        userId: currentUserId!,
        displayName: displayName,
      );
      
      await _currentUserDoc?.set(player.toJson());
      debugPrint('✅ Profil joueur créé: $displayName');
    } catch (e) {
      debugPrint('❌ Erreur createPlayer: $e');
      rethrow;
    }
  }

  /// Sauvegarde le profil du joueur
  static Future<void> savePlayer(Player player) async {
    try {
      await ensureAuthenticated();
      await _currentUserDoc?.set(player.toJson(), SetOptions(merge: true));
      debugPrint('💾 Profil joueur sauvegardé');
    } catch (e) {
      debugPrint('❌ Erreur savePlayer: $e');
      rethrow;
    }
  }

  /// Met à jour les ressources du joueur (or, gemmes, etc.)
  static Future<void> updatePlayerCurrency({
    int? gold,
    int? gems,
    int? summonTokens,
  }) async {
    try {
      await ensureAuthenticated();
      final updates = <String, dynamic>{};
      
      if (gold != null) updates['gold'] = FieldValue.increment(gold);
      if (gems != null) updates['gems'] = FieldValue.increment(gems);
      if (summonTokens != null) updates['summonTokens'] = FieldValue.increment(summonTokens);
      
      await _currentUserDoc?.update(updates);
      debugPrint('💰 Ressources mises à jour');
    } catch (e) {
      debugPrint('❌ Erreur updatePlayerCurrency: $e');
      rethrow;
    }
  }

  // ============================================================================
  // CHARACTERS (PERSONNAGES JOUABLES)
  // ============================================================================

  /// Récupère tous les personnages du joueur
  static Future<List<Character>> getAllCharacters() async {
    try {
      await ensureAuthenticated();
      final snapshot = await _charactersCollection?.get();
      
      if (snapshot == null || snapshot.docs.isEmpty) {
        debugPrint('📭 Aucun personnage trouvé');
        return [];
      }
      
      final characters = snapshot.docs
          .map((doc) => Character.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      
      debugPrint('✅ ${characters.length} personnages chargés');
      return characters;
    } catch (e) {
      debugPrint('❌ Erreur getAllCharacters: $e');
      return [];
    }
  }

  /// Récupère un personnage spécifique
  static Future<Character?> getCharacter(String characterId) async {
    try {
      await ensureAuthenticated();
      final doc = await _charactersCollection?.doc(characterId).get();
      
      if (doc == null || !doc.exists) {
        debugPrint('📭 Personnage $characterId introuvable');
        return null;
      }
      
      final character = Character.fromJson(doc.data() as Map<String, dynamic>);
      debugPrint('✅ Personnage chargé: ${character.name}');
      return character;
    } catch (e) {
      debugPrint('❌ Erreur getCharacter: $e');
      return null;
    }
  }

  /// Récupère les personnages de l'équipe
  static Future<List<Character>> getTeamCharacters() async {
    try {
      await ensureAuthenticated();
      final snapshot = await _charactersCollection
          ?.where('isInTeam', isEqualTo: true)
          .orderBy('teamPosition')
          .get();
      
      if (snapshot == null || snapshot.docs.isEmpty) {
        debugPrint('📭 Aucun personnage dans l\'équipe');
        return [];
      }
      
      final characters = snapshot.docs
          .map((doc) => Character.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      
      debugPrint('✅ ${characters.length} personnages dans l\'équipe');
      return characters;
    } catch (e) {
      debugPrint('❌ Erreur getTeamCharacters: $e');
      return [];
    }
  }

  /// Récupère le personnage principal (premier dans l'équipe)
  static Future<Character?> getMainCharacter() async {
    try {
      final teamCharacters = await getTeamCharacters();
      if (teamCharacters.isEmpty) return null;
      
      // Le personnage principal est celui en position 1
      final mainChar = teamCharacters.firstWhere(
        (c) => c.teamPosition == 1,
        orElse: () => teamCharacters.first,
      );
      
      debugPrint('✅ Personnage principal: ${mainChar.name}');
      return mainChar;
    } catch (e) {
      debugPrint('❌ Erreur getMainCharacter: $e');
      return null;
    }
  }

  /// Crée un nouveau personnage
  static Future<void> createCharacter(Character character) async {
    try {
      await ensureAuthenticated();
      
      // Si c'est le premier personnage, le mettre en position 1
      final existingChars = await getAllCharacters();
      if (existingChars.isEmpty) {
        character.isInTeam = true;
        character.teamPosition = 1;
      }
      
      await _charactersCollection?.doc(character.id).set(character.toJson());
      debugPrint('🎨 Personnage créé: ${character.name}');
    } catch (e) {
      debugPrint('❌ Erreur createCharacter: $e');
      rethrow;
    }
  }

  /// Sauvegarde un personnage
  static Future<void> saveCharacter(Character character) async {
    try {
      await ensureAuthenticated();
      await _charactersCollection?.doc(character.id).set(
        character.toJson(),
        SetOptions(merge: true),
      );
      debugPrint('💾 Personnage sauvegardé: ${character.name}');
    } catch (e) {
      debugPrint('❌ Erreur saveCharacter: $e');
      rethrow;
    }
  }

  /// Supprime un personnage
  static Future<void> deleteCharacter(String characterId) async {
    try {
      await ensureAuthenticated();
      await _charactersCollection?.doc(characterId).delete();
      debugPrint('🗑️ Personnage supprimé: $characterId');
    } catch (e) {
      debugPrint('❌ Erreur deleteCharacter: $e');
      rethrow;
    }
  }

  /// Met à jour l'équipe
  static Future<void> updateTeam(List<String> characterIds) async {
    try {
      await ensureAuthenticated();
      
      // Retirer tous les personnages de l'équipe
      final allChars = await getAllCharacters();
      for (final char in allChars) {
        char.isInTeam = false;
        char.teamPosition = 0;
        await saveCharacter(char);
      }
      
      // Ajouter les nouveaux personnages à l'équipe
      for (int i = 0; i < characterIds.length && i < 3; i++) {
        final char = await getCharacter(characterIds[i]);
        if (char != null) {
          char.isInTeam = true;
          char.teamPosition = i + 1;
          await saveCharacter(char);
        }
      }
      
      debugPrint('👥 Équipe mise à jour: ${characterIds.length} personnages');
    } catch (e) {
      debugPrint('❌ Erreur updateTeam: $e');
      rethrow;
    }
  }

  // ============================================================================
  // INITIALIZATION & CLEANUP
  // ============================================================================

  /// Vérifie si le joueur a un profil
  static Future<bool> hasProfile() async {
    try {
      await ensureAuthenticated();
      final doc = await _currentUserDoc?.get();
      return doc != null && doc.exists;
    } catch (e) {
      debugPrint('❌ Erreur hasProfile: $e');
      return false;
    }
  }

  /// Vérifie si le joueur a des personnages
  static Future<bool> hasCharacters() async {
    try {
      final characters = await getAllCharacters();
      return characters.isNotEmpty;
    } catch (e) {
      debugPrint('❌ Erreur hasCharacters: $e');
      return false;
    }
  }

  /// Réinitialise toutes les données du joueur
  static Future<void> resetAll() async {
    try {
      await ensureAuthenticated();
      
      // Supprimer tous les personnages
      final characters = await getAllCharacters();
      for (final char in characters) {
        await deleteCharacter(char.id);
      }
      
      // Supprimer le profil joueur
      await _currentUserDoc?.delete();
      
      debugPrint('🔄 Toutes les données réinitialisées');
    } catch (e) {
      debugPrint('❌ Erreur resetAll: $e');
      rethrow;
    }
  }

  /// Supprime le compte utilisateur
  static Future<void> deleteAccount() async {
    try {
      await ensureAuthenticated();
      
      // Supprimer toutes les données
      await resetAll();
      
      // Supprimer l'authentification
      await _auth.currentUser?.delete();
      
      debugPrint('🗑️ Compte supprimé');
    } catch (e) {
      debugPrint('❌ Erreur deleteAccount: $e');
      rethrow;
    }
  }

  // ============================================================================
  // STREAMS (pour les mises à jour en temps réel)
  // ============================================================================

  /// Stream du profil joueur
  static Stream<Player?> watchPlayer() {
    return _auth.authStateChanges().asyncExpand((user) {
      if (user == null) return Stream.value(null);
      
      return _usersCollection.doc(user.uid).snapshots().map((doc) {
        if (!doc.exists) return null;
        return Player.fromJson(doc.data() as Map<String, dynamic>);
      });
    });
  }

  /// Stream des personnages
  static Stream<List<Character>> watchCharacters() {
    return _auth.authStateChanges().asyncExpand((user) {
      if (user == null) return Stream.value([]);
      
      return _usersCollection
          .doc(user.uid)
          .collection('characters')
          .snapshots()
          .map((snapshot) {
        return snapshot.docs
            .map((doc) => Character.fromJson(doc.data()))
            .toList();
      });
    });
  }
}