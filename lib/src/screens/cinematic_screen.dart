import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'persona_creation_screen.dart';
import '../../l10n/app_localizations.dart';

class CinematicScreen extends StatefulWidget {
  const CinematicScreen({super.key});

  @override
  State<CinematicScreen> createState() => _CinematicScreenState();
}

class _CinematicScreenState extends State<CinematicScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  int _currentScene = 0;
  bool _canSkip = true;
  Timer? _sceneTimer;
  bool _isInitialized = false;
  
  late List<Map<String, dynamic>> _scenes;

  @override
  void initState() {
    super.initState();
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    if (!_isInitialized) {
      _isInitialized = true;
      
      // Initialiser les scènes avec les traductions
      _scenes = [
        {
          'title': S.of(context)!.cinematicTitle1,
          'text': S.of(context)!.cinematicText1,
          'subtitle': S.of(context)!.cinematicSubtitle1,
          'duration': 4,
          'color': const Color(0xFF1a0f2e),
          'particles': 20,
        },
        {
          'title': S.of(context)!.cinematicTitle2,
          'text': S.of(context)!.cinematicText2,
          'subtitle': S.of(context)!.cinematicSubtitle2,
          'duration': 5,
          'color': const Color(0xFF4a3a7a),
          'particles': 30,
        },
        {
          'title': S.of(context)!.cinematicTitle3,
          'text': S.of(context)!.cinematicText3,
          'subtitle': S.of(context)!.cinematicSubtitle3,
          'duration': 5,
          'color': const Color(0xFF8B0000),
          'particles': 40,
        },
        {
          'title': S.of(context)!.cinematicTitle4,
          'text': S.of(context)!.cinematicText4,
          'subtitle': S.of(context)!.cinematicSubtitle4,
          'duration': 5,
          'color': const Color(0xFF2d1b4e),
          'particles': 50,
        },
        {
          'title': S.of(context)!.cinematicTitle5,
          'text': S.of(context)!.cinematicText5,
          'subtitle': S.of(context)!.cinematicSubtitle5,
          'duration': 5,
          'color': const Color(0xFF7c5fa8),
          'particles': 35,
        },
        {
          'title': S.of(context)!.cinematicTitle6,
          'text': S.of(context)!.cinematicText6,
          'subtitle': S.of(context)!.cinematicSubtitle6,
          'duration': 6,
          'color': const Color(0xFFFFD700),
          'particles': 60,
          'isFinal': true,
        },
      ];
      
      _startScene();
    }
  }

  @override
  void dispose() {
    _sceneTimer?.cancel();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _startScene() {
    _fadeController.forward(from: 0);
    _slideController.forward(from: 0);
    
    final scene = _scenes[_currentScene];
    final duration = scene['duration'] as int;
    
    _sceneTimer?.cancel();
    _sceneTimer = Timer(Duration(seconds: duration), () {
      if (mounted) {
        _nextScene();
      }
    });
  }

  void _nextScene() async {
    if (!mounted) return;
    
    // Fade out
    await _fadeController.reverse();
    
    if (!mounted) return;
    
    // Vérifier si c'est la dernière scène
    if (_currentScene >= _scenes.length - 1) {
      _goToPersonaCreation();
      return;
    }
    
    // Passer à la scène suivante
    setState(() {
      _currentScene++;
    });
    
    _startScene();
  }

  void _goToPersonaCreation() {
    if (!mounted) return;
    
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const PersonaCreationScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 1000),
      ),
    );
  }

  void _skipCinematic() {
    _sceneTimer?.cancel();
    _goToPersonaCreation();
  }

  @override
  Widget build(BuildContext context) {
    final scene = _scenes[_currentScene];
    final isFinalScene = scene['isFinal'] == true;
    final sceneColor = scene['color'] as Color;
    final particleCount = scene['particles'] as int;
    
    return Scaffold(
      body: GestureDetector(
        onTap: isFinalScene ? null : _nextScene,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 1500),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF0d0617),
                sceneColor.withOpacity(0.6),
                const Color(0xFF0d0617),
              ],
            ),
          ),
          child: Stack(
            children: [
              // Particules d'étoiles animées en arrière-plan
              Positioned.fill(
                child: CustomPaint(
                  painter: _EnhancedStarsPainter(
                    animation: _fadeAnimation,
                    particleCount: particleCount,
                    accentColor: sceneColor,
                  ),
                ),
              ),
              
              // Effet de vignette
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment.center,
                      radius: 1.0,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                ),
              ),
              
              // Contenu principal
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    children: [
                      // Bouton Skip en haut à droite
                      if (_canSkip && !isFinalScene)
                        Align(
                          alignment: Alignment.topRight,
                          child: TextButton.icon(
                            onPressed: _skipCinematic,
                            icon: const Icon(
                              Icons.fast_forward,
                              color: Colors.white54,
                              size: 20,
                            ),
                            label: Text(
                              S.of(context)!.skipCinematic,
                              style: const TextStyle(
                                color: Colors.white54,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      
                      // Contenu centré
                      Expanded(
                        child: Center(
                          child: FadeTransition(
                            opacity: _fadeAnimation,
                            child: SlideTransition(
                              position: _slideAnimation,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Dé cosmique animé au centre
                                  Container(
                                    width: 120,
                                    height: 120,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: RadialGradient(
                                        colors: [
                                          sceneColor.withOpacity(0.8),
                                          sceneColor.withOpacity(0.3),
                                          Colors.transparent,
                                        ],
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: sceneColor.withOpacity(0.6),
                                          blurRadius: 60,
                                          spreadRadius: 20,
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Text(
                                        '🎲',
                                        style: TextStyle(
                                          fontSize: 60,
                                          shadows: [
                                            Shadow(
                                              color: sceneColor,
                                              blurRadius: 20,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 60),
                                  
                                  // Titre avec ligne décorative
                                  Column(
                                    children: [
                                      Container(
                                        height: 2,
                                        width: 60,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.transparent,
                                              sceneColor,
                                              Colors.transparent,
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        scene['title'] as String,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.w900,
                                          color: sceneColor,
                                          letterSpacing: 4,
                                          shadows: [
                                            Shadow(
                                              color: sceneColor.withOpacity(0.5),
                                              blurRadius: 20,
                                            ),
                                            const Shadow(
                                              blurRadius: 10,
                                              color: Colors.black,
                                              offset: Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      Container(
                                        height: 2,
                                        width: 60,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.transparent,
                                              sceneColor,
                                              Colors.transparent,
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 40),
                                  
                                  // Texte principal
                                  Text(
                                    scene['text'] as String,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      height: 1.8,
                                      fontWeight: FontWeight.w300,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  
                                  // Sous-titre
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 16,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        left: BorderSide(
                                          color: sceneColor.withOpacity(0.5),
                                          width: 3,
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      scene['subtitle'] as String,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white.withOpacity(0.8),
                                        height: 1.6,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                                  
                                  // Bouton pour la scène finale
                                  if (isFinalScene) ...[
                                    const SizedBox(height: 48),
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        boxShadow: [
                                          BoxShadow(
                                            color: sceneColor.withOpacity(0.5),
                                            blurRadius: 30,
                                            spreadRadius: 5,
                                          ),
                                        ],
                                      ),
                                      child: ElevatedButton(
                                        onPressed: _goToPersonaCreation,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: sceneColor,
                                          foregroundColor: Colors.black,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 48,
                                            vertical: 20,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(30),
                                          ),
                                          elevation: 0,
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: const [
                                            Icon(Icons.auto_awesome, size: 24),
                                            SizedBox(width: 12),
                                            Text(
                                              'Forger mon destin',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 1,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      
                      // Indicateur de progression
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          _scenes.length,
                          (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: index == _currentScene ? 40 : 10,
                            height: 4,
                            decoration: BoxDecoration(
                              color: index == _currentScene
                                  ? sceneColor
                                  : Colors.white24,
                              borderRadius: BorderRadius.circular(2),
                              boxShadow: index == _currentScene
                                  ? [
                                      BoxShadow(
                                        color: sceneColor.withOpacity(0.5),
                                        blurRadius: 8,
                                      ),
                                    ]
                                  : null,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Instruction
                      if (!isFinalScene)
                        Text(
                          'Appuyez pour continuer',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.4),
                            fontSize: 13,
                            fontStyle: FontStyle.italic,
                            letterSpacing: 1,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// CustomPainter pour les particules animées avec couleur dynamique
class _EnhancedStarsPainter extends CustomPainter {
  final Animation<double> animation;
  final int particleCount;
  final Color accentColor;

  _EnhancedStarsPainter({
    required this.animation,
    required this.particleCount,
    required this.accentColor,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final random = Random(42); // Seed fixe pour cohérence

    // Dessiner des particules colorées dynamiques
    for (int i = 0; i < particleCount; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      
      // Varier la taille et l'opacité
      final opacity = (0.2 + random.nextDouble() * 0.6) * animation.value;
      final particleSize = 1.0 + random.nextDouble() * 3.0;
      
      // Mélange de particules blanches et colorées
      final isColored = random.nextDouble() > 0.6;
      final color = isColored 
          ? accentColor.withOpacity(opacity)
          : Colors.white.withOpacity(opacity * 0.8);
      
      final particlePaint = Paint()
        ..color = color
        ..style = PaintingStyle.fill
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, particleSize * 0.8);
      
      // Dessiner la particule avec effet de glow
      canvas.drawCircle(Offset(x, y), particleSize, particlePaint);
      
      // Ajouter un petit point brillant au centre
      if (isColored && random.nextDouble() > 0.7) {
        final corePaint = Paint()
          ..color = Colors.white.withOpacity(opacity)
          ..style = PaintingStyle.fill;
        canvas.drawCircle(Offset(x, y), particleSize * 0.4, corePaint);
      }
    }
    
    // Ajouter quelques étoiles traditionnelles en arrière-plan
    for (int i = 0; i < 50; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      
      final opacity = (0.1 + random.nextDouble() * 0.3) * animation.value;
      final starPaint = Paint()
        ..color = Colors.white.withOpacity(opacity)
        ..strokeWidth = 0.5;
      
      // Petite croix scintillante
      canvas.drawLine(
        Offset(x - 1, y),
        Offset(x + 1, y),
        starPaint,
      );
      canvas.drawLine(
        Offset(x, y - 1),
        Offset(x, y + 1),
        starPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_EnhancedStarsPainter oldDelegate) => 
      oldDelegate.particleCount != particleCount ||
      oldDelegate.accentColor != accentColor;
}