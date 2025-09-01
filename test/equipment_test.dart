import 'package:flutter_test/flutter_test.dart';
import 'package:ninja_world_mmo/models/models.dart';
import 'package:ninja_world_mmo/services/equipment_service.dart';

void main() {
  group('Equipment System Tests', () {
    late Character testCharacter;
    late Item testWeapon;
    late Item testArmor;
    late EquipmentService equipmentService;

    setUp(() {
      equipmentService = EquipmentService();
      
      // Create a test character
      testCharacter = Character(
        id: 'test_char_1',
        name: 'Test Character',
        userId: 'test_user_1',
        village: 'Konoha',
        ninjaRank: 'Academy Student',
        elements: ['Fire'],
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
        currentHp: 100,
        currentChakra: 100,
        currentStamina: 100,
        experience: 0,
        level: 1,
        hpRegenRate: 1,
        cpRegenRate: 1,
        spRegenRate: 1,
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
        gender: 'male',
        inventory: [],
        equippedItems: {},
      );

      // Create test items
      testWeapon = Item(
        id: 'test_weapon_1',
        name: 'Test Sword',
        description: 'A test weapon',
        type: ItemType.weapon,
        rarity: 'Common',
        equipmentSlot: EquipmentSlot.weapon,
        statBonuses: {'strength': 5},
        statMultipliers: {},
        specialEffects: [],
        durability: 100,
        maxDurability: 100,
        isRepairable: true,
        isTradeable: true,
        isDroppable: true,
        buyPrice: 100,
        sellPrice: 50,
        isAvailableInShop: true,
        requiredLevel: 1,
        statRequirements: {},
        requiredElements: [],
        iconPath: 'assets/icons/weapon.png',
        tags: ['weapon', 'sword'],
        isActive: true,
      );

      testArmor = Item(
        id: 'test_armor_1',
        name: 'Test Armor',
        description: 'A test armor',
        type: ItemType.armor,
        rarity: 'Common',
        equipmentSlot: EquipmentSlot.body,
        statBonuses: {'defense': 3},
        statMultipliers: {},
        specialEffects: [],
        durability: 100,
        maxDurability: 100,
        isRepairable: true,
        isTradeable: true,
        isDroppable: true,
        buyPrice: 150,
        sellPrice: 75,
        isAvailableInShop: true,
        requiredLevel: 1,
        statRequirements: {},
        requiredElements: [],
        iconPath: 'assets/icons/armor.png',
        tags: ['armor', 'body'],
        isActive: true,
      );
    });

    test('Character should start with empty equipped items', () {
      expect(testCharacter.equippedItems.isEmpty, true);
    });

    test('Item should be equippable if it has an equipment slot', () {
      expect(testWeapon.equipmentSlot, isNotNull);
      expect(testWeapon.equipmentSlot, EquipmentSlot.weapon);
    });

    test('Equipment service should calculate stat bonuses correctly', () {
      // Add items to inventory
      testCharacter = testCharacter.copyWith(
        inventory: [testWeapon, testArmor],
      );

      // Equip items
      testCharacter = testCharacter.copyWith(
        equippedItems: {
          EquipmentSlot.weapon: testWeapon,
          EquipmentSlot.body: testArmor,
        },
      );

      final statBonuses = equipmentService.getEquippedStatBonuses(testCharacter);
      
      expect(statBonuses['strength'], 5);
      expect(statBonuses['defense'], 3);
    });

    test('Equipment service should identify equipped items correctly', () {
      // Add items to inventory
      testCharacter = testCharacter.copyWith(
        inventory: [testWeapon, testArmor],
      );

      // Equip items
      testCharacter = testCharacter.copyWith(
        equippedItems: {
          EquipmentSlot.weapon: testWeapon,
          EquipmentSlot.body: testArmor,
        },
      );

      expect(equipmentService.isItemEquipped(testCharacter, testWeapon), true);
      expect(equipmentService.isItemEquipped(testCharacter, testArmor), true);
    });

    test('Equipment service should get equipped items correctly', () {
      // Add items to inventory
      testCharacter = testCharacter.copyWith(
        inventory: [testWeapon, testArmor],
      );

      // Equip items
      testCharacter = testCharacter.copyWith(
        equippedItems: {
          EquipmentSlot.weapon: testWeapon,
          EquipmentSlot.body: testArmor,
        },
      );

      final equippedWeapon = equipmentService.getEquippedItem(testCharacter, EquipmentSlot.weapon);
      final equippedArmor = equipmentService.getEquippedItem(testCharacter, EquipmentSlot.body);
      final equippedHead = equipmentService.getEquippedItem(testCharacter, EquipmentSlot.head);

      expect(equippedWeapon, testWeapon);
      expect(equippedArmor, testArmor);
      expect(equippedHead, isNull);
    });
  });
}
