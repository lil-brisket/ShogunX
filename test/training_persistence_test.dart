import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ninja_world_mmo/models/training_session.dart';
import 'package:ninja_world_mmo/models/character.dart';

void main() {
  group('Training Persistence Tests', () {
    late ProviderContainer container;
    late Character testCharacter;

    setUp(() {
      container = ProviderContainer();
      
      testCharacter = Character(
        id: 'test_char_1',
        userId: 'test_user_1',
        name: 'TestNinja',
        village: 'Konoha',
        ninjaRank: 'Genin',
        elements: ['Fire'],
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
        studentIds: [],
        pvpWins: 0,
        pvpLosses: 0,
        pveWins: 0,
        pveLosses: 0,
        medicalExp: 0,
        gender: 'Unknown',
        inventory: [],
        equippedItems: {},
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('Training session should be created with correct initial values', () {
      final session = TrainingSession(
        id: 'test_session_1',
        characterId: testCharacter.id,
        statType: 'strength',
        startTime: DateTime.now(),
        currentStatValue: testCharacter.strength,
        maxStat: 250000,
      );

      expect(session.characterId, equals(testCharacter.id));
      expect(session.statType, equals('strength'));
      expect(session.isActive, isTrue);
      expect(session.currentStatValue, equals(testCharacter.strength));
      expect(session.maxStat, equals(250000));
    });

    test('Training session should calculate elapsed time correctly', () {
      final startTime = DateTime.now().subtract(const Duration(hours: 2));
      final session = TrainingSession(
        id: 'test_session_1',
        characterId: testCharacter.id,
        statType: 'strength',
        startTime: startTime,
        currentStatValue: testCharacter.strength,
        maxStat: 250000,
      );

      expect(session.elapsedTime, greaterThan(0));
      expect(session.elapsedTime, lessThanOrEqualTo(TrainingSession.maxSessionTime));
    });

    test('Training session should calculate potential gain correctly', () {
      final startTime = DateTime.now().subtract(const Duration(hours: 1));
      final session = TrainingSession(
        id: 'test_session_1',
        characterId: testCharacter.id,
        statType: 'strength',
        startTime: startTime,
        currentStatValue: testCharacter.strength,
        maxStat: 250000,
      );

      expect(session.potentialGain, greaterThan(0));
      expect(session.potentialGain, lessThanOrEqualTo(session.remainingStat));
    });

    test('Training session should be serializable to JSON', () {
      final session = TrainingSession(
        id: 'test_session_1',
        characterId: testCharacter.id,
        statType: 'strength',
        startTime: DateTime.now(),
        currentStatValue: testCharacter.strength,
        maxStat: 250000,
      );

      final json = session.toJson();
      expect(json['id'], equals(session.id));
      expect(json['characterId'], equals(session.characterId));
      expect(json['statType'], equals(session.statType));
      expect(json['isActive'], equals(session.isActive));
    });

    test('Training session should be deserializable from JSON', () {
      final originalSession = TrainingSession(
        id: 'test_session_1',
        characterId: testCharacter.id,
        statType: 'strength',
        startTime: DateTime.now(),
        currentStatValue: testCharacter.strength,
        maxStat: 250000,
      );

      final json = originalSession.toJson();
      final deserializedSession = TrainingSession.fromJson(json);

      expect(deserializedSession.id, equals(originalSession.id));
      expect(deserializedSession.characterId, equals(originalSession.characterId));
      expect(deserializedSession.statType, equals(originalSession.statType));
      expect(deserializedSession.isActive, equals(originalSession.isActive));
    });

    test('Training session should be copyable with new values', () {
      final originalSession = TrainingSession(
        id: 'test_session_1',
        characterId: testCharacter.id,
        statType: 'strength',
        startTime: DateTime.now(),
        currentStatValue: testCharacter.strength,
        maxStat: 250000,
      );

      final copiedSession = originalSession.copyWith(
        isActive: false,
        endTime: DateTime.now(),
        actualGain: 1000,
      );

      expect(copiedSession.id, equals(originalSession.id));
      expect(copiedSession.isActive, isFalse);
      expect(copiedSession.endTime, isNotNull);
      expect(copiedSession.actualGain, equals(1000));
    });
  });
}
