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
      // Step 1: Check initial state
      final initialAuthState = container.read(authStateProvider);
      // Step 2: Check training sessions
      final initialSessions = container.read(activeTrainingSessionsProvider);
      // Step 3: Test training session clearing
      final trainingNotifier = container.read(activeTrainingSessionsProvider.notifier);
      trainingNotifier.clearAllSessions();
      final clearedSessions = container.read(activeTrainingSessionsProvider);
      // Step 4: Test game state clearing
      final gameStateNotifier = container.read(gameStateProvider.notifier);
      final initialGameState = container.read(gameStateProvider);
      gameStateNotifier.clearSelectedCharacter();
      gameStateNotifier.setUserCharacters([]);
      
      final clearedGameState = container.read(gameStateProvider);
      // Step 5: Test auth state update
      final authNotifier = container.read(authStateProvider.notifier);
      authNotifier.state = authNotifier.state.copyWith(
        user: null,
        isAuthenticated: false,
        isLoading: false,
        error: null,
      );
      
      final finalAuthState = container.read(authStateProvider);
    });
  });
}
