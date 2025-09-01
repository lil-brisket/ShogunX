import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ninja_world_mmo/providers/auth_provider.dart';
import 'package:ninja_world_mmo/providers/training_provider.dart';

void main() {
  group('Logout Debug Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('Debug logout process step by step', () async {
      print('\n🔍 Starting logout debug test...\n');
      
      // Step 1: Check initial state
      print('1️⃣ Checking initial auth state...');
      final initialAuthState = container.read(authStateProvider);
      print('   - isAuthenticated: ${initialAuthState.isAuthenticated}');
      print('   - user: ${initialAuthState.user}');
      print('   - isLoading: ${initialAuthState.isLoading}');
      
      // Step 2: Check training sessions
      print('\n2️⃣ Checking training sessions...');
      final initialSessions = container.read(activeTrainingSessionsProvider);
      print('   - Active sessions count: ${initialSessions.length}');
      
      // Step 3: Test training session clearing
      print('\n3️⃣ Testing training session clearing...');
      final trainingNotifier = container.read(activeTrainingSessionsProvider.notifier);
      trainingNotifier.clearAllSessions();
      final clearedSessions = container.read(activeTrainingSessionsProvider);
      print('   - Sessions after clearing: ${clearedSessions.length}');
      
      // Step 4: Test game state clearing
      print('\n4️⃣ Testing game state clearing...');
      final gameStateNotifier = container.read(gameStateProvider.notifier);
      final initialGameState = container.read(gameStateProvider);
      print('   - Initial selected character: ${initialGameState.selectedCharacter}');
      print('   - Initial user characters count: ${initialGameState.userCharacters.length}');
      
      gameStateNotifier.clearSelectedCharacter();
      gameStateNotifier.setUserCharacters([]);
      
      final clearedGameState = container.read(gameStateProvider);
      print('   - Selected character after clearing: ${clearedGameState.selectedCharacter}');
      print('   - User characters after clearing: ${clearedGameState.userCharacters.length}');
      
      // Step 5: Test auth state update
      print('\n5️⃣ Testing auth state update...');
      final authNotifier = container.read(authStateProvider.notifier);
      authNotifier.state = authNotifier.state.copyWith(
        user: null,
        isAuthenticated: false,
        isLoading: false,
        error: null,
      );
      
      final finalAuthState = container.read(authStateProvider);
      print('   - Final isAuthenticated: ${finalAuthState.isAuthenticated}');
      print('   - Final user: ${finalAuthState.user}');
      print('   - Final isLoading: ${finalAuthState.isLoading}');
      
      print('\n✅ All logout steps completed successfully!\n');
    });
  });
}
