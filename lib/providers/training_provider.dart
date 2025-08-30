import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/training_session.dart';
import '../models/character.dart';
import '../services/training_service.dart';

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

  // Start a new training session
  void startTraining(Character character, String statType) {
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
