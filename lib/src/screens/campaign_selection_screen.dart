import 'package:flutter/material.dart';
import '../models/campaign_data.dart';
import '../models/character.dart';
import '../data/campaign_database.dart';
import '../services/game_data_service.dart';
import 'campaign_screen.dart';

/// Écran de sélection des stages de campagne
class CampaignSelectionScreen extends StatefulWidget {
  const CampaignSelectionScreen({super.key});

  @override
  State<CampaignSelectionScreen> createState() => _CampaignSelectionScreenState();
}

class _CampaignSelectionScreenState extends State<CampaignSelectionScreen> {
  double currentStageId = 1.01; // Stage débloqué actuel (depuis les saves)
  List<Character> team = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => isLoading = true);
    
    // Charger l'équipe
    team = await GameDataService.getTeamCharacters();
    
    // Charger la progression (depuis Player.storyChapter)
    final player = await GameDataService.getPlayer();
    if (player != null) {
      currentStageId = player.storyChapter.toDouble();
    }
    
    setState(() => isLoading = false);
  }

  void _startStage(CampaignStage stage) async {
    if (team.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vous devez avoir au moins un personnage dans votre équipe !'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Naviguer vers l'écran de combat avec le stage sélectionné
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => CampaignScreen(
          team: team,
          stage: stage,
        ),
      ),
    );

    // Si le stage est terminé avec succès
    if (result == true) {
      // Progression vers le stage suivant
      final nextStage = CampaignDatabase.getNextStage(stage.stageId);
      if (nextStage != null) {
        setState(() {
          currentStageId = nextStage.stageId;
        });
        
        // Sauvegarder la progression
        final player = await GameDataService.getPlayer();
        if (player != null) {
          final updatedPlayer = player.copyWith(storyChapter: nextStage.stageId.toDouble());
          await GameDataService.savePlayer(updatedPlayer);
        }
      }
    }

    // Recharger les données après retour
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF1A237E),
              Color(0xFF311B92),
              Colors.black,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: CampaignDatabase.chapters.length,
                  itemBuilder: (context, index) {
                    final chapter = CampaignDatabase.chapters[index];
                    return _buildChapterCard(chapter);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        border: Border(
          bottom: BorderSide(
            color: Colors.amber.withOpacity(0.3),
            width: 2,
          ),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'CAMPAGNE',
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Sélectionnez votre mission',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChapterCard(CampaignChapter chapter) {
    final currentChapter = currentStageId.floor();
    final isUnlocked = chapter.chapterNumber <= currentChapter;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: Colors.black.withOpacity(0.6),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: chapter.chapterNumber == currentChapter,
          leading: Icon(
            _getChapterIcon(chapter.theme),
            color: isUnlocked ? Colors.amber : Colors.grey,
            size: 32,
          ),
          title: Row(
            children: [
              Text(
                'Chapitre ${chapter.chapterNumber}',
                style: TextStyle(
                  color: isUnlocked ? Colors.amber : Colors.grey,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (!isUnlocked) ...[
                const SizedBox(width: 8),
                const Icon(Icons.lock, color: Colors.grey, size: 16),
              ],
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                chapter.chapterName,
                style: TextStyle(
                  color: isUnlocked ? Colors.white : Colors.grey,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                chapter.description,
                style: TextStyle(
                  color: isUnlocked ? Colors.white60 : Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          children: isUnlocked
              ? chapter.stages.map((stage) => _buildStageItem(stage)).toList()
              : [
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'Terminez le chapitre précédent pour débloquer',
                      style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
                    ),
                  ),
                ],
        ),
      ),
    );
  }

  Widget _buildStageItem(CampaignStage stage) {
    final isUnlocked = stage.stageId <= currentStageId;
    final isCompleted = stage.stageId < currentStageId;

    return ListTile(
      enabled: isUnlocked,
      leading: Icon(
        isCompleted ? Icons.check_circle : (isUnlocked ? Icons.play_arrow : Icons.lock),
        color: isCompleted ? Colors.green : (isUnlocked ? Colors.amber : Colors.grey),
      ),
      title: Text(
        '${stage.chapter}-${stage.stage}: ${stage.name}',
        style: TextStyle(
          color: isUnlocked ? Colors.white : Colors.grey,
          fontWeight: isUnlocked ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            stage.description,
            style: TextStyle(
              color: isUnlocked ? Colors.white60 : Colors.grey,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.person, size: 14, color: Colors.red.shade300),
              const SizedBox(width: 4),
              Text(
                '${stage.enemies.length} ennemis',
                style: TextStyle(color: Colors.red.shade300, fontSize: 11),
              ),
              const SizedBox(width: 12),
              const Icon(Icons.monetization_on, size: 14, color: Colors.amber),
              const SizedBox(width: 4),
              Text(
                '${stage.rewardGold}G',
                style: const TextStyle(color: Colors.amber, fontSize: 11),
              ),
              const SizedBox(width: 12),
              const Icon(Icons.star, size: 14, color: Colors.blue),
              const SizedBox(width: 4),
              Text(
                '${stage.rewardXP}XP',
                style: const TextStyle(color: Colors.blue, fontSize: 11),
              ),
            ],
          ),
        ],
      ),
      trailing: isUnlocked && !isCompleted
          ? ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                foregroundColor: Colors.black,
              ),
              onPressed: () => _startStage(stage),
              child: const Text('JOUER'),
            )
          : null,
      onTap: isUnlocked ? () => _startStage(stage) : null,
    );
  }

  IconData _getChapterIcon(String theme) {
    switch (theme) {
      case 'forest':
        return Icons.park;
      case 'plains':
        return Icons.landscape;
      case 'mountain':
        return Icons.terrain;
      default:
        return Icons.map;
    }
  }
}
