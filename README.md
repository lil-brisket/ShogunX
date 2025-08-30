# Ninja World MMO

A text-based MMORPG inspired by a feudal ninja world. Built with Flutter and Riverpod, designed for scalability across iOS, Android, and Web.

## Features

### 🎮 Core Game Systems

- **5 Core Stats**: Strength, Intelligence, Speed, Defense, Willpower (max 250k)
- **4 Combat Stats**: Bukijutsu, Ninjutsu, Taijutsu, Genjutsu
- **Resource Stats**: Health (HP), Chakra (CP), Stamina (STA) – scale with level
- **Ninja Rank Progression**: Academy Student → Genin → Chunin → Jounin → Elite Jounin → Kage
- **Turn-based AP Combat**: 100 AP per turn, Speed determines initiative
- **Elemental System**: Fire, Water, Earth, Wind, Lightning with strengths/weaknesses
- **Bloodlines**: Unlockable unique powers (Sharingan, Byakugan, etc.)

### 🏘️ Village & Social Systems

- **Villages**: 5 unique villages (Konoha, Suna, Kiri, Iwa, Kumo) with equal opportunities
- **Clans**: Join clans for bonuses, ranks: Shogun (leader), Advisors (2), Members
- **Dark Ops Squads**: Elite village squads with exclusive missions (Chunin+)
- **Hospital**: Healing system (self-heal timer, Ryo heal, or Medic heal using CP/STA)
- **Kage Leadership**: Player-vs-player challenge system to become Kage
- **Council System**: 5-member councils (2 appointed, 3 elected every 2 months)
- **Sensei/Student System**: Jounin+ can mentor Genin for stat growth and social bonds
- **Marriage System**: Players can propose/accept, reflected in profile

### 📱 App Structure

- **Splash Screen** → Login/Register flow
- **Main Navigation** → 5-tab bottom navigation system:
  - **Home** → Game updates + world chat
  - **Village** → Missions, Quests, Bank, Clan Hall, Dark Ops, Hospital, Training Arena, Fighting Grounds, Item Shop
  - **Loadout** → Equipment slots + Jutsu loadouts (7-slot rotation system)
  - **World** → Interactive 25x25 tile grid map with player movement + villages
  - **Profile** → Full character stats, records, reputation, logbook, customization & settings

## Screens

### 🏠 Home Tab

- Game updates / announcements
- World chat (real-time messaging planned)
- Recent activity feed
- Quick access to missions and events

### 🏘️ Village Tab

- **Missions** → D–S rank missions (locked ranks greyed out)
- **Quests** → Special storyline missions
- **Bank** → Withdraw/deposit/transfer Ryo
- **Clan Hall** → Clan details, applications, leadership roles
- **Dark Ops** → Exclusive squads, no public applications
- **Hospital** → Healing system (free timer, Ryo heal, Medic heal)
- **Training Arena** → Stat and Jutsu training
- **Fighting Grounds** → PvP, AI battles, Towers, Sparring
- **Item Shop** → Equipment, consumables, weapons

### 🎒 Loadout Tab

- **Inventory** → Equip slots (Head, Arms x2, Body, Legs, Feet, Weapon), show buffs
- **Jutsus** → Learned jutsus, assign 7 active for battle
- **Equipment Management** → Durability, repairs, upgrades
- **Loadout Presets** → Save and switch between different setups

### 🗺️ World Tab

- Interactive 25x25 grid map
- Move between villages & world zones
- PvP/PvE zones outside villages
- Resource gathering locations
- Safe zones and dangerous areas

### 👤 Profile Tab

- Name, Village, Rank, Level, XP
- PvP/PvE records (W/L, %)
- Core + Combat stats
- Logbook (completed missions/quests)
- Resources (HP, CP, STA, Ryo on-hand + banked)
- Reputation (Village Loyalty / Outlaw Infamy)
- Bloodline + Elements
- Relationship (married to)
- Settings: Avatar, name change, gender, marriage, stat reset, element reroll
- Public Profile View (hides sensitive info)

## Technical Architecture

### 📁 Project Structure

