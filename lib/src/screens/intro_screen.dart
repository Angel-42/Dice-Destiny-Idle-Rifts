import 'package:flutter/material.dart';
import 'persona_creation_screen.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  int _currentPage = 0;
  final PageController _pageController = PageController();

  final List<LorePage> _pages = [
    LorePage(
      text: 'Dans un univers où le destin lui-même est dicté par les dés cosmiques...',
      gradient: [Color(0xFF0D1421), Color(0xFF1A1A2E)],
    ),
    LorePage(
      text: 'Les Rifts, des failles dimensionnelles, déchirent la réalité et menacent l\'équilibre des mondes.',
      gradient: [Color(0xFF1A1A2E), Color(0xFF16213E)],
    ),
    LorePage(
      text: 'Les dés anciens, porteurs du pouvoir primordial, sont les seuls artefacts capables de sceller ces brèches.',
      gradient: [Color(0xFF16213E), Color(0xFF0F3460)],
    ),
    LorePage(
      text: 'Mais attention... chaque lancer de dé, chaque choix que vous faites, sculpte irrémédiablement votre destinée.',
      gradient: [Color(0xFF0F3460), Color(0xFF533483)],
    ),
    LorePage(
      text: 'Votre parcours commence maintenant.\nQui êtes-vous dans ce monde en péril ?',
      gradient: [Color(0xFF533483), Color(0xFF2C1A4D)],
      isLast: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _navigateToPersonaCreation();
    }
  }

  void _navigateToPersonaCreation() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const PersonaCreationScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 800),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: _nextPage,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 800),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: _pages[_currentPage].gradient,
            ),
          ),
          child: SafeArea(
            child: Stack(
              children: [
                // Étoiles de fond
                ...List.generate(50, (index) => _buildStar(index)),
                
                // Contenu principal
                PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                    _controller.reset();
                    _controller.forward();
                  },
                  itemCount: _pages.length,
                  itemBuilder: (context, index) {
                    return _buildPage(_pages[index]);
                  },
                ),
                
                // Indicateur de page en bas
                Positioned(
                  bottom: 40,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      _buildPageIndicator(),
                      const SizedBox(height: 20),
                      Text(
                        _pages[_currentPage].isLast ? 'Touchez pour commencer' : 'Touchez pour continuer',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStar(int index) {
    final random = (index * 123) % 100;
    return Positioned(
      left: (random * 3.7) % MediaQuery.of(context).size.width,
      top: (random * 7.3) % MediaQuery.of(context).size.height,
      child: Container(
        width: 2,
        height: 2,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity((random % 10) / 20),
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  Widget _buildPage(LorePage page) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (page.isLast) ...[
                const Text(
                  '🎲',
                  style: TextStyle(fontSize: 80),
                ),
                const SizedBox(height: 40),
              ],
              Text(
                page.text,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w300,
                  color: Colors.white,
                  height: 1.8,
                  letterSpacing: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _pages.length,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: _currentPage == index ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: _currentPage == index
                ? Colors.white
                : Colors.white24,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}

class LorePage {
  final String text;
  final List<Color> gradient;
  final bool isLast;

  LorePage({
    required this.text,
    required this.gradient,
    this.isLast = false,
  });
}
