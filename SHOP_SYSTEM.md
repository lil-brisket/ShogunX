# Shop System Documentation

## Overview

The shop system provides a comprehensive item marketplace where players can purchase equipment, consumables, and materials for their ninja characters.

## Features

### Equipment Categories
- **Head**: Headbands, helmets, crowns
- **Arms**: Arm wraps, bracers, gauntlets  
- **Body**: Shinobi vests, chain mail, dragon scale armor
- **Legs**: Training pants, leg guards, wind greaves
- **Feet**: Ninja sandals, steel boots, thunder striders
- **Weapons**: Kunai, katanas, legendary blades

### Item Types
- **Weapons**: Combat equipment with attack bonuses
- **Armor**: Defensive equipment with protection bonuses
- **Consumables**: Potions and elixirs for healing and buffs
- **Materials**: Crafting resources and rare components
- **Cosmetic**: Visual customization items

### Rarity System
- **Common**: Basic items with minimal bonuses
- **Uncommon**: Better items with moderate bonuses
- **Rare**: Powerful items with significant bonuses
- **Epic**: Exceptional items with special effects
- **Legendary**: Ultimate items with unique abilities

## Item Properties

### Stat Bonuses
Items provide direct stat increases:
- Strength, Intelligence, Speed, Defense, Willpower
- Bukijutsu, Ninjutsu, Taijutsu, Genjutsu

### Stat Multipliers
Items provide percentage-based stat increases:
- Damage reduction, movement speed, chakra efficiency
- Elemental affinity bonuses

### Special Effects
Unique abilities and bonuses:
- Elemental resistance and immunity
- Special movement abilities (wind walking, lightning speed)
- Combat enhancements (weapon mastery, armor piercing)
- Status effects and buffs

### Requirements
Items have level and stat requirements:
- Minimum character level
- Required stat values
- Elemental affinity requirements
- Bloodline restrictions

## Shop Interface

### Filters
- **Category**: Filter by item type (weapons, armor, consumables, materials)
- **Equipment Slot**: Filter by equipment slot
- **Rarity**: Filter by item rarity
- **Search**: Text search across item names, descriptions, and tags
- **Price Range**: Filter by maximum price
- **Level Range**: Filter by maximum level requirement

### Item Display
Each item shows:
- Name and rarity with color coding
- Description and type icon
- Stat bonuses and special effects
- Price and level requirements
- Purchase and details buttons

### Purchase System
- Items can only be purchased if the character:
  - Has sufficient ryo (currency)
  - Meets level requirements
  - Meets stat requirements
  - Has required elemental affinity (if any)

## Technical Implementation

### Services
- **ShopService**: Manages shop data and business logic
- **ShopProvider**: State management for shop UI and filters

### Data Structure
Items are stored with comprehensive properties:
- Basic information (ID, name, description)
- Equipment properties (slot, durability, requirements)
- Economic properties (buy/sell prices, tradeability)
- Statistical properties (bonuses, multipliers, effects)

### Filtering System
Advanced filtering with multiple criteria:
- Category-based filtering
- Equipment slot filtering
- Rarity filtering
- Price and level filtering
- Text search functionality

## Usage Examples

### Basic Item Purchase
```dart
// Check if character can afford and use item
if (shopProvider.canAffordItem(character, item) && 
    shopProvider.canUseItem(character, item)) {
  // Purchase logic here
}
```

### Filtered Item List
```dart
// Get items by equipment slot
final headItems = shopProvider.getItemsByEquipmentSlot(EquipmentSlot.head);

// Get items by rarity
final rareItems = shopProvider.getItemsByRarity('Rare');

// Get items within price range
final affordableItems = shopProvider.getItemsByPriceRange(0, 1000);
```

### Shop Initialization
```dart
// Initialize shop when screen loads
@override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    ref.read(shopProviderProvider.notifier).initializeShop();
  });
}
```

## Future Enhancements

- Purchase transaction system
- Inventory management
- Item comparison tools
- Wishlist functionality
- Auction house integration
- Crafting system integration
- Item enhancement system
- Seasonal sales and events
