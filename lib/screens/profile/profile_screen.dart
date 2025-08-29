import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/providers.dart';

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
                    radius: 24,
                    backgroundColor: Colors.deepOrange,
                    child: Text(
                      user.username.substring(0, 1).toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.username,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${user.lastVillage ?? 'Unknown'} Village',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      // TODO: Show settings dialog
                    },
                    icon: const Icon(
                      Icons.settings,
                      color: Colors.deepOrange,
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
                    // Account Info Card
                    _buildInfoCard(
                      'Account Information',
                      [
                        _buildInfoRow('Username', user.username),
                        _buildInfoRow('Display Name', user.displayName ?? 'Not set'),
                        _buildInfoRow('Email', user.email ?? 'Not set'),
                        _buildInfoRow('Last Village', user.lastVillage ?? 'Unknown'),
                        _buildInfoRow('Member Since', _formatDate(user.createdAt)),
                        _buildInfoRow('Last Login', _formatDate(user.lastLogin)),
                        _buildInfoRow('Last Activity', _formatDate(user.lastActivity ?? user.lastLogin)),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Character Info Card
                    _buildInfoCard(
                      'Character Information',
                      [
                        _buildInfoRow('Characters Owned', '${user.characterIds.length}'),
                        _buildInfoRow('Current Character', user.currentCharacterId ?? 'None selected'),
                        _buildInfoRow('Account Status', user.isActive ? 'Active' : 'Inactive'),
                        _buildInfoRow('Verified', user.isVerified ? 'Yes' : 'No'),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Social Info Card
                    _buildInfoCard(
                      'Social Information',
                      [
                        _buildInfoRow('Friends', '${user.friends.length}'),
                        _buildInfoRow('Blocked Users', '${user.blockedUsers.length}'),
                        _buildInfoRow('Ignored Users', '${user.ignoredUsers.length}'),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Settings Section
                    Container(
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
                                const Icon(Icons.settings, color: Colors.deepOrange),
                                const SizedBox(width: 8),
                                const Text(
                                  'Settings & Actions',
                                  style: TextStyle(
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
                              children: [
                                _buildSettingAction(
                                  'Edit Avatar',
                                  'Change your profile picture',
                                  Icons.photo_camera,
                                  () {
                                    // TODO: Implement avatar editing
                                  },
                                ),
                                
                                const SizedBox(height: 12),
                                
                                _buildSettingAction(
                                  'Change Name',
                                  'Modify your username',
                                  Icons.edit,
                                  () {
                                    // TODO: Implement name change
                                  },
                                ),
                                
                                const SizedBox(height: 12),
                                
                                _buildSettingAction(
                                  'Change Gender',
                                  'Update your character gender',
                                  Icons.person,
                                  () {
                                    // TODO: Implement gender change
                                  },
                                ),
                                
                                const SizedBox(height: 12),
                                
                                _buildSettingAction(
                                  'Marriage',
                                  'Propose or accept marriage',
                                  Icons.favorite,
                                  () {
                                    // TODO: Implement marriage system
                                  },
                                ),
                                
                                const SizedBox(height: 12),
                                
                                _buildSettingAction(
                                  'Stat Reset',
                                  'Reset your character stats',
                                  Icons.refresh,
                                  () {
                                    // TODO: Implement stat reset
                                  },
                                ),
                                
                                const SizedBox(height: 12),
                                
                                _buildSettingAction(
                                  'Element Re-roll',
                                  'Change your elemental affinity',
                                  Icons.shuffle,
                                  () {
                                    // TODO: Implement element re-roll
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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
}
