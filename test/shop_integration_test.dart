import 'package:flutter_test/flutter_test.dart';
import 'package:ninja_world_mmo/models/models.dart';
import 'package:ninja_world_mmo/services/shop_service.dart';
import 'package:ninja_world_mmo/services/game_service.dart';

void main() {
  group('Shop Integration Tests', () {
    late ShopService shopService;
    late GameService gameService;
    late Character testCharacter;
    late Item testItem;

    setUp(() {
      shopService = ShopService();
      gameService = GameService();
      
      // Create a test character
      testCharacter = Character(
        id: 'test_char_1',
        userId: 'test_user_1',
        name: 'TestNinja',
        village: 'Konoha',
        clanId: null,
        clanRank: null,
        ninjaRank: 'Academy Student',
        elements: ['Fire'],
        bloodline: null,
        strength: 1,
        intelligence: 1,
        speed: 1,
        defense: 1,
        willpower: 1,
        bukijutsu: 1,
        ninjutsu: 1,
        taijutsu: 1,
        genjutsu: 1,
        jutsuMastery: {},
        currentHp: 10000,
        currentChakra: 10000,
        currentStamina: 10000,
        experience: 1000,
        level: 5,
        hpRegenRate: 10,
        cpRegenRate: 10,
        spRegenRate: 10,
        ryoOnHand: 1000,
        ryoBanked: 5000,
        villageLoyalty: 50,
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
        gender: 'male',
        inventory: [],
        equippedItems: {},
      );

      // Create a test item
      testItem = Item(
        id: 'test_item_1',
        name: 'Test Kunai',
        description: 'A test throwing knife',
        type: ItemType.weapon,
        equipmentSlot: EquipmentSlot.weapon,
        statBonuses: {'strength': 50, 'speed': 25},
        statMultipliers: {},
        specialEffects: ['throwing_weapon'],
        durability: 100,
        maxDurability: 100,
        isRepairable: true,
        isTradeable: true,
        isDroppable: true,
        buyPrice: 100,
        sellPrice: 50,
        shopCategory: 'weapons',
        isAvailableInShop: true,
        requiredLevel: 1,
        statRequirements: {},
        requiredElements: [],
        requiredBloodline: null,
        iconPath: 'assets/items/test_kunai.png',
        tags: ['weapon', 'throwing', 'test'],
        isActive: true,
        rarity: 'Common',
      );
    });

    test('Purchase item and verify character data persistence', () async {
      // Initial state
      expect(testCharacter.inventory.length, equals(0));
      expect(testCharacter.ryoOnHand, equals(1000));
      
      // Purchase item
      final result = await shopService.purchaseItem(testCharacter, testItem);
      
      // Verify purchase was successful
      expect(result.success, isTrue);
      expect(result.updatedCharacter, isNotNull);
      
      // Verify character data was updated
      final updatedCharacter = result.updatedCharacter!;
      expect(updatedCharacter.inventory.length, equals(1));
      expect(updatedCharacter.ryoOnHand, equals(900)); // 1000 - 100
      expect(updatedCharacter.inventory.first.name, equals('Test Kunai'));
      
      // Verify the updated character can be retrieved from game service
      final retrievedCharacter = await gameService.getCharacter(updatedCharacter.id);
      expect(retrievedCharacter, isNotNull);
      expect(retrievedCharacter!.inventory.length, equals(1));
      expect(retrievedCharacter.ryoOnHand, equals(900));
      expect(retrievedCharacter.inventory.first.name, equals('Test Kunai'));
    });

    test('Multiple purchases update character correctly', () async {
      // Create a second item
      final secondItem = testItem.copyWith(
        id: 'test_item_2',
        name: 'Test Shuriken',
        buyPrice: 150,
      );
      
      // Purchase first item
      final result1 = await shopService.purchaseItem(testCharacter, testItem);
      expect(result1.success, isTrue);
      
      // Purchase second item
      final result2 = await shopService.purchaseItem(result1.updatedCharacter!, secondItem);
      expect(result2.success, isTrue);
      
      // Verify final state
      final finalCharacter = result2.updatedCharacter!;
      expect(finalCharacter.inventory.length, equals(2));
      expect(finalCharacter.ryoOnHand, equals(750)); // 1000 - 100 - 150
      expect(finalCharacter.inventory.map((i) => i.name).toList(), 
             containsAll(['Test Kunai', 'Test Shuriken']));
    });

    test('Purchase validation works correctly', () async {
      // Test insufficient funds
      final poorCharacter = testCharacter.copyWith(ryoOnHand: 50);
      final result1 = await shopService.purchaseItem(poorCharacter, testItem);
      expect(result1.success, isFalse);
      expect(result1.message, contains('Insufficient ryo'));
      
      // Test level requirement
      final highLevelItem = testItem.copyWith(requiredLevel: 10);
      final result2 = await shopService.purchaseItem(testCharacter, highLevelItem);
      expect(result2.success, isFalse);
      expect(result2.message, contains('requirements'));
      
      // Test item not available in shop
      final shopItem = testItem.copyWith(isAvailableInShop: false);
      final result3 = await shopService.purchaseItem(testCharacter, shopItem);
      expect(result3.success, isFalse);
      expect(result3.message, contains('not available'));
    });
  });
}
