import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import '../models/training_session.dart';
import '../models/character.dart';
import '../services/training_service.dart';
import 'auth_provider.dart';
import '../utils/logger.dart';

// Provider for active training sessions
final activeTrainingSessionsProvider = StateNotifierProvider<ActiveTrainingSessionsNotifier, List<TrainingSession>>((ref) {
  return ActiveTrainingSessionsNotifier();
});

// Provider for completed training sessions
final completedTrainingSessionsProvider = StateNotifierProvider<CompletedTrainingSessionsNotifier, List<TrainingSession>>((ref) {
  return CompletedTrainingSessionsNotifier();
});

// Notifier for active training sessions
class ActiveTrainingSessionsNotifier extends StateNotifier<List<TrainingSession>> {
  ActiveTrainingSessionsNotifier() : super([]);
  
  Timer? _progressTimer;

  @override
  void dispose() {
    _progressTimer?.cancel();
    super.dispose();
  }

  // Start progress timer to update training sessions in real-time
  void _startProgressTimer() {
    _progressTimer?.cancel();
    _progressTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      // Force rebuild of training sessions to update progress
      if (state.isNotEmpty) {
        state = [...state]; // Trigger rebuild
      } else {
        timer.cancel();
      }
    });
  }

  // Load existing training sessions from Firebase
  Future<void> loadExistingSessions(String characterId, WidgetRef ref) async {
    try {
      final sessions = await ref.read(authStateProvider.notifier).authService.getCharacterTrainingSessions(characterId);
      state = sessions;
      
      // Start progress timer if there are active sessions
      if (sessions.isNotEmpty) {
        _startProgressTimer();
      }
      
             Logger.success('Loaded ${sessions.length} existing training sessions for character: $characterId');
     } catch (e) {
       Logger.error('Failed to load training sessions: $e');
       state = [];
     }
  }

  // Clear all training sessions (for logout)
  void clearAllSessions() {
         state = [];
     Logger.success('Cleared all training sessions');
   }

  // Save all active training sessions to Firebase
  Future<void> saveAllSessionsToFirebase(WidgetRef ref) async {
    try {
      for (final session in state) {
        await ref.read(authStateProvider.notifier).authService.saveTrainingSession(session);
      }
             Logger.success('Saved ${state.length} training sessions to Firebase');
     } catch (e) {
       Logger.error('Failed to save training sessions: $e');
     }
  }

  // Start a new training session
  Future<void> startTraining(Character character, String statType, WidgetRef ref) async {
    if (!TrainingService.canTrainStat(character, statType)) {
      return; // Cannot train if stat is already maxed
    }

    // Check if character is already training any stat (only one allowed)
    final existingSession = state.where((session) => 
      session.characterId == character.id && 
      session.isActive
    ).firstOrNull;

    if (existingSession != null) {
      return; // Already training another stat
    }

    final newSession = TrainingService.startTraining(character, statType);
    state = [...state, newSession];
    
    // Start progress timer for real-time updates
    _startProgressTimer();
    
         // Save to Firebase
     await ref.read(authStateProvider.notifier).authService.saveTrainingSession(newSession);
     Logger.success('Training session started and saved to Firebase: ${newSession.statType}');
   }

  // Complete a training session
  TrainingSession? completeTraining(String sessionId) {
    final sessionIndex = state.indexWhere((session) => session.id == sessionId);
    if (sessionIndex == -1) return null;

    final session = state[sessionIndex];
    final completedSession = session.copyWith(
      isActive: false,
      endTime: DateTime.now(),
      actualGain: session.statGain,
    );

    // Remove from active sessions
    state = state.where((s) => s.id != sessionId).toList();
    
    return completedSession;
  }

  // Complete training and update character stats
  Future<void> completeTrainingAndUpdateCharacter(String sessionId, WidgetRef ref) async {
    final completedSession = completeTraining(sessionId);
    if (completedSession == null) return;

    // Get the current character from game state
    final gameState = ref.read(gameStateProvider);
    final currentCharacter = gameState.selectedCharacter;
    
         if (currentCharacter == null || currentCharacter.id != completedSession.characterId) {
       Logger.error('Character not found for training completion');
       return;
     }

    // Update character stats based on training completion
    final updatedCharacter = _updateCharacterStatFromTraining(
      currentCharacter, 
      completedSession.statType, 
      completedSession.actualGain ?? 0
    );

    // Save to Firebase and update local state
    await ref.read(authStateProvider.notifier).updateCharacter(updatedCharacter, ref);
    
         // Delete training session from Firebase
     await ref.read(authStateProvider.notifier).authService.deleteTrainingSession(sessionId);
     
     Logger.success('Training completed and character updated: ${completedSession.statType} +${completedSession.actualGain ?? 0}');
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

  // Cancel a training session
  void cancelTraining(String sessionId) {
    state = state.where((session) => session.id != sessionId).toList();
  }

  // Get active sessions for a character
  List<TrainingSession> getCharacterSessions(String characterId) {
    return state.where((session) => 
      session.characterId == characterId && 
      session.isActive
    ).toList();
  }

  // Check if character is training a specific stat
  bool isTrainingStat(String characterId, String statType) {
    return state.any((session) => 
      session.characterId == characterId && 
      session.statType == statType && 
      session.isActive
    );
  }

  // Get all active sessions
  List<TrainingSession> get allSessions => state;
}

// Notifier for completed training sessions
class CompletedTrainingSessionsNotifier extends StateNotifier<List<TrainingSession>> {
  CompletedTrainingSessionsNotifier() : super([]);

  // Add a completed session
  void addCompletedSession(TrainingSession session) {
    state = [...state, session];
  }

  // Get completed sessions for a character
  List<TrainingSession> getCharacterCompletedSessions(String characterId) {
    return state.where((session) => session.characterId == characterId).toList();
  }

  // Clear old completed sessions (older than 7 days)
  void clearOldSessions() {
    final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));
    state = state.where((session) => 
      session.endTime != null && 
      session.endTime!.isAfter(sevenDaysAgo)
    ).toList();
  }
}

// Provider for training stats summary
final trainingStatsProvider = Provider.family<TrainingStats, Character>((ref, character) {
  final activeSessions = ref.watch(activeTrainingSessionsProvider);
  final characterSessions = activeSessions.where((s) => s.characterId == character.id).toList();
  
  return TrainingStats(
    activeSessions: characterSessions.length,
    totalPotentialGain: characterSessions.fold(0, (sum, session) => sum + session.potentialGain),
    totalTimeRemaining: characterSessions.fold(0, (sum, session) => sum + (TrainingSession.maxSessionTime - session.elapsedTime)),
  );
});

// Training stats summary class
class TrainingStats {
  final int activeSessions;
  final int totalPotentialGain;
  final int totalTimeRemaining;

  TrainingStats({
    required this.activeSessions,
    required this.totalPotentialGain,
    required this.totalTimeRemaining,
  });

  String get formattedTimeRemaining {
    if (totalTimeRemaining <= 0) return 'Complete';
    
    final hours = totalTimeRemaining ~/ 3600;
    final minutes = (totalTimeRemaining % 3600) ~/ 60;
    
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }
}
