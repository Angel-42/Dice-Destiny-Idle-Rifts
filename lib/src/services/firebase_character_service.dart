import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../models/character.dart';

class FirebaseCharacterService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Référence à la collection des utilisateurs
  static CollectionReference get _usersCollection => _firestore.collection('users');

  // Référence au document de l'utilisateur actuel
  static DocumentReference? get _currentUserDoc {
    final user = _auth.currentUser;
    if (user == null) return null;
    return _usersCollection.doc(user.uid);
  }

  // Authentification anonyme (pour ne pas obliger les joueurs à créer un compte)
  static Future<void> ensureAuthenticated() async {
    if (_auth.currentUser == null) {
      await _auth.signInAnonymously();
    }
  }

  // Vérifie si l'utilisateur a des personnages
  static Future<bool> hasCharacters() async {
    try {
      await ensureAuthenticated();
      final doc = await _currentUserDoc?.get();
      if (doc == null || !doc.exists) return false;
      
      final data = doc.data() as Map<String, dynamic>?;
      final characters = data?['characters'] as List?;
      return characters != null && characters.isNotEmpty;
    } catch (e) {
      debugPrint('Erreur hasCharacters: $e');
      return false;
    }
  }

  // Récupère le personnage actif
  static Future<Character?> getActiveCharacter() async {
    try {
      await ensureAuthenticated();
      final doc = await _currentUserDoc?.get();
      if (doc == null || !doc.exists) return null;
      
      final data = doc.data() as Map<String, dynamic>?;
      final activeCharacterJson = data?['activeCharacter'] as Map<String, dynamic>?;
      
      if (activeCharacterJson == null) return null;
      return Character.fromJson(activeCharacterJson);
    } catch (e) {
      debugPrint('Erreur getActiveCharacter: $e');
      return null;
    }
  }

  // Sauvegarde le personnage actif
  static Future<void> saveActiveCharacter(Character character) async {
    try {
      await ensureAuthenticated();
      await _currentUserDoc?.set({
        'activeCharacter': character.toJson(),
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint('Erreur saveActiveCharacter: $e');
      rethrow;
    }
  }

  // Récupère tous les personnages
  static Future<List<Character>> getAllCharacters() async {
    try {
      await ensureAuthenticated();
      final doc = await _currentUserDoc?.get();
      if (doc == null || !doc.exists) return [];
      
      final data = doc.data() as Map<String, dynamic>?;
      final charactersList = data?['characters'] as List?;
      
      if (charactersList == null) return [];
      return charactersList
          .map((json) => Character.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('Erreur getAllCharacters: $e');
      return [];
    }
  }

  // Sauvegarde tous les personnages
  static Future<void> saveCharacters(List<Character> characters) async {
    try {
      await ensureAuthenticated();
      await _currentUserDoc?.set({
        'characters': characters.map((c) => c.toJson()).toList(),
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint('Erreur saveCharacters: $e');
      rethrow;
    }
  }

  // Crée un nouveau personnage
  static Future<void> createCharacter(Character character) async {
    try {
      await ensureAuthenticated();
      final characters = await getAllCharacters();
      characters.add(character);
      
      await _currentUserDoc?.set({
        'characters': characters.map((c) => c.toJson()).toList(),
        'activeCharacter': character.toJson(),
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint('Erreur createCharacter: $e');
      rethrow;
    }
  }

  // Supprime un personnage
  static Future<void> deleteCharacter(String characterId) async {
    try {
      await ensureAuthenticated();
      final characters = await getAllCharacters();
      characters.removeWhere((c) => c.id == characterId);
      
      await saveCharacters(characters);
      
      // Si c'était le personnage actif, le réinitialiser
      final activeCharacter = await getActiveCharacter();
      if (activeCharacter?.id == characterId) {
        await _currentUserDoc?.update({
          'activeCharacter': FieldValue.delete(),
        });
      }
    } catch (e) {
      debugPrint('Erreur deleteCharacter: $e');
      rethrow;
    }
  }

  // Réinitialise toutes les données de l'utilisateur
  static Future<void> resetAll() async {
    try {
      await ensureAuthenticated();
      await _currentUserDoc?.delete();
    } catch (e) {
      debugPrint('Erreur resetAll: $e');
      rethrow;
    }
  }

  // Supprime le compte utilisateur (authentification + données)
  static Future<void> deleteAccount() async {
    try {
      await ensureAuthenticated();
      
      // Supprimer les données Firestore
      await _currentUserDoc?.delete();
      
      // Supprimer l'authentification
      await _auth.currentUser?.delete();
    } catch (e) {
      debugPrint('Erreur deleteAccount: $e');
      rethrow;
    }
  }
}