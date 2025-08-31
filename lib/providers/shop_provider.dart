import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/shop_service.dart';

class ShopProvider extends ChangeNotifier {
  final ShopService _shopService = ShopService();
  
  // Shop state
  List<Item> _availableItems = [];
  List<Item> _filteredItems = [];
  String _selectedCategory = 'all';
  EquipmentSlot? _selectedEquipmentSlot;
  String _selectedRarity = 'all';
  int? _maxPrice;
  int? _maxLevel;
  String _searchTerm = '';
  
  // Getters
  List<Item> get availableItems => _availableItems;
  List<Item> get filteredItems => _filteredItems;
  String get selectedCategory => _selectedCategory;
  EquipmentSlot? get selectedEquipmentSlot => _selectedEquipmentSlot;
  String get selectedRarity => _selectedRarity;
  int? get maxPrice => _maxPrice;
  int? get maxLevel => _maxLevel;
  String get searchTerm => _searchTerm;
  
  // Initialize shop
  void initializeShop() {
    _availableItems = _shopService.getAvailableItems();
    _applyFilters();
    notifyListeners();
  }
  
  // Filter methods
  void setCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
    notifyListeners();
  }
  
  void setEquipmentSlot(EquipmentSlot? slot) {
    _selectedEquipmentSlot = slot;
    _applyFilters();
    notifyListeners();
  }
  
  void setRarity(String rarity) {
    _selectedRarity = rarity;
    _applyFilters();
    notifyListeners();
  }
  
  void setMaxPrice(int? price) {
    _maxPrice = price;
    _applyFilters();
    notifyListeners();
  }
  
  void setMaxLevel(int? level) {
    _maxLevel = level;
    _applyFilters();
    notifyListeners();
  }
  
  void setSearchTerm(String term) {
    _searchTerm = term;
    _applyFilters();
    notifyListeners();
  }
  
  void clearFilters() {
    _selectedCategory = 'all';
    _selectedEquipmentSlot = null;
    _selectedRarity = 'all';
    _maxPrice = null;
    _maxLevel = null;
    _searchTerm = '';
    _applyFilters();
    notifyListeners();
  }
  
  // Apply all active filters
  void _applyFilters() {
    String? category = _selectedCategory == 'all' ? null : _selectedCategory;
    String? rarity = _selectedRarity == 'all' ? null : _selectedRarity;
    
    _filteredItems = _shopService.getFilteredItems(
      category: category,
      equipmentSlot: _selectedEquipmentSlot,
      rarity: rarity,
      maxPrice: _maxPrice,
      maxLevel: _maxLevel,
      searchTerm: _searchTerm.isEmpty ? null : _searchTerm,
    );
  }
  
  // Get items by equipment slot
  List<Item> getItemsByEquipmentSlot(EquipmentSlot slot) {
    return _shopService.getItemsByEquipmentSlot(slot);
  }
  
  // Get items by category
  List<Item> getItemsByCategory(String category) {
    return _shopService.getItemsByCategory(category);
  }
  
  // Get items by rarity
  List<Item> getItemsByRarity(String rarity) {
    return _shopService.getItemsByRarity(rarity);
  }
  
  // Check if character can afford item
  bool canAffordItem(Character character, Item item) {
    return _shopService.canAffordItem(character, item);
  }
  
  // Check if character can use item
  bool canUseItem(Character character, Item item) {
    return _shopService.canUseItem(character, item);
  }
  
  // Purchase an item - now actually executes the purchase
  Future<ShopPurchaseResult> purchaseItem(Character character, Item item) async {
    return await _shopService.purchaseItem(character, item);
  }
  
  // Get available categories
  List<String> getAvailableCategories() {
    final categories = _availableItems
        .map((item) => item.shopCategory)
        .where((category) => category != null)
        .map((category) => category!)
        .toSet()
        .toList();
    categories.sort();
    return ['all', ...categories];
  }
  
  // Get available rarities
  List<String> getAvailableRarities() {
    final rarities = _availableItems
        .map((item) => item.rarity)
        .toSet()
        .toList();
    rarities.sort();
    return ['all', ...rarities];
  }
  
  // Get price range
  Map<String, int> getPriceRange() {
    if (_availableItems.isEmpty) return {'min': 0, 'max': 0};
    
    final prices = _availableItems.map((item) => item.buyPrice).toList();
    return {
      'min': prices.reduce((a, b) => a < b ? a : b),
      'max': prices.reduce((a, b) => a > b ? a : b),
    };
  }
  
  // Get level range
  Map<String, int> getLevelRange() {
    if (_availableItems.isEmpty) return {'min': 0, 'max': 0};
    
    final levels = _availableItems.map((item) => item.requiredLevel).toList();
    return {
      'min': levels.reduce((a, b) => a < b ? a : b),
      'max': levels.reduce((a, b) => a > b ? a : b),
    };
  }
}
