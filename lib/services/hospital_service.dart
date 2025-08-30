import '../models/models.dart';

class HospitalService {
  static final HospitalService _instance = HospitalService._internal();
  factory HospitalService() => _instance;
  
  HospitalService._internal() {
    _initializeDemoData();
  }

  // In-memory storage for demo purposes
  final Map<String, HospitalPatient> _patients = {};
  final Map<String, int> _medicalExp = {}; // characterId -> medicalExp

  void _initializeDemoData() {
    // Add some demo patients
    _patients['demo_patient_1'] = HospitalPatient(
      id: 'demo_patient_1',
      characterId: 'demo_patient_1',
      characterName: 'InjuredNinja',
      currentHp: 0,
      maxHp: 500000,
      currentChakra: 0,
      maxChakra: 600000,
      currentStamina: 0,
      maxStamina: 700000,
      admittedAt: DateTime.now().subtract(const Duration(minutes: 1)),
      naturalHealTime: DateTime.now().add(const Duration(minutes: 1)),
    );

    _patients['demo_patient_2'] = HospitalPatient(
      id: 'demo_patient_2',
      characterId: 'demo_patient_2',
      characterName: 'WoundedKunoichi',
      currentHp: 50000,
      maxHp: 450000,
      currentChakra: 100000,
      maxChakra: 500000,
      currentStamina: 150000,
      maxStamina: 600000,
      admittedAt: DateTime.now().subtract(const Duration(minutes: 30)),
      naturalHealTime: DateTime.now().add(const Duration(minutes: 30)),
    );

    // Add some demo medical EXP
    _medicalExp['demo_user_1'] = 5000; // Apprentice Medic
    _medicalExp['demo_patient_1'] = 0; // Novice Medic
    _medicalExp['demo_patient_2'] = 15000; // Novice Medic
  }

  // Constants
  static const int naturalHealDurationMinutes = 2;
  static const int paidHealCost = 1000; // Ryo cost for instant heal
  static const int expPerHeal = 10; // Medical EXP gained per patient healed

  // Get all patients in hospital
  Future<List<HospitalPatient>> getAllPatients() async {
    await Future.delayed(const Duration(milliseconds: 100));
    
    // Clean up fully healed patients
    _cleanupHealedPatients();
    
    return _patients.values.toList();
  }

  // Get patient by character ID
  Future<HospitalPatient?> getPatient(String characterId) async {
    await Future.delayed(const Duration(milliseconds: 50));
    return _patients[characterId];
  }

  // Admit a character to hospital (when HP reaches 0)
  Future<void> admitPatient(Character character) async {
    await Future.delayed(const Duration(milliseconds: 100));
    
    final patient = HospitalPatient(
      id: 'patient_${character.id}',
      characterId: character.id,
      characterName: character.name,
      currentHp: character.currentHp,
      maxHp: character.maxHp,
      currentChakra: character.currentChakra,
      maxChakra: character.maxChakra,
      currentStamina: character.currentStamina,
      maxStamina: character.maxStamina,
      admittedAt: DateTime.now(),
      naturalHealTime: DateTime.now().add(Duration(minutes: naturalHealDurationMinutes)),
    );
    
    _patients[character.id] = patient;
  }

  // Natural healing (automatic after timer)
  Future<void> processNaturalHealing() async {
    await Future.delayed(const Duration(milliseconds: 50));
    
    final now = DateTime.now();
    final patientsToHeal = <String>[];
    
    for (final entry in _patients.entries) {
      final patient = entry.value;
      if (patient.naturalHealTime != null && now.isAfter(patient.naturalHealTime!)) {
        patientsToHeal.add(entry.key);
      }
    }
    
    for (final characterId in patientsToHeal) {
      final patient = _patients[characterId]!;
      final healedPatient = patient.copyWith(
        currentHp: patient.maxHp,
        currentChakra: patient.maxChakra,
        currentStamina: patient.maxStamina,
        healedAt: now,
      );
      _patients[characterId] = healedPatient;
    }
  }

  // Paid healing (instant full heal)
  Future<bool> performPaidHeal(String characterId, int ryoCost) async {
    await Future.delayed(const Duration(milliseconds: 100));
    
    final patient = _patients[characterId];
    if (patient == null) return false;
    
    if (ryoCost < paidHealCost) return false;
    
    final healedPatient = patient.copyWith(
      currentHp: patient.maxHp,
      currentChakra: patient.maxChakra,
      currentStamina: patient.maxStamina,
      isPaidHeal: true,
      paidHealCost: ryoCost,
      healedAt: DateTime.now(),
    );
    
    _patients[characterId] = healedPatient;
    return true;
  }

