import 'package:flutter/material.dart';
import '../models/character.dart';
import '../models/persona.dart';
import '../services/game_data_service.dart';
import 'game_hub_screen.dart';

class PersonaCreationScreen extends StatefulWidget {
  const PersonaCreationScreen({super.key});

  @override
  State<PersonaCreationScreen> createState() => _PersonaCreationScreenState();
}

class _PersonaCreationScreenState extends State<PersonaCreationScreen> {
  int _currentStep = 0;
  final TextEditingController _nameController = TextEditingController();
  
  PersonaRace? _selectedRace;
  PersonaRegion? _selectedRegion;
  PersonaOrigin? _selectedOrigin;
  PersonaClass? _selectedClass;
  
  bool _isCreating = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  bool get _canProceed {
    switch (_currentStep) {
      case 0:
        return _nameController.text.trim().isNotEmpty;
      case 1:
        return _selectedRace != null;
      case 2:
        return _selectedRegion != null;
      case 3:
        return _selectedOrigin != null;
      case 4:
        return _selectedClass != null;
      default:
        return false;
    }
  }

  void _nextStep() {
    if (_canProceed) {
      if (_currentStep < 4) {
        setState(() => _currentStep++);
      } else {
        _createCharacter();
      }
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
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

      final stats = CharacterStats(
        maxHp: 100,
        attack: 15,
        defense: 10,
        speed: 12,
        magic: 8,
        luck: 10,
      );

      final character = Character(
        name: _nameController.text.trim(),
        persona: persona,
        stats: stats,
        appearance: CharacterAppearance.fromRace(_selectedRace!),
        isInTeam: true,      // Premier personnage dans l'équipe
        teamPosition: 1,      // Position principale
      );

      // Créer le profil Player si il n'existe pas
      final hasProfile = await GameDataService.hasProfile();
      if (!hasProfile) {
        await GameDataService.createPlayer(_nameController.text.trim());
      }

      // Créer le personnage
      await GameDataService.createCharacter(character);
      
      // Récupérer le player pour naviguer
      final player = await GameDataService.getPlayer();

      if (mounted && player != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => GameHubScreen(
              player: player,
              character: character,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isCreating = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0D1421), Color(0xFF16213E), Color(0xFF0F3460)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              _buildProgressBar(),
              Expanded(
                child: _buildCurrentStep(),
              ),
              _buildNavigationButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final titles = [
      'Votre Nom',
      'Votre Race',
      'Votre Région d\'Origine',
      'Votre Statut Social',
      'Votre Classe',
    ];

    final subtitles = [
      'Comment vous appellera-t-on ?',
      'Quelle est votre nature ?',
      'D\'où venez-vous ?',
      'Quelle est votre origine ?',
      'Quelle voie suivez-vous ?',
    ];

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text(
            titles[_currentStep],
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            subtitles[_currentStep],
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.7),
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
          if (_currentStep > 0) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.withOpacity(0.5)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 20),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      'Ce choix définira votre histoire principale',
                      style: TextStyle(
                        color: Colors.orange.shade200,
                        fontSize: 13,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: List.generate(5, (index) {
          return Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              height: 4,
              decoration: BoxDecoration(
                color: index <= _currentStep
                    ? Colors.cyan
                    : Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _buildNameStep();
      case 1:
        return _buildRaceStep();
      case 2:
        return _buildRegionStep();
      case 3:
        return _buildOriginStep();
      case 4:
        return _buildClassStep();
      default:
        return Container();
    }
  }

  Widget _buildNameStep() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '✨',
              style: TextStyle(fontSize: 80),
            ),
            const SizedBox(height: 40),
            TextField(
              controller: _nameController,
              autofocus: true,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              decoration: InputDecoration(
                hintText: 'Entrez votre nom...',
                hintStyle: TextStyle(
                  color: Colors.white.withOpacity(0.3),
                ),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.cyan.withOpacity(0.5)),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.cyan, width: 2),
                ),
              ),
              onChanged: (value) => setState(() {}),
              onSubmitted: (value) {
                if (_canProceed) _nextStep();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRaceStep() {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: PersonaRace.values.map((race) {
        final isSelected = _selectedRace == race;
        return _buildChoiceCard(
          emoji: race.emoji,
          title: race.displayName,
          description: race.description,
          isSelected: isSelected,
          onTap: () => setState(() => _selectedRace = race),
        );
      }).toList(),
    );
  }

  Widget _buildRegionStep() {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: PersonaRegion.values.map((region) {
        final isSelected = _selectedRegion == region;
        return _buildChoiceCard(
          emoji: region.emoji,
          title: region.displayName,
          description: region.description,
          isSelected: isSelected,
          onTap: () => setState(() => _selectedRegion = region),
        );
      }).toList(),
    );
  }

  Widget _buildOriginStep() {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: PersonaOrigin.values.map((origin) {
        final isSelected = _selectedOrigin == origin;
        return _buildChoiceCard(
          emoji: origin.emoji,
          title: origin.displayName,
          description: origin.description,
          isSelected: isSelected,
          onTap: () => setState(() => _selectedOrigin = origin),
        );
      }).toList(),
    );
  }

  Widget _buildClassStep() {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: PersonaClass.values.map((cls) {
        final isSelected = _selectedClass == cls;
        return _buildChoiceCard(
          emoji: cls.emoji,
          title: cls.displayName,
          description: cls.description,
          isSelected: isSelected,
          onTap: () => setState(() => _selectedClass = cls),
        );
      }).toList(),
    );
  }

  Widget _buildChoiceCard({
    required String emoji,
    required String title,
    required String description,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.cyan.withOpacity(0.2)
              : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Colors.cyan : Colors.white.withOpacity(0.1),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Text(
              emoji,
              style: const TextStyle(fontSize: 40),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.cyan : Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.7),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: Colors.cyan, size: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: _previousStep,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: Colors.white30),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Retour',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          if (_currentStep > 0) const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: _canProceed && !_isCreating ? _nextStep : null,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.cyan,
                disabledBackgroundColor: Colors.grey.shade800,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isCreating
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      _currentStep == 4 ? 'Commencer l\'aventure' : 'Continuer',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
