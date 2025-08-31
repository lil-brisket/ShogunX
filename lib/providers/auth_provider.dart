import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../services/services.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
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
  final AuthService _authService;

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
    state = state.copyWith(isLoading: true);
    
    try {
      await _authService.logout();
      state = state.copyWith(
        user: null,
        isAuthenticated: false,
        isLoading: false,
      );
      
      // Clear game state on logout
      ref.read(gameStateProvider.notifier).clearSelectedCharacter();
      ref.read(gameStateProvider.notifier).setUserCharacters([]);
    } catch (e) {
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
      return characters;
    } catch (e) {
      return [];
    }
  }

  void selectCharacter(Character character, WidgetRef ref) {
    ref.read(gameStateProvider.notifier).selectCharacter(character);
  }

  void updateCharacter(Character character, WidgetRef ref) {
    ref.read(gameStateProvider.notifier).updateCharacter(character);
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
  }

  Future<void> createCharacter(Character character, WidgetRef ref) async {
    try {
      await GameService().createCharacter(character);
      await refreshUserCharacters(ref);
      ref.read(gameStateProvider.notifier).selectCharacter(character);
    } catch (e) {
      // Handle error
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
