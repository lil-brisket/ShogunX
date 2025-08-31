import 'package:flutter/material.dart';

enum ItemType { weapon, armor, consumable, material, cosmetic }
enum EquipmentSlot { head, arms, body, legs, feet, weapon }

class Item {
  final String id;
  final String name;
  final String description;
  final ItemType type;
  final EquipmentSlot? equipmentSlot; // null for non-equipment items
  
  // Stats and effects
  final Map<String, int> statBonuses; // stat -> bonus value
  final Map<String, double> statMultipliers; // stat -> multiplier
  final List<String> specialEffects; // special abilities, buffs
  
  // Equipment properties
  final int? durability;
  final int? maxDurability;
  final bool isRepairable;
  final bool isTradeable;
  final bool isDroppable;
  
  // Shop and economy
  final int buyPrice;
  final int sellPrice;
  final String? shopCategory;
  final bool isAvailableInShop;
  
  // Requirements
  final int requiredLevel;
  final Map<String, int> statRequirements;
  final List<String> requiredElements;
  final String? requiredBloodline;
  
  // UI and display
  final String iconPath;
  final List<String> tags;
  final bool isActive;
  final String rarity; // Common, Uncommon, Rare, Epic, Legendary

  Item({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    this.equipmentSlot,
    required this.statBonuses,
    required this.statMultipliers,
    required this.specialEffects,
    this.durability,
    this.maxDurability,
    required this.isRepairable,
    required this.isTradeable,
    required this.isDroppable,
    required this.buyPrice,
    required this.sellPrice,
    this.shopCategory,
    required this.isAvailableInShop,
    required this.requiredLevel,
    required this.statRequirements,
    required this.requiredElements,
    this.requiredBloodline,
    required this.iconPath,
    required this.tags,
    required this.isActive,
    required this.rarity,
  });

  // Check if character can equip/use this item
  bool canUse(dynamic character) {
    if (!isActive) return false;
    if (character.level < requiredLevel) return false;
    
    // Check stat requirements
    for (final entry in statRequirements.entries) {
      final statValue = _getStatValue(character, entry.key);
      if (statValue < entry.value) return false;
    }
    
    // Check element requirements
    if (requiredElements.isNotEmpty) {
      final hasRequiredElement = requiredElements.any(
        (element) => character.elements.contains(element)
      );
      if (!hasRequiredElement) return false;
    }
    
    // Check bloodline requirement
    if (requiredBloodline != null && character.bloodline != requiredBloodline) {
      return false;
    }
    
    return true;
  }

  // Check if character can afford this item
  bool canAfford(dynamic character) {
    return character.ryoOnHand >= buyPrice;
  }

  // Get durability percentage
  double? get durabilityPercentage {
    if (durability == null || maxDurability == null) return null;
    return durability! / maxDurability!;
  }

  // Check if item needs repair
  bool get needsRepair {
    if (durability == null || maxDurability == null) return false;
    return durability! < maxDurability!;
  }

  int _getStatValue(dynamic character, String stat) {
    switch (stat) {
      case 'strength': return character.strength;
      case 'intelligence': return character.intelligence;
      case 'speed': return character.speed;
      case 'defense': return character.defense;
      case 'willpower': return character.willpower;
      case 'bukijutsu': return character.bukijutsu;
      case 'ninjutsu': return character.ninjutsu;
      case 'taijutsu': return character.taijutsu;
              case 'genjutsu': return character.genjutsu;
      default: return 0;
    }
  }

