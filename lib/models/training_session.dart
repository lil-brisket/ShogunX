class TrainingSession {
  final String id;
  final String characterId;
  final String statType; // 'strength', 'intelligence', 'speed', 'defense', 'willpower', 'bukijutsu', 'ninjutsu', 'taijutsu', 'genjutsu'
  final DateTime startTime;
  final int currentStatValue;
  final int maxStat;
  final bool isActive;
  final DateTime? endTime;
  final int? actualGain;

  // Core Parameters
  static const int maxSessionTime = 28800; // 8 hours in seconds
  static const int xpPerSession = 25000;
  static const double baseRate = xpPerSession / maxSessionTime; // 0.87 XP/sec
  static const bool idleAllowed = true;
  static const bool earlyCollection = false;

  TrainingSession({
    required this.id,
    required this.characterId,
    required this.statType,
    required this.startTime,
    required this.currentStatValue,
    required this.maxStat,
    this.isActive = true,
    this.endTime,
    this.actualGain,
  });

  // Calculate elapsed time for current session
  int get elapsedTime {
    final now = DateTime.now();
    final elapsed = now.difference(startTime).inSeconds;
    return elapsed > maxSessionTime ? maxSessionTime : elapsed;
  }

  // Calculate potential gain based on elapsed time
  int get potentialGain {
    return (baseRate * elapsedTime).round();
  }

  // Calculate remaining stat capacity
  int get remainingStat {
    return maxStat - currentStatValue;
  }

  // Calculate actual stat gain (capped by remaining stat)
  int get statGain {
    final potential = potentialGain;
    final remaining = remainingStat;
    return potential > remaining ? remaining : potential;
  }

  // Check if session is complete (8 hours or max stat reached)
  bool get isComplete {
    return elapsedTime >= maxSessionTime || remainingStat <= 0;
  }

  // Get session progress as percentage
  double get progress {
    if (remainingStat <= 0) return 1.0;
    return elapsedTime / maxSessionTime;
  }

  // Get formatted time remaining
  String get timeRemaining {
    if (isComplete) return 'Complete';
    
    final remaining = maxSessionTime - elapsedTime;
    final hours = remaining ~/ 3600;
    final minutes = (remaining % 3600) ~/ 60;
    final seconds = remaining % 60;
    
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }

  // Get formatted elapsed time
  String get formattedElapsedTime {
    final elapsed = elapsedTime;
    final hours = elapsed ~/ 3600;
    final minutes = (elapsed % 3600) ~/ 60;
    
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }

  // Create a copy with updated values
  TrainingSession copyWith({
    String? id,
    String? characterId,
    String? statType,
    DateTime? startTime,
    int? currentStatValue,
    int? maxStat,
    bool? isActive,
    DateTime? endTime,
    int? actualGain,
  }) {
    return TrainingSession(
      id: id ?? this.id,
      characterId: characterId ?? this.characterId,
      statType: statType ?? this.statType,
      startTime: startTime ?? this.startTime,
      currentStatValue: currentStatValue ?? this.currentStatValue,
      maxStat: maxStat ?? this.maxStat,
      isActive: isActive ?? this.isActive,
      endTime: endTime ?? this.endTime,
      actualGain: actualGain ?? this.actualGain,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'characterId': characterId,
      'statType': statType,
      'startTime': startTime.toIso8601String(),
      'currentStatValue': currentStatValue,
      'maxStat': maxStat,
      'isActive': isActive,
      'endTime': endTime?.toIso8601String(),
      'actualGain': actualGain,
    };
  }

  // Create from JSON
  factory TrainingSession.fromJson(Map<String, dynamic> json) {
    return TrainingSession(
      id: json['id'],
      characterId: json['characterId'],
      statType: json['statType'],
      startTime: DateTime.parse(json['startTime']),
      currentStatValue: json['currentStatValue'],
      maxStat: json['maxStat'],
      isActive: json['isActive'] ?? true,
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
      actualGain: json['actualGain'],
    );
  }
}
