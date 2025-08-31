import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/providers.dart';
import '../../models/models.dart';
import '../../services/services.dart';
import 'avatar_change_dialog.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _displayNameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _displayNameController.dispose();
    super.dispose();
  }

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

    // Get the current character from game state
    final gameState = ref.watch(gameStateProvider);
    final currentCharacter = gameState.selectedCharacter;
    
    if (currentCharacter == null) {
      return _buildNoCharacterScreen();
    }
    
    return _buildSettingsContent(context, user, currentCharacter);
  }

  Widget _buildNoCharacterScreen() {
    return Scaffold(
      backgroundColor: const Color(0xFF0f3460),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1a1a2e),
        title: const Text(
          'Settings',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back, color: Colors.deepOrange),
        ),
        elevation: 0,
      ),
      body: const Center(
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
              'Create or select a character to access settings',
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

  Widget _buildSettingsContent(BuildContext context, User user, Character character) {
    return Scaffold(
      backgroundColor: const Color(0xFF0f3460),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1a1a2e),
        title: const Text(
          'Settings',
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
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Character Info Card
              _buildCharacterInfoCard(character),
              const SizedBox(height: 16),

              // Avatar Settings
              _buildSettingsSection(
                'Avatar & Appearance',
                Icons.face,
                [
                  _buildSettingTile(
                    'Change Avatar',
                    'Update your profile picture',
                    Icons.photo_camera,
                    () => _showAvatarChangeDialog(character),
                  ),
                  _buildSettingTile(
                    'Change Gender',
                    'Switch between male/female/other',
                    Icons.person,
                    () => _showGenderChangeDialog(character),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Character Settings
              _buildSettingsSection(
                'Character Management',
                Icons.person_outline,
                [
                  _buildSettingTile(
                    'Change Name',
                    'Modify your character name (costs 1000 Ryo)',
                    Icons.edit,
                    () => _showNameChangeDialog(character),
                    subtitle: 'Cost: 1000 Ryo',
                    enabled: character.ryoOnHand >= 1000,
                  ),
                  _buildSettingTile(
                    'Stat Reset',
                    'Reset all character stats (costs 5000 Ryo)',
                    Icons.refresh,
                    () => _showStatResetDialog(character),
                    subtitle: 'Cost: 5000 Ryo',
                    enabled: character.ryoOnHand >= 5000,
                  ),
                  _buildSettingTile(
                    'Element Re-roll',
                    'Change your elemental affinity (costs 10000 Ryo)',
                    Icons.shuffle,
                    () => _showElementRerollDialog(character),
                    subtitle: 'Cost: 10000 Ryo',
                    enabled: character.ryoOnHand >= 10000,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Social Settings
              _buildSettingsSection(
                'Social & Relationships',
                Icons.people,
                [
                  _buildSettingTile(
                    character.marriedTo != null ? 'Divorce' : 'Marriage Proposal',
                    character.marriedTo != null 
                        ? 'Divorce (costs 2000 Ryo)' 
                        : 'Propose to another player',
                    character.marriedTo != null ? Icons.heart_broken : Icons.favorite,
                    () => character.marriedTo != null 
                        ? _showDivorceDialog(character) 
                        : _showMarriageDialog(character),
                    subtitle: character.marriedTo != null 
                        ? 'Currently married to ${character.marriedTo}' 
                        : null,
                  ),
                  _buildSettingTile(
                    'Sensei/Student Management',
                    'Manage mentorship relationships',
                    Icons.school,
                    () => _showMentorshipDialog(character),
                    subtitle: character.senseiId != null 
                        ? 'Has sensei' 
                        : character.studentIds.isNotEmpty 
                            ? '${character.studentIds.length} students'
                            : null,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Display Settings
              _buildSettingsSection(
                'Display & Customization',
                Icons.badge,
                [
                  _buildSettingTile(
                    'Display Name',
                    'Set a custom display name',
                    Icons.badge,
                    () => _showDisplayNameDialog(character),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Dangerous Actions
              _buildSettingsSection(
                'Dangerous Actions',
                Icons.warning,
                [
                  _buildSettingTile(
                    'Delete Character',
                    'Permanently delete this character',
                    Icons.delete_forever,
                    () => _showDeleteCharacterDialog(character),
                    isDestructive: true,
                  ),
                  _buildSettingTile(
                    'Reset Account',
                    'Reset all progress and start fresh',
                    Icons.restart_alt,
                    () => _showResetAccountDialog(),
                    isDestructive: true,
                  ),
                ],
                isDestructive: true,
              ),
              
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCharacterInfoCard(Character character) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF16213e),
            const Color(0xFF1a1a2e),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.deepOrange.withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.deepOrange,
              borderRadius: BorderRadius.circular(12),
              image: character.avatarUrl != null 
                  ? DecorationImage(
                      image: NetworkImage(character.avatarUrl!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: character.avatarUrl == null
                ? Center(
                    child: Text(
                      character.name.substring(0, 1).toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  character.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${character.ninjaRank} • ${character.village}',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Level ${character.level} • ${_formatNumber(character.ryoOnHand)} Ryo',
                  style: const TextStyle(
                    color: Colors.deepOrange,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(String title, IconData icon, List<Widget> children, {bool isDestructive = false}) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF16213e),
            const Color(0xFF1a1a2e),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDestructive 
              ? Colors.red.withValues(alpha: 0.3)
              : Colors.deepOrange.withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  isDestructive
                      ? Colors.red.withValues(alpha: 0.3)
                      : Colors.deepOrange.withValues(alpha: 0.3),
                  isDestructive
                      ? Colors.red.withValues(alpha: 0.1)
                      : Colors.deepOrange.withValues(alpha: 0.1),
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: isDestructive ? Colors.red : Colors.deepOrange,
                  size: 20,
                ),
                const SizedBox(width: 8),
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

  Widget _buildSettingTile(
    String title, 
    String description, 
    IconData icon, 
    VoidCallback onTap, {
    String? subtitle,
    bool enabled = true,
    bool isDestructive = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: enabled 
                ? Colors.black.withValues(alpha: 0.2)
                : Colors.black.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDestructive
                  ? Colors.red.withValues(alpha: enabled ? 0.3 : 0.1)
                  : Colors.deepOrange.withValues(alpha: enabled ? 0.2 : 0.1),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(
                icon, 
                color: !enabled
                    ? Colors.grey
                    : isDestructive
                        ? Colors.red
                        : Colors.deepOrange, 
                size: 24,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: enabled ? Colors.white : Colors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      description,
                      style: TextStyle(
                        color: enabled 
                            ? Colors.white.withValues(alpha: 0.7) 
                            : Colors.grey.withValues(alpha: 0.7),
                        fontSize: 14,
                      ),
                    ),
                    if (subtitle != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          subtitle,
                          style: TextStyle(
                            color: Colors.deepOrange.withValues(alpha: enabled ? 0.8 : 0.4),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              if (enabled)
                Icon(
                  Icons.arrow_forward_ios,
                  color: isDestructive
                      ? Colors.red.withValues(alpha: 0.7)
                      : Colors.deepOrange.withValues(alpha: 0.7),
                  size: 16,
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Dialog methods with working functionality
  void _showAvatarChangeDialog(Character character) {
    showDialog(
      context: context,
      builder: (context) => AvatarChangeDialog(
        character: character,
        onAvatarChanged: (avatarUrl) => _updateAvatar(character, avatarUrl),
      ),
    );
  }

  void _showGenderChangeDialog(Character character) {
    final availableGenders = ['Male', 'Female', 'Other', 'Unknown'];
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF16213e),
        title: const Text(
          'Change Gender',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Select your character\'s gender:',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 16),
            ...availableGenders.map((gender) => ListTile(
              title: Text(
                gender,
                style: TextStyle(
                  color: character.gender == gender ? Colors.deepOrange : Colors.white,
                  fontWeight: character.gender == gender ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              trailing: character.gender == gender 
                  ? const Icon(Icons.check, color: Colors.deepOrange)
                  : null,
              onTap: () => _updateGender(character, gender),
            )),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
          ),
        ],
      ),
    );
  }

  void _showNameChangeDialog(Character character) {
    _nameController.text = character.name;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF16213e),
        title: const Text(
          'Change Character Name',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Current name: ${character.name}',
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 8),
            Text(
              'Cost: 1000 Ryo',
              style: const TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'New Name',
                labelStyle: const TextStyle(color: Colors.white70),
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
              final newName = _nameController.text.trim();
              if (newName.isNotEmpty && newName != character.name) {
                Navigator.of(context).pop();
                _updateName(character, newName);
              }
            },
            child: const Text('Confirm', style: TextStyle(color: Colors.deepOrange)),
          ),
        ],
      ),
    );
  }

  void _showStatResetDialog(Character character) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF16213e),
        title: const Text(
          'Reset Character Stats',
          style: TextStyle(color: Colors.red),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.warning,
              color: Colors.red,
              size: 48,
            ),
            const SizedBox(height: 16),
            const Text(
              'This will reset ALL your character stats to their starting values.',
              style: TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Cost: 5000 Ryo',
              style: const TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'This action cannot be undone!',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
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
              Navigator.of(context).pop();
              _resetStats(character);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Reset Stats'),
          ),
        ],
      ),
    );
  }

  void _showElementRerollDialog(Character character) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF16213e),
        title: const Text(
          'Reroll Elements',
          style: TextStyle(color: Colors.orange),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.shuffle,
              color: Colors.orange,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              'Current elements: ${character.elements.join(', ')}',
              style: const TextStyle(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              'This will give you a completely new random element.',
              style: TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Cost: 10000 Ryo',
              style: const TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'This action cannot be undone!',
              style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
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
              Navigator.of(context).pop();
              _rerollElements(character);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.orange),
            child: const Text('Reroll Elements'),
          ),
        ],
      ),
    );
  }

  void _showMarriageDialog(Character character) {
    _showInfoDialog(
      'Marriage System',
      'The marriage system is coming soon! You will be able to propose to other players and form special bonds.',
    );
  }

  void _showDivorceDialog(Character character) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF16213e),
        title: const Text(
          'Divorce',
          style: TextStyle(color: Colors.red),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.heart_broken,
              color: Colors.red,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              'Are you sure you want to divorce ${character.marriedTo}?',
              style: const TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Cost: 2000 Ryo',
              style: const TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'This action cannot be undone!',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
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
              Navigator.of(context).pop();
              _divorce(character);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Divorce'),
          ),
        ],
      ),
    );
  }

  void _showMentorshipDialog(Character character) {
    _showInfoDialog(
      'Mentorship System',
      'The mentorship system is coming soon! Jounin+ players will be able to mentor Genin players for stat growth and social bonds.',
    );
  }

  void _showDisplayNameDialog(Character character) {
    _displayNameController.text = character.name;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF16213e),
        title: const Text(
          'Set Display Name',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Set a custom display name that other players will see:',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _displayNameController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Display Name',
                labelStyle: const TextStyle(color: Colors.white70),
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
              final displayName = _displayNameController.text.trim();
              if (displayName.isNotEmpty) {
                Navigator.of(context).pop();
                _updateDisplayName(character, displayName);
              }
            },
            child: const Text('Set', style: TextStyle(color: Colors.deepOrange)),
          ),
        ],
      ),
    );
  }

  void _showDeleteCharacterDialog(Character character) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF16213e),
        title: const Text(
          'Delete Character',
          style: TextStyle(color: Colors.red),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.delete_forever,
              color: Colors.red,
              size: 48,
            ),
            const SizedBox(height: 16),
            const Text(
              'This will PERMANENTLY delete your character and all progress.',
              style: TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              'This action cannot be undone!',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
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
              Navigator.of(context).pop();
              _deleteCharacter(character);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete Character'),
          ),
        ],
      ),
    );
  }

  void _showResetAccountDialog() {
    _showInfoDialog(
      'Reset Account',
      'The account reset feature is coming soon! This will allow you to reset all progress and start fresh.',
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

  // Action methods using the character update provider
  Future<void> _updateAvatar(Character character, String? newAvatarUrl) async {
    try {
      final characterUpdateNotifier = ref.read(characterUpdateNotifierProvider(character.id).notifier);
      final success = await characterUpdateNotifier.updateCharacterAvatar(newAvatarUrl);
      if (success) {
        // Add to avatar history if it's a valid URL
        if (newAvatarUrl != null) {
          final avatarService = AvatarService();
          await avatarService.addAvatarToHistory(newAvatarUrl);
        }
        
        // Invalidate the character provider to refresh the UI
        ref.invalidate(characterProvider(character.id));
        
        _showSuccessSnackbar('Avatar updated successfully!');
      } else {
        _showErrorSnackbar('Failed to update avatar');
      }
    } catch (e) {
      _showErrorSnackbar('Error updating avatar: ${e.toString()}');
    }
  }

  Future<void> _updateGender(Character character, String newGender) async {
    try {
      final characterUpdateNotifier = ref.read(characterUpdateNotifierProvider(character.id).notifier);
      final success = await characterUpdateNotifier.updateCharacterGender(newGender);
      if (success && mounted) {
        Navigator.of(context).pop();
        _showSuccessSnackbar('Gender updated successfully!');
      } else if (mounted) {
        _showErrorSnackbar('Failed to update gender');
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackbar('Error updating gender: ${e.toString()}');
      }
    }
  }

  Future<void> _updateName(Character character, String newName) async {
    try {
      final characterUpdateNotifier = ref.read(characterUpdateNotifierProvider(character.id).notifier);
      final success = await characterUpdateNotifier.updateCharacterName(newName);
      if (mounted) {
        if (success) {
          _showSuccessSnackbar('Name updated successfully!');
        } else {
          _showErrorSnackbar('Insufficient Ryo or failed to update name');
        }
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackbar('Error updating name: ${e.toString()}');
      }
    }
  }

  Future<void> _resetStats(Character character) async {
    try {
      final characterUpdateNotifier = ref.read(characterUpdateNotifierProvider(character.id).notifier);
      final success = await characterUpdateNotifier.resetCharacterStats();
      if (mounted) {
        if (success) {
          _showSuccessSnackbar('Stats reset successfully!');
        } else {
          _showErrorSnackbar('Insufficient Ryo or failed to reset stats');
        }
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackbar('Error resetting stats: ${e.toString()}');
      }
    }
  }

  Future<void> _rerollElements(Character character) async {
    try {
      final characterUpdateNotifier = ref.read(characterUpdateNotifierProvider(character.id).notifier);
      final success = await characterUpdateNotifier.rerollCharacterElements();
      if (mounted) {
        if (success) {
          _showSuccessSnackbar('Elements rerolled successfully!');
        } else {
          _showErrorSnackbar('Insufficient Ryo or failed to reroll elements');
        }
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackbar('Error rerolling elements: ${e.toString()}');
      }
    }
  }

  Future<void> _divorce(Character character) async {
    try {
      final characterUpdateNotifier = ref.read(characterUpdateNotifierProvider(character.id).notifier);
      final success = await characterUpdateNotifier.divorceCharacter();
      if (mounted) {
        if (success) {
          _showSuccessSnackbar('Divorce completed successfully!');
        } else {
          _showErrorSnackbar('Insufficient Ryo or failed to complete divorce');
        }
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackbar('Error completing divorce: ${e.toString()}');
      }
    }
  }

  Future<void> _updateDisplayName(Character character, String displayName) async {
    // For now, this just updates the regular name
    // In the future, this could be a separate display name field
    try {
      final characterUpdateNotifier = ref.read(characterUpdateNotifierProvider(character.id).notifier);
      final success = await characterUpdateNotifier.updateCharacterName(displayName);
      if (mounted) {
        if (success) {
          _showSuccessSnackbar('Display name updated successfully!');
        } else {
          _showErrorSnackbar('Insufficient Ryo or failed to update display name');
        }
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackbar('Error updating display name: ${e.toString()}');
      }
    }
  }

  Future<void> _deleteCharacter(Character character) async {
    try {
      final characterUpdateNotifier = ref.read(characterUpdateNotifierProvider(character.id).notifier);
      final success = await characterUpdateNotifier.deleteCharacter();
      if (mounted) {
        if (success) {
          _showSuccessSnackbar('Character deleted successfully!');
          // Navigate back to character selection or main screen
          context.pop();
        } else {
          _showErrorSnackbar('Failed to delete character');
        }
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackbar('Error deleting character: ${e.toString()}');
      }
    }
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match match) => '${match[1]},',
    );
  }
}