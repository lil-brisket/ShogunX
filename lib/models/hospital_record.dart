enum TreatmentType { selfHeal, ryoHeal, medicHeal, emergency }
enum PatientStatus { admitted, treated, discharged, deceased }

class HospitalRecord {
  final String id;
  final String patientId;
  final String? medicId; // null for self-heal
  final TreatmentType treatmentType;
  final PatientStatus status;
  final int cost; // Ryo cost
  final int chakraCost; // For medic healing
  final int staminaCost; // For medic healing
  final DateTime admittedAt;
  final DateTime? treatedAt;
  final DateTime? dischargedAt;
  final String? notes;
  final Map<String, dynamic> treatmentData; // Healing amounts, etc.

  HospitalRecord({
    required this.id,
    required this.patientId,
    this.medicId,
    required this.treatmentType,
    required this.status,
    required this.cost,
    required this.chakraCost,
    required this.staminaCost,
    required this.admittedAt,
    this.treatedAt,
    this.dischargedAt,
    this.notes,
    required this.treatmentData,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patientId,
      'medicId': medicId,
      'treatmentType': treatmentType.name,
      'status': status.name,
      'cost': cost,
      'chakraCost': chakraCost,
      'staminaCost': staminaCost,
      'admittedAt': admittedAt.toIso8601String(),
      'treatedAt': treatedAt?.toIso8601String(),
      'dischargedAt': dischargedAt?.toIso8601String(),
      'notes': notes,
      'treatmentData': treatmentData,
    };
  }

  factory HospitalRecord.fromJson(Map<String, dynamic> json) {
    return HospitalRecord(
      id: json['id'],
      patientId: json['patientId'],
      medicId: json['medicId'],
      treatmentType: TreatmentType.values.firstWhere((e) => e.name == json['treatmentType']),
      status: PatientStatus.values.firstWhere((e) => e.name == json['status']),
      cost: json['cost'],
      chakraCost: json['chakraCost'],
      staminaCost: json['staminaCost'],
      admittedAt: DateTime.parse(json['admittedAt']),
      treatedAt: json['treatedAt'] != null 
          ? DateTime.parse(json['treatedAt']) 
          : null,
      dischargedAt: json['dischargedAt'] != null 
          ? DateTime.parse(json['dischargedAt']) 
          : null,
      notes: json['notes'],
      treatmentData: Map<String, dynamic>.from(json['treatmentData']),
    );
  }

  HospitalRecord copyWith({
    String? id,
    String? patientId,
    String? medicId,
    TreatmentType? treatmentType,
    PatientStatus? status,
    int? cost,
    int? chakraCost,
    int? staminaCost,
    DateTime? admittedAt,
    DateTime? treatedAt,
    DateTime? dischargedAt,
    String? notes,
    Map<String, dynamic>? treatmentData,
  }) {
    return HospitalRecord(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      medicId: medicId ?? this.medicId,
      treatmentType: treatmentType ?? this.treatmentType,
      status: status ?? this.status,
      cost: cost ?? this.cost,
      chakraCost: chakraCost ?? this.chakraCost,
      staminaCost: staminaCost ?? this.staminaCost,
      admittedAt: admittedAt ?? this.admittedAt,
      treatedAt: treatedAt ?? this.treatedAt,
      dischargedAt: dischargedAt ?? this.dischargedAt,
      notes: notes ?? this.notes,
      treatmentData: treatmentData ?? this.treatmentData,
    );
  }
}
