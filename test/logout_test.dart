import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ninja_world_mmo/providers/providers.dart';

void main() {
  group('Logout Functionality', () {
    test('auth provider should exist and be accessible', () {
      final container = ProviderContainer();
      
      // Test that auth provider exists
      final authNotifier = container.read(authStateProvider.notifier);
      expect(authNotifier, isNotNull);
      
      // Test that initial state is not authenticated
      final initialState = container.read(authStateProvider);
      expect(initialState.isAuthenticated, isFalse);
      expect(initialState.user, isNull);
      
      container.dispose();
    });
    
    test('game state provider should exist and be accessible', () {
      final container = ProviderContainer();
      
      // Test that game state provider exists
      final gameState = container.read(gameStateProvider);
      expect(gameState, isNotNull);
      expect(gameState.selectedCharacter, isNull);
      expect(gameState.userCharacters, isEmpty);
      
      container.dispose();
    });
    
    test('tab providers should exist and have initial values', () {
      final container = ProviderContainer();
      
      // Test that tab providers exist and have initial values
      expect(container.read(selectedTabProvider), 0);
      expect(container.read(selectedVillageTabProvider), 0);
      expect(container.read(selectedLoadoutTabProvider), 0);
      
      container.dispose();
    });
  });
}
