import 'package:flutter/material.dart';
import 'dialogue_box.dart';

class DialogueManager {
  /// Affiche une séquence de lignes. Retourne une map des choix faits (speaker -> choice id).
  ///
  /// Options:
  /// - `alignment`: où placer la boite (ex: Alignment.bottomCenter)
  /// - `charDuration`: vitesse de la machine à écrire
  /// - `autoAdvance`: si true, la ligne avance automatiquement après `autoAdvanceDelay`
  /// - `autoAdvanceDelay`: délai avant avance auto
  /// - `barrierDismissible`: permet de fermer en tapant hors de la boite
  static Future<Map<String, String>> showSequence(
    BuildContext context,
    List<DialogueLine> lines, {
    Alignment alignment = Alignment.bottomCenter,
    Duration charDuration = const Duration(milliseconds: 24),
    bool autoAdvance = false,
    Duration autoAdvanceDelay = const Duration(milliseconds: 800),
    bool barrierDismissible = false,
  }) async {
    final results = <String, String>{};
    int index = 0;
    bool skipped = false;

    await showGeneralDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierLabel: 'Dialogue',
      pageBuilder: (ctx, a1, a2) {
        return StatefulBuilder(builder: (ctx, setState) {
          void _next([String? choiceForSpeaker]) {
            if (choiceForSpeaker != null) {
              results[lines[index].speaker] = choiceForSpeaker;
            }
            index++;
            if (index >= lines.length) {
              Navigator.of(ctx).pop();
            } else {
              setState(() {});
            }
          }

          return SafeArea(
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Align(
                alignment: alignment,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: DialogueBox(
                    line: lines[index],
                    charDuration: charDuration,
                    autoAdvance: autoAdvance,
                    autoAdvanceDelay: autoAdvanceDelay,
                    onNext: () => _next(),
                    onSkip: () {
                      skipped = true;
                      results.clear();
                      Navigator.of(ctx).pop();
                    },
                    onChoiceSelected: (choiceId) => _next(choiceId),
                  ),
                ),
              ),
            ),
          );
        });
      },
    );

    if (skipped) return <String, String>{};
    return results;
  }
}
