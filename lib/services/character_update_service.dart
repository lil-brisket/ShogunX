import '../models/models.dart';
import 'game_service.dart';

class CharacterUpdateService {
  static final CharacterUpdateService _instance = CharacterUpdateService._internal();
  factory CharacterUpdateService() => _instance;
  CharacterUpdateService._internal();

  final GameService _gameService = GameService();

  /// Update character name (costs 1000 Ryo)
  Future<bool> updateCharacterName(Character character, String newName) async {
    if (character.ryoOnHand < 1000) {
      return false;
    }

    final updatedCharacter = character.copyWith(
      name: newName,
      ryoOnHand: character.ryoOnHand - 1000,
    );

    await _gameService.saveCharacter(updatedCharacter);
    return true;
  }

  /// Update character gender
  Future<bool> updateCharacterGender(Character character, String newGender) async {
    final updatedCharacter = character.copyWith(
      gender: newGender,
    );

    await _gameService.saveCharacter(updatedCharacter);
    return true;
  }

  /// Update character avatar URL
  Future<bool> updateCharacterAvatar(Character character, String? newAvatarUrl) async {
    final updatedCharacter = character.copyWith(
      avatarUrl: newAvatarUrl,
    );

    await _gameService.saveCharacter(updatedCharacter);
    return true;
  }

  /// Reset character stats (costs 5000 Ryo)
  Future<bool> resetCharacterStats(Character character) async {
    if (character.ryoOnHand < 5000) {
      return false;
    }

    final updatedCharacter = character.copyWith(
      strength: 1000,
      intelligence: 1000,
      speed: 1000,
      defense: 1000,
      willpower: 1000,
      bukijutsu: 1000,
      ninjutsu: 1000,
      taijutsu: 1000,
      genjutsu: 0,
      ryoOnHand: character.ryoOnHand - 5000,
    );

    await _gameService.saveCharacter(updatedCharacter);
    return true;
  }

  /// Reroll character elements (costs 10000 Ryo)
  Future<bool> rerollCharacterElements(Character character) async {
    if (character.ryoOnHand < 10000) {
      return false;
    }

    final newElements = _getRandomElements();
    final updatedCharacter = character.copyWith(
      elements: newElements,
      ryoOnHand: character.ryoOnHand - 10000,
    );

    await _gameService.saveCharacter(updatedCharacter);
    return true;
  }

  /// Divorce character (costs 2000 Ryo)
  Future<bool> divorceCharacter(Character character) async {
    if (character.ryoOnHand < 2000) {
      return false;
    }

    final updatedCharacter = character.copyWith(
      marriedTo: null,
      ryoOnHand: character.ryoOnHand - 2000,
    );

    await _gameService.saveCharacter(updatedCharacter);
    return true;
  }

  /// Delete character permanently
  Future<bool> deleteCharacter(Character character) async {
    try {
      await _gameService.deleteCharacter(character.id);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Get random elements for reroll
  List<String> _getRandomElements() {
    final allElements = ['Fire', 'Water', 'Earth', 'Wind', 'Lightning'];
    final random = DateTime.now().millisecondsSinceEpoch % allElements.length;
    return [allElements[random]];
  }

  /// Get available genders
  List<String> getAvailableGenders() {
    return ['Male', 'Female', 'Other', 'Unknown'];
  }

  /// Get available avatar options (placeholder for future implementation)
  List<String> getAvailableAvatars() {
    return [
      'https://example.com/avatar1.png',
      'https://example.com/avatar2.png',
      'https://example.com/avatar3.png',
    ];
  }
}
