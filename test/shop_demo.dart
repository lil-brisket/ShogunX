import 'package:ninja_world_mmo/services/shop_service.dart';
import 'package:ninja_world_mmo/services/game_service.dart';
import 'package:ninja_world_mmo/models/models.dart';

void main() async {
  print('=== Shop System Demo ===\n');
  
  final shopService = ShopService();
  final gameService = GameService();
  
  // Create a test character
  final character = Character(
    id: 'demo_char_1',
    userId: 'demo_user_1',
    name: 'DemoNinja',
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
    genjutsu: 1000,
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
  
  print('Initial Character State:');
  print('Name: ${character.name}');
  print('Ryo on hand: ${character.ryoOnHand}');
  print('Inventory items: ${character.inventory.length}');
  print('');
  
  // Get available items from shop
  final availableItems = shopService.getAvailableItems();
  print('Available items in shop: ${availableItems.length}');
  
  if (availableItems.isNotEmpty) {
    final firstItem = availableItems.first;
    print('First item: ${firstItem.name} (${firstItem.buyPrice} ryo)');
    print('');
    
    // Attempt to purchase the item
    print('Attempting to purchase ${firstItem.name}...');
    final result = await shopService.purchaseItem(character, firstItem);
    
    if (result.success) {
      print('✅ Purchase successful!');
      print('Message: ${result.message}');
      
      final updatedCharacter = result.updatedCharacter!;
      print('\nUpdated Character State:');
      print('Name: ${updatedCharacter.name}');
      print('Ryo on hand: ${updatedCharacter.ryoOnHand}');
      print('Inventory items: ${updatedCharacter.inventory.length}');
      
      if (updatedCharacter.inventory.isNotEmpty) {
        print('Inventory contents:');
        for (final item in updatedCharacter.inventory) {
          print('  - ${item.name} (${item.rarity})');
        }
      }
      
      // Save the character to game service
      await gameService.saveCharacter(updatedCharacter);
      print('\n✅ Character saved to game service');
      
      // Retrieve the character to verify persistence
      final retrievedCharacter = await gameService.getCharacter(updatedCharacter.id);
      if (retrievedCharacter != null) {
        print('\nRetrieved Character from Game Service:');
        print('Name: ${retrievedCharacter.name}');
        print('Ryo on hand: ${retrievedCharacter.ryoOnHand}');
        print('Inventory items: ${retrievedCharacter.inventory.length}');
        
        if (retrievedCharacter.inventory.isNotEmpty) {
          print('Inventory contents:');
          for (final item in retrievedCharacter.inventory) {
            print('  - ${item.name} (${item.rarity})');
          }
        }
      }
      
    } else {
      print('❌ Purchase failed!');
      print('Message: ${result.message}');
    }
  } else {
    print('No items available in shop');
  }
  
  print('\n=== Demo Complete ===');
}
