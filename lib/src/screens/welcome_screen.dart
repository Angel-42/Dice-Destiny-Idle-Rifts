import 'package:dice_destiny_idle_rifts/src/services/auth_service.dart';
import 'package:dice_destiny_idle_rifts/src/services/game_data_service.dart';
import 'package:dice_destiny_idle_rifts/src/widgets/game_navbar.dart';
import 'package:dice_destiny_idle_rifts/src/widgets/login_dialog.dart';
import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import 'cinematic_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {
  bool _isChecking = false;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          // Fond dégradé inspiré Pixel Art Tactique / HD-2D
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              // Tons sombres fantasy avec touches colorées
              Color(0xFF1a0f2e), // Violet très sombre (nuit profonde)
              Color(0xFF2d1b4e), // Violet foncé
              Color(0xFF3d2463), // Violet profond
              Color(0xFF1f1535), // Presque noir violacé
              Color(0xFF0d0617), // Noir profond en bas
            ],
            stops: [0.0, 0.3, 0.5, 0.75, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Effet de grille tactique en arrière-plan (référence Fire Emblem/Advance Wars)
            Positioned.fill(
              child: CustomPaint(
                painter: _TacticalGridPainter(),
              ),
            ),
            
            // Particules/étoiles lumineuses (effet Octopath Traveler HD-2D)
            Positioned.fill(
              child: CustomPaint(
                painter: _ParticlesPainter(),
              ),
            ),
            
            // Vignette pour effet de profondeur
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 1.2,
                    colors: [
                      Colors.transparent,
                      const Color(0xFF0d0617).withOpacity(0.6),
                    ],
                  ),
                ),
              ),
            ),
            
            // Contenu principal
            SafeArea(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height - 
                              MediaQuery.of(context).padding.top - 
                              MediaQuery.of(context).padding.bottom,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Logo et titre avec effet de glow
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.amber.withOpacity(0.5),
                                    blurRadius: 30,
                                    spreadRadius: 10,
                                  ),
                                ],
                              ),
                              child: const Text(
                                '🎲',
                                style: TextStyle(fontSize: 80),
                              ),
                            ),
                            const SizedBox(height: 24),
                            
                            // Titre principal avec effet de brillance
                            ShaderMask(
                              shaderCallback: (bounds) => LinearGradient(
                                colors: [
                                  Colors.amber.shade300,
                                  Colors.amber.shade600,
                                  Colors.amber.shade300,
                                ],
                              ).createShader(bounds),
                              child: Text(
                                S.of(context)!.diceDestiny,
                                style: const TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  letterSpacing: 2,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 20,
                                      color: Colors.black,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            
                            // Sous-titre avec effet néon
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.deepPurple.shade300,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.deepPurple.withOpacity(0.5),
                                    blurRadius: 20,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Text(
                                S.of(context)!.idleRifts,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.deepPurple.shade100,
                                  letterSpacing: 6,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                            const SizedBox(height: 32),
                            
                            // Description avec fond semi-transparent
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.auto_awesome,
                                        color: Colors.amber,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 8),
                                      Flexible(
                                        child: Text(
                                          S.of(context)!.epicUniverseTagline,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      const Icon(
                                        Icons.auto_awesome,
                                        color: Colors.amber,
                                        size: 18,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    S.of(context)!.epicUniverseDescription,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.white.withOpacity(0.9),
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 48),
                            
                            // Bouton de démarrage avec animation et effet 3D
                            _isChecking
                                ? Container(
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.6),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          width: 40,
                                          height: 40,
                                          child: CircularProgressIndicator(
                                            color: Colors.amber,
                                            strokeWidth: 3,
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          S.of(context)!.initializingPortal,
                                          style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: _handleStart,
                                        borderRadius: BorderRadius.circular(35),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 32,
                                            vertical: 18,
                                          ),
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                Colors.amber.shade400,
                                                Colors.amber.shade700,
                                              ],
                                            ),
                                            borderRadius: BorderRadius.circular(35),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.amber.withOpacity(0.6),
                                                blurRadius: 20,
                                                spreadRadius: 2,
                                                offset: const Offset(0, 4),
                                              ),
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.3),
                                                blurRadius: 10,
                                                offset: const Offset(0, 8),
                                              ),
                                            ],
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.play_arrow_rounded,
                                                color: Colors.deepPurple.shade900,
                                                size: 28,
                                              ),
                                              const SizedBox(width: 8),
                                              Flexible(
                                                child: Text(
                                                  S.of(context)!.startAdventure,
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w800,
                                                    color: Colors.deepPurple,
                                                    letterSpacing: 0.5,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                            const SizedBox(height: 32),
                            
                            // Version et easter egg
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.4),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.code,
                                    color: Colors.white54,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 8),
                                  Flexible(
                                    child: Text(
                                      S.of(context)!.versionInfo,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.white54,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

    Future<void> _handleStart() async {
    debugPrint('[DEBUG] Start button pressed');
    setState(() => _isChecking = true);
  
    try {
      // 🔥 Si l'utilisateur n'est pas connecté, afficher le LoginDialog
      if (!AuthService.isSignedIn) {
        debugPrint('[DEBUG] User is not signed in, showing LoginDialog...');
        
        // Afficher le dialog de connexion
        final result = await showDialog<bool>(
          context: context,
          barrierDismissible: false, // Empêcher de fermer en cliquant à côté
          builder: (context) => const LoginDialog(),
        );
        
        // Si l'utilisateur annule ou que la connexion échoue
        if (result != true) {
          debugPrint('[DEBUG] Login cancelled or failed');
          setState(() => _isChecking = false);
          return;
        }
      }
  
      // ✅ Maintenant l'utilisateur est authentifié (anonyme ou Google)
      debugPrint('[DEBUG] User authenticated: ${AuthService.currentUserId}');
      
      // Vérifier les données du joueur
      final hasProfile = await GameDataService.hasProfile();
      final hasCharacters = await GameDataService.hasCharacters();
      debugPrint('[DEBUG] hasProfile: $hasProfile, hasCharacters: $hasCharacters');
  
      if (!mounted) return;
  
      // Animation de sortie
      await _controller.reverse();
  
      if (!mounted) return;
  
      // Navigation selon l'état du joueur
      if (!hasProfile || !hasCharacters) {
        debugPrint('[DEBUG] Navigating to CinematicScreen (new user)');
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const CinematicScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.easeInOutCubic;
  
              var tween = Tween(begin: begin, end: end).chain(
                CurveTween(curve: curve),
              );
  
              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
            transitionDuration: const Duration(milliseconds: 600),
          ),
        );
      } else {
        debugPrint('[DEBUG] Navigating to GameNavbar (existing user)');
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const GameNavbar(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            transitionDuration: const Duration(milliseconds: 600),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
  
      setState(() => _isChecking = false);
  
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      S.of(context)!.connectionError(e.toString()),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          action: SnackBarAction(
            label: 'Réessayer',
            textColor: Colors.white,
            onPressed: _handleStart,
          ),
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }
}

// CustomPainter pour la grille tactique en arrière-plan (effet Fire Emblem/Advance Wars)
class _TacticalGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF4a3a7a).withOpacity(0.15) // Violet clair transparent
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    const gridSize = 40.0;

    for (double x = 0; x < size.width; x += gridSize) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }

    for (double y = 0; y < size.height; y += gridSize) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }

    final highlightPaint = Paint()
      ..color = const Color(0xFF7c5fa8).withOpacity(0.1)
      ..style = PaintingStyle.fill;

    final highlights = [
      const Offset(2, 3),
      const Offset(5, 2),
      const Offset(3, 7),
      const Offset(8, 5),
      const Offset(6, 9),
      const Offset(4, 4),
    ];

    for (final pos in highlights) {
      final x = pos.dx * gridSize;
      final y = pos.dy * gridSize;
      if (x < size.width && y < size.height) {
        canvas.drawRect(
          Rect.fromLTWH(x, y, gridSize, gridSize),
          highlightPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// CustomPainter pour les particules lumineuses (effet Octopath Traveler HD-2D)
class _ParticlesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill;

    final particles = [
      _Particle(size.width * 0.1, size.height * 0.15, 2.0, const Color(0xFFffd700)),
      _Particle(size.width * 0.85, size.height * 0.25, 1.5, const Color(0xFFb19cd9)),
      _Particle(size.width * 0.3, size.height * 0.4, 1.8, const Color(0xFF8a7fb8)),
      _Particle(size.width * 0.75, size.height * 0.6, 2.2, const Color(0xFFffd700)),
      _Particle(size.width * 0.5, size.height * 0.2, 1.0, const Color(0xFFdda0dd)),
      _Particle(size.width * 0.9, size.height * 0.8, 1.6, const Color(0xFFb19cd9)),
      _Particle(size.width * 0.2, size.height * 0.7, 1.2, const Color(0xFF8a7fb8)),
      _Particle(size.width * 0.6, size.height * 0.85, 2.0, const Color(0xFFffd700)),
      _Particle(size.width * 0.15, size.height * 0.5, 1.4, const Color(0xFFdda0dd)),
      _Particle(size.width * 0.7, size.height * 0.35, 1.7, const Color(0xFFb19cd9)),
    ];

    for (final particle in particles) {
      paint.color = particle.color.withOpacity(0.3);
      canvas.drawCircle(
        Offset(particle.x, particle.y),
        particle.size * 3,
        paint,
      );

      paint.color = particle.color.withOpacity(0.8);
      canvas.drawCircle(
        Offset(particle.x, particle.y),
        particle.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _Particle {
  final double x;
  final double y;
  final double size;
  final Color color;

  _Particle(this.x, this.y, this.size, this.color);
}
