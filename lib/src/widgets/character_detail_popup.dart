import 'package:flutter/material.dart';
import '../models/character.dart';
import 'character_compact_view.dart';

/// Widget modulaire pour afficher les détails d'un personnage avec des boutons d'action
class CharacterDetailPopup extends StatelessWidget {
  final Character character;
  final bool isEnemy;
  final VoidCallback? onAttack;
  final VoidCallback? onClose;

  const CharacterDetailPopup({
    super.key,
    required this.character,
    this.isEnemy = false,
    this.onAttack,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Contenu principal - utilise le widget réutilisable
            CharacterCompactView(
              character: character,
              isEnemy: isEnemy,
            ),
            
            // Boutons d'action en bas
            if (onAttack != null || onClose != null) ...[
              const SizedBox(height: 16),
              _buildFooter(context),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isEnemy ? Colors.red.withOpacity(0.5) : Colors.amber.withOpacity(0.5),
          width: 2,
        ),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          if (onClose != null)
            Expanded(
              child: ElevatedButton(
                onPressed: onClose,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade800,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text('FERMER'),
              ),
            ),
          if (onClose != null && onAttack != null) const SizedBox(width: 12),
          if (onAttack != null)
            Expanded(
              child: ElevatedButton.icon(
                onPressed: onAttack,
                icon: const Icon(Icons.gps_fixed),
                label: const Text('ATTAQUER'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