  // Get rarity color for UI
  Color get rarityColor {
    switch (rarity.toLowerCase()) {
      case 'common':
        return Colors.grey;
      case 'uncommon':
        return Colors.green;
      case 'rare':
        return Colors.blue;
      case 'epic':
        return Colors.purple;
      case 'legendary':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  // Get type icon for UI
  IconData get typeIcon {
    switch (type) {
      case ItemType.weapon:
        return Icons.gps_fixed;
      case ItemType.armor:
        return Icons.shield;
      case ItemType.consumable:
        return Icons.local_drink;
      case ItemType.material:
        return Icons.inventory;
      case ItemType.cosmetic:
        return Icons.face;
    }
  }

  Item copyWith({
    String? id,
    String? name,
    String? description,
    ItemType? type,
    EquipmentSlot? equipmentSlot,
    Map<String, int>? statBonuses,
    Map<String, double>? statMultipliers,
    List<String>? specialEffects,
    int? durability,
    int? maxDurability,
    bool? isRepairable,
    bool? isTradeable,
    bool? isDroppable,
    int? buyPrice,
    int? sellPrice,
    String? shopCategory,
    bool? isAvailableInShop,
    int? requiredLevel,
    Map<String, int>? statRequirements,
    List<String>? requiredElements,
    String? requiredBloodline,
    String? iconPath,
    List<String>? tags,
    bool? isActive,
    String? rarity,
  }) {
    return Item(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      equipmentSlot: equipmentSlot ?? this.equipmentSlot,
      statBonuses: statBonuses ?? this.statBonuses,
      statMultipliers: statMultipliers ?? this.statMultipliers,
      specialEffects: specialEffects ?? this.specialEffects,
      durability: durability ?? this.durability,
      maxDurability: maxDurability ?? this.maxDurability,
      isRepairable: isRepairable ?? this.isRepairable,
      isTradeable: isTradeable ?? this.isTradeable,
      isDroppable: isDroppable ?? this.isDroppable,
      buyPrice: buyPrice ?? this.buyPrice,
      sellPrice: sellPrice ?? this.sellPrice,
      shopCategory: shopCategory ?? this.shopCategory,
      isAvailableInShop: isAvailableInShop ?? this.isAvailableInShop,
      requiredLevel: requiredLevel ?? this.requiredLevel,
      statRequirements: statRequirements ?? this.statRequirements,
      requiredElements: requiredElements ?? this.requiredElements,
      requiredBloodline: requiredBloodline ?? this.requiredBloodline,
      iconPath: iconPath ?? this.iconPath,
      tags: tags ?? this.tags,
      isActive: isActive ?? this.isActive,
      rarity: rarity ?? this.rarity,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'type': type.name,
      'equipmentSlot': equipmentSlot?.name,
      'statBonuses': statBonuses,
      'statMultipliers': statMultipliers,
      'specialEffects': specialEffects,
      'durability': durability,
      'maxDurability': maxDurability,
      'isRepairable': isRepairable,
      'isTradeable': isTradeable,
      'isDroppable': isDroppable,
      'buyPrice': buyPrice,
      'sellPrice': sellPrice,
      'shopCategory': shopCategory,
      'isAvailableInShop': isAvailableInShop,
      'requiredLevel': requiredLevel,
      'statRequirements': statRequirements,
      'requiredElements': requiredElements,
      'requiredBloodline': requiredBloodline,
      'iconPath': iconPath,
      'tags': tags,
      'isActive': isActive,
      'rarity': rarity,
    };
  }

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      type: ItemType.values.firstWhere((t) => t.name == json['type']),
      equipmentSlot: json['equipmentSlot'] != null 
          ? EquipmentSlot.values.firstWhere((s) => s.name == json['equipmentSlot'])
          : null,
      statBonuses: Map<String, int>.from(json['statBonuses']),
      statMultipliers: Map<String, double>.from(json['statMultipliers']),
      specialEffects: List<String>.from(json['specialEffects']),
      durability: json['durability'],
      maxDurability: json['maxDurability'],
      isRepairable: json['isRepairable'],
      isTradeable: json['isTradeable'],
      isDroppable: json['isDroppable'],
      buyPrice: json['buyPrice'],
      sellPrice: json['sellPrice'],
      shopCategory: json['shopCategory'],
      isAvailableInShop: json['isAvailableInShop'],
      requiredLevel: json['requiredLevel'],
      statRequirements: Map<String, int>.from(json['statRequirements']),
      requiredElements: List<String>.from(json['requiredElements']),
      requiredBloodline: json['requiredBloodline'],
      iconPath: json['iconPath'],
      tags: List<String>.from(json['tags']),
      isActive: json['isActive'],
      rarity: json['rarity'],
    );
  }
}
