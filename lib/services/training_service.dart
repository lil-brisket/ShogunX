import 'dart:math';
import '../models/training_session.dart';
import '../models/character.dart';

class TrainingService {
  static const String _chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
  
  // Generate unique ID for training sessions
  static String _generateId() {
    final random = Random();
    return String.fromCharCodes(
      Iterable.generate(8, (_) => _chars.codeUnitAt(random.nextInt(_chars.length)))
    );
  }

  // Start a new training session
  static TrainingSession startTraining(Character character, String statType) {
    // Check if character is already training any stat
    if (character.isTraining) {
      throw Exception('Character is already training another stat');
    }
    
    final currentStatValue = _getStatValue(character, statType);
    final maxStat = _getMaxStat(statType);
    
    return TrainingSession(
      id: _generateId(),
      characterId: character.id,
      statType: statType,
      startTime: DateTime.now(),
      currentStatValue: currentStatValue,
      maxStat: maxStat,
    );
  }

  // Complete a training session and return updated character
  static Character completeTraining(Character character, TrainingSession session) {
    final statGain = session.statGain;
    
    // Update the character's stat
    return _updateCharacterStat(character, session.statType, statGain);
  }

  // Get stat gain for a training session
  static int getStatGain(TrainingSession session) {
    return session.statGain;
  }

  // Update character stat after training completion
  static Character updateCharacterStat(Character character, String statType, int statGain) {
    return _updateCharacterStat(character, statType, statGain);
  }

  // Get character stat value
  static int getCharacterStat(Character character, String statType) {
    return _getStatValue(character, statType);
  }

  // Get character max stat value
  static int getCharacterMaxStat(String statType) {
    return _getMaxStat(statType);
  }

  // Check if character can train a specific stat
  static bool canTrainStat(Character character, String statType) {
    final currentValue = _getStatValue(character, statType);
    final maxValue = _getMaxStat(statType);
    return currentValue < maxValue;
  }

  // Get all available stats for training
  static List<String> getAvailableStats() {
    return [
      'strength',
      'intelligence', 
      'speed',
      'defense',
      'willpower',
      'bukijutsu',
      'ninjutsu',
      'taijutsu',
      'genjutsu',
    ];
  }





  // Get current stat value for a character
  static int _getStatValue(Character character, String statType) {
    switch (statType) {
      case 'strength':
        return character.strength;
      case 'intelligence':
        return character.intelligence;
      case 'speed':
        return character.speed;
      case 'defense':
        return character.defense;
      case 'willpower':
        return character.willpower;
      case 'bukijutsu':
        return character.bukijutsu;
      case 'ninjutsu':
        return character.ninjutsu;
      case 'taijutsu':
        return character.taijutsu;
      case 'genjutsu':
        return character.genjutsu;
      default:
        return 0;
    }
  }

  // Get maximum stat value for a stat type
  static int _getMaxStat(String statType) {
    switch (statType) {
      case 'strength':
      case 'intelligence':
      case 'speed':
      case 'defense':
      case 'willpower':
        return 250000; // Core stats max
      case 'bukijutsu':
      case 'ninjutsu':
      case 'taijutsu':
      case 'genjutsu':
        return 500000; // Combat stats max
      default:
        return 0;
    }
  }

  // Update character stat and return new character instance
  static Character _updateCharacterStat(Character character, String statType, int gain) {
    switch (statType) {
      case 'strength':
        return character.copyWith(strength: character.strength + gain);
      case 'intelligence':
        return character.copyWith(intelligence: character.intelligence + gain);
      case 'speed':
        return character.copyWith(speed: character.speed + gain);
      case 'defense':
        return character.copyWith(defense: character.defense + gain);
      case 'willpower':
        return character.copyWith(willpower: character.willpower + gain);
      case 'bukijutsu':
        return character.copyWith(bukijutsu: character.bukijutsu + gain);
      case 'ninjutsu':
        return character.copyWith(ninjutsu: character.ninjutsu + gain);
      case 'taijutsu':
        return character.copyWith(taijutsu: character.taijutsu + gain);
      case 'genjutsu':
        return character.copyWith(genjutsu: character.genjutsu + gain);
      default:
        return character;
    }
  }

  // Get stat display name
  static String getStatDisplayName(String statType) {
    switch (statType) {
      case 'strength':
        return 'Strength';
      case 'intelligence':
        return 'Intelligence';
      case 'speed':
        return 'Speed';
      case 'defense':
        return 'Defense';
      case 'willpower':
        return 'Willpower';
      case 'bukijutsu':
        return 'Bukijutsu';
      case 'ninjutsu':
        return 'Ninjutsu';
      case 'taijutsu':
        return 'Taijutsu';
      case 'genjutsu':
        return 'Genjutsu';
      default:
        return statType;
    }
  }

  // Get stat icon
  static String getStatIcon(String statType) {
    switch (statType) {
      case 'strength':
        return '💪';
      case 'intelligence':
        return '🧠';
      case 'speed':
        return '⚡';
      case 'defense':
        return '🛡️';
      case 'willpower':
        return '🔥';
      case 'bukijutsu':
        return '⚔️';
      case 'ninjutsu':
        return '🌀';
      case 'taijutsu':
        return '🥋';
      case 'genjutsu':
        return '👁️';
      default:
        return '📊';
    }
  }


}
