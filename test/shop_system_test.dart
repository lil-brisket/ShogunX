import 'package:flutter_test/flutter_test.dart';
import 'package:ninja_world_mmo/models/models.dart';
import 'package:ninja_world_mmo/services/shop_service.dart';

void main() {
  group('Shop System Tests', () {
    late ShopService shopService;
    late Character testCharacter;
    late Item testItem;

    setUp(() {
      shopService = ShopService();
      
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
        currentHp: 30,
        currentChakra: 30,
        currentStamina: 30,
        experience: 0,
        level: 1,
        hpRegenRate: 1,
        cpRegenRate: 1,
        spRegenRate: 1,
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

    test('Character can afford item', () {
      expect(shopService.canAffordItem(testCharacter, testItem), isTrue);
    });

    test('Character can use item', () {
      expect(shopService.canUseItem(testCharacter, testItem), isTrue);
    });

    test('Purchase item success', () async {
      final result = await shopService.purchaseItem(testCharacter, testItem);
      
      expect(result.success, isTrue);
      expect(result.message, contains('Successfully purchased'));
      expect(result.updatedCharacter, isNotNull);
      expect(result.purchasedItem, isNotNull);
      
      // Check that character's ryo was deducted
      expect(result.updatedCharacter!.ryoOnHand, equals(900)); // 1000 - 100
      
      // Check that item was added to inventory
      expect(result.updatedCharacter!.inventory.length, equals(1));
      expect(result.updatedCharacter!.inventory.first.name, equals('Test Kunai'));
    });

    test('Purchase item with insufficient ryo', () async {
      // Create character with insufficient ryo
      final poorCharacter = testCharacter.copyWith(ryoOnHand: 50);
      
      final result = await shopService.purchaseItem(poorCharacter, testItem);
      
      expect(result.success, isFalse);
      expect(result.message, contains('Insufficient ryo'));
    });

    test('Purchase item with level requirement too high', () async {
      // Create item with high level requirement
      final highLevelItem = testItem.copyWith(requiredLevel: 10);
      
      final result = await shopService.purchaseItem(testCharacter, highLevelItem);
      
      expect(result.success, isFalse);
      expect(result.message, contains('requirements'));
    });

    test('Purchase item not available in shop', () async {
      // Create item not available in shop
      final shopItem = testItem.copyWith(isAvailableInShop: false);
      
      final result = await shopService.purchaseItem(testCharacter, shopItem);
      
      expect(result.success, isFalse);
      expect(result.message, contains('not available'));
    });
  });
}
