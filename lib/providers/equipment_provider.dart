import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../services/services.dart';

class EquipmentNotifier extends StateNotifier<AsyncValue<void>> {
  final EquipmentService _equipmentService = EquipmentService();
  final GameService _gameService = GameService();

  EquipmentNotifier() : super(const AsyncValue.data(null));

  // Equip an item
  Future<EquipmentResult> equipItem(Character character, Item item) async {
    state = const AsyncValue.loading();
    
    try {
      final result = await _equipmentService.equipItem(character, item);
      
      if (result.success && result.updatedCharacter != null) {
        // Update the character in the game state
        await _gameService.saveCharacter(result.updatedCharacter!);
      }
      
      state = const AsyncValue.data(null);
      return result;
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      return EquipmentResult(
        success: false,
        message: 'Failed to equip item: $error',
      );
    }
  }

  // Unequip an item
  Future<EquipmentResult> unequipItem(Character character, EquipmentSlot slot) async {
    state = const AsyncValue.loading();
    
    try {
      final result = await _equipmentService.unequipItem(character, slot);
      
      if (result.success && result.updatedCharacter != null) {
        // Update the character in the game state
        await _gameService.saveCharacter(result.updatedCharacter!);
      }
      
      state = const AsyncValue.data(null);
      return result;
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      return EquipmentResult(
        success: false,
        message: 'Failed to unequip item: $error',
      );
    }
  }

  // Get equipped items for a character
  Map<EquipmentSlot, Item?> getEquippedItems(Character character) {
    return character.equippedItems;
  }

  // Get items that can be equipped in a specific slot
  List<Item> getEquippableItemsForSlot(Character character, EquipmentSlot slot) {
    return character.inventory.where((item) => 
      item.equipmentSlot == slot && item.canUse(character)
    ).toList();
  }

  // Calculate total stat bonuses from equipped items
  Map<String, int> calculateStatBonuses(Character character) {
    return _equipmentService.getEquippedStatBonuses(character);
  }
}

final equipmentProvider = StateNotifierProvider<EquipmentNotifier, AsyncValue<void>>((ref) {
  return EquipmentNotifier();
});
