import 'package:flutter/material.dart';
import '../models/player.dart';
import '../models/preset_character.dart';
import '../models/character.dart';
import '../models/codex_entry.dart';
import '../data/fe.dart';
import '../services/game_data_service.dart';

class CodexScreen extends StatefulWidget {
  const CodexScreen({super.key});

  @override
  State<CodexScreen> createState() => _CodexScreenState();
}

class _CodexScreenState extends State<CodexScreen> {
  Player? _player;
  bool _isLoading = true;
  String _filterRarity = 'all';
  String _sortBy = 'name';
  bool _showUnlockedOnly = false;

  @override
  void initState() {
    super.initState();
    _loadPlayer();
  }

  Future<void> _loadPlayer() async {
    final player = await GameDataService.getPlayer();
    if (mounted) {
      setState(() {
        _player = player;
        _isLoading = false;
      });
    }
  }

  List<PresetCharacter> get _allCharacters => CharacterDatabase.allCharacters;

  List<PresetCharacter> get _filteredCharacters {
    var characters = _allCharacters;

    // Filtre par rareté
    if (_filterRarity != 'all') {
      characters = characters.where((preset) {
        if (_filterRarity == 'legendary' && preset.rarity == CharacterRarity.legendary) return true;
        if (_filterRarity == 'epic' && preset.rarity == CharacterRarity.epic) return true;
        if (_filterRarity == 'rare' && preset.rarity == CharacterRarity.rare) return true;
        if (_filterRarity == 'common' && preset.rarity == CharacterRarity.common) return true;
        return false;
      }).toList();
    }

    // Filtre par débloqué
    if (_showUnlockedOnly) {
      characters = characters.where((preset) {
        return _player?.codex.containsKey(preset.name) ?? false;
      }).toList();
    }

    // Tri
    switch (_sortBy) {
      case 'name':
        characters.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'unlocks':
        characters.sort((a, b) {
          final aEntry = _player?.codex[a.name];
          final bEntry = _player?.codex[b.name];
          return (bEntry?.unlockCount ?? 0).compareTo(aEntry?.unlockCount ?? 0);
        });
        break;
      case 'battles':
        characters.sort((a, b) {
          final aEntry = _player?.codex[a.name];
          final bEntry = _player?.codex[b.name];
          return (bEntry?.totalBattles ?? 0).compareTo(aEntry?.totalBattles ?? 0);
        });
        break;
    }

    return characters;
  }

  Color _getRarityColor(PresetCharacter preset) {
    switch (preset.rarity) {
      case CharacterRarity.legendary:
        return Colors.purple;
      case CharacterRarity.epic:
        return Colors.blue;
      case CharacterRarity.rare:
        return Colors.green;
      case CharacterRarity.common:
        return Colors.grey;
    }
  }

