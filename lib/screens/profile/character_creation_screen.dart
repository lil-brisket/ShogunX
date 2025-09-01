import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/providers.dart';
import '../../models/models.dart';

class CharacterCreationScreen extends ConsumerStatefulWidget {
  const CharacterCreationScreen({super.key});

  @override
  ConsumerState<CharacterCreationScreen> createState() => _CharacterCreationScreenState();
}

class _CharacterCreationScreenState extends ConsumerState<CharacterCreationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String _selectedVillage = 'Konoha';
  String _selectedGender = 'Unknown';
  bool _isCreating = false;

  final List<String> _availableVillages = [
    'Konoha',
    'Suna',
    'Kiri',
    'Kumo',
    'Iwa',
  ];

  final List<String> _availableGenders = [
    'Unknown',
    'Male',
    'Female',
    'Other',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _createCharacter() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isCreating = true;
      });

      try {
        final user = ref.read(authStateProvider).user;
        if (user == null) {
          throw Exception('User not found');
        }

        // Create a new character
        final newCharacter = Character(
          id: 'char_${user.id}_${DateTime.now().millisecondsSinceEpoch}',
          userId: user.id,
          name: _nameController.text.trim(),
          village: _selectedVillage,
          clanId: null,
          clanRank: null,
          ninjaRank: 'Academy Student',
          elements: _getRandomElements(),
          bloodline: null,
          strength: 1,
          intelligence: 1,
          speed: 1,
          defense: 1,
          willpower: 1,
          bukijutsu: 1,
          ninjutsu: 1,
          taijutsu: 1,
          genjutsu: 1,
          jutsuMastery: {},
          currentHp: 30,
          currentChakra: 30,
          currentStamina: 30,
          experience: 0,
          level: 1,
          hpRegenRate: 1,
          cpRegenRate: 1,
          spRegenRate: 1,
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
          gender: _selectedGender,
          inventory: [],
          equippedItems: {},
        );

        // Create the character using the auth provider
        await ref.read(authStateProvider.notifier).createCharacter(newCharacter, ref);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Character "${newCharacter.name}" created successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          context.pop();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to create character: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isCreating = false;
          });
        }
      }
    }
  }

  List<String> _getRandomElements() {
    final allElements = ['Fire', 'Water', 'Earth', 'Wind', 'Lightning'];
    final random = DateTime.now().millisecondsSinceEpoch % allElements.length;
    return [allElements[random]];
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final gameState = ref.watch(gameStateProvider);
        final userCharacters = gameState.userCharacters;
        
        // If user already has a character, show error and go back
        if (userCharacters.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('You already have a character. Only one character per account is allowed.'),
                backgroundColor: Colors.red,
              ),
            );
            context.pop();
          });
          
          return Scaffold(
            backgroundColor: const Color(0xFF0f3460),
            body: Center(
              child: Text(
                'Redirecting...',
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        }
        
        return Scaffold(
      backgroundColor: const Color(0xFF0f3460),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1a1a2e),
        title: const Text(
          'Create Character',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back, color: Colors.deepOrange),
        ),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFF16213e),
                        const Color(0xFF1a1a2e),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.deepOrange.withValues(alpha: 0.5),
                      width: 2,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.person_add,
                        size: 60,
                        color: Colors.deepOrange,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Create Your Ninja',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Begin your journey in the Ninja World',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Character Name
                TextFormField(
                  controller: _nameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Character Name',
                    labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
                    prefixIcon: const Icon(Icons.person, color: Colors.deepOrange),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: Colors.deepOrange),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: Colors.deepOrange.withValues(alpha: 0.5)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: Colors.deepOrange, width: 2),
                    ),
                    filled: true,
                    fillColor: Colors.black.withValues(alpha: 0.3),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a character name';
                    }
                    if (value.trim().length < 3) {
                      return 'Name must be at least 3 characters long';
                    }
                    if (value.trim().length > 20) {
                      return 'Name must be less than 20 characters';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 24),
                
                // Village Selection
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.deepOrange.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.location_city, color: Colors.deepOrange),
                          const SizedBox(width: 8),
                          Text(
                            'Select Village',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _availableVillages.map((village) {
                          final isSelected = _selectedVillage == village;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedVillage = village;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: isSelected 
                                    ? Colors.deepOrange 
                                    : Colors.black.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isSelected 
                                      ? Colors.deepOrange 
                                      : Colors.deepOrange.withValues(alpha: 0.3),
                                ),
                              ),
                              child: Text(
                                village,
                                style: TextStyle(
                                  color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.8),
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Gender Selection
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.deepOrange.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.person_outline, color: Colors.deepOrange),
                          const SizedBox(width: 8),
                          Text(
                            'Select Gender',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _availableGenders.map((gender) {
                          final isSelected = _selectedGender == gender;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedGender = gender;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: isSelected 
                                    ? Colors.deepOrange 
                                    : Colors.black.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isSelected 
                                      ? Colors.deepOrange 
                                      : Colors.deepOrange.withValues(alpha: 0.3),
                                ),
                              ),
                              child: Text(
                                gender,
                                style: TextStyle(
                                  color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.8),
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Character Stats Preview
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.deepOrange.withValues(alpha: 0.1),
                        Colors.deepOrange.withValues(alpha: 0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.deepOrange.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.analytics, color: Colors.deepOrange),
                          const SizedBox(width: 8),
                          Text(
                            'Starting Stats',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildStatRow('Strength', 1000),
                      _buildStatRow('Intelligence', 1000),
                      _buildStatRow('Speed', 1000),
                      _buildStatRow('Defense', 1000),
                      _buildStatRow('Willpower', 1000),
                      const SizedBox(height: 12),
                      _buildStatRow('Bukijutsu', 1000),
                      _buildStatRow('Ninjutsu', 1000),
                      _buildStatRow('Taijutsu', 1000),
                      _buildStatRow('Genjutsu', 0),
                    ],
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Create Button
                ElevatedButton(
                  onPressed: _isCreating ? null : _createCharacter,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 8,
                  ),
                  child: _isCreating
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text('Creating Character...'),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.person_add),
                            const SizedBox(width: 8),
                            Text(
                              'Create Character',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
        );
      },
    );
  }

  Widget _buildStatRow(String statName, int value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            statName,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 14,
            ),
          ),
          Text(
            value.toString(),
            style: TextStyle(
              color: Colors.deepOrange,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
