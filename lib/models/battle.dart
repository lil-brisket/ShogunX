enum BattleType { pvp, pve, sparring, tower, mission }
enum BattleStatus { pending, active, completed, cancelled }

class Battle {
  final String id;
  final BattleType type;
  final BattleStatus status;
  final String? challengerId;
  final String? defenderId;
  final String? missionId; // For PvE battles
  final DateTime createdAt;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final String? winnerId;
  final Map<String, dynamic> battleData; // Turn data, damage dealt, etc.
  final List<String> spectators; // Player IDs watching
  final bool isPrivate;

  Battle({
    required this.id,
    required this.type,
    required this.status,
    this.challengerId,
    this.defenderId,
    this.missionId,
    required this.createdAt,
    this.startedAt,
    this.completedAt,
    this.winnerId,
    required this.battleData,
    required this.spectators,
    required this.isPrivate,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'status': status.name,
      'challengerId': challengerId,
      'defenderId': defenderId,
      'missionId': missionId,
      'createdAt': createdAt.toIso8601String(),
      'startedAt': startedAt?.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'winnerId': winnerId,
      'battleData': battleData,
      'spectators': spectators,
      'isPrivate': isPrivate,
    };
  }

  factory Battle.fromJson(Map<String, dynamic> json) {
    return Battle(
      id: json['id'],
      type: BattleType.values.firstWhere((e) => e.name == json['type']),
      status: BattleStatus.values.firstWhere((e) => e.name == json['status']),
      challengerId: json['challengerId'],
      defenderId: json['defenderId'],
      missionId: json['missionId'],
      createdAt: DateTime.parse(json['createdAt']),
      startedAt: json['startedAt'] != null 
          ? DateTime.parse(json['startedAt']) 
          : null,
      completedAt: json['completedAt'] != null 
          ? DateTime.parse(json['completedAt']) 
          : null,
      winnerId: json['winnerId'],
      battleData: Map<String, dynamic>.from(json['battleData']),
      spectators: List<String>.from(json['spectators']),
      isPrivate: json['isPrivate'],
    );
  }

  Battle copyWith({
    String? id,
    BattleType? type,
    BattleStatus? status,
    String? challengerId,
    String? defenderId,
    String? missionId,
    DateTime? createdAt,
    DateTime? startedAt,
    DateTime? completedAt,
    String? winnerId,
    Map<String, dynamic>? battleData,
    List<String>? spectators,
    bool? isPrivate,
  }) {
    return Battle(
      id: id ?? this.id,
      type: type ?? this.type,
      status: status ?? this.status,
      challengerId: challengerId ?? this.challengerId,
      defenderId: defenderId ?? this.defenderId,
      missionId: missionId ?? this.missionId,
      createdAt: createdAt ?? this.createdAt,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      winnerId: winnerId ?? this.winnerId,
      battleData: battleData ?? this.battleData,
      spectators: spectators ?? this.spectators,
      isPrivate: isPrivate ?? this.isPrivate,
    );
  }
}
