import 'package:flutter/material.dart';
import '../models/persona.dart';
import '../models/character.dart';
import '../services/character_factory.dart';
import '../services/game_data_service.dart';
import '../widgets/game_navbar.dart';

class PersonaCreationScreen extends StatefulWidget {
  const PersonaCreationScreen({super.key});

  @override
  State<PersonaCreationScreen> createState() => _PersonaCreationScreenState();
}

class _PersonaCreationScreenState extends State<PersonaCreationScreen> {
  final TextEditingController _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  PersonaRace _selectedRace = PersonaRace.human;
  PersonaRegion _selectedRegion = PersonaRegion.west;
  PersonaOrigin _selectedOrigin = PersonaOrigin.noble;
  PersonaClass _selectedClass = PersonaClass.warrior;
  
  bool _isCreating = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _createCharacter() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isCreating = true);
    
    try {
      final persona = Persona(
        race: _selectedRace,
        region: _selectedRegion,
        origin: _selectedOrigin,
        characterClass: _selectedClass,
      );
      
      // Créer le personnage via la factory
      final character = CharacterFactory.createFromPersona(
        persona,
        _nameController.text.trim(),
      );
      
      // Créer le profil joueur si nécessaire
      final hasProfile = await GameDataService.hasProfile();
      if (!hasProfile) {
        await GameDataService.createPlayer(_nameController.text.trim());
      }
      
      // Sauvegarder le personnage
      await GameDataService.createCharacter(character);
      
      if (!mounted) return;
      
      // Naviguer vers le jeu
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const GameNavbar()),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de la création : $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isCreating = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Créer votre personnage'),
        backgroundColor: Colors.deepPurple,
      ),
      body: _isCreating
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Nom du personnage
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Nom du personnage',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _nameController,
                              decoration: const InputDecoration(
                                hintText: 'Entrez un nom...',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Le nom est requis';
                                }
                                if (value.trim().length < 3) {
                                  return 'Le nom doit contenir au moins 3 caractères';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Race
                    _buildSelectionCard<PersonaRace>(
                      title: 'Race',
                      value: _selectedRace,
                      items: PersonaRace.values,
                      onChanged: (value) => setState(() => _selectedRace = value),
                      itemBuilder: (race) => _PersonaOption(
                        emoji: race.emoji,
                        title: race.displayName,
                        description: race.description,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Région
                    _buildSelectionCard<PersonaRegion>(
                      title: 'Région',
                      value: _selectedRegion,
                      items: PersonaRegion.values,
                      onChanged: (value) => setState(() => _selectedRegion = value),
                      itemBuilder: (region) => _PersonaOption(
                        emoji: region.emoji,
                        title: region.displayName,
                        description: region.description,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Origine
                    _buildSelectionCard<PersonaOrigin>(
                      title: 'Origine',
                      value: _selectedOrigin,
                      items: PersonaOrigin.values,
                      onChanged: (value) => setState(() => _selectedOrigin = value),
                      itemBuilder: (origin) => _PersonaOption(
                        emoji: origin.emoji,
                        title: origin.displayName,
                        description: origin.description,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Classe
                    _buildSelectionCard<PersonaClass>(
                      title: 'Classe',
                      value: _selectedClass,
                      items: PersonaClass.values,
                      onChanged: (value) => setState(() => _selectedClass = value),
                      itemBuilder: (cls) => _PersonaOption(
                        emoji: cls.emoji,
                        title: cls.displayName,
                        description: cls.description,
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Bouton de création
                    ElevatedButton(
                      onPressed: _createCharacter,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'Créer le personnage',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildSelectionCard<T>({
    required String title,
    required T value,
    required List<T> items,
    required ValueChanged<T> onChanged,
    required Widget Function(T) itemBuilder,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...items.map((item) {
              final isSelected = item == value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: InkWell(
                  onTap: () => onChanged(item),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.deepPurple.withOpacity(0.1)
                          : Colors.grey.withOpacity(0.05),
                      border: Border.all(
                        color: isSelected
                            ? Colors.deepPurple
                            : Colors.grey.withOpacity(0.3),
                        width: isSelected ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: itemBuilder(item),
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}

class _PersonaOption extends StatelessWidget {
  final String emoji;
  final String title;
  final String description;

  const _PersonaOption({
    required this.emoji,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          emoji,
          style: const TextStyle(fontSize: 32),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}