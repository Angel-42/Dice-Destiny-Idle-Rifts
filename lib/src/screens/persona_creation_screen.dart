import 'package:flutter/material.dart';
import 'dart:math';
import '../models/persona.dart';
import '../services/character_factory.dart';
import '../services/game_data_service.dart';
import '../widgets/game_navbar.dart';

class PersonaCreationScreen extends StatefulWidget {
  const PersonaCreationScreen({super.key});

  @override
  State<PersonaCreationScreen> createState() => _PersonaCreationScreenState();
}

class _PersonaCreationScreenState extends State<PersonaCreationScreen> 
    with TickerProviderStateMixin {
  
  // Controllers
  final TextEditingController _nameController = TextEditingController();
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  // État de la création
  int _currentStep = 0;
  PersonaRace? _selectedRace;
  PersonaRegion? _selectedRegion;
  PersonaOrigin? _selectedOrigin;
  PersonaClass? _selectedClass;
  bool _isCreating = false;

  // Étapes du processus
  final List<String> _stepTitles = [
    'VOTRE NOM',
    'VOTRE RACE',
    'VOTRE RÉGION',
    'VOTRE ORIGINE',
    'VOTRE CLASSE',
    'CONFIRMATION',
  ];

  @override
  void initState() {
    super.initState();
    
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.3, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );
    
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < _stepTitles.length - 1) {
      setState(() {
        _currentStep++;
      });
      
      // Relancer les animations
      _fadeController.reset();
      _slideController.reset();
      _fadeController.forward();
      _slideController.forward();
    } else {
      _createCharacter();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      
      // Relancer les animations
      _fadeController.reset();
      _slideController.reset();
      _fadeController.forward();
      _slideController.forward();
    }
  }

  bool _canProceed() {
    switch (_currentStep) {
      case 0:
        final name = _nameController.text.trim();
        if (name.length < 3) return false;
        int uppercase = name.replaceAll(RegExp(r'[^A-Z]'), '').length;
        int lowercase = name.replaceAll(RegExp(r'[^a-z]'), '').length;
        int total = name.length;
        if (uppercase == 0 && lowercase == total) {
          return total <= 11;
        }
        if (lowercase == 0 && uppercase == total) {
          return total <= 8;
        }
        final maxAllowed = 11 - (uppercase * 0.375).round();
        return total <= maxAllowed;
      case 1:
        return _selectedRace != null;
      case 2:
        return _selectedRegion != null;
      case 3:
        return _selectedOrigin != null;
      case 4:
        return _selectedClass != null;
      case 5:
        return true;
      default:
        return false;
    }
  }

  Future<void> _createCharacter() async {
    setState(() => _isCreating = true);
    
    try {
      final persona = Persona(
        race: _selectedRace!,
        region: _selectedRegion!,
        origin: _selectedOrigin!,
        characterClass: _selectedClass!,
      );
      
      final character = CharacterFactory.createFromPersona(
        persona,
        _nameController.text.trim(),
      );
      
      // L'utilisateur est déjà authentifié via le Welcome Screen
      
      final hasProfile = await GameDataService.hasProfile();
      if (!hasProfile) {
        await GameDataService.createPlayer(character.name);
      }
      
      await GameDataService.createCharacter(character);
      
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const GameNavbar()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isCreating = false);
      }
    }
  }

  Color _getStepColor() {
    switch (_currentStep) {
      case 0: return const Color(0xFF9C27B0); // Purple
      case 1: return const Color(0xFF2196F3); // Blue
      case 2: return const Color(0xFF4CAF50); // Green
      case 3: return const Color(0xFFFF9800); // Orange
      case 4: return const Color(0xFFF44336); // Red
      case 5: return const Color(0xFFFFD700); // Gold
      default: return Colors.purple;
    }
  }

  @override
  Widget build(BuildContext context) {
    final stepColor = _getStepColor();
    
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 1000),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF0d0617),
              stepColor.withOpacity(0.3),
              const Color(0xFF0d0617),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Particules en arrière-plan
            Positioned.fill(
              child: CustomPaint(
                painter: _ParticlesPainter(
                  animation: _fadeAnimation,
                  color: stepColor,
                ),
              ),
            ),
            
            // Contenu principal
            SafeArea(
              child: Column(
                children: [
                  // En-tête avec progression
                  _buildHeader(stepColor),
                  
                  // Contenu de l'étape
                  Expanded(
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: _buildStepContent(stepColor),
                      ),
                    ),
                  ),
                  
                  // Boutons de navigation
                  _buildNavigationButtons(stepColor),
                ],
              ),
            ),
            
            // Overlay de chargement
            if (_isCreating)
              Container(
                color: Colors.black87,
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Colors.amber,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(Color stepColor) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Titre de l'étape
          Text(
            _stepTitles[_currentStep],
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: stepColor,
              letterSpacing: 3,
              shadows: [
                Shadow(
                  color: stepColor.withOpacity(0.5),
                  blurRadius: 20,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          // Indicateur de progression
          Row(
            children: List.generate(
              _stepTitles.length,
              (index) => Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  height: 4,
                  decoration: BoxDecoration(
                    color: index <= _currentStep
                        ? stepColor
                        : Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(2),
                    boxShadow: index == _currentStep
                        ? [
                            BoxShadow(
                              color: stepColor.withOpacity(0.5),
                              blurRadius: 8,
                            ),
                          ]
                        : null,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          
          // Message d'avertissement
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(
                color: stepColor.withOpacity(0.3),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.auto_awesome,
                  color: stepColor,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Vos choix façonneront votre destin',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepContent(Color stepColor) {
    switch (_currentStep) {
      case 0:
        return _buildNameStep(stepColor);
      case 1:
        return _buildRaceStep(stepColor);
      case 2:
        return _buildRegionStep(stepColor);
      case 3:
        return _buildOriginStep(stepColor);
      case 4:
        return _buildClassStep(stepColor);
      case 5:
        return _buildConfirmationStep(stepColor);
      default:
        return const SizedBox();
    }
  }

  Widget _buildNameStep(Color stepColor) {
    // Calculer la limite dynamique
    final name = _nameController.text.trim();
    int uppercase = name.replaceAll(RegExp(r'[^A-Z]'), '').length;
    int lowercase = name.replaceAll(RegExp(r'[^a-z]'), '').length;
    int total = name.length;
    int maxAllowed;
    String hint;
    if (uppercase == 0 && lowercase == total) {
      maxAllowed = 11;
      hint = 'Minuscules uniquement : max 11 caractères';
    } else if (lowercase == 0 && uppercase == total) {
      maxAllowed = 8;
      hint = 'Majuscules uniquement : max 8 caractères';
    } else {
      maxAllowed = 11 - (uppercase * 0.375).round();
      hint = 'Mélange : max $maxAllowed caractères';
    }
    final isValid = total >= 3 && total <= maxAllowed;
    final counterColor = isValid ? Colors.green : Colors.red;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 40),
          Text(
            '✨',
            style: const TextStyle(fontSize: 60),
          ),
          const SizedBox(height: 32),
          Text(
            'Comment vous nomme-t-on dans les légendes ?',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 40),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: stepColor.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Column(
              children: [
                TextField(
                  controller: _nameController,
                  onChanged: (_) => setState(() {}),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: 'Votre nom',
                    hintStyle: TextStyle(
                      color: Colors.white.withOpacity(0.3),
                      fontWeight: FontWeight.normal,
                    ),
                    border: InputBorder.none,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isValid ? Icons.check_circle : Icons.error,
                      color: counterColor,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '$total / $maxAllowed',
                      style: TextStyle(
                        color: counterColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
              ),
            ),
            child: Column(
              children: [
                Text(
                  'Minimum 3 caractères',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRaceStep(Color stepColor) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text(
            'Quelle est votre nature ?',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 32),
          ...PersonaRace.values.map((race) => _buildChoiceCard(
            title: race.displayName,
            description: race.description,
            emoji: race.emoji,
            isSelected: _selectedRace == race,
            color: stepColor,
            onTap: () => setState(() => _selectedRace = race),
          )),
        ],
      ),
    );
  }

  Widget _buildRegionStep(Color stepColor) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text(
            'D\'où venez-vous ?',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 32),
          ...PersonaRegion.values.map((region) => _buildChoiceCard(
            title: region.displayName,
            description: region.description,
            emoji: region.emoji,
            isSelected: _selectedRegion == region,
            color: stepColor,
            onTap: () => setState(() => _selectedRegion = region),
          )),
        ],
      ),
    );
  }

  Widget _buildOriginStep(Color stepColor) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text(
            'Quelle est votre histoire ?',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 32),
          ...PersonaOrigin.values.map((origin) => _buildChoiceCard(
            title: origin.displayName,
            description: origin.description,
            emoji: origin.emoji,
            isSelected: _selectedOrigin == origin,
            color: stepColor,
            onTap: () => setState(() => _selectedOrigin = origin),
          )),
        ],
      ),
    );
  }

  Widget _buildClassStep(Color stepColor) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text(
            'Quelle voie empruntez-vous ?',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 32),
          ...PersonaClass.values.map((characterClass) => _buildChoiceCard(
            title: characterClass.displayName,
            description: characterClass.description,
            emoji: characterClass.emoji,
            isSelected: _selectedClass == characterClass,
            color: stepColor,
            onTap: () => setState(() => _selectedClass = characterClass),
          )),
        ],
      ),
    );
  }

  Widget _buildConfirmationStep(Color stepColor) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Text(
            '🎲',
            style: const TextStyle(fontSize: 80),
          ),
          const SizedBox(height: 32),
          Text(
            'Votre légende est prête à s\'écrire',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: stepColor,
            ),
          ),
          const SizedBox(height: 40),
          
          // Résumé
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.4),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: stepColor.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Column(
              children: [
                _buildSummaryRow('Nom', _nameController.text.trim()),
                const Divider(color: Colors.white24, height: 32),
                _buildSummaryRow('Race', _selectedRace!.displayName),
                const Divider(color: Colors.white24, height: 32),
                _buildSummaryRow('Région', _selectedRegion!.displayName),
                const Divider(color: Colors.white24, height: 32),
                _buildSummaryRow('Origine', _selectedOrigin!.displayName),
                const Divider(color: Colors.white24, height: 32),
                _buildSummaryRow('Classe', _selectedClass!.displayName),
              ],
            ),
          ),
          const SizedBox(height: 32),
          
          // Avertissement final
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border.all(
                color: stepColor,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: stepColor,
                  size: 32,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'Ces choix sont définitifs et influenceront votre parcours dans les Rifts',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: 14,
            fontWeight: FontWeight.w300,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildChoiceCard({
    required String title,
    required String description,
    required String emoji,
    required bool isSelected,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withOpacity(0.2)
              : Colors.black.withOpacity(0.3),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? color : Colors.white.withOpacity(0.2),
            width: isSelected ? 3 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.4),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            // Emoji
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: isSelected
                    ? color.withOpacity(0.2)
                    : Colors.white.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  emoji,
                  style: const TextStyle(fontSize: 32),
                ),
              ),
            ),
            const SizedBox(width: 20),
            
            // Texte
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? color : Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withOpacity(0.7),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            
            // Checkmark
            if (isSelected)
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 20,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationButtons(Color stepColor) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          // Bouton Retour
          if (_currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: _previousStep,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: BorderSide(color: Colors.white.withOpacity(0.3)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.arrow_back, size: 18),
                    SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        'Retour',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          
          if (_currentStep > 0) const SizedBox(width: 12),
          
          // Bouton Suivant/Continuer
          Expanded(
            flex: _currentStep == 0 ? 1 : 1,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: _canProceed()
                    ? [
                        BoxShadow(
                          color: stepColor.withOpacity(0.5),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ]
                    : null,
              ),
              child: ElevatedButton(
                onPressed: _canProceed() ? _nextStep : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: stepColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                  disabledBackgroundColor: Colors.white.withOpacity(0.1),
                  disabledForegroundColor: Colors.white.withOpacity(0.3),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        _currentStep == _stepTitles.length - 1
                            ? 'Forger mon destin'
                            : 'Continuer',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(
                      _currentStep == _stepTitles.length - 1
                          ? Icons.auto_awesome
                          : Icons.arrow_forward,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ParticlesPainter extends CustomPainter {
  final Animation<double> animation;
  final Color color;

  _ParticlesPainter({
    required this.animation,
    required this.color,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final random = Random(123);

    for (int i = 0; i < 30; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final particleSize = 1.0 + random.nextDouble() * 2.0;
      final opacity = (0.2 + random.nextDouble() * 0.4) * animation.value;

      final paint = Paint()
        ..color = color.withOpacity(opacity)
        ..style = PaintingStyle.fill
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, particleSize);

      canvas.drawCircle(Offset(x, y), particleSize, paint);
    }
  }

  @override
  bool shouldRepaint(_ParticlesPainter oldDelegate) => 
      oldDelegate.color != color;
}
