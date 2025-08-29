import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/providers.dart';
import '../../models/models.dart';
import '../../services/banking_service.dart';
import '../profile/transfer_dialog.dart';


class VillageScreen extends ConsumerStatefulWidget {
  const VillageScreen({super.key});

  @override
  ConsumerState<VillageScreen> createState() => _VillageScreenState();
}

class _VillageScreenState extends ConsumerState<VillageScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 8, vsync: this);
    _tabController.addListener(() {
      ref.read(selectedVillageTabProvider.notifier).state = _tabController.index;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
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
          // Note: We need character data to check if mission can be taken
          final canTake = false; // TODO: Implement with character data
          
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
                        // TODO: Implement take mission
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
    // Note: HP is now character-specific, not user-specific
    final isDead = false; // TODO: Implement with character data
    
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Status Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDead ? Colors.red.withValues(alpha: 0.2) : Colors.green.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDead ? Colors.red : Colors.green,
              ),
            ),
            child: Column(
              children: [
                Icon(
                  isDead ? Icons.healing : Icons.favorite,
                  color: isDead ? Colors.red : Colors.green,
                  size: 48,
                ),
                const SizedBox(height: 16),
                Text(
                  isDead ? 'You are unconscious!' : 'You are healthy',
                  style: TextStyle(
                    color: isDead ? Colors.red : Colors.green,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  isDead ? 'Your HP has reached 0' : 'Your HP is above 0',
                  style: TextStyle(
                    color: isDead ? Colors.red.withValues(alpha: 0.8) : Colors.green.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
          
          if (isDead) ...[
            const SizedBox(height: 32),
            
            _buildHospitalAction(
              'Wait to Heal (2 min)',
              'Free healing over time',
              Icons.timer,
              Colors.blue,
              () {
                // TODO: Implement wait to heal
              },
            ),
            
            const SizedBox(height: 16),
            
            _buildHospitalAction(
              'Pay to Heal (100 Ryo)',
              'Instant healing for a price',
              Icons.payment,
              Colors.green,
              () {
                // TODO: Implement pay to heal
              },
            ),
            
            const SizedBox(height: 16),
            
            _buildHospitalAction(
              'Get Healed by Player',
              'Request healing from others',
              Icons.people,
              Colors.purple,
              () {
                // TODO: Implement player healing
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTrainingTab() {
    return const Center(
      child: Text(
        'Training Arena coming soon!',
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }

  Widget _buildShopTab() {
    return const Center(
      child: Text(
        'Item Shop coming soon!',
        style: TextStyle(color: Colors.white, fontSize: 18),
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

  Widget _buildHospitalAction(String title, String description, IconData icon, Color color, VoidCallback onTap) {
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
