import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/providers.dart';
import '../../models/models.dart';

class CombatArenaScreen extends ConsumerStatefulWidget {
  const CombatArenaScreen({super.key});

  @override
  ConsumerState<CombatArenaScreen> createState() => _CombatArenaScreenState();
}

class _CombatArenaScreenState extends ConsumerState<CombatArenaScreen> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authStateProvider).user;
    final currentCharacter = ref.watch(gameStateProvider).selectedCharacter;

    if (user == null) {
      return _buildNoUserMessage();
    }

    if (currentCharacter == null) {
      return _buildNoCharacterMessage();
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Arena Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF16213e),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.red.withValues(alpha: 0.4),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.red.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.sports_kabaddi,
                        color: Colors.red,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Combat Arena',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Test your skills in battle',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.7),
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Character Stats Summary
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.red.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildStatDisplay('HP', currentCharacter.currentHp, Colors.red),
                      ),
                      Expanded(
                        child: _buildStatDisplay('CP', currentCharacter.currentChakra, Colors.blue),
                      ),
                      Expanded(
                        child: _buildStatDisplay('STA', currentCharacter.currentStamina, Colors.green),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Combat Options
          _buildCombatOptions(currentCharacter),
          
          const SizedBox(height: 24),
          
          // Battle History
          _buildBattleHistory(),
        ],
      ),
    );
  }

  Widget _buildStatDisplay(String label, int current, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          current.toString(),
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildCombatOptions(Character character) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.red.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.red.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
                             Icon(
                 Icons.sports_kabaddi,
                 color: Colors.red,
                 size: 20,
               ),
              const SizedBox(width: 8),
              Text(
                'Combat Options',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        
        // Practice Mode
        _buildCombatOption(
          title: 'Practice Mode',
          description: 'Spar against training dummies to improve your skills',
          icon: Icons.fitness_center,
          color: Colors.green,
          onTap: () => _showPracticeMode(character),
        ),
        
        const SizedBox(height: 12),
        
        // VS AI Mode
        _buildCombatOption(
          title: 'VS AI',
          description: 'Battle against computer-controlled opponents',
          icon: Icons.computer,
          color: Colors.blue,
          onTap: () => _showVsAIMode(character),
        ),
        
        const SizedBox(height: 12),
        
        // Battle Tower
        _buildCombatOption(
          title: 'Battle Tower',
          description: 'Climb the tower and face increasingly difficult challenges',
          icon: Icons.castle,
          color: Colors.purple,
          onTap: () => _showBattleTower(character),
        ),
      ],
    );
  }

  Widget _buildCombatOption({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF16213e),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withValues(alpha: 0.4),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: color.withValues(alpha: 0.7),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBattleHistory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.orange.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.orange.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.history,
                color: Colors.orange,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Recent Battles',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        
        // Placeholder for battle history
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF16213e),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.orange.withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            children: [
              Icon(
                Icons.history,
                color: Colors.orange.withValues(alpha: 0.5),
                size: 48,
              ),
              const SizedBox(height: 12),
              Text(
                'No recent battles',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Start fighting to see your battle history here',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.5),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNoUserMessage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.sports_kabaddi,
            color: Colors.red.withValues(alpha: 0.5),
            size: 64,
          ),
          const SizedBox(height: 16),
          Text(
            'Please log in to access the Combat Arena.',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildNoCharacterMessage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_off,
            color: Colors.red.withValues(alpha: 0.5),
            size: 64,
          ),
          const SizedBox(height: 16),
          Text(
            'Please select a character to enter the Combat Arena.',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ],
      ),
    );
  }

  void _showPracticeMode(Character character) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF16213e),
        title: Row(
          children: [
            Icon(Icons.fitness_center, color: Colors.green),
            const SizedBox(width: 8),
            Text(
              'Practice Mode',
              style: TextStyle(color: Colors.green),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose your training partner:',
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16),
            _buildPracticeOption('Training Dummy', 'Basic practice with no risk', Icons.face, Colors.grey),
            const SizedBox(height: 8),
            _buildPracticeOption('Wooden Clone', 'Intermediate training partner', Icons.forest, Colors.brown),
            const SizedBox(height: 8),
            _buildPracticeOption('Shadow Clone', 'Advanced training simulation', Icons.person, Colors.purple),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel', style: TextStyle(color: Colors.white70)),
          ),
        ],
      ),
    );
  }

  void _showVsAIMode(Character character) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF16213e),
        title: Row(
          children: [
            Icon(Icons.computer, color: Colors.blue),
            const SizedBox(width: 8),
            Text(
              'VS AI Mode',
              style: TextStyle(color: Colors.blue),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select difficulty level:',
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16),
            _buildAIOption('Easy', 'Suitable for beginners', Icons.sentiment_satisfied, Colors.green),
            const SizedBox(height: 8),
            _buildAIOption('Medium', 'Balanced challenge', Icons.sentiment_neutral, Colors.orange),
            const SizedBox(height: 8),
            _buildAIOption('Hard', 'For experienced fighters', Icons.sentiment_dissatisfied, Colors.red),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel', style: TextStyle(color: Colors.white70)),
          ),
        ],
      ),
    );
  }

  void _showBattleTower(Character character) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF16213e),
        title: Row(
          children: [
            Icon(Icons.castle, color: Colors.purple),
            const SizedBox(width: 8),
            Text(
              'Battle Tower',
              style: TextStyle(color: Colors.purple),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current Floor: 1',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Climb the tower to earn rewards and prestige!',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.purple.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.purple.withValues(alpha: 0.3)),
              ),
              child: Column(
                children: [
                  Text(
                    'Floor 1 Reward:',
                    style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '• 100 Ryo\n• 50 Experience\n• Basic Equipment',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel', style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _startBattleTower(character);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
              foregroundColor: Colors.white,
            ),
            child: Text('Start Battle'),
          ),
        ],
      ),
    );
  }

  Widget _buildPracticeOption(String title, String description, IconData icon, Color color) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pop();
        _startPractice(title);
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(color: color, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    description,
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAIOption(String title, String description, IconData icon, Color color) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pop();
        _startVsAI(title);
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(color: color, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    description,
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _startPractice(String opponent) {
    // TODO: Implement practice mode
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Practice mode against $opponent coming soon!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _startVsAI(String difficulty) {
    // TODO: Implement VS AI mode
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('VS AI mode ($difficulty) coming soon!'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _startBattleTower(Character character) {
    // TODO: Implement battle tower
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Battle Tower mode coming soon!'),
        backgroundColor: Colors.purple,
      ),
    );
  }
}
