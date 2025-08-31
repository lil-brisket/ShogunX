import 'package:flutter_test/flutter_test.dart';
import 'package:ninja_world_mmo/models/models.dart';
import 'package:ninja_world_mmo/services/hospital_service.dart';

void main() {
  group('Hospital System Tests', () {
    test('MedicalRank should return correct rank based on EXP', () {
      expect(MedicalRank.getRankByExp(0).name, equals('Novice Medic'));
      expect(MedicalRank.getRankByExp(25000).name, equals('Novice Medic'));
      expect(MedicalRank.getRankByExp(25001).name, equals('Apprentice Medic'));
      expect(MedicalRank.getRankByExp(50000).name, equals('Apprentice Medic'));
      expect(MedicalRank.getRankByExp(50001).name, equals('Expert Medic'));
      expect(MedicalRank.getRankByExp(100000).name, equals('Expert Medic'));
      expect(MedicalRank.getRankByExp(100001).name, equals('Master Medic'));
    });

    test('MedicalRank should calculate progress correctly', () {
      expect(MedicalRank.getProgressToNextRank(0), equals(0.0));
      expect(MedicalRank.getProgressToNextRank(12500), closeTo(0.5, 0.001));
      expect(MedicalRank.getProgressToNextRank(25000), equals(1.0));
      expect(MedicalRank.getProgressToNextRank(37500), closeTo(0.5, 0.001));
    });

    test('HospitalPatient should calculate health percentages correctly', () {
      final patient = HospitalPatient(
        id: 'test',
        characterId: 'test',
        characterName: 'Test',
        currentHp: 50,
        maxHp: 100,
        currentChakra: 25,
        maxChakra: 100,
        currentStamina: 75,
        maxStamina: 100,
        admittedAt: DateTime.now(),
      );

      expect(patient.hpPercentage, equals(0.5));
      expect(patient.chakraPercentage, equals(0.25));
      expect(patient.staminaPercentage, equals(0.75));
    });

    test('HospitalService should calculate healing costs correctly', () {
      final hospitalService = HospitalService();
      final patient = HospitalPatient(
        id: 'test',
        characterId: 'test',
        characterName: 'Test',
        currentHp: 50,
        maxHp: 100,
        currentChakra: 25,
        maxChakra: 100,
        currentStamina: 75,
        maxStamina: 100,
        admittedAt: DateTime.now(),
      );

      final cost = hospitalService.getHealingCost(patient);
      expect(cost, equals(150)); // 50 missing HP + 75 missing CP + 25 missing SP
    });
  });
}
