import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../services/services.dart';
import 'training_provider.dart';
import 'game_provider.dart';

final authServiceProvider = Provider<FirebaseAuthService>((ref) {
  return FirebaseAuthService();
});

final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.read(authServiceProvider));
});

// Character selection provider
final selectedCharacterProvider = StateProvider<Character?>((ref) {
  final gameState = ref.watch(gameStateProvider);
  return gameState.selectedCharacter;
});

// Game state provider for character management
final gameStateProvider = StateNotifierProvider<GameStateNotifier, GameState>((ref) {
  return GameStateNotifier();
});

class AuthState {
  final User? user;
  final bool isLoading;
  final bool isAuthenticated;
  final String? error;

  AuthState({
    this.user,
    this.isLoading = false,
    this.isAuthenticated = false,
    this.error,
  });

  AuthState copyWith({
    User? user,
    bool? isLoading,
    bool? isAuthenticated,
    String? error,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      error: error ?? this.error,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final FirebaseAuthService _authService;
  
  FirebaseAuthService get authService => _authService;

  AuthNotifier(this._authService) : super(AuthState());

  Future<bool> login(String username, String password, WidgetRef ref) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final success = await _authService.login(username, password);
      if (success) {
        // Load user characters after successful login
        final characters = await loadUserCharacters();
        
        state = state.copyWith(
          user: _authService.currentUser,
          isAuthenticated: true,
          isLoading: false,
        );
        
        // Update game state with user characters
        ref.read(gameStateProvider.notifier).setUserCharacters(characters);
        if (characters.isNotEmpty) {
          ref.read(gameStateProvider.notifier).selectCharacter(characters.first);
          print('✅ Auto-selected character: ${characters.first.name}');
        } else {
          print('⚠️ No characters found for user - they will need to create one');
        }
        
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Invalid username or password',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Login failed: ${e.toString()}',
      );
      return false;
    }
  }

