import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../services/character_update_service.dart';
import '../services/game_service.dart';
import 'game_provider.dart';
import 'auth_provider.dart';

// Character Update Service Provider
final characterUpdateServiceProvider = Provider<CharacterUpdateService>((ref) => CharacterUpdateService());

// Character Update Notifier Provider
final characterUpdateNotifierProvider = StateNotifierProvider.family<CharacterUpdateNotifier, AsyncValue<Character?>, String>((ref, characterId) {
  final characterUpdateService = ref.read(characterUpdateServiceProvider);
  final gameService = ref.read(gameServiceProvider);
  return CharacterUpdateNotifier(characterUpdateService, gameService, characterId, ref);
});

class CharacterUpdateNotifier extends StateNotifier<AsyncValue<Character?>> {
  final CharacterUpdateService _characterUpdateService;
  final GameService _gameService;
  final String _characterId;
  final Ref _ref;

  CharacterUpdateNotifier(this._characterUpdateService, this._gameService, this._characterId, this._ref) 
      : super(const AsyncValue.loading()) {
    _loadCharacter();
  }

  Future<void> _loadCharacter() async {
    try {
      state = const AsyncValue.loading();
      final character = await _gameService.getCharacter(_characterId);
      if (character != null) {
        state = AsyncValue.data(character);
      } else {
        state = AsyncValue.error('Character not found', StackTrace.current);
      }
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<bool> updateCharacterName(String newName) async {
    try {
      final currentCharacter = state.value;
      if (currentCharacter == null) return false;

      final success = await _characterUpdateService.updateCharacterName(currentCharacter, newName);
      if (success) {
        await _loadCharacter(); // Refresh the character data
        // Update the game state
        _updateGameState();
      }
      return success;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateCharacterGender(String newGender) async {
    try {
      final currentCharacter = state.value;
      if (currentCharacter == null) return false;

      final success = await _characterUpdateService.updateCharacterGender(currentCharacter, newGender);
      if (success) {
        await _loadCharacter(); // Refresh the character data
        // Update the game state
        _updateGameState();
      }
      return success;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateCharacterAvatar(String? newAvatarUrl) async {
    try {
      final currentCharacter = state.value;
      if (currentCharacter == null) return false;

      final success = await _characterUpdateService.updateCharacterAvatar(currentCharacter, newAvatarUrl);
      if (success) {
        await _loadCharacter(); // Refresh the character data
        // Update the game state
        _updateGameState();
      }
      return success;
    } catch (e) {
      return false;
    }
  }

  Future<bool> resetCharacterStats() async {
    try {
      final currentCharacter = state.value;
      if (currentCharacter == null) return false;

      final success = await _characterUpdateService.resetCharacterStats(currentCharacter);
      if (success) {
        await _loadCharacter(); // Refresh the character data
        // Update the game state
        _updateGameState();
      }
      return success;
    } catch (e) {
      return false;
    }
  }

  Future<bool> rerollCharacterElements() async {
    try {
      final currentCharacter = state.value;
      if (currentCharacter == null) return false;

      final success = await _characterUpdateService.rerollCharacterElements(currentCharacter);
      if (success) {
        await _loadCharacter(); // Refresh the character data
        // Update the game state
        _updateGameState();
      }
      return success;
    } catch (e) {
      return false;
    }
  }

  Future<bool> divorceCharacter() async {
    try {
      final currentCharacter = state.value;
      if (currentCharacter == null) return false;

      final success = await _characterUpdateService.divorceCharacter(currentCharacter);
      if (success) {
        await _loadCharacter(); // Refresh the character data
        // Update the game state
        _updateGameState();
      }
      return success;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteCharacter() async {
    try {
      final currentCharacter = state.value;
      if (currentCharacter == null) return false;

      final success = await _characterUpdateService.deleteCharacter(currentCharacter);
      return success;
    } catch (e) {
      return false;
    }
  }

  void _updateGameState() {
    final updatedCharacter = state.value;
    if (updatedCharacter != null) {
      // Update the game state with the updated character
      final gameStateNotifier = _ref.read(gameStateProvider.notifier);
      gameStateNotifier.updateCharacter(updatedCharacter);
    }
  }

  Future<void> refresh() async {
    await _loadCharacter();
  }
}