  String _getRarityLabel(PresetCharacter preset) {
    switch (preset.rarity) {
      case CharacterRarity.legendary:
        return '🌟 Légendaire';
      case CharacterRarity.epic:
        return '🟪 Épique';
      case CharacterRarity.rare:
        return '🟩 Rare';
      case CharacterRarity.common:
        return '⬜ Commun';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Codex des Héros')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final totalCharacters = _allCharacters.length;
    final unlockedCharacters = _player?.totalCharactersUnlocked ?? 0;
    final completion = _player?.codexCompletion(totalCharacters) ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Codex des Héros'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Container(
            padding: const EdgeInsets.all(16),
            color: Colors.black.withOpacity(0.1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      '$unlockedCharacters / $totalCharacters',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const Text('Héros Obtenus', style: TextStyle(fontSize: 12)),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      '${completion.toStringAsFixed(1)}%',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.amber),
                    ),
                    const Text('Complétion', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Filtres et tri
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.grey.shade900,
            child: Column(
              children: [
                Row(
                  children: [
                    // Filtre par rareté
                    Expanded(
                      child: DropdownButton<String>(
                        value: _filterRarity,
                        isExpanded: true,
                        items: const [
                          DropdownMenuItem(value: 'all', child: Text('🎯 Toutes Raretés')),
                          DropdownMenuItem(value: 'legendary', child: Text('🌟 Légendaire')),
                          DropdownMenuItem(value: 'epic', child: Text('🟪 Épique')),
                          DropdownMenuItem(value: 'rare', child: Text('🟩 Rare')),
                          DropdownMenuItem(value: 'common', child: Text('⬜ Commun')),
                        ],
                        onChanged: (value) {
                          setState(() => _filterRarity = value!);
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Tri
                    Expanded(
                      child: DropdownButton<String>(
                        value: _sortBy,
                        isExpanded: true,
                        items: const [
                          DropdownMenuItem(value: 'name', child: Text('📝 Nom')),
                          DropdownMenuItem(value: 'unlocks', child: Text('🔓 Obtentions')),
                          DropdownMenuItem(value: 'battles', child: Text('⚔️ Combats')),
                        ],
                        onChanged: (value) {
                          setState(() => _sortBy = value!);
                        },
                      ),
                    ),
                  ],
                ),
                // Toggle débloqués seulement
                CheckboxListTile(
                  title: const Text('Héros obtenus uniquement'),
                  value: _showUnlockedOnly,
                  onChanged: (value) {
                    setState(() => _showUnlockedOnly = value ?? false);
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                  dense: true,
                ),
              ],
            ),
          ),

          // Liste des personnages
          Expanded(
            child: _filteredCharacters.isEmpty
                ? const Center(
                    child: Text(
                      'Aucun héros trouvé',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: _filteredCharacters.length,
                    itemBuilder: (context, index) {
                      final preset = _filteredCharacters[index];
                      final entry = _player?.codex[preset.name];
                      final isUnlocked = entry != null && entry.unlockCount > 0;

                      return _buildCharacterCard(preset, entry, isUnlocked);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCharacterCard(PresetCharacter preset, CodexEntry? entry, bool isUnlocked) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      color: isUnlocked ? Colors.grey.shade800 : Colors.grey.shade900.withOpacity(0.5),
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          backgroundColor: _getRarityColor(preset),
          backgroundImage: AssetImage(preset.headshot),
        ),
        title: Text(
          isUnlocked ? preset.name : '???',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isUnlocked ? Colors.white : Colors.grey,
          ),
        ),
        subtitle: isUnlocked
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.star, size: 14, color: _getRarityColor(preset)),
                      const SizedBox(width: 4),
                      Text(
                        _getRarityLabel(preset),
                        style: TextStyle(color: _getRarityColor(preset), fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text('${preset.persona.characterClass.displayName} • ${preset.persona.region.displayName}'),
                  const SizedBox(height: 4),
                  Text(
                    '🔓 ${entry!.unlockCount} fois • ⚔️ ${entry.totalBattles} combats • ⬆️ Niv.${entry.maxLevel}',
                    style: const TextStyle(fontSize: 11, color: Colors.amber),
                  ),
                ],
              )
            : const Text(
                'Héros non obtenu',
                style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
              ),
        trailing: isUnlocked
            ? Icon(Icons.chevron_right, color: _getRarityColor(preset))
            : const Icon(Icons.lock, color: Colors.grey),
        onTap: isUnlocked
            ? () => _showCharacterDetail(preset, entry!)
            : null,
      ),
    );
  }

  void _showCharacterDetail(PresetCharacter preset, CodexEntry entry) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: _getRarityColor(preset),
              backgroundImage: AssetImage(preset.headshot),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(preset.name),
                  Row(
                    children: [
                      Text(
                        _getRarityLabel(preset),
                        style: TextStyle(
                          fontSize: 14,
                          color: _getRarityColor(preset),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('⚡ ${preset.persona.characterClass.displayName}'),
              Text('🌍 ${preset.persona.region.displayName}'),
              const Divider(),
              Text('🔓 Obtenu ${entry.unlockCount} fois'),
              Text('⚔️ ${entry.totalBattles} combats livrés'),
              Text('⬆️ Niveau maximum atteint: ${entry.maxLevel}'),
              const Divider(),
              Text('📅 Première obtention: ${_formatDate(entry.firstUnlock)}'),
              Text('📅 Dernière obtention: ${_formatDate(entry.lastUnlock)}'),
              const Divider(),
              const Text('📊 Statistiques de base:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('❤️ PV: ${preset.baseStats['maxHp'] ?? 100}'),
              Text('⚔️ ATK: ${preset.baseStats['attack'] ?? 10}'),
              Text('🛡️ DEF: ${preset.baseStats['defense'] ?? 8}'),
              Text('⚡ SPD: ${preset.baseStats['speed'] ?? 6}'),
              Text('🎯 LUCK: ${preset.baseStats['luck'] ?? 5}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
