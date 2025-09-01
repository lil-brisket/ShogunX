import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ninja_world_mmo/services/character_persistence_service.dart';
import 'package:ninja_world_mmo/models/models.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  
  group('Character Persistence Service Tests', () {
    late CharacterPersistenceService persistenceService;

    setUp(() {
      persistenceService = CharacterPersistenceService();
    });

    tearDown(() async {
      // Clear all test data after each test
      await persistenceService.clearAllCharacters();
    });

    test('should save and load character correctly', () async {
      // Create a test character
      final character = Character(
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

      // Save character
      await persistenceService.saveCharacter(character);

      // Load character by ID
      final loadedCharacter = await persistenceService.loadCharacter('test_char_1');
      
      expect(loadedCharacter, isNotNull);
      expect(loadedCharacter!.id, equals('test_char_1'));
      expect(loadedCharacter.name, equals('TestNinja'));
      expect(loadedCharacter.village, equals('Konoha'));
    });

    test('should load character by user ID correctly', () async {
      // Create a test character
      final character = Character(
        id: 'test_char_2',
        userId: 'test_user_2',
        name: 'TestNinja2',
        village: 'Suna',
        clanId: null,
        clanRank: null,
        ninjaRank: 'Genin',
        elements: ['Water'],
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

      // Save character
      await persistenceService.saveCharacter(character);

      // Load character by user ID
      final loadedCharacter = await persistenceService.loadCharacterByUserId('test_user_2');
      
      expect(loadedCharacter, isNotNull);
      expect(loadedCharacter!.userId, equals('test_user_2'));
      expect(loadedCharacter.name, equals('TestNinja2'));
      expect(loadedCharacter.village, equals('Suna'));
    });

    test('should check if character exists correctly', () async {
      // Create a test character
      final character = Character(
        id: 'test_char_3',
        userId: 'test_user_3',
        name: 'TestNinja3',
        village: 'Kiri',
        clanId: null,
        clanRank: null,
        ninjaRank: 'Genin',
        elements: ['Earth'],
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

      // Check before saving
      final existsBefore = await persistenceService.characterExists('test_user_3');
      expect(existsBefore, isFalse);

      // Save character
      await persistenceService.saveCharacter(character);

      // Check after saving
      final existsAfter = await persistenceService.characterExists('test_user_3');
      expect(existsAfter, isTrue);
    });

    test('should delete character correctly', () async {
      // Create a test character
      final character = Character(
        id: 'test_char_4',
        userId: 'test_user_4',
        name: 'TestNinja4',
        village: 'Kumo',
        clanId: null,
        clanRank: null,
        ninjaRank: 'Genin',
        elements: ['Wind'],
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

      // Save character
      await persistenceService.saveCharacter(character);

      // Verify it exists
      final existsBefore = await persistenceService.characterExists('test_user_4');
      expect(existsBefore, isTrue);

      // Delete character
      await persistenceService.deleteCharacter('test_char_4', 'test_user_4');

      // Verify it's deleted
      final existsAfter = await persistenceService.characterExists('test_user_4');
      expect(existsAfter, isFalse);

      final loadedCharacter = await persistenceService.loadCharacter('test_char_4');
      expect(loadedCharacter, isNull);
    });
  });
}