  // Medic healing (using CP/SP)
  Future<HealingResult> performMedicHeal(Character healer, String patientId) async {
    await Future.delayed(const Duration(milliseconds: 150));
    
    final patient = _patients[patientId];
    if (patient == null) {
      return HealingResult.failure('Patient not found');
    }
    
    if (patient.isFullyHealed) {
      return HealingResult.failure('Patient is already fully healed');
    }
    
    final rankData = MedicalRank.getRankByExp(healer.medicalExp);
    
    // Calculate missing stats
    final missingHp = patient.maxHp - patient.currentHp;
    final missingCp = patient.maxChakra - patient.currentChakra;
    final missingSp = patient.maxStamina - patient.currentStamina;
    
    // Calculate max HP that can be healed based on healer's resources
    final maxHpByCp = (healer.currentChakra / rankData.cpPerHp).floor();
    final maxHpBySp = (healer.currentStamina / rankData.spPerHp).floor();
    
    // Heal as much HP as possible with available resources
    final maxHpHealed = [missingHp, maxHpByCp, maxHpBySp].reduce((a, b) => a < b ? a : b);
    
    if (maxHpHealed <= 0) {
      return HealingResult.failure('Not enough CP/SP to heal any HP');
    }
    
    // Calculate resources used
    final cpUsed = (maxHpHealed * rankData.cpPerHp).round();
    final spUsed = (maxHpHealed * rankData.spPerHp).round();
    
    // Apply healing - heal HP, CP, and SP as much as possible
    final newHp = (patient.currentHp + maxHpHealed).clamp(0, patient.maxHp);
    
    // Heal CP and SP proportionally to HP healing, but also consider direct CP/SP healing
    final cpHealRatio = maxHpHealed / patient.maxHp;
    final spHealRatio = maxHpHealed / patient.maxHp;
    
    final newChakra = (patient.currentChakra + (missingCp * cpHealRatio)).round().clamp(0, patient.maxChakra);
    final newStamina = (patient.currentStamina + (missingSp * spHealRatio)).round().clamp(0, patient.maxStamina);
    
    // Update patient
    final healedPatient = patient.copyWith(
      currentHp: newHp,
      currentChakra: newChakra,
      currentStamina: newStamina,
      healedBy: healer.id,
      healedAt: DateTime.now(),
    );
    
    _patients[patientId] = healedPatient;
    
    // Update healer's medical EXP
    _medicalExp[healer.id] = (healer.medicalExp + expPerHeal);
    
    return HealingResult.success(
      hpHealed: maxHpHealed,
      cpUsed: cpUsed,
      spUsed: spUsed,
      expGained: expPerHeal,
      newRank: MedicalRank.getRankByExp(_medicalExp[healer.id] ?? 0),
    );
  }

  // Get medical rank for a character
  MedicalRank getMedicalRank(String characterId) {
    final exp = _medicalExp[characterId] ?? 0;
    return MedicalRank.getRankByExp(exp);
  }

  // Get medical EXP for a character
  int getMedicalExp(String characterId) {
    return _medicalExp[characterId] ?? 0;
  }

  // Add medical EXP to a character
  Future<void> addMedicalExp(String characterId, int exp) async {
    await Future.delayed(const Duration(milliseconds: 50));
    _medicalExp[characterId] = (_medicalExp[characterId] ?? 0) + exp;
  }

  // Check if character is in hospital
  Future<bool> isInHospital(String characterId) async {
    await Future.delayed(const Duration(milliseconds: 50));
    return _patients.containsKey(characterId);
  }

  // Discharge patient (remove from hospital)
  Future<void> dischargePatient(String characterId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _patients.remove(characterId);
  }

  // Clean up fully healed patients
  void _cleanupHealedPatients() {
    final patientsToRemove = <String>[];
    
    for (final entry in _patients.entries) {
      final patient = entry.value;
      if (patient.isFullyHealed) {
        patientsToRemove.add(entry.key);
      }
    }
    
    for (final characterId in patientsToRemove) {
      _patients.remove(characterId);
    }
  }

  // Get healing cost for a patient
  int getHealingCost(HospitalPatient patient) {
    final missingHp = patient.maxHp - patient.currentHp;
    final missingCp = patient.maxChakra - patient.currentChakra;
    final missingSp = patient.maxStamina - patient.currentStamina;
    
    // Base cost: 1 ryo per missing HP/CP/SP
    return missingHp + missingCp + missingSp;
  }

  // Get estimated healing time for natural healing
  Duration getEstimatedHealingTime(HospitalPatient patient) {
    if (patient.naturalHealTime == null) return Duration.zero;
    final remaining = patient.naturalHealTime!.difference(DateTime.now());
    return remaining.isNegative ? Duration.zero : remaining;
  }
}

// Result class for healing operations
class HealingResult {
  final bool success;
  final String? errorMessage;
  final int? hpHealed;
  final int? cpUsed;
  final int? spUsed;
  final int? expGained;
  final MedicalRank? newRank;

  const HealingResult._({
    required this.success,
    this.errorMessage,
    this.hpHealed,
    this.cpUsed,
    this.spUsed,
    this.expGained,
    this.newRank,
  });

  factory HealingResult.success({
    required int hpHealed,
    required int cpUsed,
    required int spUsed,
    required int expGained,
    MedicalRank? newRank,
  }) {
    return HealingResult._(
      success: true,
      hpHealed: hpHealed,
      cpUsed: cpUsed,
      spUsed: spUsed,
      expGained: expGained,
      newRank: newRank,
    );
  }

  factory HealingResult.failure(String errorMessage) {
    return HealingResult._(
      success: false,
      errorMessage: errorMessage,
    );
  }
}
