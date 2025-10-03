import 'package:flutter/material.dart';
import '../models/character.dart';
import '../models/persona.dart';

class CharacterDetailScreen extends StatelessWidget {
  final Character character;

  const CharacterDetailScreen({super.key, required this.character});

  String _getRaceDescription() {
    switch (character.persona.race) {
      case PersonaRace.human:
        return 'Les humains sont polyvalents et adaptables. Leur détermination et leur ingéniosité leur permettent de surmonter tous les obstacles.';
      case PersonaRace.elf:
        return 'Les elfes sont gracieux et magiques. Leur connexion ancestrale avec la nature leur confère sagesse et longévité.';
      case PersonaRace.dwarf:
        return 'Les nains sont robustes et tenaces. Leur maîtrise de la forge et leur courage au combat sont légendaires.';
      case PersonaRace.orc:
        return 'Les orcs sont puissants et féroces. Leur force brute et leur esprit guerrier en font des adversaires redoutables.';
    }
  }

  String _getClassDescription() {
    switch (character.persona.characterClass) {
      case PersonaClass.warrior:
        return 'Un guerrier courageux qui maîtrise les armes de mêlée. Expert en combat rapproché, il protège ses alliés avec bravoure.';
      case PersonaClass.mage:
        return 'Un mage érudit qui manipule les arcanes. Ses sorts dévastateurs peuvent changer le cours d\'une bataille.';
      case PersonaClass.rogue:
        return 'Un voleur agile qui frappe dans l\'ombre. Sa rapidité et sa ruse lui permettent d\'éliminer ses cibles silencieusement.';
      case PersonaClass.cleric:
        return 'Un clerc dévoué qui canalise la magie divine. Ses soins et bénédictions soutiennent toute l\'équipe.';
    }
  }

  String _getOriginDescription() {
    switch (character.persona.origin) {
      case PersonaOrigin.noble:
        return 'Né dans une famille noble, vous avez grandi entouré de luxe et d\'éducation. Votre lignée vous ouvre de nombreuses portes.';
      case PersonaOrigin.merchant:
        return 'Issu d\'une famille de marchands, vous connaissez la valeur de l\'or et l\'art de la négociation. Le commerce coule dans vos veines.';
      case PersonaOrigin.peasant:
        return 'Né humble paysan, vous avez appris la valeur du travail acharné. Votre détermination forge votre destinée.';
      case PersonaOrigin.scholar:
        return 'Élevé parmi les livres et le savoir, vous possédez une soif de connaissance insatiable. La sagesse guide vos pas.';
    }
  }

  String _getRegionDescription() {
    switch (character.persona.region) {
      case PersonaRegion.west:
        return 'Les terres de l\'Ouest, royaume des plaines verdoyantes et des royaumes prospères. La civilisation y fleurit.';
      case PersonaRegion.east:
        return 'Les terres de l\'Est, domaine des déserts mystiques et des cités anciennes. La magie ancestrale y règne.';
      case PersonaRegion.north:
        return 'Les terres du Nord, royaume des montagnes enneigées et des forteresses imprenables. La force y est respectée.';
      case PersonaRegion.south:
        return 'Les terres du Sud, domaine des jungles luxuriantes et des tribus anciennes. La nature y est sauvage.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0D1421), Color(0xFF1A1A2E)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.1),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Profil du Héros',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildMainCard(context),
                      const SizedBox(height: 24),
                      
                      _buildDescriptionSection(
                        '🧬 Race',
                        character.persona.race.displayName,
                        _getRaceDescription(),
                        Colors.blue,
                      ),
                      const SizedBox(height: 16),
                      
                      _buildDescriptionSection(
                        '⚔️ Classe',
                        character.persona.characterClass.displayName,
                        _getClassDescription(),
                        Colors.purple,
                      ),
                      const SizedBox(height: 16),
                      
                      _buildDescriptionSection(
                        '🏛️ Origine',
                        character.persona.origin.displayName,
                        _getOriginDescription(),
                        Colors.amber,
                      ),
                      const SizedBox(height: 16),
                      
                      _buildDescriptionSection(
                        '🗺️ Région',
                        character.persona.region.displayName,
                        _getRegionDescription(),
                        Colors.green,
                      ),
                      const SizedBox(height: 24),
                      
                      _buildStatsSection(),
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

  Widget _buildMainCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(character.appearance.colorValue).withOpacity(0.3),
            Color(character.appearance.colorValue).withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Color(character.appearance.colorValue).withOpacity(0.5),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Color(character.appearance.colorValue).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Color(character.appearance.colorValue).withOpacity(0.2),
              shape: BoxShape.circle,
              border: Border.all(
                color: Color(character.appearance.colorValue),
                width: 3,
              ),
            ),
            child: Center(
              child: Text(
                character.appearance.emoji,
                style: const TextStyle(fontSize: 64),
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          Text(
            character.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.cyan.withOpacity(0.3),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.cyan),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star, color: Colors.cyan, size: 18),
                const SizedBox(width: 6),
                Text(
                  'Niveau ${character.level}',
                  style: const TextStyle(
                    color: Colors.cyan,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '❤️ Points de vie',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    '${character.currentHp} / ${character.stats.maxHp}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: character.hpPercentage,
                  backgroundColor: Colors.white.withOpacity(0.1),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    character.hpPercentage > 0.5 ? Colors.green : Colors.orange,
                  ),
                  minHeight: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection(String icon, String title, String description, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  icon,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  color: color,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '📊 Statistiques',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildStatBar('⚔️ Attaque', character.stats.attack, Colors.red),
        const SizedBox(height: 12),
        _buildStatBar('🛡️ Défense', character.stats.defense, Colors.blue),
        const SizedBox(height: 12),
        _buildStatBar('⚡ Vitesse', character.stats.speed, Colors.yellow),
        const SizedBox(height: 12),
        _buildStatBar('✨ Magie', character.stats.magic, Colors.purple),
        const SizedBox(height: 12),
        _buildStatBar('🍀 Chance', character.stats.luck, Colors.green),
      ],
    );
  }

  Widget _buildStatBar(String label, int value, Color color) {
    final percentage = (value / 100).clamp(0.0, 1.0);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '$value',
              style: TextStyle(
                color: color,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: percentage,
            backgroundColor: Colors.white.withOpacity(0.1),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 10,
          ),
        ),
      ],
    );
  }
}
