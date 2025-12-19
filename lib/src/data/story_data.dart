import 'package:flutter/material.dart';
import '../models/campaign_data.dart';
import '../widgets/dialogue_box.dart';
import '../widgets/dialogue_manager.dart';

// Import per-episode story files
import 'stories/story_1_1.dart';
import 'stories/story_1_2.dart';
import 'stories/story_1_3.dart';
import 'stories/story_2_1.dart';
import 'stories/story_2_2.dart';
import 'stories/story_2_3.dart';
import 'stories/story_3_1.dart';
import 'stories/story_3_2.dart';
import 'stories/story_3_3.dart';

/// Simple story model used for chapter storytelling
class Story {
  final int chapter;
  final int stage;
  final String title;
  final List<StoryLine> lines;

  Story({required this.chapter, required this.stage, required this.title, required this.lines});
}

class StoryLine {
  final String speaker;
  final String text;
  final String? portrait;
  final List<StoryChoice>? choices;

  StoryLine({required this.speaker, required this.text, this.portrait, this.choices});

  // Convert to DialogueLine used by the UI
  DialogueLine toDialogueLine() {
    return DialogueLine(
      speaker: speaker,
      text: text,
      portrait: portrait,
      choices: choices?.map((c) => DialogueChoice(id: c.id, label: c.label)).toList(),
    );
  }
}

class StoryChoice {
  final String id;
  final String label;
  StoryChoice({required this.id, required this.label});
}

/// Service that exposes available stories and plays them
class StoryService {
  // Key is "chapter.stage" e.g. "1.1"
  // Raw episode data variables are defined in the imported files (episode_1_1, ...)
  static final Map<String, Story> _storiesByEpisode = {
    '1.1': _makeStoryFromRaw(episode_1_1),
    '1.2': _makeStoryFromRaw(episode_1_2),
    '1.3': _makeStoryFromRaw(episode_1_3),
    '2.1': _makeStoryFromRaw(episode_2_1),
    '2.2': _makeStoryFromRaw(episode_2_2),
    '2.3': _makeStoryFromRaw(episode_2_3),
    '3.1': _makeStoryFromRaw(episode_3_1),
    '3.2': _makeStoryFromRaw(episode_3_2),
    '3.3': _makeStoryFromRaw(episode_3_3),
  };

  /// Retourne la story pour un stage donné (chapter+stage)
  static Story? getStoryForStageNum(int chapter, int stage) => _storiesByEpisode['$chapter.$stage'];

  /// Play story for a given stage (chapter+stage). Returns the choices map.
  static Future<Map<String, String>> playStoryForStage(
    BuildContext context,
    CampaignStage stage, {
    Alignment alignment = Alignment.bottomCenter,
    Duration charDuration = const Duration(milliseconds: 28),
    bool autoAdvance = false,
    Duration autoAdvanceDelay = const Duration(milliseconds: 600),
  }) async {
    final story = getStoryForStageNum(stage.chapter, stage.stage);
    if (story == null || story.lines.isEmpty) return {};

    // Convert to DialogueLine sequence
    final lines = story.lines.map((l) => l.toDialogueLine()).toList();

    final results = await DialogueManager.showSequence(
      context,
      lines,
      alignment: alignment,
      charDuration: charDuration,
      autoAdvance: autoAdvance,
      autoAdvanceDelay: autoAdvanceDelay,
      barrierDismissible: false,
    );

    return results;
  }
  
  // Helpers to build Story from raw episode maps imported from files
  static Story _makeStoryFromRaw(Map raw) {
    final chapter = raw['chapter'] as int? ?? 1;
    final stage = raw['stage'] as int? ?? 1;
    final title = raw['title'] as String? ?? '';
    final linesRaw = raw['lines'] as List? ?? [];
    final lines = linesRaw.map((l) {
      final speaker = l['speaker'] as String? ?? '';
      final text = l['text'] as String? ?? '';
      final portrait = l['portrait'] as String?;
      final choicesRaw = l['choices'] as List?;
      List<StoryChoice>? choices;
      if (choicesRaw != null) {
        choices = choicesRaw.map((c) => StoryChoice(id: c['id'] as String, label: c['label'] as String)).toList();
      }
      return StoryLine(speaker: speaker, text: text, portrait: portrait, choices: choices);
    }).toList();

    return Story(chapter: chapter, stage: stage, title: title, lines: lines);
  }
}
