import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/player.dart';
import '../models/character.dart';
import '../models/preset_character.dart';
import '../data/character_database.dart';
import 'auth_service.dart';

/// Service Firebase pour gérer les données du joueur et des personnages
class GameDataService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Références
  static CollectionReference get _usersCollection => _firestore.collection('users');
  
  static DocumentReference? get _currentUserDoc {
    final userId = AuthService.currentUserId;
    if (userId == null) return null;
    return _usersCollection.doc(userId);
  }
  
  static CollectionReference? get _charactersCollection {
    return _currentUserDoc?.collection('characters');
  }

  // ============================================================================
  // AUTHENTIFICATION (délégué à AuthService)
  // ============================================================================

  /// Obtenir l'ID utilisateur actuel
  static String? get currentUserId => AuthService.currentUserId;
  
  /// Vérifier si l'utilisateur est connecté
  static bool get isSignedIn => AuthService.isSignedIn;

  // ============================================================================
  // PLAYER (COMPTE JOUEUR)
  // ============================================================================

  /// Récupère le profil du joueur
  static Future<Player?> getPlayer() async {
    try {
      // Les méthodes assument que l'utilisateur est authentifié
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
      // Vérifier que l'utilisateur est authentifié
      if (currentUserId == null) {
        throw Exception('Utilisateur non authentifié');
      }
      
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
      // Les méthodes assument que l'utilisateur est authentifié
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
      // Les méthodes assument que l'utilisateur est authentifié
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
      // Les méthodes assument que l'utilisateur est authentifié
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
      // Les méthodes assument que l'utilisateur est authentifié
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
      // Les méthodes assument que l'utilisateur est authentifié
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
      // Les méthodes assument que l'utilisateur est authentifié
      
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
      // Les méthodes assument que l'utilisateur est authentifié
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

  /// Sauvegarde plusieurs personnages en une seule opération atomique (batch)
  static Future<void> saveCharactersBatch(List<Character> characters) async {
    try {
      final userDoc = _currentUserDoc;
      if (userDoc == null) {
        throw Exception('Utilisateur non authentifié');
      }

      final batch = _firestore.batch();
      final col = userDoc.collection('characters');

      for (final c in characters) {
        final docRef = col.doc(c.id);
        batch.set(docRef, c.toJson(), SetOptions(merge: true));
      }

      await batch.commit();
      debugPrint('💾 Batch sauvegarde ${characters.length} personnages');
    } catch (e) {
      debugPrint('❌ Erreur saveCharactersBatch: $e');
      rethrow;
    }
  }

  /// Supprime un personnage
  static Future<void> deleteCharacter(String characterId) async {
    try {
      // Les méthodes assument que l'utilisateur est authentifié
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
      // Les méthodes assument que l'utilisateur est authentifié
      
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
      // Les méthodes assument que l'utilisateur est authentifié
      final doc = await _currentUserDoc?.get();
      return doc != null && doc.exists;
    } catch (e) {
      debugPrint('❌ Erreur hasProfile: $e');
      return false;
    }
  }

  /// Vérifie si une sauvegarde existe (profil OU personnages)
  static Future<bool> hasSaveData() async {
    try {
      // Vérifier le profil
      final hasProfileData = await hasProfile();
      if (hasProfileData) return true;

      // Vérifier les personnages
      final hasChars = await hasCharacters();
      return hasChars;
    } catch (e) {
      debugPrint('❌ Erreur hasSaveData: $e');
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
      // Les méthodes assument que l'utilisateur est authentifié
      
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
      // Les méthodes assument que l'utilisateur est authentifié
      
      // Supprimer toutes les données
      await resetAll();
      
      // Supprimer l'authentification via AuthService
      await AuthService.currentUser?.delete();
      
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
    return AuthService.authStateChanges.asyncExpand((user) {
      if (user == null) return Stream.value(null);
      
      return _usersCollection.doc(user.uid).snapshots().map((doc) {
        if (!doc.exists) return null;
        return Player.fromJson(doc.data() as Map<String, dynamic>);
      });
    });
  }

  /// Stream des personnages
  static Stream<List<Character>> watchCharacters() {
    return AuthService.authStateChanges.asyncExpand((user) {
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

  // ============================================================================
  // MIGRATION / MAINTENANCE
  // ============================================================================

  /// Migre les personnages existants pour utiliser les sprites de la database
  static Future<void> migrateCharacterSprites() async {
    try {
      final characters = await getAllCharacters();
      print('🔄 Début migration des sprites pour ${characters.length} personnages');
      
      int migrated = 0;
      for (final character in characters) {
        // Chercher le preset correspondant par nom dans CharacterDatabase
        PresetCharacter? preset;
        try {
          preset = CharacterDatabase.allCharacters.firstWhere(
            (p) => p.name == character.name,
          );
        } catch (e) {
          // Pas de preset trouvé pour ce personnage
          continue;
        }
        
        if (preset.headshot != character.appearance.headshot ||
            preset.lheadshot != character.appearance.lheadshot ||
            preset.pixel != character.appearance.pixel ||
            preset.fullsize != character.appearance.fullsize) {
          print('🔄 Migration sprites pour ${character.name}');
          
          final updatedCharacter = Character(
            id: character.id,
            name: character.name,
            persona: character.persona,
            stats: character.stats,
            appearance: CharacterAppearance(
              headshot: preset.headshot,
              lheadshot: preset.lheadshot,
              pixel: preset.pixel,
              fullsize: preset.fullsize,
              colorValue: preset.colorValue,
              description: character.appearance.description,
            ),
            level: character.level,
            xp: character.xp,
            x: character.x,
            y: character.y,
            weapon: character.weapon,
            armorOrAccessory: character.armorOrAccessory,
            equippedSkills: character.equippedSkills,
            weaponMasteries: character.weaponMasteries,
            inventory: preset.customInventory ?? character.inventory, // 🔥 IMPORTANT: Restaurer l'inventaire custom du preset
            initialOwnedClassIds: character.ownedClassIds,
            activeClassId: character.activeClassId,
            basedRarity: character.basedRarity,
            currentRarity: character.currentRarity,
            isInTeam: character.isInTeam,
            teamPosition: character.teamPosition,
            obtainedAt: character.obtainedAt,
          );
          updatedCharacter.currentHp = character.currentHp;
          
          await saveCharacter(updatedCharacter);
          migrated++;
        }
      }
      
      print('✅ Migration terminée: $migrated/${characters.length} personnages migrés');
    } catch (e) {
      print('❌ Erreur lors de la migration: $e');
    }
  }

  /// Force la restauration des inventaires customs depuis les presets
  /// Utile si les inventaires ont été perdus ou sont incomplets
  static Future<void> restoreCustomInventories() async {
    try {
      final characters = await getAllCharacters();
      if (characters.isEmpty) {
        print('⚠️ Aucun personnage à restaurer');
        return;
      }
      
      print('🔄 Restauration des inventaires customs pour ${characters.length} personnages');
      
      int restored = 0;
      for (final character in characters) {
        print('📋 Vérification de ${character.name}:');
        print('   - Armes: ${character.inventory.weapons.length}');
        print('   - Armures: ${character.inventory.armors.length}');
        print('   - Skills: ${character.inventory.skills.length}');
        
        // Chercher le preset correspondant par ID ou nom
        PresetCharacter? preset;
        try {
          preset = CharacterDatabase.getById(character.id) ?? 
                   CharacterDatabase.allCharacters.firstWhere(
                     (p) => p.name == character.name,
                   );
        } catch (e) {
          print('   ❌ Pas de preset trouvé pour ${character.name}');
          continue;
        }
        
        // Si le preset a un inventaire custom et que le personnage n'en a pas ou qu'il est vide
        if (preset.customInventory != null) {
          print('   ℹ️ Preset a un inventaire custom avec:');
          print('      - ${preset.customInventory!.weapons.length} armes');
          print('      - ${preset.customInventory!.armors.length} armures');
          print('      - ${preset.customInventory!.skills.length} skills');
          
          final hasEmptyInventory = character.inventory.weapons.isEmpty && 
                                    character.inventory.armors.isEmpty &&
                                    character.inventory.skills.isEmpty;
          
          if (hasEmptyInventory) {
            print('   🔄 RESTAURATION pour ${character.name}');
            
            final updatedCharacter = Character(
              id: character.id,
              name: character.name,
              persona: character.persona,
              stats: character.stats,
              appearance: character.appearance,
              level: character.level,
              xp: character.xp,
              x: character.x,
              y: character.y,
              weapon: character.weapon,
              armorOrAccessory: character.armorOrAccessory,
              equippedSkills: character.equippedSkills,
              weaponMasteries: character.weaponMasteries,
              inventory: preset.customInventory!, // Restaurer l'inventaire custom
              initialOwnedClassIds: character.ownedClassIds,
              activeClassId: character.activeClassId,
              basedRarity: character.basedRarity,
              currentRarity: character.currentRarity,
              isInTeam: character.isInTeam,
              teamPosition: character.teamPosition,
              obtainedAt: character.obtainedAt,
            );
            updatedCharacter.currentHp = character.currentHp;
            
            await saveCharacter(updatedCharacter);
            print('   ✅ Sauvegardé dans Firestore');
            restored++;
          } else {
            print('   ✅ Inventaire déjà rempli, pas besoin de restaurer');
          }
        } else {
          print('   ℹ️ Pas d\'inventaire custom dans le preset');
        }
      }
      
      print('✅ Restauration terminée: $restored/${characters.length} inventaires restaurés');
      
      // Vérification : recharger les personnages pour confirmer que la sauvegarde a fonctionné
      print('🔍 Vérification post-restauration...');
      final reloadedCharacters = await getAllCharacters();
      for (final char in reloadedCharacters) {
        if (char.name == 'MC' || char.name == 'Aria') {
          print('   ${char.name}: ${char.inventory.weapons.length} armes, ${char.inventory.armors.length} armures, ${char.inventory.skills.length} skills');
        }
      }
    } catch (e, stackTrace) {
      print('❌ Erreur lors de la restauration: $e');
      print('Stack trace: $stackTrace');
    }
  }
}