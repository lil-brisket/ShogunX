import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/providers.dart';
import '../../models/models.dart';
import '../../services/banking_service.dart';
import 'transfer_dialog.dart';
import 'transaction_history_dialog.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authStateProvider).user;
    
    if (user == null) {
      return const Scaffold(
        backgroundColor: Color(0xFF0f3460),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Get the current character
    final currentCharacterId = user.currentCharacterId;
    if (currentCharacterId == null) {
      return _buildNoCharacterScreen();
    }

    final characterAsync = ref.watch(characterProvider(currentCharacterId));
    
    return characterAsync.when(
      data: (character) => character != null ? _buildProfileContent(context, user, character) : _buildNoCharacterScreen(),
      loading: () => const Scaffold(
        backgroundColor: Color(0xFF0f3460),
        body: Center(
          child: CircularProgressIndicator(color: Colors.deepOrange),
        ),
      ),
      error: (error, _) => Scaffold(
        backgroundColor: const Color(0xFF0f3460),
        body: Center(
          child: Text(
            'Error loading character: $error',
            style: const TextStyle(color: Colors.red),
          ),
        ),
      ),
    );
  }

  Widget _buildNoCharacterScreen() {
    return const Scaffold(
      backgroundColor: Color(0xFF0f3460),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_off,
              color: Colors.deepOrange,
              size: 64,
            ),
            SizedBox(height: 16),
            Text(
              'No Character Selected',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Create or select a character to view profile',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileContent(BuildContext context, User user, Character character) {
    
    return Scaffold(
      backgroundColor: const Color(0xFF0f3460),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1a1a2e),
                border: Border(
                  bottom: BorderSide(
                    color: Colors.deepOrange.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.deepOrange,
                    backgroundImage: character.avatarUrl != null ? NetworkImage(character.avatarUrl!) : null,
                    child: character.avatarUrl == null
                        ? Text(
                            character.name.substring(0, 1).toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              character.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.deepOrange.withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Lv.${character.level}',
                                style: const TextStyle(
                                  color: Colors.deepOrange,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              '${character.ninjaRank} • ${character.village}',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.7),
                                fontSize: 14,
                              ),
                            ),
                            if (character.marriedTo != null) ...[
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.favorite,
                                color: Colors.pink,
                                size: 16,
                              ),
                            ],
                          ],
                        ),
                        if (character.bloodline != null)
                          Container(
                            margin: const EdgeInsets.only(top: 4),
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.red.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              character.bloodline!,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      context.push('/profile/settings');
                    },
                    icon: const Icon(
                      Icons.settings,
                      color: Colors.deepOrange,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),
            
            // Profile Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Character Overview
                    _buildCharacterOverview(character),
                    const SizedBox(height: 16),
                    
                    // Stats Section
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatsCard('Core Stats', [
                            _buildStatRow('Strength', character.strength, 250000),
                            _buildStatRow('Intelligence', character.intelligence, 250000),
                            _buildStatRow('Speed', character.speed, 250000),
                            _buildStatRow('Defense', character.defense, 250000),
                            _buildStatRow('Willpower', character.willpower, 250000),
                          ]),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildStatsCard('Combat Stats', [
                            _buildStatRow('Bukijutsu', character.bukijutsu, 500000),
                            _buildStatRow('Ninjutsu', character.ninjutsu, 500000),
                            _buildStatRow('Taijutsu', character.taijutsu, 500000),
                            _buildStatRow('Bloodline Eff', character.bloodlineEfficiency, 50000),
                          ]),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Resources & Records
                    Row(
                      children: [
                        Expanded(
                          child: _buildResourcesCard(character),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildRecordsCard(character),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Reputation & Elements
                    Row(
                      children: [
                        Expanded(
                          child: _buildReputationCard(character),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildElementsCard(character),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Relationships & Logbook
                    Row(
                      children: [
                        Expanded(
                          child: _buildRelationshipsCard(character),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildLogbookCard(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCharacterOverview(Character character) {
    final xpNeeded = (character.level * 1000); // Simple XP calculation
    final xpProgress = (character.experience % 1000) / 1000;
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF16213e),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.deepOrange.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Experience Progress',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: xpProgress,
                        backgroundColor: Colors.black.withValues(alpha: 0.3),
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.deepOrange),
                        minHeight: 8,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${character.experience} / $xpNeeded XP',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              if (character.canAdvanceRank)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green.withValues(alpha: 0.5)),
                  ),
                  child: const Text(
                    'Rank Up Available!',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          if (character.marriedTo != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.pink.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.pink.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.favorite, color: Colors.pink, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Married to ${character.marriedTo}',
                    style: const TextStyle(
                      color: Colors.pink,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
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

  Widget _buildStatsCard(String title, List<Widget> stats) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF16213e),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.deepOrange.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.deepOrange.withValues(alpha: 0.2),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  title == 'Core Stats' ? Icons.fitness_center : Icons.sports_kabaddi,
                  color: Colors.deepOrange,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(children: stats),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String name, int value, int max) {
    final percentage = value / max;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  name,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 11,
                  ),
                ),
              ),
              Text(
                _formatNumber(value),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percentage,
              backgroundColor: Colors.black.withValues(alpha: 0.3),
              valueColor: AlwaysStoppedAnimation<Color>(
                percentage < 0.5 ? Colors.orange : Colors.green,
              ),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResourcesCard(Character character) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF16213e),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.deepOrange.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.2),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.inventory, color: Colors.blue, size: 16),
                const SizedBox(width: 6),
                const Text(
                  'Resources',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: () => _showBankingDialog(character),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.green.withValues(alpha: 0.5)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.account_balance, color: Colors.green, size: 12),
                        SizedBox(width: 4),
                        Text(
                          'Bank',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                _buildResourceBar('HP', character.currentHp, character.maxHp, Colors.red),
                _buildResourceBar('CP', character.currentChakra, character.maxChakra, Colors.blue),
                _buildResourceBar('STA', character.currentStamina, character.maxStamina, Colors.green),
                const SizedBox(height: 8),
                _buildRyoRow('On Hand', character.ryoOnHand, Colors.orange),
                _buildRyoRow('In Bank', character.ryoBanked, Colors.green),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.deepOrange.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: _buildInfoRow('Total Wealth', '${_formatNumber(character.ryoOnHand + character.ryoBanked)} Ryo'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRyoRow(String label, int amount, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(
            label == 'On Hand' ? Icons.account_balance_wallet : Icons.account_balance,
            color: color,
            size: 14,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 12,
              ),
            ),
          ),
          Text(
            '${_formatNumber(amount)} Ryo',
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResourceBar(String name, int current, int max, Color color) {
    final percentage = current / max;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                name,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 11,
                ),
              ),
              const Spacer(),
              Text(
                '$current/$max',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percentage,
              backgroundColor: Colors.black.withValues(alpha: 0.3),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecordsCard(Character character) {
    final totalPvP = character.pvpWins + character.pvpLosses;
    final totalPvE = character.pveWins + character.pveLosses;
    
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF16213e),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.deepOrange.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.purple.withValues(alpha: 0.2),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: const Row(
              children: [
                Icon(Icons.emoji_events, color: Colors.purple, size: 16),
                SizedBox(width: 6),
                Text(
                  'Battle Records',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                _buildRecordRow('PvP Wins', character.pvpWins, Colors.green),
                _buildRecordRow('PvP Losses', character.pvpLosses, Colors.red),
                _buildRecordRow('PvP Rate', '${(character.pvpWinRate * 100).toStringAsFixed(1)}%', Colors.orange),
                const SizedBox(height: 6),
                _buildRecordRow('PvE Wins', character.pveWins, Colors.green),
                _buildRecordRow('PvE Losses', character.pveLosses, Colors.red),
                _buildRecordRow('PvE Rate', '${(character.pveWinRate * 100).toStringAsFixed(1)}%', Colors.orange),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecordRow(String label, dynamic value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 11,
              ),
            ),
          ),
          Text(
            value.toString(),
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReputationCard(Character character) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF16213e),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.deepOrange.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.amber.withValues(alpha: 0.2),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: const Row(
              children: [
                Icon(Icons.star, color: Colors.amber, size: 16),
                SizedBox(width: 6),
                Text(
                  'Reputation',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                _buildReputationBar('Village Loyalty', character.villageLoyalty, Colors.blue),
                const SizedBox(height: 8),
                _buildReputationBar('Outlaw Infamy', character.outlawInfamy, Colors.red),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReputationBar(String name, int value, Color color) {
    final percentage = (value + 1000) / 2000; // Assuming -1000 to +1000 range
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              name,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 11,
              ),
            ),
            const Spacer(),
            Text(
              value.toString(),
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: percentage.clamp(0.0, 1.0),
            backgroundColor: Colors.black.withValues(alpha: 0.3),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 6,
          ),
        ),
      ],
    );
  }

  Widget _buildElementsCard(Character character) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF16213e),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.deepOrange.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.cyan.withValues(alpha: 0.2),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: const Row(
              children: [
                Icon(Icons.local_fire_department, color: Colors.cyan, size: 16),
                SizedBox(width: 6),
                Text(
                  'Elements',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (character.elements.isNotEmpty) ...[
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: character.elements.map((element) => _buildElementChip(element)).toList(),
                  ),
                ] else ...[
                  Text(
                    'No elements unlocked',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.5),
                      fontSize: 12,
                    ),
                  ),
                ],
                if (character.bloodline != null) ...[
                  const SizedBox(height: 8),
                  _buildBloodlineChip(character.bloodline!),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildElementChip(String element) {
    final color = _getElementColor(element);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        element,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildBloodlineChip(String bloodline) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.bloodtype, color: Colors.red, size: 12),
          const SizedBox(width: 4),
          Text(
            bloodline,
            style: const TextStyle(
              color: Colors.red,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Color _getElementColor(String element) {
    switch (element.toLowerCase()) {
      case 'fire':
        return Colors.red;
      case 'water':
        return Colors.blue;
      case 'earth':
        return Colors.brown;
      case 'wind':
        return Colors.green;
      case 'lightning':
        return Colors.yellow;
      default:
        return Colors.grey;
    }
  }

  Widget _buildRelationshipsCard(Character character) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF16213e),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.deepOrange.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.pink.withValues(alpha: 0.2),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: const Row(
              children: [
                Icon(Icons.people, color: Colors.pink, size: 16),
                SizedBox(width: 6),
                Text(
                  'Relationships',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                _buildInfoRow('Marriage', character.marriedTo ?? 'Single'),
                _buildInfoRow('Sensei', character.senseiId ?? 'None'),
                _buildInfoRow('Students', '${character.studentIds.length}'),
                if (character.clanId != null) ...[
                  _buildInfoRow('Clan', character.clanId!),
                  _buildInfoRow('Clan Rank', character.clanRank ?? 'Member'),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogbookCard() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF16213e),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.deepOrange.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.2),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: const Row(
              children: [
                Icon(Icons.book, color: Colors.green, size: 16),
                SizedBox(width: 6),
                Text(
                  'Logbook',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                _buildInfoRow('Missions Completed', '23'),
                _buildInfoRow('Quests Completed', '5'),
                _buildInfoRow('Dark Ops', '2'),
                _buildInfoRow('Last Mission', '2 hours ago'),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () {
                    // TODO: Show full logbook
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'View Full Logbook',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
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

  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match match) => '${match[1]},',
    );
  }

  Widget _buildInfoCard(String title, List<Widget> children) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF16213e),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.deepOrange.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.deepOrange.withValues(alpha: 0.2),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingAction(String title, String description, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.deepOrange.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.deepOrange, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
              color: Colors.deepOrange.withValues(alpha: 0.7),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  void _showBankingDialog(Character character) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: const Color(0xFF16213e),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: double.maxFinite,
          constraints: const BoxConstraints(maxWidth: 400, maxHeight: 600),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Icon(Icons.account_balance, color: Colors.green),
                  const SizedBox(width: 8),
                  const Text(
                    'Banking',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Current Balance
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    _buildBalanceRow('On Hand', character.ryoOnHand, Icons.account_balance_wallet, Colors.orange),
                    const SizedBox(height: 8),
                    _buildBalanceRow('In Bank', character.ryoBanked, Icons.account_balance, Colors.green),
                    const Divider(color: Colors.white24),
                    _buildBalanceRow('Total', character.ryoOnHand + character.ryoBanked, Icons.savings, Colors.deepOrange),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Action Buttons
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.2,
                  children: [
                    _buildBankingAction(
                      'Deposit',
                      'Move Ryo to Bank',
                      Icons.upload,
                      Colors.green,
                      () => _showDepositDialog(character),
                    ),
                    _buildBankingAction(
                      'Withdraw',
                      'Take Ryo from Bank',
                      Icons.download,
                      Colors.blue,
                      () => _showWithdrawDialog(character),
                    ),
                    _buildBankingAction(
                      'Transfer',
                      'Send to Player',
                      Icons.send,
                      Colors.purple,
                      () => _showTransferDialog(character),
                    ),
                    _buildBankingAction(
                      'History',
                      'View Transactions',
                      Icons.history,
                      Colors.amber,
                      () => _showTransactionHistory(character),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBalanceRow(String label, int amount, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ),
        Text(
          '${_formatNumber(amount)} Ryo',
          style: TextStyle(
            color: color,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildBankingAction(String title, String subtitle, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: color,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 10,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showDepositDialog(Character character) {
    Navigator.of(context).pop(); // Close banking dialog
    _showAmountDialog(
      'Deposit Ryo',
      'Enter amount to deposit to bank',
      character.ryoOnHand,
      (amount) async {
        final bankingNotifier = ref.read(bankingNotifierProvider(character.id).notifier);
        final result = await bankingNotifier.deposit(amount);
        if (mounted) {
          _showResultSnackbar(result);
        }
      },
    );
  }

  void _showWithdrawDialog(Character character) {
    Navigator.of(context).pop(); // Close banking dialog
    _showAmountDialog(
      'Withdraw Ryo',
      'Enter amount to withdraw from bank',
      character.ryoBanked,
      (amount) async {
        final bankingNotifier = ref.read(bankingNotifierProvider(character.id).notifier);
        final result = await bankingNotifier.withdraw(amount);
        if (mounted) {
          _showResultSnackbar(result);
        }
      },
    );
  }

  void _showTransferDialog(Character character) {
    Navigator.of(context).pop(); // Close banking dialog
    showDialog(
      context: context,
      builder: (context) => TransferDialog(character: character),
    );
  }

  void _showTransactionHistory(Character character) {
    Navigator.of(context).pop(); // Close banking dialog
    showDialog(
      context: context,
      builder: (context) => TransactionHistoryDialog(character: character),
    );
  }

  void _showAmountDialog(String title, String subtitle, int maxAmount, Function(int) onConfirm) {
    final controller = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF16213e),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              subtitle,
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 8),
            Text(
              'Available: ${_formatNumber(maxAmount)} Ryo',
              style: const TextStyle(color: Colors.green, fontSize: 12),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Enter amount...',
                hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.deepOrange),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.deepOrange.withValues(alpha: 0.5)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.deepOrange, width: 2),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
          ),
          TextButton(
            onPressed: () {
              final amount = int.tryParse(controller.text) ?? 0;
              if (amount > 0 && amount <= maxAmount) {
                Navigator.of(context).pop();
                onConfirm(amount);
              }
            },
            child: const Text('Confirm', style: TextStyle(color: Colors.deepOrange)),
          ),
        ],
      ),
    );
  }

  void _showResultSnackbar(BankingResult result) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result.message),
        backgroundColor: result.success ? Colors.green : Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showInfoDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF16213e),
        title: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
        content: Text(
          content,
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'OK',
              style: TextStyle(color: Colors.deepOrange),
            ),
          ),
        ],
      ),
    );
  }
}
