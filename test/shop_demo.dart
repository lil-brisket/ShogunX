import 'package:ninja_world_mmo/services/shop_service.dart';
import 'package:ninja_world_mmo/services/game_service.dart';
import 'package:ninja_world_mmo/models/models.dart';

void main() async {
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
  // Get available items from shop
  final availableItems = shopService.getAvailableItems();
  if (availableItems.isNotEmpty) {
    final firstItem = availableItems.first;
    print('First item: ${firstItem.name} (${firstItem.buyPrice} ryo)');
    // Attempt to purchase the item
    final result = await shopService.purchaseItem(character, firstItem);
    
    if (result.success) {
      final updatedCharacter = result.updatedCharacter!;
      if (updatedCharacter.inventory.isNotEmpty) {
        for (final item in updatedCharacter.inventory) {
          print('  - ${item.name} (${item.rarity})');
        }
      }
      
      // Save the character to game service
      await gameService.saveCharacter(updatedCharacter);
      // Retrieve the character to verify persistence
      final retrievedCharacter = await gameService.getCharacter(updatedCharacter.id);
      if (retrievedCharacter != null) {
        if (retrievedCharacter.inventory.isNotEmpty) {
          for (final item in retrievedCharacter.inventory) {
            print('  - ${item.name} (${item.rarity})');
          }
        }
      }
      
    } else {
    }
  } else {
  }
}
