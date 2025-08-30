import 'dart:async';
import '../models/models.dart';

class RegenerationService {
  static const Duration _regenerationInterval = Duration(seconds: 30);
  Timer? _regenerationTimer;
  final Map<String, Character> _activeCharacters = {};
  final Map<String, DateTime> _lastRegeneration = {};
  
  // Callback to notify when character stats change
  Function(String characterId, Character updatedCharacter)? onCharacterUpdated;

  void startRegeneration(String characterId, Character character) {
    _activeCharacters[characterId] = character;
    _lastRegeneration[characterId] = DateTime.now();
    
    // Start timer if not already running
    _regenerationTimer ??= Timer.periodic(_regenerationInterval, _performRegeneration);
  }

  void stopRegeneration(String characterId) {
    _activeCharacters.remove(characterId);
    _lastRegeneration.remove(characterId);
    
    // Stop timer if no more active characters
    if (_activeCharacters.isEmpty && _regenerationTimer != null) {
      _regenerationTimer?.cancel();
      _regenerationTimer = null;
    }
  }

  void updateCharacter(String characterId, Character character) {
    _activeCharacters[characterId] = character;
  }

  void _performRegeneration(Timer timer) {
    final now = DateTime.now();
    
    for (final entry in _activeCharacters.entries) {
      final characterId = entry.key;
      final character = entry.value;
      final lastRegen = _lastRegeneration[characterId];
      
      if (lastRegen != null && now.difference(lastRegen) >= _regenerationInterval) {
        final updatedCharacter = _regenerateCharacter(character);
        _activeCharacters[characterId] = updatedCharacter;
        _lastRegeneration[characterId] = now;
        
        // Notify listeners of character update
        onCharacterUpdated?.call(characterId, updatedCharacter);
      }
    }
  }

  Character _regenerateCharacter(Character character) {
    // Calculate new values with regeneration
    int newHp = (character.currentHp + character.hpRegenRate).clamp(0, character.maxHp);
    int newCp = (character.currentChakra + character.cpRegenRate).clamp(0, character.maxChakra);
    int newSp = (character.currentStamina + character.spRegenRate).clamp(0, character.maxStamina);
    
    // Only update if there are actual changes
    if (newHp != character.currentHp || 
        newCp != character.currentChakra || 
        newSp != character.currentStamina) {
      return character.copyWith(
        currentHp: newHp,
        currentChakra: newCp,
        currentStamina: newSp,
      );
    }
    
    return character;
  }

  // Get time until next regeneration for a character
  Duration getTimeUntilNextRegeneration(String characterId) {
    final lastRegen = _lastRegeneration[characterId];
    if (lastRegen == null) return Duration.zero;
    
    final nextRegen = lastRegen.add(_regenerationInterval);
    final now = DateTime.now();
    
    if (now.isAfter(nextRegen)) {
      return Duration.zero;
    }
    
    return nextRegen.difference(now);
  }

  // Get regeneration progress (0.0 to 1.0) for a character
  double getRegenerationProgress(String characterId) {
    final lastRegen = _lastRegeneration[characterId];
    if (lastRegen == null) return 0.0;
    
    final now = DateTime.now();
    final elapsed = now.difference(lastRegen);
    
    if (elapsed >= _regenerationInterval) return 1.0;
    
    return elapsed.inMilliseconds / _regenerationInterval.inMilliseconds;
  }

  // Get active character by ID
  Character? getActiveCharacter(String characterId) {
    return _activeCharacters[characterId];
  }

  // Get all active character IDs
  Set<String> get activeCharacterIds => _activeCharacters.keys.toSet();

  // Check if a character is active
  bool isCharacterActive(String characterId) {
    return _activeCharacters.containsKey(characterId);
  }

  void dispose() {
    _regenerationTimer?.cancel();
    _regenerationTimer = null;
    _activeCharacters.clear();
    _lastRegeneration.clear();
  }
}
