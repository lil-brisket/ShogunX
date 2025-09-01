import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/auth_provider.dart';
import '../widgets/admin_sidebar.dart';
import 'users/users_screen.dart';
import 'items/items_screen.dart';
import 'jutsus/jutsus_screen.dart';
import 'quests/quests_screen.dart';
import 'settings/settings_screen.dart';

class AdminDashboard extends ConsumerStatefulWidget {
  const AdminDashboard({super.key});

  @override
  ConsumerState<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends ConsumerState<AdminDashboard> {
  int _selectedIndex = 0;
  bool _isSidebarCollapsed = false;

  final List<AdminScreen> _screens = [
    AdminScreen(
      title: 'Users',
      icon: Icons.people,
      screen: const UsersScreen(),
    ),
    AdminScreen(
      title: 'Items',
      icon: Icons.inventory,
      screen: const ItemsScreen(),
    ),
    AdminScreen(
      title: 'Jutsus',
      icon: Icons.auto_awesome,
      screen: const JutsusScreen(),
    ),
    AdminScreen(
      title: 'Quests',
      icon: Icons.assignment,
      screen: const QuestsScreen(),
    ),
    AdminScreen(
      title: 'Settings',
      icon: Icons.settings,
      screen: const SettingsScreen(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isAdmin = ref.watch(isAdminProvider);
    
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          AdminSidebar(
            selectedIndex: _selectedIndex,
            isCollapsed: _isSidebarCollapsed,
            screens: _screens,
            onItemSelected: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            onToggleCollapse: () {
              setState(() {
                _isSidebarCollapsed = !_isSidebarCollapsed;
              });
            },
          ),
          
          // Main Content
          Expanded(
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Column(
                children: [
                  // Top App Bar
                  _buildTopAppBar(),
                  
                  // Content Area
                  Expanded(
                    child: isAdmin.when(
                      data: (isAdmin) {
                        if (isAdmin) {
                          return _screens[_selectedIndex].screen;
                        } else {
                          return const Center(
                            child: Text(
                              'Access denied. Admin privileges required.',
                              style: TextStyle(fontSize: 18, color: Colors.red),
                            ),
                          );
                        }
                      },
                      loading: () => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      error: (error, stack) => Center(
                        child: Text('Error: $error'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopAppBar() {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Toggle Sidebar Button
          IconButton(
            onPressed: () {
              setState(() {
                _isSidebarCollapsed = !_isSidebarCollapsed;
              });
            },
            icon: Icon(
              _isSidebarCollapsed ? Icons.menu_open : Icons.menu,
              color: Colors.grey,
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Current Screen Title
          Text(
            _screens[_selectedIndex].title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          
          const Spacer(),
          
          // User Info and Logout
          _buildUserInfo(),
        ],
      ),
    );
  }

  Widget _buildUserInfo() {
    final user = ref.watch(currentUserProvider);
    
    return Row(
      children: [
        // User Avatar
        CircleAvatar(
          radius: 16,
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: Text(
            user?.email?.substring(0, 1).toUpperCase() ?? 'A',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        
        const SizedBox(width: 8),
        
        // User Email
        Text(
          user?.email ?? 'Unknown',
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        
        const SizedBox(width: 16),
        
        // Logout Button
        IconButton(
          onPressed: () => _showLogoutDialog(),
          icon: const Icon(Icons.logout, color: Colors.grey),
          tooltip: 'Logout',
        ),
      ],
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(firebaseAuthProvider).signOut();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}

class AdminScreen {
  final String title;
  final IconData icon;
  final Widget screen;

  AdminScreen({
    required this.title,
    required this.icon,
    required this.screen,
  });
}
