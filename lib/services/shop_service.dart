import '../models/models.dart';
import 'stub_data.dart';
import 'game_service.dart';
import 'equipment_service.dart';

class ShopService {
  // Singleton pattern
  static final ShopService _instance = ShopService._internal();
  factory ShopService() => _instance;
  ShopService._internal();

  final GameService _gameService = GameService();
  final EquipmentService _equipmentService = EquipmentService();

  // Get all available shop items
  List<Item> getAvailableItems() {
    return _shopItems.where((item) => item.isAvailableInShop).toList();
  }

  // Get items by category
  List<Item> getItemsByCategory(String category) {
    return _shopItems.where((item) => 
      item.isAvailableInShop && item.shopCategory == category
    ).toList();
  }

  // Get items by equipment slot
  List<Item> getItemsByEquipmentSlot(EquipmentSlot slot) {
    return _shopItems.where((item) => 
      item.isAvailableInShop && 
      item.equipmentSlot == slot &&
      item.type == ItemType.weapon || item.type == ItemType.armor
    ).toList();
  }

  // Get items by rarity
  List<Item> getItemsByRarity(String rarity) {
    return _shopItems.where((item) => 
      item.isAvailableInShop && 
      item.rarity.toLowerCase() == rarity.toLowerCase()
    ).toList();
  }

  // Get items within price range
  List<Item> getItemsByPriceRange(int minPrice, int maxPrice) {
    return _shopItems.where((item) => 
      item.isAvailableInShop && 
      item.buyPrice >= minPrice && 
      item.buyPrice <= maxPrice
    ).toList();
  }

  // Get items by level requirement
  List<Item> getItemsByLevel(int level) {
    return _shopItems.where((item) => 
      item.isAvailableInShop && 
      item.requiredLevel <= level
    ).toList();
  }

  // Check if character can afford item
  bool canAffordItem(Character character, Item item) {
    return character.ryoOnHand >= item.buyPrice;
  }

  // Check if character can use item
  bool canUseItem(Character character, Item item) {
    return item.canUse(character);
  }
  
  // Purchase an item - actually execute the purchase
  Future<ShopPurchaseResult> purchaseItem(Character character, Item item) async {
    // Check if character can afford the item
    if (!canAffordItem(character, item)) {
      return ShopPurchaseResult(
        success: false,
        message: 'Insufficient ryo. You need ${item.buyPrice} ryo but have ${character.ryoOnHand} ryo.',
      );
    }
    
    // Check if character can use the item
    if (!canUseItem(character, item)) {
      return ShopPurchaseResult(
        success: false,
        message: 'You do not meet the requirements to use this item.',
      );
    }
    
    // Check if item is available in shop
    if (!item.isAvailableInShop) {
      return ShopPurchaseResult(
        success: false,
        message: 'This item is not available for purchase.',
      );
    }
    
    try {
      // Create a copy of the item for the character's inventory
      final purchasedItem = item.copyWith(
        id: '${item.id}_${DateTime.now().millisecondsSinceEpoch}',
      );
      
      // Update character: add item to inventory and deduct ryo
      final updatedCharacter = character.copyWith(
        inventory: [...character.inventory, purchasedItem],
        ryoOnHand: character.ryoOnHand - item.buyPrice,
      );
      
      // Save the updated character
      await _gameService.saveCharacter(updatedCharacter);
      
      return ShopPurchaseResult(
        success: true,
        message: 'Successfully purchased ${item.name} for ${item.buyPrice} ryo! Item added to inventory.',
        updatedCharacter: updatedCharacter,
        purchasedItem: purchasedItem,
      );
    } catch (e) {
      return ShopPurchaseResult(
        success: false,
        message: 'Purchase failed: $e',
      );
    }
  }

  // Purchase and equip an item
  Future<ShopPurchaseResult> purchaseAndEquipItem(Character character, Item item) async {
    // First purchase the item
    final purchaseResult = await purchaseItem(character, item);
    
    if (!purchaseResult.success) {
      return purchaseResult;
    }
    
    // If purchase was successful and item is equippable, try to equip it
    if (item.equipmentSlot != null && purchaseResult.updatedCharacter != null) {
      final equipResult = await _equipmentService.equipItem(
        purchaseResult.updatedCharacter!, 
        purchaseResult.purchasedItem!
      );
      
      if (equipResult.success) {
        return ShopPurchaseResult(
          success: true,
          message: '${purchaseResult.message} ${equipResult.message}',
          updatedCharacter: equipResult.updatedCharacter,
          purchasedItem: purchaseResult.purchasedItem,
        );
      } else {
        // Purchase succeeded but equip failed - item is still in inventory
        return ShopPurchaseResult(
          success: true,
          message: '${purchaseResult.message} Failed to equip: ${equipResult.message}',
          updatedCharacter: purchaseResult.updatedCharacter,
          purchasedItem: purchaseResult.purchasedItem,
        );
      }
    }
    
    return purchaseResult;
  }

  // Get filtered items based on multiple criteria
  List<Item> getFilteredItems({
    String? category,
    EquipmentSlot? equipmentSlot,
    String? rarity,
    int? maxPrice,
    int? maxLevel,
    String? searchTerm,
  }) {
    var items = _shopItems.where((item) => item.isAvailableInShop);

    if (category != null) {
      items = items.where((item) => item.shopCategory == category);
    }

    if (equipmentSlot != null) {
      items = items.where((item) => item.equipmentSlot == equipmentSlot);
    }

    if (rarity != null) {
      items = items.where((item) => 
        item.rarity.toLowerCase() == rarity.toLowerCase()
      );
    }

    if (maxPrice != null) {
      items = items.where((item) => item.buyPrice <= maxPrice);
    }

    if (maxLevel != null) {
      items = items.where((item) => item.requiredLevel <= maxLevel);
    }

    if (searchTerm != null && searchTerm.isNotEmpty) {
      items = items.where((item) => 
        item.name.toLowerCase().contains(searchTerm.toLowerCase()) ||
        item.description.toLowerCase().contains(searchTerm.toLowerCase()) ||
        item.tags.any((tag) => tag.toLowerCase().contains(searchTerm.toLowerCase()))
      );
    }

    return items.toList();
  }

  // Shop items database
  final List<Item> _shopItems = StubDataService().sampleItems;
}

// Result class for shop purchases
class ShopPurchaseResult {
  final bool success;
  final String message;
  final Character? updatedCharacter;
  final Item? purchasedItem;

  const ShopPurchaseResult({
    required this.success,
    required this.message,
    this.updatedCharacter,
    this.purchasedItem,
  });
}
