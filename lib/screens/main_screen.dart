import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/providers.dart';
import 'home/home_screen.dart';
import 'village/village_screen.dart';
import 'loadout/loadout_screen.dart';
import 'world/world_screen.dart';
import 'profile/profile_screen.dart';

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTab = ref.watch(selectedTabProvider);
    
    final screens = [
      const HomeScreen(),
      const VillageScreen(),
      const LoadoutScreen(),
      const WorldScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: screens[selectedTab],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1a1a2e),
          border: Border(
            top: BorderSide(
              color: Colors.deepOrange.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: selectedTab,
          onTap: (index) {
            ref.read(selectedTabProvider.notifier).state = index;
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color(0xFF1a1a2e),
          selectedItemColor: Colors.deepOrange,
          unselectedItemColor: Colors.white.withValues(alpha: 0.6),
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 12,
          ),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.location_city),
              label: 'Village',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.inventory),
              label: 'Loadout',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.map),
              label: 'World',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
