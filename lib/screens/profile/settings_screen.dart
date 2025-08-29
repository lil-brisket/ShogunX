import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/providers.dart';
import '../../models/models.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
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
      data: (character) => character != null ? _buildSettingsContent(context, user, character) : _buildNoCharacterScreen(),
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
        actions: [
          IconButton(
            onPressed: () {
              _showPublicProfileDialog(character);
            },
            icon: const Icon(Icons.visibility, color: Colors.deepOrange),
            tooltip: 'View Public Profile',
          ),
        ],
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
                    () => _showAvatarChangeDialog(),
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
                    'Marriage Proposal',
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

              // Privacy Settings
              _buildSettingsSection(
                'Privacy & Display',
                Icons.security,
                [
                  _buildSettingTile(
                    'Profile Visibility',
                    'Control who can view your profile',
                    Icons.visibility,
                    () => _showPrivacyDialog(),
                  ),
                  _buildSettingTile(
                    'Display Name',
                    'Set a custom display name',
                    Icons.badge,
                    () => _showDisplayNameDialog(),
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
        color: const Color(0xFF16213e),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.deepOrange.withValues(alpha: 0.3),
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
                Text(
                  character.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${character.ninjaRank} • Level ${character.level}',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 14,
                  ),
                ),
                Text(
                  '${character.village} Village',
                  style: TextStyle(
                    color: Colors.deepOrange.withValues(alpha: 0.8),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${character.ryoOnHand} Ryo',
              style: const TextStyle(
                color: Colors.green,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(String title, IconData icon, List<Widget> children, {bool isDestructive = false}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF16213e),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDestructive 
              ? Colors.red.withValues(alpha: 0.3)
              : Colors.deepOrange.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDestructive
                  ? Colors.red.withValues(alpha: 0.2)
                  : Colors.deepOrange.withValues(alpha: 0.2),
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

  // Dialog methods (placeholder implementations)
  void _showPublicProfileDialog(Character character) {
    // TODO: Show public profile view dialog
    _showInfoDialog('Public Profile', 'This feature will show how your profile appears to other players.');
  }

  void _showAvatarChangeDialog() {
    // TODO: Implement avatar selection
    _showInfoDialog('Change Avatar', 'This feature will allow you to upload or select a new avatar.');
  }

  void _showGenderChangeDialog(Character character) {
    // TODO: Implement gender selection
    _showInfoDialog('Change Gender', 'This feature will allow you to change your character\'s gender.');
  }

  void _showNameChangeDialog(Character character) {
    // TODO: Implement name change with Ryo cost
    _showInfoDialog('Change Name', 'This feature will allow you to change your character name for 1000 Ryo.');
  }

  void _showStatResetDialog(Character character) {
    // TODO: Implement stat reset with confirmation
    _showInfoDialog('Stat Reset', 'This feature will reset all your character stats for 5000 Ryo.');
  }

  void _showElementRerollDialog(Character character) {
    // TODO: Implement element reroll
    _showInfoDialog('Element Re-roll', 'This feature will allow you to change your elemental affinity for 10000 Ryo.');
  }

  void _showMarriageDialog(Character character) {
    // TODO: Implement marriage proposal system
    _showInfoDialog('Marriage', 'This feature will allow you to propose to other players.');
  }

  void _showDivorceDialog(Character character) {
    // TODO: Implement divorce system
    _showInfoDialog('Divorce', 'This feature will allow you to divorce your current spouse for 2000 Ryo.');
  }

  void _showMentorshipDialog(Character character) {
    // TODO: Implement sensei/student management
    _showInfoDialog('Mentorship', 'This feature will allow you to manage sensei/student relationships.');
  }

  void _showPrivacyDialog() {
    // TODO: Implement privacy settings
    _showInfoDialog('Privacy Settings', 'This feature will allow you to control profile visibility.');
  }

  void _showDisplayNameDialog() {
    // TODO: Implement display name change
    _showInfoDialog('Display Name', 'This feature will allow you to set a custom display name.');
  }

  void _showDeleteCharacterDialog(Character character) {
    // TODO: Implement character deletion with strong confirmation
    _showInfoDialog('Delete Character', 'This feature will permanently delete your character. This action cannot be undone!');
  }

  void _showResetAccountDialog() {
    // TODO: Implement account reset with strong confirmation
    _showInfoDialog('Reset Account', 'This feature will reset all your progress. This action cannot be undone!');
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