```
lib/
├── models/        # Data models (User, Character, Mission, Clan, Jutsu, Item, World, ChatMessage)
├── services/      # Auth, database, API stubs, Theme, Stub Data (Firebase-ready)
├── providers/     # State management (Riverpod)
├── screens/       # Organized by tabs and sub-features
├── widgets/       # Shared UI components (cards, panels, buttons)
└── main.dart      # App entry point
```

### 🛠️ Technology Stack

- **Flutter 3.x** → Cross-platform UI
- **Riverpod** → State management
- **GoRouter** → Navigation
- **Material 3** → UI system with custom dark theme
- **Dark Theme** → Ninja-styled design with orange accents
- **Firebase (planned)** → Auth, Firestore DB, Cloud Functions
- **WebSockets (future)** → Real-time multiplayer

### 🎨 Design System

- **Material 3** implementation with dark theme
- **Orange accent colors** for primary actions and highlights
- **Consistent theming** across all components
- **Mobile-first design** with responsive layouts
- **Accessibility support** with proper contrast ratios

## Data Models

### 👤 Character System
- **Core Stats**: Strength, Intelligence, Speed, Defense, Willpower
- **Combat Stats**: Bukijutsu, Ninjutsu, Taijutsu, Genjutsu
- **Resources**: HP, Chakra, Stamina with dynamic scaling
- **Progression**: Level-based advancement with rank requirements
- **Relationships**: Sensei/Student, Marriage, Clan membership

### 🎯 Mission System
- **Rank System**: D, C, B, A, S with increasing difficulty
- **Types**: Regular missions, Quests, Dark Ops
- **Requirements**: Level, Rank, Stats, Elements, Bloodlines
- **Rewards**: Experience, Ryo, Items, Jutsus
- **Prerequisites**: Mission chains and story progression

### ⚔️ Jutsu System
- **Types**: Ninjutsu, Taijutsu, Bukijutsu, Bloodline
- **Elements**: Fire, Water, Earth, Wind, Lightning, Neutral
- **Mastery**: 10 levels for normal, 15 for bloodline techniques
- **Costs**: Chakra and Stamina consumption
- **Cooldowns**: Turn-based restrictions

### 🏛️ Clan System
- **Leadership**: Shogun (leader), Advisors (max 2), Members
- **Bonuses**: Stat multipliers and special abilities
- **Requirements**: Application process with fees
- **Dark Ops**: Exclusive access for special missions

### 🗺️ World System
- **Grid-based**: 25x25 tile system
- **Village Locations**: Strategic placement of major settlements
- **Zone Types**: Village, Wilderness, PvP, PvE, Safe, Dangerous
- **Movement**: Turn-based navigation with restrictions

## Development Roadmap

### 🎯 MVP (Phase 1) ✅ COMPLETED

- ✅ Splash, Login/Register screens
- ✅ Tab system (Home, Village, Loadout, World, Profile)
- ✅ Complete data models and relationships
- ✅ Material 3 dark theme with orange accents
- ✅ Stub data service for development
- ✅ Basic navigation and routing

### 🔥 Phase 2 (In Progress)

- 🔄 Clan & Dark Ops system implementation
- 🔄 PvP (sparring, towers) system
- 🔄 Hospital system with Medic roles
- 🔄 Training & stat allocation
- 🔄 Expanded World map functionality

### 🌍 Phase 3 (Planned)

- 📋 Kage & Council elections
- 📋 Sensei/Student mentorship
- 📋 Marriage system
- 📋 Lottery system
- 📋 Bloodline techniques
- 📋 Real-time multiplayer

## Getting Started

### Prerequisites

- Flutter SDK 3.9+
- Dart SDK 3.9+
- Android Studio / VS Code with Flutter extensions

### Install & Run

```bash
flutter pub get
flutter run
```

### Development Guidelines

- **State Management**: Use Riverpod for all state
- **UI Components**: Follow Material 3 design principles
- **Data Models**: Use immutable data classes with proper validation
- **Testing**: Implement unit tests for business logic
- **Code Quality**: Follow Flutter best practices and project cursor rules

## License

This project is for educational and demonstration purposes.

---

**🥷 Step into the Ninja World. Choose your village. Forge your path. ⚔️**
