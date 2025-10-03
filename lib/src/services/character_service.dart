import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/character.dart';

class CharacterService {
  static const String _charactersKey = 'characters';
  static const String _activeCharacterKey = 'active_character';

  // Vérifie si des personnages existent
  static Future<bool> hasCharacters() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final charactersJson = prefs.getString(_charactersKey);
      if (charactersJson == null || charactersJson.isEmpty) {
        return false;
      }
      final List<dynamic> charactersList = json.decode(charactersJson);
      return charactersList.isNotEmpty;
    } catch (e) {
      print('Erreur lors de la vérification des personnages: $e');
      return false;
    }
  }

  // Récupère le personnage actif
  static Future<Character?> getActiveCharacter() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final characterJson = prefs.getString(_activeCharacterKey);
      if (characterJson == null || characterJson.isEmpty) {
        return null;
      }
      return Character.fromJson(json.decode(characterJson));
    } catch (e) {
      print('Erreur lors de la récupération du personnage actif: $e');
      return null;
    }
  }

  // Sauvegarde le personnage actif
  static Future<void> saveActiveCharacter(Character character) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_activeCharacterKey, json.encode(character.toJson()));
    } catch (e) {
      print('Erreur lors de la sauvegarde du personnage actif: $e');
    }
  }

  // Sauvegarde tous les personnages
  static Future<void> saveCharacters(List<Character> characters) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final charactersJson = json.encode(characters.map((c) => c.toJson()).toList());
      await prefs.setString(_charactersKey, charactersJson);
    } catch (e) {
      print('Erreur lors de la sauvegarde des personnages: $e');
    }
  }

  // Récupère tous les personnages
  static Future<List<Character>> getAllCharacters() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final charactersJson = prefs.getString(_charactersKey);
      if (charactersJson == null || charactersJson.isEmpty) {
        return [];
      }
      final List<dynamic> charactersList = json.decode(charactersJson);
      return charactersList.map((json) => Character.fromJson(json)).toList();
    } catch (e) {
      print('Erreur lors de la récupération des personnages: $e');
      return [];
    }
  }

  // Crée un nouveau personnage
  static Future<void> createCharacter(Character character) async {
    try {
      final characters = await getAllCharacters();
      characters.add(character);
      await saveCharacters(characters);
      await saveActiveCharacter(character);
    } catch (e) {
      print('Erreur lors de la création du personnage: $e');
    }
  }

  // Supprime un personnage
  static Future<void> deleteCharacter(String characterId) async {
    try {
      final characters = await getAllCharacters();
      characters.removeWhere((c) => c.id == characterId);
      await saveCharacters(characters);
      
      // Si c'était le personnage actif, réinitialiser
      final activeCharacter = await getActiveCharacter();
      if (activeCharacter?.id == characterId) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove(_activeCharacterKey);
      }
    } catch (e) {
      print('Erreur lors de la suppression du personnage: $e');
    }
  }

  // Réinitialise toutes les données
  static Future<void> resetAll() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_charactersKey);
      await prefs.remove(_activeCharacterKey);
    } catch (e) {
      print('Erreur lors de la réinitialisation: $e');
    }
  }
}
