import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';

/// Service pour gérer l'authentification (Anonyme, Email, Google)
class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn();

  /// Obtenir l'utilisateur actuel
  static User? get currentUser => _auth.currentUser;
  
  /// Obtenir l'UID de l'utilisateur actuel
  static String? get currentUserId => _auth.currentUser?.uid;
  
  /// Vérifier si l'utilisateur est connecté
  static bool get isSignedIn => _auth.currentUser != null;
  
  /// Vérifier si l'utilisateur est anonyme
  static bool get isAnonymous => _auth.currentUser?.isAnonymous ?? false;

  /// Stream pour écouter les changements d'état d'authentification
  static Stream<User?> get authStateChanges => _auth.authStateChanges();

  // ========== CONNEXION ANONYME ==========
  
  /// Se connecter en mode anonyme (temporaire)
  static Future<UserCredential> signInAnonymously() async {
    try {
      debugPrint('🔐 Connexion anonyme en cours...');
      final userCredential = await _auth.signInAnonymously();
      debugPrint('✅ Connexion anonyme réussie: ${userCredential.user?.uid}');
      return userCredential;
    } on FirebaseAuthException catch (e) {
      debugPrint('❌ Erreur connexion anonyme: ${e.code} - ${e.message}');
      if (e.code == 'operation-not-allowed') {
        throw Exception('La connexion anonyme n\'est pas activée. Active-la dans Firebase Console.');
      }
      rethrow;
    }
  }

  // ========== CONNEXION EMAIL/PASSWORD ==========
  
  /// Créer un compte avec email et mot de passe
  static Future<UserCredential> signUpWithEmail({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      debugPrint('📧 Création de compte avec email: $email');
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Mettre à jour le nom d'affichage si fourni
      if (displayName != null && displayName.isNotEmpty) {
        await userCredential.user?.updateDisplayName(displayName);
        await userCredential.user?.reload();
      }
      
      debugPrint('✅ Compte créé: ${userCredential.user?.uid}');
      return userCredential;
    } on FirebaseAuthException catch (e) {
      debugPrint('❌ Erreur création compte: ${e.code} - ${e.message}');
      throw _handleAuthException(e);
    }
  }
  
  /// Se connecter avec email et mot de passe
  static Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      debugPrint('📧 Connexion avec email: $email');
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      debugPrint('✅ Connexion email réussie: ${userCredential.user?.uid}');
      return userCredential;
    } on FirebaseAuthException catch (e) {
      debugPrint('❌ Erreur connexion email: ${e.code} - ${e.message}');
      throw _handleAuthException(e);
    }
  }

  // ========== CONNEXION GOOGLE ==========
  
  /// Se connecter avec Google
  static Future<UserCredential> signInWithGoogle() async {
    try {
      debugPrint('🔍 Connexion Google en cours...');
      
      // Déclencher le flux d'authentification Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        debugPrint('⚠️ Connexion Google annulée par l\'utilisateur');
        throw Exception('Connexion Google annulée');
      }
      
      debugPrint('📱 Utilisateur Google sélectionné: ${googleUser.email}');
      
      // Obtenir les détails d'authentification
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      
      // Créer les credentials Firebase
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      
      // Se connecter à Firebase avec les credentials Google
      final userCredential = await _auth.signInWithCredential(credential);
      debugPrint('✅ Connexion Google réussie: ${userCredential.user?.uid}');
      
      return userCredential;
    } on FirebaseAuthException catch (e) {
      debugPrint('❌ Erreur Firebase lors de la connexion Google: ${e.code} - ${e.message}');
      throw _handleAuthException(e);
    } catch (e) {
      debugPrint('❌ Erreur connexion Google: $e');
      rethrow;
    }
  }

  // ========== LINK COMPTE ANONYME ==========
  
  /// Lier un compte anonyme existant avec Email/Password
  static Future<UserCredential> linkAnonymousWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      if (!isAnonymous) {
        throw Exception('L\'utilisateur actuel n\'est pas anonyme');
      }
      
      debugPrint('🔗 Liaison du compte anonyme avec email: $email');
      
      final credential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );
      
      final userCredential = await currentUser!.linkWithCredential(credential);
      debugPrint('✅ Compte anonyme lié avec succès: ${userCredential.user?.uid}');
      
      return userCredential;
    } on FirebaseAuthException catch (e) {
      debugPrint('❌ Erreur liaison compte: ${e.code} - ${e.message}');
      throw _handleAuthException(e);
    }
  }
  
  /// Lier un compte anonyme existant avec Google
  static Future<UserCredential> linkAnonymousWithGoogle() async {
    try {
      if (!isAnonymous) {
        throw Exception('L\'utilisateur actuel n\'est pas anonyme');
      }
      
      debugPrint('🔗 Liaison du compte anonyme avec Google...');
      
      // Obtenir les credentials Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        throw Exception('Connexion Google annulée');
      }
      
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      
      // Lier le compte anonyme avec Google
      final userCredential = await currentUser!.linkWithCredential(credential);
      debugPrint('✅ Compte anonyme lié avec Google: ${userCredential.user?.uid}');
      
      return userCredential;
    } on FirebaseAuthException catch (e) {
      debugPrint('❌ Erreur liaison Google: ${e.code} - ${e.message}');
      throw _handleAuthException(e);
    }
  }

  // ========== DÉCONNEXION ==========
  
  /// Se déconnecter
  static Future<void> signOut() async {
    try {
      debugPrint('👋 Déconnexion en cours...');
      await Future.wait([
        _auth.signOut(),
        _googleSignIn.signOut(),
      ]);
      debugPrint('✅ Déconnexion réussie');
    } catch (e) {
      debugPrint('❌ Erreur lors de la déconnexion: $e');
      rethrow;
    }
  }

  // ========== RÉINITIALISATION MOT DE PASSE ==========
  
  /// Envoyer un email de réinitialisation de mot de passe
  static Future<void> sendPasswordResetEmail(String email) async {
    try {
      debugPrint('📧 Envoi d\'email de réinitialisation à: $email');
      await _auth.sendPasswordResetEmail(email: email);
      debugPrint('✅ Email de réinitialisation envoyé');
    } on FirebaseAuthException catch (e) {
      debugPrint('❌ Erreur envoi email: ${e.code} - ${e.message}');
      throw _handleAuthException(e);
    }
  }

  // ========== GESTION DES ERREURS ==========
  
  /// Convertir les codes d'erreur Firebase en messages lisibles
  static Exception _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return Exception('Le mot de passe est trop faible (minimum 6 caractères)');
      case 'email-already-in-use':
        return Exception('Cet email est déjà utilisé par un autre compte');
      case 'invalid-email':
        return Exception('L\'adresse email est invalide');
      case 'user-disabled':
        return Exception('Ce compte a été désactivé');
      case 'user-not-found':
        return Exception('Aucun compte ne correspond à cet email');
      case 'wrong-password':
        return Exception('Mot de passe incorrect');
      case 'operation-not-allowed':
        return Exception('Cette méthode de connexion n\'est pas activée');
      case 'credential-already-in-use':
        return Exception('Ces identifiants sont déjà utilisés par un autre compte');
      case 'provider-already-linked':
        return Exception('Ce provider est déjà lié à votre compte');
      default:
        return Exception('Erreur d\'authentification: ${e.message}');
    }
  }
}
