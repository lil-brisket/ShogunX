import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../services/services.dart';

// Provider for HospitalService
final hospitalServiceProvider = Provider<HospitalService>((ref) {
  return HospitalService();
});

// Provider for all patients in hospital
final hospitalPatientsProvider = FutureProvider<List<HospitalPatient>>((ref) async {
  final hospitalService = ref.read(hospitalServiceProvider);
  return await hospitalService.getAllPatients();
});

// Provider for a specific patient
final hospitalPatientProvider = FutureProvider.family<HospitalPatient?, String>((ref, characterId) async {
  final hospitalService = ref.read(hospitalServiceProvider);
  return await hospitalService.getPatient(characterId);
});

// Provider for medical rank of a character
final medicalRankProvider = Provider.family<MedicalRank, String>((ref, characterId) {
  final hospitalService = ref.read(hospitalServiceProvider);
  return hospitalService.getMedicalRank(characterId);
});

// Provider for medical EXP of a character
final medicalExpProvider = Provider.family<int, String>((ref, characterId) {
  final hospitalService = ref.read(hospitalServiceProvider);
  return hospitalService.getMedicalExp(characterId);
});

// Provider for checking if character is in hospital
final isInHospitalProvider = FutureProvider.family<bool, String>((ref, characterId) async {
  final hospitalService = ref.read(hospitalServiceProvider);
  return await hospitalService.isInHospital(characterId);
});

// Notifier for hospital operations
class HospitalNotifier extends StateNotifier<AsyncValue<void>> {
  final HospitalService _hospitalService;
  final Ref _ref;

  HospitalNotifier(this._hospitalService, this._ref) : super(const AsyncValue.data(null));

  // Admit a character to hospital
  Future<void> admitPatient(Character character) async {
    state = const AsyncValue.loading();
    try {
      await _hospitalService.admitPatient(character);
      // Refresh the patients list
      _ref.invalidate(hospitalPatientsProvider);
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  // Perform paid healing
  Future<bool> performPaidHeal(String characterId, int ryoCost) async {
    state = const AsyncValue.loading();
    try {
      final success = await _hospitalService.performPaidHeal(characterId, ryoCost);
      if (success) {
        // Refresh the patients list
        _ref.invalidate(hospitalPatientsProvider);
      }
      state = const AsyncValue.data(null);
      return success;
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      return false;
    }
  }

  // Perform medic healing
  Future<HealingResult> performMedicHeal(Character healer, String patientId) async {
    state = const AsyncValue.loading();
    try {
      final result = await _hospitalService.performMedicHeal(healer, patientId);
      if (result.success) {
        // Refresh the patients list and medical rank
        _ref.invalidate(hospitalPatientsProvider);
        _ref.invalidate(medicalRankProvider(healer.id));
        _ref.invalidate(medicalExpProvider(healer.id));
      }
      state = const AsyncValue.data(null);
      return result;
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      return HealingResult.failure('An error occurred during healing');
    }
  }

  // Process natural healing
  Future<void> processNaturalHealing() async {
    state = const AsyncValue.loading();
    try {
      await _hospitalService.processNaturalHealing();
      // Refresh the patients list
      _ref.invalidate(hospitalPatientsProvider);
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  // Discharge a patient
  Future<void> dischargePatient(String characterId) async {
    state = const AsyncValue.loading();
    try {
      await _hospitalService.dischargePatient(characterId);
      // Refresh the patients list
      _ref.invalidate(hospitalPatientsProvider);
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  // Add medical EXP to a character
  Future<void> addMedicalExp(String characterId, int exp) async {
    try {
      await _hospitalService.addMedicalExp(characterId, exp);
      // Refresh medical rank and EXP
      _ref.invalidate(medicalRankProvider(characterId));
      _ref.invalidate(medicalExpProvider(characterId));
    } catch (error, stackTrace) {
      // Handle error silently for EXP updates
    }
  }
}

// Provider for HospitalNotifier
final hospitalNotifierProvider = StateNotifierProvider<HospitalNotifier, AsyncValue<void>>((ref) {
  final hospitalService = ref.read(hospitalServiceProvider);
  return HospitalNotifier(hospitalService, ref);
});

// Provider for hospital operations
final hospitalOperationsProvider = Provider<HospitalNotifier>((ref) {
  return ref.read(hospitalNotifierProvider.notifier);
});
