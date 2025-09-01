import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/models.dart';
import '../../providers/providers.dart';
import '../../widgets/logout_button.dart';

class LoadoutScreen extends ConsumerStatefulWidget {
  const LoadoutScreen({super.key});

  @override
  ConsumerState<LoadoutScreen> createState() => _LoadoutScreenState();
}

class _LoadoutScreenState extends ConsumerState<LoadoutScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      ref.read(selectedLoadoutTabProvider.notifier).state = _tabController.index;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedTab = ref.watch(selectedLoadoutTabProvider);
    
    _tabController.index = selectedTab;
    
    return Scaffold(
      backgroundColor: const Color(0xFF0f3460),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1a1a2e),
                border: Border(
                  bottom: BorderSide(
                    color: Colors.deepOrange.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.inventory,
                    color: Colors.deepOrange,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Loadout',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Manage your equipment and jutsus',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const LogoutButton(),
                ],
              ),
            ),
            
            // Tab Bar
            Container(
              color: const Color(0xFF16213e),
              child: TabBar(
                controller: _tabController,
                indicatorColor: Colors.deepOrange,
                labelColor: Colors.deepOrange,
                unselectedLabelColor: Colors.white.withValues(alpha: 0.6),
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 14,
                ),
                tabs: const [
                  Tab(text: 'Equipment'),
                  Tab(text: 'Jutsus'),
                  Tab(text: 'Presets'),
                ],
              ),
            ),
            
            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildEquipmentTab(),
                  _buildJutsusTab(),
                  _buildPresetsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEquipmentTab() {
    final currentCharacter = ref.watch(gameStateProvider).selectedCharacter;
    
    if (currentCharacter == null) {
      return const Center(
        child: Text(
          'No character selected',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      );
    }
    
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Equipment Slots
          Expanded(
            child: ListView(
              children: [
                _buildEquipmentSlot('Head', Icons.face, _getEquippedItem(currentCharacter, EquipmentSlot.head)),
                _buildEquipmentSlot('Arms', Icons.accessibility, _getEquippedItem(currentCharacter, EquipmentSlot.arms)),
                _buildEquipmentSlot('Body', Icons.person, _getEquippedItem(currentCharacter, EquipmentSlot.body)),
                _buildEquipmentSlot('Legs', Icons.directions_walk, _getEquippedItem(currentCharacter, EquipmentSlot.legs)),
                _buildEquipmentSlot('Feet', Icons.directions_run, _getEquippedItem(currentCharacter, EquipmentSlot.feet)),
                _buildEquipmentSlot('Weapon', Icons.gps_fixed, _getEquippedItem(currentCharacter, EquipmentSlot.weapon)),
                
                const SizedBox(height: 20),
                
                // Stat Bonuses Section
                _buildStatBonusesSection(currentCharacter),
                
                const SizedBox(height: 20),
                
                // Inventory Section
                _buildInventorySection(currentCharacter),
              ],
            ),
          ),
          
          // Equipment Actions
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF16213e),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.deepOrange.withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              children: [
                _buildEquipmentAction(
                  'Repair All Equipment',
                  'Fix durability of all items',
                  Icons.build,
                  Colors.blue,
                  () {
                    // TODO: Implement repair all
                  },
                ),
                
                const SizedBox(height: 12),
                
                _buildEquipmentAction(
                  'Upgrade Equipment',
                  'Enhance your gear',
                  Icons.trending_up,
                  Colors.green,
                  () {
                    // TODO: Implement upgrade
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJutsusTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Active Jutsus
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF16213e),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.deepOrange.withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Active Jutsus (7 slots)',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Jutsu slots grid
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 1,
                  ),
                  itemCount: 7,
                  itemBuilder: (context, index) {
                    return _buildJutsuSlot(index);
                  },
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Available Jutsus
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF16213e),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.deepOrange.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Available Jutsus',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  Expanded(
                    child: ListView.builder(
                      itemCount: 5, // TODO: Get from actual jutsu data
                      itemBuilder: (context, index) {
                        return _buildJutsuItem('Jutsu ${index + 1}', 'Description for jutsu ${index + 1}');
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPresetsTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Preset List
          Expanded(
            child: ListView(
              children: [
                _buildPresetCard('PvP Loadout', 'Optimized for player battles', Icons.sports_kabaddi),
                _buildPresetCard('PvE Loadout', 'Optimized for missions', Icons.assignment),
                _buildPresetCard('Training Loadout', 'Focused on stat growth', Icons.fitness_center),
                _buildPresetCard('Defensive Loadout', 'High survivability', Icons.shield),
              ],
            ),
          ),
          
          // Save Current Loadout
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF16213e),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.deepOrange.withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              children: [
                Text(
                  'Save Current Loadout',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                
                TextField(
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Enter preset name...',
                    hintStyle: TextStyle(
                      color: Colors.grey.withValues(alpha: 0.3),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Colors.deepOrange.withValues(alpha: 0.5),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: Colors.deepOrange,
                        width: 2,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 12),
                
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Implement save preset
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Save Preset'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Item? _getEquippedItem(Character character, EquipmentSlot slot) {
    // Get equipped item from the equippedItems map
    return character.equippedItems[slot];
  }

  Widget _buildStatBonusesSection(Character character) {
    final equipmentNotifier = ref.read(equipmentProvider.notifier);
    final statBonuses = equipmentNotifier.calculateStatBonuses(character);
    
    if (statBonuses.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF16213e),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.deepOrange.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.trending_up,
              color: Colors.deepOrange,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Equipment Bonuses',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Text(
              'No bonuses',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.5),
                fontSize: 14,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      );
    }
    
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF16213e),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.deepOrange.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.deepOrange.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.trending_up,
                  color: Colors.deepOrange,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Equipment Bonuses',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: statBonuses.entries.map((entry) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.green.withValues(alpha: 0.5)),
                ),
                child: Text(
                  '+${entry.value} ${entry.key}',
                  style: const TextStyle(
                    color: Colors.green,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInventorySection(Character character) {
    final inventory = character.inventory;
    
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF16213e),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.deepOrange.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.deepOrange.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.inventory_2,
                  color: Colors.deepOrange,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Inventory (${inventory.length} items)',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          
          if (inventory.isEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.inventory_2,
                      color: Colors.white.withValues(alpha: 0.5),
                      size: 48,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your inventory is empty',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Visit the Item Shop to purchase equipment',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.5),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: inventory.map((item) => _buildInventoryItemCard(item)).toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInventoryItemCard(Item item) {
    final currentCharacter = ref.watch(gameStateProvider).selectedCharacter;
    if (currentCharacter == null) return const SizedBox.shrink();
    
    final equipmentNotifier = ref.read(equipmentProvider.notifier);
    final isEquipped = item.equipmentSlot != null && 
                      currentCharacter.equippedItems[item.equipmentSlot!] == item;
    
    return InkWell(
      onTap: item.equipmentSlot != null ? () async {
        if (isEquipped) {
          // Unequip the item
          final result = await equipmentNotifier.unequipItem(currentCharacter, item.equipmentSlot!);
          if (result.success && result.updatedCharacter != null) {
            // Update the game state
            ref.read(gameStateProvider.notifier).updateCharacter(result.updatedCharacter!);
            
            // Check if widget is still mounted before using context
            if (!mounted) return;
            
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(result.message)),
            );
          } else {
            // Check if widget is still mounted before using context
            if (!mounted) return;
            
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(result.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        } else {
          // Equip the item
          final result = await equipmentNotifier.equipItem(currentCharacter, item);
          if (result.success && result.updatedCharacter != null) {
            // Update the game state
            ref.read(gameStateProvider.notifier).updateCharacter(result.updatedCharacter!);
            
            // Check if widget is still mounted before using context
            if (!mounted) return;
            
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(result.message)),
            );
          } else {
            // Check if widget is still mounted before using context
            if (!mounted) return;
            
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(result.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      } : null,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isEquipped 
            ? Colors.green.withValues(alpha:0.1)
            : const Color(0xFF1a1a2e),
          borderRadius: BorderRadius.circular(8),
                      border: Border.all(
              color: isEquipped 
                ? Colors.green.withValues(alpha:0.8)
                : item.rarityColor.withValues(alpha:0.3),
              width: isEquipped ? 2 : 1,
            ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: item.rarityColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(item.typeIcon, color: item.rarityColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        item.name,
                        style: TextStyle(
                          color: item.rarityColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        child: Text(
                          item.rarity,
                          style: TextStyle(
                            color: item.rarityColor,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (item.statBonuses.isNotEmpty)
                    Text(
                      'Stats: ${item.statBonuses.entries.map((e) => '+${e.value} ${e.key}').join(', ')}',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
            ),
            if (item.equipmentSlot != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isEquipped 
                    ? Colors.red.withValues(alpha: 0.2)
                    : Colors.green.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isEquipped 
                      ? Colors.red.withValues(alpha: 0.5)
                      : Colors.green.withValues(alpha: 0.5)
                  ),
                ),
                child: Text(
                  isEquipped ? 'Unequip' : 'Equip ${item.equipmentSlot!.name}',
                  style: TextStyle(
                    color: isEquipped ? Colors.red : Colors.green,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEquipmentSlot(String slotName, IconData icon, Item? equippedItem) {
    final currentCharacter = ref.watch(gameStateProvider).selectedCharacter;
    if (currentCharacter == null) return const SizedBox.shrink();
    
    final equipmentSlot = _getSlotFromName(slotName);
    
    return InkWell(
      onTap: () => _showEquipmentOptions(context, currentCharacter, equipmentSlot, equippedItem),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF16213e),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: equippedItem != null 
              ? equippedItem.rarityColor.withValues(alpha: 0.5)
              : Colors.white.withValues(alpha: 0.2),
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: equippedItem != null 
                  ? equippedItem.rarityColor.withValues(alpha: 0.2)
                  : Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                equippedItem?.typeIcon ?? icon,
                color: equippedItem?.rarityColor ?? Colors.white.withValues(alpha: 0.5),
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    slotName,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (equippedItem != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      equippedItem.name,
                      style: TextStyle(
                        color: equippedItem.rarityColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (equippedItem.statBonuses.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Stats: ${equippedItem.statBonuses.entries.map((e) => '+${e.value} ${e.key}').join(', ')}',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ] else ...[
                    const SizedBox(height: 4),
                    Text(
                      'Empty',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.5),
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (equippedItem != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: equippedItem.rarityColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: equippedItem.rarityColor.withValues(alpha: 0.5)),
                ),
                child: Text(
                  equippedItem.rarity,
                  style: TextStyle(
                    color: equippedItem.rarityColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Helper method to convert slot name to EquipmentSlot enum
  EquipmentSlot _getSlotFromName(String slotName) {
    switch (slotName.toLowerCase()) {
      case 'head':
        return EquipmentSlot.head;
      case 'arms':
        return EquipmentSlot.arms;
      case 'body':
        return EquipmentSlot.body;
      case 'legs':
        return EquipmentSlot.legs;
      case 'feet':
        return EquipmentSlot.feet;
      case 'weapon':
        return EquipmentSlot.weapon;
      default:
        return EquipmentSlot.weapon;
    }
  }

  // Show equipment options dialog
  void _showEquipmentOptions(BuildContext context, Character character, EquipmentSlot slot, Item? equippedItem) {
    final equipmentNotifier = ref.read(equipmentProvider.notifier);
    final equippableItems = equipmentNotifier.getEquippableItemsForSlot(character, slot);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF16213e),
        title: Text(
          '${slot.name.toUpperCase()} Slot',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (equippedItem != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1a1a2e),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: equippedItem.rarityColor.withValues(alpha: 0.5)),
                  ),
                  child: Row(
                    children: [
                      Icon(equippedItem.typeIcon, color: equippedItem.rarityColor, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              equippedItem.name,
                              style: TextStyle(
                                color: equippedItem.rarityColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (equippedItem.statBonuses.isNotEmpty)
                              Text(
                                'Stats: ${equippedItem.statBonuses.entries.map((e) => '+${e.value} ${e.key}').join(', ')}',
                                style: const TextStyle(color: Colors.white70, fontSize: 12),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                                            Navigator.of(context).pop();
                      final result = await equipmentNotifier.unequipItem(character, slot);
                      if (result.success && result.updatedCharacter != null) {
                        // Update the game state
                        ref.read(gameStateProvider.notifier).updateCharacter(result.updatedCharacter!);
                        
                        // Check if widget is still mounted before using context
                        if (!mounted) return;
                        
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(result.message)),
                        );
                      } else {
                        // Check if widget is still mounted before using context
                        if (!mounted) return;
                        
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(result.message),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Unequip'),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              if (equippableItems.isNotEmpty) ...[
                Text(
                  'Available Items:',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...equippableItems.map((item) => Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: InkWell(
                    onTap: () async {
                      Navigator.of(context).pop();
                      final result = await equipmentNotifier.equipItem(character, item);
                      if (result.success && result.updatedCharacter != null) {
                        // Update the game state
                        ref.read(gameStateProvider.notifier).updateCharacter(result.updatedCharacter!);
                        
                        // Check if widget is still mounted before using context
                        if (!mounted) return;
                        
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(result.message)),
                        );
                      } else {
                        // Check if widget is still mounted before using context
                        if (!mounted) return;
                        
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(result.message),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1a1a2e),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: item.rarityColor.withValues(alpha: 0.5)),
                      ),
                      child: Row(
                        children: [
                          Icon(item.typeIcon, color: item.rarityColor, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name,
                                  style: TextStyle(
                                    color: item.rarityColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (item.statBonuses.isNotEmpty)
                                  Text(
                                    'Stats: ${item.statBonuses.entries.map((e) => '+${e.value} ${e.key}').join(', ')}',
                                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                                  ),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16),
                        ],
                      ),
                    ),
                  ),
                )),
              ] else ...[
                const Text(
                  'No equippable items available',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close', style: TextStyle(color: Colors.deepOrange)),
          ),
        ],
      ),
    );
  }

  Widget _buildEquipmentAction(String title, String description, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    description,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJutsuSlot(int index) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1a1a2e),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey.withValues(alpha: 0.3),
        ),
      ),
      child: Center(
        child: Text(
          '${index + 1}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildJutsuItem(String name, String description) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1a1a2e),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.deepOrange.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.flash_on, color: Colors.deepOrange, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.add_circle_outline,
            color: Colors.deepOrange,
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildPresetCard(String name, String description, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF16213e),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.deepOrange.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.deepOrange, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  // TODO: Load preset
                },
                icon: const Icon(Icons.download, color: Colors.blue),
              ),
              IconButton(
                onPressed: () {
                  // TODO: Delete preset
                },
                icon: const Icon(Icons.delete, color: Colors.red),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
