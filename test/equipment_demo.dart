import 'package:flutter/material.dart';
import '../lib/models/models.dart';
import '../lib/services/services.dart';

class EquipmentDemo extends StatefulWidget {
  const EquipmentDemo({Key? key}) : super(key: key);

  @override
  State<EquipmentDemo> createState() => _EquipmentDemoState();
}

class _EquipmentDemoState extends State<EquipmentDemo> {
  final ShopService _shopService = ShopService();
  final EquipmentService _equipmentService = EquipmentService();
  Character? _character;
  List<Item> _availableItems = [];
  String _message = '';

  @override
  void initState() {
    super.initState();
    _loadDemoData();
  }

  void _loadDemoData() {
    // Load sample character and items
    final stubData = StubDataService();
    _character = stubData.sampleCharacters.first;
    _availableItems = stubData.sampleItems.where((item) => 
      item.isAvailableInShop && item.equipmentSlot != null
    ).toList();
    setState(() {});
  }

  Future<void> _purchaseItem(Item item) async {
    if (_character == null) return;

    final result = await _shopService.purchaseItem(_character!, item);
    
    setState(() {
      _message = result.message;
      if (result.success && result.updatedCharacter != null) {
        _character = result.updatedCharacter;
      }
    });
  }

  Future<void> _purchaseAndEquipItem(Item item) async {
    if (_character == null) return;

    final result = await _shopService.purchaseAndEquipItem(_character!, item);
    
    setState(() {
      _message = result.message;
      if (result.success && result.updatedCharacter != null) {
        _character = result.updatedCharacter;
      }
    });
  }

  Future<void> _equipItem(Item item) async {
    if (_character == null) return;

    final result = await _equipmentService.equipItem(_character!, item);
    
    setState(() {
      _message = result.message;
      if (result.success && result.updatedCharacter != null) {
        _character = result.updatedCharacter;
      }
    });
  }

  Future<void> _unequipItem(EquipmentSlot slot) async {
    if (_character == null) return;

    final result = await _equipmentService.unequipItem(_character!, slot);
    
    setState(() {
      _message = result.message;
      if (result.success && result.updatedCharacter != null) {
        _character = result.updatedCharacter;
      }
    });
  }

  Widget _buildItemCard(Item item) {
    final canAfford = _character != null && _shopService.canAffordItem(_character!, item);
    final canUse = _character != null && _shopService.canUseItem(_character!, item);
    final isEquipped = _character != null && _equipmentService.isItemEquipped(_character!, item);

    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    item.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: item.rarityColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    item.rarity,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              item.description,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            Text(
              'Slot: ${item.equipmentSlot?.name ?? 'None'}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            Text(
              'Price: ${item.buyPrice} ryo',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            if (item.statBonuses.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                'Stats: ${item.statBonuses.entries.map((e) => '${e.key}: +${e.value}').join(', ')}',
                style: const TextStyle(fontSize: 12, color: Colors.blue),
              ),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: canAfford && canUse ? () => _purchaseItem(item) : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: const Text('Buy'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: canAfford && canUse ? () => _purchaseAndEquipItem(item) : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: const Text('Buy & Equip'),
                  ),
                ),
              ],
            ),
            if (isEquipped) ...[
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  border: Border.all(color: Colors.green),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'EQUIPPED',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
            if (!canAfford) ...[
              const SizedBox(height: 8),
              const Text(
                'Cannot afford',
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            ],
            if (!canUse) ...[
              const SizedBox(height: 8),
              const Text(
                'Cannot use',
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEquipmentSection() {
    if (_character == null) return const SizedBox.shrink();

    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Equipped Items',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...EquipmentSlot.values.map((slot) {
              final equippedItem = _equipmentService.getEquippedItem(_character!, slot);
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    SizedBox(
                      width: 100,
                      child: Text(
                        '${slot.name}:',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        equippedItem?.name ?? 'None',
                        style: TextStyle(
                          color: equippedItem != null ? Colors.green : Colors.grey,
                        ),
                      ),
                    ),
                    if (equippedItem != null)
                      ElevatedButton(
                        onPressed: () => _unequipItem(slot),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        ),
                        child: const Text('Unequip'),
                      ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildCharacterInfo() {
    if (_character == null) return const SizedBox.shrink();

    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Character: ${_character!.name}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text('Level: ${_character!.level}'),
            Text('Ryo: ${_character!.ryoOnHand}'),
            Text('Inventory Items: ${_character!.inventory.length}'),
            const SizedBox(height: 8),
            const Text(
              'Stats:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('Strength: ${_character!.strength}'),
            Text('Intelligence: ${_character!.intelligence}'),
            Text('Speed: ${_character!.speed}'),
            Text('Defense: ${_character!.defense}'),
            Text('Willpower: ${_character!.willpower}'),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Equipment System Demo'),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildCharacterInfo(),
            _buildEquipmentSection(),
            if (_message.isNotEmpty)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(8.0),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(_message),
              ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Available Items',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            ..._availableItems.map(_buildItemCard).toList(),
          ],
        ),
      ),
    );
  }
}