  Future<bool> register(String username, String password, String village, WidgetRef ref) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final success = await _authService.register(username, password, village);
      if (success) {
        // Load user characters after successful registration
        final characters = await loadUserCharacters();
        
        state = state.copyWith(
          user: _authService.currentUser,
          isAuthenticated: true,
          isLoading: false,
        );
        
        // Update game state with user characters
        ref.read(gameStateProvider.notifier).setUserCharacters(characters);
        if (characters.isNotEmpty) {
          ref.read(gameStateProvider.notifier).selectCharacter(characters.first);
          print('✅ Auto-selected character: ${characters.first.name}');
        } else {
          print('⚠️ No characters found for user - they will need to create one');
        }
        
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Registration failed',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Registration failed: ${e.toString()}',
      );
      return false;
    }
  }

  Future<void> logout(WidgetRef ref) async {
    print('🔄 Starting logout process...');
    
    try {
      print('🧹 Clearing training sessions...');
      // Clear training sessions before logout
      ref.read(activeTrainingSessionsProvider.notifier).clearAllSessions();
      
      print('🔐 Calling Firebase logout...');
      await _authService.logout();
      
      print('🎮 Clearing game state...');
      // Clear game state on logout
      ref.read(gameStateProvider.notifier).clearSelectedCharacter();
      ref.read(gameStateProvider.notifier).setUserCharacters([]);
      
      // Reset all tab selections to home
      ref.read(selectedTabProvider.notifier).state = 0;
      ref.read(selectedVillageTabProvider.notifier).state = 0;
      ref.read(selectedLoadoutTabProvider.notifier).state = 0;
      
      // Clear shop filters
      ref.read(shopProviderProvider.notifier).clearFilters();
      
      print('📱 Updating auth state...');
      // Update auth state last to trigger navigation
      state = state.copyWith(
        user: null,
        isAuthenticated: false,
        isLoading: false,
        error: null,
      );
      
      print('✅ Logout successful - user state cleared');
    } catch (e) {
      print('❌ Logout error: $e');
      // Don't use ref in catch block as widget might be disposed
      state = state.copyWith(
        isLoading: false,
        error: 'Logout failed: ${e.toString()}',
      );
    }
  }

  Future<void> updateUser(User user) async {
    try {
      await _authService.updateUser(user);
      state = state.copyWith(user: user);
    } catch (e) {
      state = state.copyWith(error: 'Update failed: ${e.toString()}');
    }
  }

  List<String> getAvailableVillages() {
    return _authService.getAvailableVillages();
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  Future<List<Character>> loadUserCharacters() async {
    try {
      final characters = await _authService.getUserCharacters();
      print('✅ Loaded ${characters.length} characters for user');
      return characters;
    } catch (e) {
      print('❌ Failed to load user characters: $e');
      // Return empty list if Firebase is not available
      return [];
    }
  }

  void selectCharacter(Character character, WidgetRef ref) {
    ref.read(gameStateProvider.notifier).selectCharacter(character);
    
    // Load training sessions for the selected character
    ref.read(activeTrainingSessionsProvider.notifier).loadExistingSessions(character.id, ref);
  }

  Future<void> loadTrainingSessionsForCharacter(String characterId, WidgetRef ref) async {
    await ref.read(activeTrainingSessionsProvider.notifier).loadExistingSessions(characterId, ref);
  }

  Future<void> updateCharacter(Character character, WidgetRef ref) async {
    try {
      // Update in Firebase
      await _authService.updateCharacter(character);
      // Update in local state
      ref.read(gameStateProvider.notifier).updateCharacter(character);
      print('✅ Character updated in both Firebase and local state');
    } catch (e) {
      print('❌ Failed to update character: $e');
    }
  }

  Character? getCurrentCharacter(WidgetRef ref) {
    return ref.read(gameStateProvider.notifier).state.selectedCharacter;
  }

  List<Character> getUserCharacters(WidgetRef ref) {
    return ref.read(gameStateProvider.notifier).state.userCharacters;
  }

  Future<void> refreshUserCharacters(WidgetRef ref) async {
    final characters = await loadUserCharacters();
    ref.read(gameStateProvider.notifier).setUserCharacters(characters);
    
    // If no characters exist, try to create a default one
    if (characters.isEmpty && state.user != null) {
      print('🔄 No characters found, attempting to create default character...');
      try {
        final defaultCharacter = _createDefaultCharacter(
          state.user!.id, 
          state.user!.username, 
          state.user!.lastVillage ?? 'Konoha'
        );
        await createCharacter(defaultCharacter, ref);
        print('✅ Default character created successfully');
      } catch (e) {
        print('❌ Failed to create default character: $e');
      }
    }
  }

  Future<void> createCharacter(Character character, WidgetRef ref) async {
    try {
      print('🎮 Creating character: ${character.name}');
      
      // Check if user already has a character
      final existingCharacters = ref.read(gameStateProvider.notifier).state.userCharacters;
      if (existingCharacters.isNotEmpty) {
        throw Exception('User already has a character. Only one character per account is allowed.');
      }
      
      // Save character to Firebase first
      await _authService.saveCharacter(character);
      
      // Also save to game service for local storage
      await GameService().createCharacter(character);
      
      // Refresh user characters and select the new one
      await refreshUserCharacters(ref);
      ref.read(gameStateProvider.notifier).selectCharacter(character);
      
      print('✅ Character created successfully: ${character.name}');
    } catch (e) {
      print('❌ Failed to create character: $e');
      rethrow;
    }
  }

  Future<void> deleteCharacter(String characterId, WidgetRef ref) async {
    try {
      await GameService().deleteCharacter(characterId);
      await refreshUserCharacters(ref);
      
      // If the deleted character was selected, select the first available character
      final currentCharacter = ref.read(gameStateProvider.notifier).state.selectedCharacter;
      if (currentCharacter?.id == characterId) {
        final characters = ref.read(gameStateProvider.notifier).state.userCharacters;
        if (characters.isNotEmpty) {
          ref.read(gameStateProvider.notifier).selectCharacter(characters.first);
        } else {
          ref.read(gameStateProvider.notifier).clearSelectedCharacter();
        }
      }
    } catch (e) {
      // Handle error
    }
  }

  void updateCharacterStats(String characterId, Map<String, int> statUpdates, WidgetRef ref) {
    ref.read(gameStateProvider.notifier).updateCharacterStats(characterId, statUpdates);
  }

  void updateCharacterStat(String characterId, String statType, int newValue, WidgetRef ref) {
    ref.read(gameStateProvider.notifier).updateCharacterStats(characterId, {statType: newValue});
  }

  Character _createDefaultCharacter(String userId, String username, String village) {
    return Character(
      id: 'char_${userId}_${DateTime.now().millisecondsSinceEpoch}',
      userId: userId,
      name: username,
      village: village,
      clanId: null,
      clanRank: null,
      ninjaRank: 'Genin',
      elements: _getRandomElements(),
      bloodline: null,
      strength: 1000,
      intelligence: 1000,
      speed: 1000,
      defense: 1000,
      willpower: 1000,
      bukijutsu: 1000,
      ninjutsu: 1000,
      taijutsu: 1000,
      genjutsu: 0,
      jutsuMastery: {},
      currentHp: 40000,
      currentChakra: 30000,
      currentStamina: 30000,
      experience: 0,
      level: 1,
      hpRegenRate: 100,
      cpRegenRate: 100,
      spRegenRate: 100,
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
      gender: 'Unknown',
      inventory: [],
      equippedItems: {},
    );
  }

  List<String> _getRandomElements() {
    final allElements = ['Fire', 'Water', 'Earth', 'Wind', 'Lightning'];
    final random = DateTime.now().millisecondsSinceEpoch % allElements.length;
    return [allElements[random]];
  }

  void completeTraining(String characterId, String statType, int statGain, WidgetRef ref) {
    final currentCharacter = ref.read(gameStateProvider.notifier).state.selectedCharacter;
    if (currentCharacter?.id == characterId) {
      final updatedCharacter = _updateCharacterStatFromTraining(currentCharacter!, statType, statGain);
      ref.read(gameStateProvider.notifier).updateCharacter(updatedCharacter);
    }
  }

  Character _updateCharacterStatFromTraining(Character character, String statType, int statGain) {
    switch (statType) {
      case 'strength':
        return character.copyWith(strength: character.strength + statGain);
      case 'intelligence':
        return character.copyWith(intelligence: character.intelligence + statGain);
      case 'speed':
        return character.copyWith(speed: character.speed + statGain);
      case 'defense':
        return character.copyWith(defense: character.defense + statGain);
      case 'willpower':
        return character.copyWith(willpower: character.willpower + statGain);
      case 'bukijutsu':
        return character.copyWith(bukijutsu: character.bukijutsu + statGain);
      case 'ninjutsu':
        return character.copyWith(ninjutsu: character.ninjutsu + statGain);
      case 'taijutsu':
        return character.copyWith(taijutsu: character.taijutsu + statGain);
      case 'genjutsu':
        return character.copyWith(genjutsu: character.genjutsu + statGain);
      default:
        return character;
    }
  }
}

