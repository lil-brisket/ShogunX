import '../models/models.dart';
import 'game_service.dart';

class EquipmentService {
  // Singleton pattern
  static final EquipmentService _instance = EquipmentService._internal();
  factory EquipmentService() => _instance;
  EquipmentService._internal();

  final GameService _gameService = GameService();

  // Equip an item
  Future<EquipmentResult> equipItem(Character character, Item item) async {
    // Check if item is equippable
    if (item.equipmentSlot == null) {
      return EquipmentResult(
        success: false,
        message: 'This item cannot be equipped.',
      );
    }

    // Check if character can use the item
    if (!item.canUse(character)) {
      return EquipmentResult(
        success: false,
        message: 'You do not meet the requirements to equip this item.',
      );
    }

    // Check if item is in inventory
    if (!character.inventory.any((invItem) => invItem.id == item.id)) {
      return EquipmentResult(
        success: false,
        message: 'Item not found in inventory.',
      );
    }

    try {
      final slot = item.equipmentSlot!;
      final currentlyEquipped = character.equippedItems[slot];
      
      // Create new equipped items map
      final newEquippedItems = Map<EquipmentSlot, Item?>.from(character.equippedItems);
      
      // Unequip current item if any
      if (currentlyEquipped != null) {
        // Add currently equipped item back to inventory
        final updatedInventory = [...character.inventory];
        // Remove the item being equipped from inventory
        updatedInventory.removeWhere((invItem) => invItem.id == item.id);
        // Add the currently equipped item back to inventory
        updatedInventory.add(currentlyEquipped);
        
        // Update character
        final updatedCharacter = character.copyWith(
          inventory: updatedInventory,
          equippedItems: newEquippedItems..[slot] = item,
        );
        
        await _gameService.saveCharacter(updatedCharacter);
        
        return EquipmentResult(
          success: true,
          message: 'Equipped ${item.name} and unequipped ${currentlyEquipped.name}.',
          updatedCharacter: updatedCharacter,
          equippedItem: item,
          unequippedItem: currentlyEquipped,
        );
      } else {
        // No item currently equipped in this slot
        final updatedInventory = [...character.inventory];
        updatedInventory.removeWhere((invItem) => invItem.id == item.id);
        
        final updatedCharacter = character.copyWith(
          inventory: updatedInventory,
          equippedItems: newEquippedItems..[slot] = item,
        );
        
        await _gameService.saveCharacter(updatedCharacter);
        
        return EquipmentResult(
          success: true,
          message: 'Equipped ${item.name}.',
          updatedCharacter: updatedCharacter,
          equippedItem: item,
        );
      }
    } catch (e) {
      return EquipmentResult(
        success: false,
        message: 'Failed to equip item: $e',
      );
    }
  }

  // Unequip an item
  Future<EquipmentResult> unequipItem(Character character, EquipmentSlot slot) async {
    final equippedItem = character.equippedItems[slot];
    
    if (equippedItem == null) {
      return EquipmentResult(
        success: false,
        message: 'No item equipped in this slot.',
      );
    }

    try {
      final newEquippedItems = Map<EquipmentSlot, Item?>.from(character.equippedItems);
      newEquippedItems[slot] = null;
      
      final updatedInventory = [...character.inventory, equippedItem];
      
      final updatedCharacter = character.copyWith(
        inventory: updatedInventory,
        equippedItems: newEquippedItems,
      );
      
      await _gameService.saveCharacter(updatedCharacter);
      
      return EquipmentResult(
        success: true,
        message: 'Unequipped ${equippedItem.name}.',
        updatedCharacter: updatedCharacter,
        unequippedItem: equippedItem,
      );
    } catch (e) {
      return EquipmentResult(
        success: false,
        message: 'Failed to unequip item: $e',
      );
    }
  }

  // Get equipped item in a specific slot
  Item? getEquippedItem(Character character, EquipmentSlot slot) {
    return character.equippedItems[slot];
  }

  // Get all equipped items
  Map<EquipmentSlot, Item?> getAllEquippedItems(Character character) {
    return character.equippedItems;
  }

  // Check if an item is equipped
  bool isItemEquipped(Character character, Item item) {
    if (item.equipmentSlot == null) return false;
    final equippedItem = character.equippedItems[item.equipmentSlot];
    return equippedItem?.id == item.id;
  }

  // Get total stat bonuses from equipped items
  Map<String, int> getEquippedStatBonuses(Character character) {
    final bonuses = <String, int>{};
    
    for (final item in character.equippedItems.values) {
      if (item != null) {
        for (final entry in item.statBonuses.entries) {
          bonuses[entry.key] = (bonuses[entry.key] ?? 0) + entry.value;
        }
      }
    }
    
    return bonuses;
  }

  // Get total stat multipliers from equipped items
  Map<String, double> getEquippedStatMultipliers(Character character) {
    final multipliers = <String, double>{};
    
    for (final item in character.equippedItems.values) {
      if (item != null) {
        for (final entry in item.statMultipliers.entries) {
          multipliers[entry.key] = (multipliers[entry.key] ?? 1.0) * entry.value;
        }
      }
    }
    
    return multipliers;
  }

  // Get all special effects from equipped items
  List<String> getEquippedSpecialEffects(Character character) {
    final effects = <String>[];
    
    for (final item in character.equippedItems.values) {
      if (item != null) {
        effects.addAll(item.specialEffects);
      }
    }
    
    return effects;
  }
}

// Result class for equipment operations
class EquipmentResult {
  final bool success;
  final String message;
  final Character? updatedCharacter;
  final Item? equippedItem;
  final Item? unequippedItem;

  const EquipmentResult({
    required this.success,
    required this.message,
    this.updatedCharacter,
    this.equippedItem,
    this.unequippedItem,
  });
}
