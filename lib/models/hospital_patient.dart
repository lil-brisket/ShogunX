class HospitalPatient {
  final String id;
  final String characterId;
  final String characterName;
  final int currentHp;
  final int maxHp;
  final int currentChakra;
  final int maxChakra;
  final int currentStamina;
  final int maxStamina;
  final DateTime admittedAt;
  final DateTime? naturalHealTime;
  final bool isPaidHeal;
  final int paidHealCost;
  final String? healedBy; // ID of medic who healed them
  final DateTime? healedAt;

  const HospitalPatient({
    required this.id,
    required this.characterId,
    required this.characterName,
    required this.currentHp,
    required this.maxHp,
    required this.currentChakra,
    required this.maxChakra,
    required this.currentStamina,
    required this.maxStamina,
    required this.admittedAt,
    this.naturalHealTime,
    this.isPaidHeal = false,
    this.paidHealCost = 0,
    this.healedBy,
    this.healedAt,
  });

  bool get isFullyHealed => currentHp >= maxHp && currentChakra >= maxChakra && currentStamina >= maxStamina;
  
  bool get canNaturalHeal => naturalHealTime != null && DateTime.now().isAfter(naturalHealTime!);
  
  Duration get timeUntilNaturalHeal {
    if (naturalHealTime == null) return Duration.zero;
    final remaining = naturalHealTime!.difference(DateTime.now());
    return remaining.isNegative ? Duration.zero : remaining;
  }

  double get hpPercentage => currentHp / maxHp;
  double get chakraPercentage => currentChakra / maxChakra;
  double get staminaPercentage => currentStamina / maxStamina;

  HospitalPatient copyWith({
    String? id,
    String? characterId,
    String? characterName,
    int? currentHp,
    int? maxHp,
    int? currentChakra,
    int? maxChakra,
    int? currentStamina,
    int? maxStamina,
    DateTime? admittedAt,
    DateTime? naturalHealTime,
    bool? isPaidHeal,
    int? paidHealCost,
    String? healedBy,
    DateTime? healedAt,
  }) {
    return HospitalPatient(
      id: id ?? this.id,
      characterId: characterId ?? this.characterId,
      characterName: characterName ?? this.characterName,
      currentHp: currentHp ?? this.currentHp,
      maxHp: maxHp ?? this.maxHp,
      currentChakra: currentChakra ?? this.currentChakra,
      maxChakra: maxChakra ?? this.maxChakra,
      currentStamina: currentStamina ?? this.currentStamina,
      maxStamina: maxStamina ?? this.maxStamina,
      admittedAt: admittedAt ?? this.admittedAt,
      naturalHealTime: naturalHealTime ?? this.naturalHealTime,
      isPaidHeal: isPaidHeal ?? this.isPaidHeal,
      paidHealCost: paidHealCost ?? this.paidHealCost,
      healedBy: healedBy ?? this.healedBy,
      healedAt: healedAt ?? this.healedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'characterId': characterId,
      'characterName': characterName,
      'currentHp': currentHp,
      'maxHp': maxHp,
      'currentChakra': currentChakra,
      'maxChakra': maxChakra,
      'currentStamina': currentStamina,
      'maxStamina': maxStamina,
      'admittedAt': admittedAt.toIso8601String(),
      'naturalHealTime': naturalHealTime?.toIso8601String(),
      'isPaidHeal': isPaidHeal,
      'paidHealCost': paidHealCost,
      'healedBy': healedBy,
      'healedAt': healedAt?.toIso8601String(),
    };
  }

  factory HospitalPatient.fromJson(Map<String, dynamic> json) {
    return HospitalPatient(
      id: json['id'],
      characterId: json['characterId'],
      characterName: json['characterName'],
      currentHp: json['currentHp'],
      maxHp: json['maxHp'],
      currentChakra: json['currentChakra'],
      maxChakra: json['maxChakra'],
      currentStamina: json['currentStamina'],
      maxStamina: json['maxStamina'],
      admittedAt: DateTime.parse(json['admittedAt']),
      naturalHealTime: json['naturalHealTime'] != null ? DateTime.parse(json['naturalHealTime']) : null,
      isPaidHeal: json['isPaidHeal'] ?? false,
      paidHealCost: json['paidHealCost'] ?? 0,
      healedBy: json['healedBy'],
      healedAt: json['healedAt'] != null ? DateTime.parse(json['healedAt']) : null,
    );
  }
}