// Game state for character management
class GameState {
  final Character? selectedCharacter;
  final List<Character> userCharacters;

  GameState({
    this.selectedCharacter,
    this.userCharacters = const [],
  });

  GameState copyWith({
    Character? selectedCharacter,
    List<Character>? userCharacters,
  }) {
    return GameState(
      selectedCharacter: selectedCharacter ?? this.selectedCharacter,
      userCharacters: userCharacters ?? this.userCharacters,
    );
  }
}

class GameStateNotifier extends StateNotifier<GameState> {
  GameStateNotifier() : super(GameState());

  void selectCharacter(Character character) {
    state = state.copyWith(selectedCharacter: character);
  }

  void updateCharacter(Character updatedCharacter) {
    final updatedCharacters = state.userCharacters.map((char) {
      if (char.id == updatedCharacter.id) {
        return updatedCharacter;
      }
      return char;
    }).toList();

    state = state.copyWith(
      selectedCharacter: state.selectedCharacter?.id == updatedCharacter.id 
        ? updatedCharacter 
        : state.selectedCharacter,
      userCharacters: updatedCharacters,
    );
  }

  void updateCharacterStats(String characterId, Map<String, int> statUpdates) {
    final updatedCharacters = state.userCharacters.map((char) {
      if (char.id == characterId) {
        Character updatedChar = char;
        for (final entry in statUpdates.entries) {
          updatedChar = _updateCharacterStat(updatedChar, entry.key, entry.value);
        }
        return updatedChar;
      }
      return char;
    }).toList();

    final updatedSelectedCharacter = state.selectedCharacter?.id == characterId
        ? _updateCharacterStats(state.selectedCharacter!, statUpdates)
        : state.selectedCharacter;

    state = state.copyWith(
      selectedCharacter: updatedSelectedCharacter,
      userCharacters: updatedCharacters,
    );
  }

  Character _updateCharacterStats(Character character, Map<String, int> statUpdates) {
    Character updatedChar = character;
    for (final entry in statUpdates.entries) {
      updatedChar = _updateCharacterStat(updatedChar, entry.key, entry.value);
    }
    return updatedChar;
  }

  Character _updateCharacterStat(Character character, String statType, int value) {
    switch (statType) {
      case 'strength':
        return character.copyWith(strength: value);
      case 'intelligence':
        return character.copyWith(intelligence: value);
      case 'speed':
        return character.copyWith(speed: value);
      case 'defense':
        return character.copyWith(defense: value);
      case 'willpower':
        return character.copyWith(willpower: value);
      case 'bukijutsu':
        return character.copyWith(bukijutsu: value);
      case 'ninjutsu':
        return character.copyWith(ninjutsu: value);
      case 'taijutsu':
        return character.copyWith(taijutsu: value);
      case 'genjutsu':
        return character.copyWith(genjutsu: value);
      default:
        return character;
    }
  }

  void setUserCharacters(List<Character> characters) {
    state = state.copyWith(userCharacters: characters);
  }

  void clearSelectedCharacter() {
    state = state.copyWith(selectedCharacter: null);
  }
}
