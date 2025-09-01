import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/models.dart';
import '../../providers/providers.dart';
import '../../services/services.dart';
import '../../widgets/logout_button.dart';

class HospitalScreen extends ConsumerStatefulWidget {
  const HospitalScreen({super.key});

  @override
  ConsumerState<HospitalScreen> createState() => _HospitalScreenState();
}

class _HospitalScreenState extends ConsumerState<HospitalScreen> {
  Timer? _naturalHealingTimer;

  @override
  void initState() {
    super.initState();
    // Set up timer to process natural healing every 30 seconds
    _naturalHealingTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      ref.read(hospitalOperationsProvider).processNaturalHealing();
    });
  }

  @override
  void dispose() {
    _naturalHealingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hospital'),
        backgroundColor: theme.colorScheme.surface,
        foregroundColor: theme.colorScheme.onSurface,
        actions: const [
          LogoutButton(),
        ],
      ),
      body: Column(
        children: [
          // Medical Rank Info
          _buildMedicalRankCard(),
          
          // Patient List
          Expanded(
            child: _buildPatientList(),
          ),
        ],
      ),
    );
  }

  Widget _buildMedicalRankCard() {
    return Consumer(
      builder: (context, ref, child) {
        final character = ref.watch(gameStateProvider).selectedCharacter;
        if (character == null) return const SizedBox.shrink();
        
        final medicalRank = ref.watch(medicalRankProvider(character.id));
        final medicalExp = ref.watch(medicalExpProvider(character.id));
        
        return Card(
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Medical Rank',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            medicalRank.name,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            medicalRank.description,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'EXP: ${medicalExp.toStringAsFixed(0)}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 4),
                        _buildRankProgressBar(medicalExp, medicalRank),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatInfo('CP/HP', medicalRank.cpPerHp.toStringAsFixed(1)),
                    ),
                    Expanded(
                      child: _buildStatInfo('SP/HP', medicalRank.spPerHp.toStringAsFixed(1)),
                    ),
                    Expanded(
                      child: _buildStatInfo('Efficiency', '${(medicalRank.healingEfficiency * 100).toStringAsFixed(0)}%'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRankProgressBar(int currentExp, MedicalRank currentRank) {
    final progress = MedicalRank.getProgressToNextRank(currentExp);
    final nextRank = MedicalRank.getNextRank(currentExp);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'Next: ${nextRank.name}',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 2),
        SizedBox(
          width: 80,
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[800],
            valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
          ),
        ),
      ],
    );
  }

  Widget _buildStatInfo(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.grey[400],
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildPatientList() {
    return Consumer(
      builder: (context, ref, child) {
        final patientsAsync = ref.watch(hospitalPatientsProvider);
        
        return patientsAsync.when(
          data: (patients) {
            if (patients.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.local_hospital,
                      size: 64,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No patients in hospital',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Patients will appear here when their HP reaches 0',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              );
            }
            
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: patients.length,
              itemBuilder: (context, index) {
                final patient = patients[index];
                return _buildPatientCard(patient);
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Text('Error: $error'),
          ),
        );
      },
    );
  }

  Widget _buildPatientCard(HospitalPatient patient) {
    final theme = Theme.of(context);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Patient Name and Status
            Row(
              children: [
                Expanded(
                  child: Text(
                    patient.characterName,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                _buildStatusChip(patient),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Health Bars
            _buildHealthBar('HP', patient.currentHp, patient.maxHp, Colors.red),
            const SizedBox(height: 8),
            _buildHealthBar('CP', patient.currentChakra, patient.maxChakra, Colors.blue),
            const SizedBox(height: 8),
            _buildHealthBar('SP', patient.currentStamina, patient.maxStamina, Colors.green),
            
            const SizedBox(height: 16),
            
            // Healing Options
            if (!patient.isFullyHealed) _buildHealingOptions(patient),
            
            // Natural Healing Timer
            if (patient.naturalHealTime != null && !patient.isFullyHealed)
              _buildNaturalHealingTimer(patient),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(HospitalPatient patient) {
    if (patient.isFullyHealed) {
      return Chip(
        label: const Text('Healed'),
        backgroundColor: Colors.green[800],
        labelStyle: const TextStyle(color: Colors.white),
      );
    } else if (patient.isPaidHeal) {
      return Chip(
        label: const Text('Paid Heal'),
        backgroundColor: Colors.orange[800],
        labelStyle: const TextStyle(color: Colors.white),
      );
    } else {
      return Chip(
        label: const Text('Recovering'),
        backgroundColor: Colors.blue[800],
        labelStyle: const TextStyle(color: Colors.white),
      );
    }
  }

  Widget _buildHealthBar(String label, int current, int max, Color color) {
    final percentage = max > 0 ? current / max : 0.0;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(
              '$current / $max',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: percentage,
          backgroundColor: Colors.grey[800],
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      ],
    );
  }

  Widget _buildHealingOptions(HospitalPatient patient) {
    return Consumer(
      builder: (context, ref, child) {
        final currentCharacter = ref.watch(gameStateProvider).selectedCharacter;
        final isOwnCharacter = currentCharacter?.id == patient.characterId;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Healing Options',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                // Only show paid heal option to the character owner
                if (isOwnCharacter) ...[
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _showPaidHealDialog(patient),
                      icon: const Icon(Icons.payment),
                      label: const Text('Paid Heal'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showMedicHealDialog(patient),
                    icon: const Icon(Icons.healing),
                    label: const Text('Medic Heal'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildNaturalHealingTimer(HospitalPatient patient) {
    return Consumer(
      builder: (context, ref, child) {
        return FutureBuilder<Duration>(
          future: Future.value(patient.timeUntilNaturalHeal),
          builder: (context, snapshot) {
            final timeRemaining = snapshot.data ?? Duration.zero;
            
            if (timeRemaining.inSeconds <= 0) {
              return const Text(
                'Natural healing complete!',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.w600,
                ),
              );
            }
            
            final minutes = timeRemaining.inMinutes;
            final seconds = timeRemaining.inSeconds % 60;
            
            return Row(
              children: [
                const Icon(
                  Icons.timer,
                  color: Colors.blue,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  'Natural healing in: ${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                  style: const TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showPaidHealDialog(HospitalPatient patient) {
    final cost = HospitalService.paidHealCost;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Paid Healing'),
        content: Text(
          'Pay $cost Ryo for instant full healing?\n\n'
          'This will restore all HP, CP, and SP immediately.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final navigator = Navigator.of(context);
              final messenger = ScaffoldMessenger.of(context);
              navigator.pop();
              final success = await ref.read(hospitalOperationsProvider).performPaidHeal(patient.characterId, cost);
              
              if (mounted) {
                if (success) {
                  messenger.showSnackBar(
                    const SnackBar(
                      content: Text('Healing successful!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  messenger.showSnackBar(
                    const SnackBar(
                      content: Text('Healing failed. Insufficient Ryo.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void _showMedicHealDialog(HospitalPatient patient) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Medic Healing'),
        content: const Text(
          'Use your CP and SP to heal this patient as much as possible?\n\n'
          'You will gain medical experience and the patient will be healed based on your available resources.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final navigator = Navigator.of(context);
              final messenger = ScaffoldMessenger.of(context);
              navigator.pop();
              
              final character = ref.read(gameStateProvider).selectedCharacter;
              if (character == null) return;
              
              final result = await ref.read(hospitalOperationsProvider).performMedicHeal(character, patient.characterId);
              
              if (mounted) {
                if (result.success) {
                  messenger.showSnackBar(
                    SnackBar(
                      content: Text(
                        'Healed ${result.hpHealed} HP! '
                        'Used ${result.cpUsed} CP and ${result.spUsed} SP. '
                        'Gained ${result.expGained} medical EXP!',
                      ),
                      backgroundColor: Colors.green,
                    ),
                  );
                  
                  if (result.newRank != null) {
                    messenger.showSnackBar(
                      SnackBar(
                        content: Text(
                          'Congratulations! You are now a ${result.newRank!.name}!',
                        ),
                        backgroundColor: Colors.orange,
                      ),
                    );
                  }
                } else {
                  messenger.showSnackBar(
                    SnackBar(
                      content: Text('Healing failed: ${result.errorMessage}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
}
