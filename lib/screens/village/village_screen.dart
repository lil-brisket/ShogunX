import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/providers.dart';
import '../../models/models.dart';
import '../../services/banking_service.dart';
import '../../services/training_service.dart';
import '../profile/transfer_dialog.dart';
import 'hospital_screen.dart';


class VillageScreen extends ConsumerStatefulWidget {
  const VillageScreen({super.key});

  @override
  ConsumerState<VillageScreen> createState() => _VillageScreenState();
}

class _VillageScreenState extends ConsumerState<VillageScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  Timer? _trainingTimer;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 8, vsync: this);
    _tabController.addListener(() {
      ref.read(selectedVillageTabProvider.notifier).state = _tabController.index;
    });
    
    // Start timer to refresh training sessions every second
    _trainingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {}); // Trigger rebuild to update training progress
      }
    });
    
    // Initialize shop immediately
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(shopProviderProvider.notifier).initializeShop();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _trainingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authStateProvider).user;
    final selectedTab = ref.watch(selectedVillageTabProvider);
    
    _tabController.index = selectedTab;
    
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
                  Icon(
                    Icons.location_city,
                    color: Colors.deepOrange,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${user?.lastVillage ?? 'Unknown'} Village',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Your home village',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Tab Bar
            Container(
              color: const Color(0xFF16213e),
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                indicatorColor: Colors.deepOrange,
                labelColor: Colors.deepOrange,
                unselectedLabelColor: Colors.white.withValues(alpha: 0.6),
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 14,
                ),
                tabs: const [
                  Tab(text: 'Missions'),
                  Tab(text: 'Quests'),
                  Tab(text: 'Bank'),
                  Tab(text: 'Clan Hall'),
                  Tab(text: 'Dark Ops'),
                  Tab(text: 'Hospital'),
                  Tab(text: 'Training'),
                  Tab(text: 'Shop'),
                ],
              ),
            ),
            
            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildMissionsTab(),
                  _buildQuestsTab(),
                  _buildBankTab(),
                  _buildClanHallTab(),
                  _buildDarkOpsTab(),
                  _buildHospitalTab(),
                  _buildTrainingTab(),
                  _buildShopTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMissionsTab() {
    final user = ref.watch(authStateProvider).user;
    final missionsAsync = ref.watch(missionsByVillageProvider(user?.lastVillage ?? ''));
    
    return missionsAsync.when(
      data: (missions) => ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: missions.length,
        itemBuilder: (context, index) {
          final mission = missions[index];
          final currentCharacter = ref.watch(gameStateProvider).selectedCharacter;
          final canTake = currentCharacter != null && currentCharacter.level >= mission.requiredLevel;
          
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: canTake ? const Color(0xFF16213e) : Colors.grey.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: canTake ? _getMissionRankColor(mission.rank) : Colors.grey.withValues(alpha: 0.5),
              ),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _getMissionRankColor(mission.rank).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  mission.rankName,
                  style: TextStyle(
                    color: _getMissionRankColor(mission.rank),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text(
                mission.title,
                style: TextStyle(
                  color: canTake ? Colors.white : Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mission.description,
                    style: TextStyle(
                      color: canTake ? Colors.white.withValues(alpha: 0.8) : Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Level ${mission.requiredLevel}',
                        style: TextStyle(
                          color: canTake ? Colors.white.withValues(alpha: 0.7) : Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(
                        Icons.monetization_on,
                        color: Colors.green,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${mission.ryoReward} Ryo',
                        style: TextStyle(
                          color: canTake ? Colors.white.withValues(alpha: 0.7) : Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              trailing: canTake
                  ? ElevatedButton(
                      onPressed: () {
                        // TODO: Implement take mission - for now just show a message
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Mission "${mission.title}" taken!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Take'),
                    )
                  : Text(
                      'Level ${mission.requiredLevel}',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
            ),
          );
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text('Error: $error', style: const TextStyle(color: Colors.red)),
      ),
    );
  }

  Widget _buildQuestsTab() {
    return const Center(
      child: Text(
        'Quests coming soon!',
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }

  Widget _buildBankTab() {
    final user = ref.watch(authStateProvider).user;
    
    if (user?.currentCharacterId == null) {
      return const Center(
        child: Text(
          'No character selected',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      );
    }

    final characterAsync = ref.watch(characterProvider(user!.currentCharacterId!));
    
    return characterAsync.when(
      data: (character) {
        if (character == null) {
          return const Center(
            child: Text(
              'Character not found',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Balance Cards
              Row(
                children: [
                  Expanded(
                    child: _buildBalanceCard(
                      'On Hand',
                      _formatNumber(character.ryoOnHand),
                      Icons.account_balance_wallet,
                      Colors.green,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildBalanceCard(
                      'In Bank',
                      _formatNumber(character.ryoBanked),
                      Icons.account_balance,
                      Colors.blue,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Total Wealth
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF16213e),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.deepOrange.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.savings, color: Colors.deepOrange, size: 24),
                    const SizedBox(width: 12),
                    const Text(
                      'Total Wealth',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${_formatNumber(character.ryoOnHand + character.ryoBanked)} Ryo',
                      style: const TextStyle(
                        color: Colors.deepOrange,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Bank Actions
              _buildBankAction(
                'Deposit Ryo',
                'Move money from hand to bank',
                Icons.arrow_downward,
                Colors.green,
                () => _showDepositDialog(character),
              ),
              
              const SizedBox(height: 16),
              
              _buildBankAction(
                'Withdraw Ryo',
                'Move money from bank to hand',
                Icons.arrow_upward,
                Colors.orange,
                () => _showWithdrawDialog(character),
              ),
              
              const SizedBox(height: 16),
              
              _buildBankAction(
                'Transfer to Player',
                'Send money to another player',
                Icons.swap_horiz,
                Colors.purple,
                () => _showTransferDialog(character),
              ),
            ],
          ),
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(color: Colors.deepOrange),
      ),
      error: (error, _) => Center(
        child: Text(
          'Error loading character: $error',
          style: const TextStyle(color: Colors.red),
        ),
      ),
    );
  }

  Widget _buildClanHallTab() {
    final user = ref.watch(authStateProvider).user;
    final clansAsync = ref.watch(clansByVillageProvider(user?.lastVillage ?? ''));
    
    return clansAsync.when(
      data: (clans) {
        if (clans.isEmpty) {
          return const Center(
            child: Text(
              'No clans found in this village',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          );
        }
        
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: clans.length,
          itemBuilder: (context, index) {
            final clan = clans[index];
            final isMember = user != null && clan.memberIds.contains(user.id);
            
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
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
                        const Icon(Icons.group, color: Colors.deepOrange),
                        const SizedBox(width: 8),
                        Text(
                          clan.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                                                 if (clan.canAcceptMembers && user != null && !isMember)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'Recruiting',
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          clan.description,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Clan Info
                        Row(
                          children: [
                            _buildClanInfo('Leader', 'User ${clan.leaderId}'),
                            const SizedBox(width: 16),
                            _buildClanInfo('Members', '${clan.totalMembers}/${clan.maxMembers}'),
                          ],
                        ),
                        
                        const SizedBox(height: 16),
                        
                        if (isMember) ...[
                          const Text(
                            'Your Role:',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            clan.getMemberRank(user.id).name.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.deepOrange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ] else if (clan.canAcceptMembers) ...[
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                // TODO: Implement apply to clan
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepOrange,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Apply to Join'),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text('Error: $error', style: const TextStyle(color: Colors.red)),
      ),
    );
  }

  Widget _buildDarkOpsTab() {
    return const Center(
      child: Text(
        'Dark Ops coming soon!',
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }

  Widget _buildHospitalTab() {
    return const HospitalScreen();
  }

  Widget _buildTrainingTab() {
    final user = ref.watch(authStateProvider).user;
    if (user == null) return _buildNoUserMessage();
    
    final currentCharacter = ref.watch(gameStateProvider).selectedCharacter;
    if (currentCharacter == null) return _buildNoCharacterMessage();
    
    final activeSessions = ref.watch(activeTrainingSessionsProvider);
    final characterSessions = activeSessions.where((s) => s.characterId == currentCharacter.id).toList();
    final hasActiveSessions = characterSessions.isNotEmpty;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Active Training Sessions
          if (hasActiveSessions) ...[
            _buildActiveTrainingSessionsSection(characterSessions),
            const SizedBox(height: 20),
          ],
          
          // Available Training Options
          _buildAvailableTrainingOptions(currentCharacter, hasActiveSessions),
        ],
      ),
    );
  }

  Widget _buildActiveTrainingSessionsSection(List<TrainingSession> characterSessions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.deepOrange.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.deepOrange.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.play_circle,
                color: Colors.deepOrange,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Active Training Sessions',
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
        ...characterSessions.map((session) => _buildActiveTrainingCard(session)),
      ],
    );
  }

  Widget _buildAvailableTrainingOptions(Character character, bool hasActiveSessions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.green.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.green.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.fitness_center,
                color: Colors.green,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Available Training Options',
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
        
        // Core Stats Grid
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.blue.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.blue.withValues(alpha: 0.3),
            ),
          ),
          child: Text(
            'Core Stats',
            style: TextStyle(
              color: Colors.blue,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 2.5,
          children: [
            'strength',
            'intelligence',
            'speed',
            'defense',
            'willpower',
          ].map((statType) => _buildStatTrainingCard(statType, character, hasActiveSessions)).toList(),
        ),
        
        const SizedBox(height: 20),
        
        // Combat Stats Grid
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.purple.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.purple.withValues(alpha: 0.3),
            ),
          ),
          child: Text(
            'Combat Stats',
            style: TextStyle(
              color: Colors.purple,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 2.5,
          children: [
            'bukijutsu',
            'ninjutsu',
            'taijutsu',
            'genjutsu',
          ].map((statType) => _buildStatTrainingCard(statType, character, hasActiveSessions)).toList(),
        ),
      ],
    );
  }



  Widget _buildNoUserMessage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Please log in to access training.',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/login');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepOrange,
              foregroundColor: Colors.white,
            ),
            child: const Text('Go to Login'),
          ),
        ],
      ),
    );
  }

  Widget _buildNoCharacterMessage() {
    final user = ref.watch(authStateProvider).user;
    if (user == null) return _buildNoUserMessage();

    final userCharacters = ref.watch(authStateProvider.notifier).getUserCharacters(ref);
    if (userCharacters.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'No characters found for this user. Please create one.',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                // Create a default character
                final defaultCharacter = Character(
                  id: 'char_${user.id}_${DateTime.now().millisecondsSinceEpoch}',
                  userId: user.id,
                  name: '${user.username}_${DateTime.now().millisecondsSinceEpoch % 1000}',
                  village: user.lastVillage ?? 'Konoha',
                  clanId: null,
                  clanRank: null,
                  ninjaRank: 'Genin',
                  elements: ['Fire'],
                  bloodline: null,
                  strength: 1000,
                  intelligence: 1000,
                  speed: 1000,
                  defense: 1000,
                  willpower: 1000,
                  bukijutsu: 1000,
                  ninjutsu: 1000,
                  taijutsu: 1000,
                  genjutsu: 0,
                  jutsuMastery: {},
                  currentHp: 40000,
                  currentChakra: 30000,
                  currentStamina: 30000,
                  experience: 0,
                  level: 1,
                  hpRegenRate: 100,
                  cpRegenRate: 100,
                  spRegenRate: 100,
                  ryoOnHand: 1000,
                  ryoBanked: 0,
                  villageLoyalty: 100,
                  outlawInfamy: 0,
                  marriedTo: null,
                  senseiId: null,
                  studentIds: [],
                  pvpWins: 0,
                  pvpLosses: 0,
                  pveWins: 0,
                  pveLosses: 0,
                  medicalExp: 0,
                  avatarUrl: null,
                  gender: 'Unknown',
                  inventory: [],
                );
                
                await ref.read(authStateProvider.notifier).createCharacter(defaultCharacter, ref);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                foregroundColor: Colors.white,
              ),
              child: const Text('Create Character'),
            ),
          ],
        ),
      );
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Please select a character to access training.',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              ref.read(authStateProvider.notifier).selectCharacter(userCharacters.first, ref);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepOrange,
              foregroundColor: Colors.white,
            ),
            child: const Text('Select Character'),
          ),
        ],
      ),
    );
  }



  Widget _buildActiveTrainingCard(TrainingSession session) {
    final trainingNotifier = ref.read(activeTrainingSessionsProvider.notifier);
    final completedNotifier = ref.read(completedTrainingSessionsProvider.notifier);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF16213e),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.deepOrange.withValues(alpha: 0.4),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.deepOrange.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.deepOrange.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  TrainingService.getStatIcon(session.statType),
                  style: const TextStyle(fontSize: 24),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Training ${TrainingService.getStatDisplayName(session.statType)}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Started ${session.formattedElapsedTime} ago',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              if (session.isComplete) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Complete',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Progress bar
          Container(
            height: 8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Colors.grey.withValues(alpha: 0.3),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: session.progress,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  gradient: LinearGradient(
                    colors: session.isComplete 
                      ? [Colors.green, Colors.green.shade400]
                      : [Colors.deepOrange, Colors.orange],
                  ),
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 8),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Progress: ${(session.progress * 100).toStringAsFixed(1)}%',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 14,
                ),
              ),
              Text(
                session.isComplete ? 'Ready to collect!' : session.timeRemaining,
                style: TextStyle(
                  color: session.isComplete ? Colors.green : Colors.orange,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
                    Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.blue.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    'Potential Gain: ${session.potentialGain}',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              if (session.isComplete) ...[
                ElevatedButton(
                  onPressed: () {
                    // Complete training and update character
                    final completedSession = trainingNotifier.completeTraining(session.id);
                    if (completedSession != null) {
                      completedNotifier.addCompletedSession(completedSession);
                      
                      // Update character stats using auth provider
                      ref.read(authStateProvider.notifier).completeTraining(
                        session.characterId, 
                        session.statType, 
                        completedSession.actualGain ?? 0, 
                        ref
                      );
                      
                      // Show success message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Training completed! ${TrainingService.getStatDisplayName(session.statType)} +${completedSession.actualGain}',
                          ),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Collect XP'),
                ),
              ] else ...[
                ElevatedButton(
                  onPressed: () {
                    // Redeem training early
                    final completedSession = trainingNotifier.completeTraining(session.id);
                    if (completedSession != null) {
                      completedNotifier.addCompletedSession(completedSession);
                      
                      // Update character stats using auth provider
                      ref.read(authStateProvider.notifier).completeTraining(
                        session.characterId, 
                        session.statType, 
                        completedSession.actualGain ?? 0, 
                        ref
                      );
                      
                      // Show success message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Training redeemed! ${TrainingService.getStatDisplayName(session.statType)} +${completedSession.actualGain}',
                          ),
                          backgroundColor: Colors.deepOrange,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Redeem'),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatTrainingCard(String statType, Character character, bool hasActiveSessions) {
    final trainingNotifier = ref.read(activeTrainingSessionsProvider.notifier);
    final isCurrentlyTraining = ref.watch(activeTrainingSessionsProvider.notifier).isTrainingStat(character.id, statType);
    final canTrain = TrainingService.canTrainStat(character, statType);
    
    return Container(
      decoration: BoxDecoration(
        color: isCurrentlyTraining 
          ? Colors.deepOrange.withValues(alpha: 0.15)
          : canTrain 
            ? const Color(0xFF16213e)
            : Colors.grey.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCurrentlyTraining 
            ? Colors.deepOrange.withValues(alpha: 0.6)
            : canTrain 
              ? Colors.deepOrange.withValues(alpha: 0.4)
              : Colors.grey.withValues(alpha: 0.4),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: isCurrentlyTraining 
              ? Colors.deepOrange.withValues(alpha: 0.1)
              : Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: canTrain && !isCurrentlyTraining ? () {
          trainingNotifier.startTraining(character, statType);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Started training ${TrainingService.getStatDisplayName(statType)}',
              ),
              backgroundColor: Colors.green,
            ),
          );
        } : null,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isCurrentlyTraining 
                        ? Colors.deepOrange.withValues(alpha: 0.2)
                        : Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      TrainingService.getStatIcon(statType),
                      style: const TextStyle(fontSize: 22),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      TrainingService.getStatDisplayName(statType),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (isCurrentlyTraining) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.deepOrange.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.deepOrange.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Text(
                    'Training...',
                    style: TextStyle(
                      color: Colors.deepOrange,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ] else if (canTrain) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.green.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Text(
                    'Available',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ] else ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.grey.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Text(
                    'Maxed',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }



  Widget _buildShopTab() {
    return Consumer(
      builder: (context, ref, child) {
        final shopProvider = ref.watch(shopProviderProvider);
        final character = ref.watch(selectedCharacterProvider);
        
        if (character == null) {
          return const Center(
            child: Text(
              'No character selected',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          );
        }
        
        return Column(
          children: [
            // Shop Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF16213e),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.amber.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.shopping_cart, color: Colors.amber, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Item Shop',
                          style: TextStyle(
                            color: Colors.amber,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Available Ryo: ${character.ryoOnHand}',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Filters
            _buildShopFilters(shopProvider),
            
            const SizedBox(height: 16),
            
            // Equipment Categories
            _buildEquipmentCategories(shopProvider),
            
            const SizedBox(height: 16),
            
            // Items List
            Expanded(
              child: _buildItemsList(shopProvider, character),
            ),
          ],
        );
      },
    );
  }

  Widget _buildShopFilters(ShopProvider shopProvider) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF16213e),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.amber.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filters',
            style: TextStyle(
              color: Colors.amber,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: shopProvider.selectedCategory,
                  decoration: InputDecoration(
                    labelText: 'Category',
                    labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.amber.withValues(alpha: 0.5)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.amber.withValues(alpha: 0.5)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.amber),
                    ),
                  ),
                  dropdownColor: const Color(0xFF16213e),
                  style: const TextStyle(color: Colors.white),
                  items: shopProvider.getAvailableCategories().map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(
                        category == 'all' ? 'All Categories' : category,
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      ref.read(shopProviderProvider.notifier).setCategory(value);
                    }
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: shopProvider.selectedRarity,
                  decoration: InputDecoration(
                    labelText: 'Rarity',
                    labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.amber.withValues(alpha: 0.5)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.amber.withValues(alpha: 0.5)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.amber),
                    ),
                  ),
                  dropdownColor: const Color(0xFF16213e),
                  style: const TextStyle(color: Colors.white),
                  items: shopProvider.getAvailableRarities().map((rarity) {
                    return DropdownMenuItem(
                      value: rarity,
                      child: Text(
                        rarity == 'all' ? 'All Rarities' : rarity,
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      ref.read(shopProviderProvider.notifier).setRarity(value);
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: TextEditingController(text: shopProvider.searchTerm),
                  decoration: InputDecoration(
                    labelText: 'Search',
                    labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
                    hintText: 'Search items...',
                    hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.amber.withValues(alpha: 0.5)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.amber.withValues(alpha: 0.5)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.amber),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                  onChanged: (value) {
                    ref.read(shopProviderProvider.notifier).setSearchTerm(value);
                  },
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: () {
                  ref.read(shopProviderProvider.notifier).clearFilters();
                },
                icon: Icon(Icons.clear, color: Colors.white),
                label: Text('Clear', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.withValues(alpha: 0.8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEquipmentCategories(ShopProvider shopProvider) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildCategoryChip(shopProvider, null, 'All Equipment', Icons.all_inclusive),
          _buildCategoryChip(shopProvider, EquipmentSlot.head, 'Head', Icons.face),
          _buildCategoryChip(shopProvider, EquipmentSlot.arms, 'Arms', Icons.accessibility),
          _buildCategoryChip(shopProvider, EquipmentSlot.body, 'Body', Icons.person),
          _buildCategoryChip(shopProvider, EquipmentSlot.legs, 'Legs', Icons.directions_walk),
          _buildCategoryChip(shopProvider, EquipmentSlot.feet, 'Feet', Icons.sports_soccer),
          _buildCategoryChip(shopProvider, EquipmentSlot.weapon, 'Weapons', Icons.gps_fixed),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(ShopProvider shopProvider, EquipmentSlot? slot, String label, IconData icon) {
    final isSelected = shopProvider.selectedEquipmentSlot == slot;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        selected: isSelected,
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: isSelected ? Colors.white : Colors.amber),
            const SizedBox(width: 4),
            Text(label, style: TextStyle(color: isSelected ? Colors.white : Colors.amber)),
          ],
        ),
        selectedColor: Colors.amber,
        backgroundColor: Colors.transparent,
        side: BorderSide(color: Colors.amber.withValues(alpha: 0.5)),
        onSelected: (selected) {
          ref.read(shopProviderProvider.notifier).setEquipmentSlot(selected ? slot : null);
        },
      ),
    );
  }

  Widget _buildItemsList(ShopProvider shopProvider, Character character) {
    final items = shopProvider.filteredItems;
    
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, color: Colors.white.withValues(alpha: 0.5), size: 48),
            const SizedBox(height: 16),
            Text(
              'No items found',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 18,
              ),
            ),
            Text(
              'Try adjusting your filters',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.5),
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }
    
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _buildItemCard(item, character, shopProvider);
      },
    );
  }

  Widget _buildItemCard(Item item, Character character, ShopProvider shopProvider) {
    final canAfford = shopProvider.canAffordItem(character, item);
    final canUse = shopProvider.canUseItem(character, item);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF16213e),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: item.rarityColor.withValues(alpha: 0.5),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: item.rarityColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(item.typeIcon, color: item.rarityColor, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            item.name,
                            style: TextStyle(
                              color: item.rarityColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: item.rarityColor.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              item.rarity,
                              style: TextStyle(
                                color: item.rarityColor,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        item.description,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${item.buyPrice} Ryo',
                      style: TextStyle(
                        color: canAfford ? Colors.green : Colors.red,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Level ${item.requiredLevel}',
                      style: TextStyle(
                        color: canUse ? Colors.green : Colors.orange,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            
            if (item.statBonuses.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                'Stat Bonuses:',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: item.statBonuses.entries.map((entry) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blue.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${entry.key}: +${entry.value}',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 12,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
            
            if (item.specialEffects.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                'Special Effects:',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: item.specialEffects.map((effect) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.purple.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      effect.replaceAll('_', ' ').toUpperCase(),
                      style: TextStyle(
                        color: Colors.purple,
                        fontSize: 12,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
            
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: canAfford && canUse ? () => _purchaseItem(item, character) : null,
                    icon: Icon(Icons.shopping_cart, color: Colors.white),
                    label: Text('Purchase', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: canAfford && canUse ? Colors.green : Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showItemDetails(item),
                    icon: Icon(Icons.info, color: Colors.amber),
                    label: Text('Details', style: TextStyle(color: Colors.amber)),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.amber),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _purchaseItem(Item item, Character character) async {
    final shopProvider = ref.read(shopProviderProvider.notifier);
    
    try {
      // Attempt to purchase the item using the new async method
      final result = await shopProvider.purchaseItem(character, item);
      
      // Check if widget is still mounted before using context
      if (!mounted) return;
      
      if (result.success) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.message),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );
        
        // Update the game state provider so profile and loadout screens can see changes
        if (result.updatedCharacter != null) {
          ref.read(gameStateProvider.notifier).updateCharacter(result.updatedCharacter!);
        }
        
        // Invalidate character provider to refresh character data
        ref.invalidate(characterProvider(character.id));
        
        // Refresh the shop to show updated Ryo
        ref.read(shopProviderProvider.notifier).initializeShop();
      } else {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.message),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      // Check if widget is still mounted before using context
      if (!mounted) return;
      
      // Show error message for exceptions
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Purchase failed: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _showItemDetails(Item item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF16213e),
        title: Text(
          item.name,
          style: TextStyle(color: item.rarityColor),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                item.description,
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 16),
              if (item.statBonuses.isNotEmpty) ...[
                Text(
                  'Stat Bonuses:',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ...item.statBonuses.entries.map((entry) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    '${entry.key}: +${entry.value}',
                    style: const TextStyle(color: Colors.white),
                  ),
                )),
                const SizedBox(height: 16),
              ],
              if (item.statMultipliers.isNotEmpty) ...[
                Text(
                  'Stat Multipliers:',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ...item.statMultipliers.entries.map((entry) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    '${entry.key}: x${entry.value}',
                    style: const TextStyle(color: Colors.white),
                  ),
                )),
                const SizedBox(height: 16),
              ],
              if (item.specialEffects.isNotEmpty) ...[
                Text(
                  'Special Effects:',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ...item.specialEffects.map((effect) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    '• ${effect.replaceAll('_', ' ').toUpperCase()}',
                    style: const TextStyle(color: Colors.white),
                  ),
                )),
                const SizedBox(height: 16),
              ],
              Text(
                'Price: ${item.buyPrice} Ryo',
                style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              ),
              Text(
                'Required Level: ${item.requiredLevel}',
                style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
              ),
              if (item.durability != null) ...[
                Text(
                  'Durability: ${item.durability}/${item.maxDurability}',
                  style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close', style: TextStyle(color: Colors.amber)),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceCard(String title, String amount, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF16213e),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            amount,
            style: TextStyle(
              color: color,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBankAction(String title, String description, IconData icon, Color color, VoidCallback onTap) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF16213e),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Row(
          children: [
            Icon(icon, color: color, size: 24),
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
              color: color.withValues(alpha: 0.7),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClanInfo(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 12,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }



  Color _getMissionRankColor(MissionRank rank) {
    switch (rank) {
      case MissionRank.S:
        return Colors.red;
      case MissionRank.A:
        return Colors.orange;
      case MissionRank.B:
        return Colors.green;
      case MissionRank.C:
        return Colors.blue;
      case MissionRank.D:
        return Colors.grey;
    }
  }

  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match match) => '${match[1]},',
    );
  }

  void _showDepositDialog(Character character) {
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
    showDialog(
      context: context,
      builder: (context) => TransferDialog(character: character),
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
}
