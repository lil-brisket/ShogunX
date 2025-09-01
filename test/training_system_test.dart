import 'package:flutter_test/flutter_test.dart';
import 'package:ninja_world_mmo/models/training_session.dart';
import 'package:ninja_world_mmo/models/character.dart';
import 'package:ninja_world_mmo/services/training_service.dart';

void main() {
  group('Training System Tests', () {
    late Character testCharacter;

    setUp(() {
      testCharacter = Character(
        id: 'test_char_1',
        userId: 'test_user_1',
        name: 'TestNinja',
        village: 'Konoha',
        clanId: null,
        clanRank: null,
        ninjaRank: 'Genin',
        elements: ['Fire'],
        bloodline: null,
        strength: 1000,
        intelligence: 1000,
        speed: 1000,
        defense: 1000,
        willpower: 1000,
        bukijutsu: 1000,
        ninjutsu: 1000,
        taijutsu: 1000,
        genjutsu: 0,
        jutsuMastery: {},
        currentHp: 40000,
        currentChakra: 30000,
        currentStamina: 30000,
        experience: 0,
        level: 1,
        hpRegenRate: 100,
        cpRegenRate: 100,
        spRegenRate: 100,
        ryoOnHand: 1000,
        ryoBanked: 0,
        villageLoyalty: 100,
        outlawInfamy: 0,
        marriedTo: null,
        senseiId: null,
        studentIds: [],
        pvpWins: 0,
        pvpLosses: 0,
        pveWins: 0,
        pveLosses: 0,
        medicalExp: 0,
        avatarUrl: null,
        gender: 'Unknown',
        inventory: [],
        equippedItems: {},
      );
    });

    test('Training session creation', () {
      final session = TrainingService.startTraining(testCharacter, 'strength');
      
      expect(session.characterId, equals(testCharacter.id));
      expect(session.statType, equals('strength'));
      expect(session.currentStatValue, equals(1000));
      expect(session.maxStat, equals(250000));
      expect(session.isActive, isTrue);
      expect(session.startTime, isNotNull);
    });

    test('Training session progress calculation', () {
      final session = TrainingService.startTraining(testCharacter, 'strength');
      
      // Test initial progress
      expect(session.progress, greaterThanOrEqualTo(0.0));
      expect(session.progress, lessThanOrEqualTo(1.0));
      expect(session.potentialGain, greaterThanOrEqualTo(0));
    });

    test('Training session completion', () {
      final session = TrainingService.startTraining(testCharacter, 'strength');
      
      // For testing, we need to simulate some elapsed time
      // Since the session was just created, statGain should be 0 initially
      expect(session.statGain, equals(0));
      
      // Test that the completion method works (even with 0 gain)
      final completedCharacter = TrainingService.completeTraining(testCharacter, session);
      expect(completedCharacter.strength, equals(testCharacter.strength)); // No gain initially
    });

    test('Can train stat check', () {
      expect(TrainingService.canTrainStat(testCharacter, 'strength'), isTrue);
      expect(TrainingService.canTrainStat(testCharacter, 'intelligence'), isTrue);
      
      // Test with maxed stat
      final maxedCharacter = testCharacter.copyWith(strength: 250000);
      expect(TrainingService.canTrainStat(maxedCharacter, 'strength'), isFalse);
    });

    test('Training session time remaining', () {
      final session = TrainingService.startTraining(testCharacter, 'strength');
      
      expect(session.timeRemaining, isNotEmpty);
      expect(session.timeRemaining, isNot(equals('Complete')));
    });

    test('Training session early collection enabled', () {
      expect(TrainingSession.earlyCollection, isTrue);
    });

    test('Training session max time', () {
      expect(TrainingSession.maxSessionTime, equals(28800)); // 8 hours in seconds
    });

    test('Training session base rate calculation', () {
      expect(TrainingSession.baseRate, closeTo(0.87, 0.01)); // 25000 XP / 28800 seconds
    });
  });
}
