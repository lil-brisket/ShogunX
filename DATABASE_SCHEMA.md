# Ninja World MMO - Database Schema

## Overview

This document outlines the Firestore database schema for the Ninja World MMO. The schema is designed for scalability, real-time multiplayer support, and efficient querying of game data.

## Database Structure

### Collections Overview

```
firestore/
├── users/                    # User accounts and authentication
├── characters/               # Player character data
├── villages/                 # Village information and settings
├── clans/                    # Clan data and membership
├── missions/                 # Available missions by village
├── jutsus/                   # Jutsu definitions and requirements
├── items/                    # Item definitions and shop data
├── world/                    # World map and tile data
├── chat/                     # Global and village chat messages
├── battles/                  # PvP and PvE battle records
├── transactions/             # Banking and shop transactions
├── training_sessions/        # Training activity logs
├── hospital_records/         # Medical treatment logs
└── game_updates/             # System announcements and updates
```

## Detailed Schema

### 1. Users Collection

**Document ID**: `{userId}` (auto-generated)

```json
{
  "id": "user_123",
  "username": "ninja_player",
  "email": "player@example.com",
  "createdAt": "2024-01-01T00:00:00Z",
  "lastLogin": "2024-01-15T10:30:00Z",
  "isActive": true,
  "isVerified": false,
  "displayName": "Ninja Player",
  "avatarUrl": "https://example.com/avatar.jpg",
  "bio": "A skilled ninja warrior",
  "preferences": {
    "theme": "dark",
    "notifications": {
      "missions": true,
      "clan": true,
      "pvp": false
    }
  },
  "isBanned": false,
  "banReason": null,
  "banExpiry": null,
  "warningCount": 0,
  "friends": ["user_456", "user_789"],
  "blockedUsers": [],
  "ignoredUsers": [],
  "currentCharacterId": "char_123",
  "characterIds": ["char_123", "char_456"],
  "lastVillage": "Konoha",
  "lastActivity": "2024-01-15T10:30:00Z"
}
```

### 2. Characters Collection

**Document ID**: `{characterId}` (auto-generated)

```json
{
  "id": "char_123",
  "userId": "user_123",
  "name": "Naruto Uzumaki",
  "village": "Konoha",
  "clanId": "clan_uzumaki",
  "clanRank": "member",
  "ninjaRank": "Genin",
  "elements": ["wind"],
  "bloodline": null,
  
  "stats": {
    "strength": 15000,
    "intelligence": 8000,
    "speed": 18000,
    "defense": 12000,
    "willpower": 20000,
    "bukijutsu": 25000,
    "ninjutsu": 30000,
    "taijutsu": 28000,
    "genjutsu": 0
  },
  
  "jutsuMastery": {
    "rasengan": 5,
    "shadow_clone": 8
  },
  
  "currentStatus": {
    "hp": 150000,
    "chakra": 80000,
    "stamina": 180000,
    "experience": 45000,
    "level": 12
  },
  
  "regenerationRates": {
    "hp": 100,
    "chakra": 100,
    "stamina": 100
  },
  
  "resources": {
    "ryoOnHand": 5000,
    "ryoBanked": 15000
  },
  
  "reputation": {
    "villageLoyalty": 85,
    "outlawInfamy": 0
  },
  
  "relationships": {
    "marriedTo": null,
    "senseiId": "char_kakashi",
    "studentIds": []
  },
  
  "records": {
    "pvpWins": 15,
    "pvpLosses": 8,
    "pveWins": 45,
    "pveLosses": 3,
    "medicalExp": 0
  },
  
  "appearance": {
    "avatarUrl": "assets/avatars/naruto.png",
    "gender": "male"
  },
  
  "inventory": [
    {
      "itemId": "item_sword_1",
      "quantity": 1,
      "durability": 100,
      "maxDurability": 100
    }
  ],
  
  "equippedItems": {
    "head": null,
    "arms": [null, null],
    "body": "item_armor_1",
    "legs": null,
    "feet": null,
    "weapon": "item_sword_1"
  },
  
  "worldPosition": {
    "x": 12,
    "y": 12,
    "village": "Konoha"
  },
  
  "lastUpdated": "2024-01-15T10:30:00Z",
  "createdAt": "2024-01-01T00:00:00Z"
}
```

### 3. Villages Collection

**Document ID**: `{villageName}` (e.g., "Konoha", "Suna")

```json
{
  "id": "Konoha",
  "name": "Konohagakure",
  "description": "The Hidden Leaf Village",
  "leader": {
    "characterId": "char_kage_1",
    "name": "Hokage",
    "electionDate": "2024-01-01T00:00:00Z"
  },
  "council": [
    {
      "characterId": "char_council_1",
      "name": "Council Member 1",
      "position": "elected",
      "termEnd": "2024-03-01T00:00:00Z"
    }
  ],
  "worldPosition": {
    "x": 12,
    "y": 12
  },
  "population": 150,
  "activePlayers": 45,
  "settings": {
    "missionRefreshRate": 3600,
    "hospitalHealingRate": 100,
    "trainingBonus": 1.2
  },
  "lastUpdated": "2024-01-15T10:30:00Z"
}
```

### 4. Clans Collection

**Document ID**: `{clanId}` (auto-generated)

```json
{
  "id": "clan_uzumaki",
  "name": "Uzumaki Clan",
  "village": "Konoha",
  "description": "A powerful clan known for their sealing techniques",
  "leader": {
    "characterId": "char_123",
    "name": "Naruto Uzumaki",
    "rank": "shogun"
  },
  "advisors": [
    {
      "characterId": "char_456",
      "name": "Advisor 1",
      "rank": "advisor"
    }
  ],
  "members": [
    {
      "characterId": "char_789",
      "name": "Member 1",
      "rank": "member",
      "joinedAt": "2024-01-01T00:00:00Z"
    }
  ],
  "applications": [
    {
      "characterId": "char_app_1",
      "name": "Applicant 1",
      "appliedAt": "2024-01-15T10:30:00Z",
      "status": "pending"
    }
  ],
  "bonuses": {
    "strength": 1.1,
    "chakra": 1.2
  },
  "specialAbilities": ["sealing_techniques"],
  "treasury": 50000,
  "createdAt": "2024-01-01T00:00:00Z",
  "lastUpdated": "2024-01-15T10:30:00Z"
}
```

### 5. Missions Collection

**Document ID**: `{missionId}` (auto-generated)

```json
{
  "id": "mission_d_rank_1",
  "title": "Deliver Package",
  "description": "Deliver a package to the neighboring village",
  "village": "Konoha",
  "rank": "D",
  "type": "regular",
  "requirements": {
    "minLevel": 1,
    "minRank": "Academy Student",
    "stats": {
      "speed": 1000
    },
    "elements": [],
    "bloodline": null
  },
  "rewards": {
    "experience": 100,
    "ryo": 500,
    "items": ["item_health_potion"],
    "jutsus": []
  },
  "difficulty": 1,
  "estimatedTime": 300,
  "isAvailable": true,
  "prerequisites": [],
  "chainId": null,
  "createdAt": "2024-01-01T00:00:00Z",
  "lastUpdated": "2024-01-15T10:30:00Z"
}
```

### 6. Jutsus Collection

**Document ID**: `{jutsuId}` (auto-generated)

```json
{
  "id": "rasengan",
  "name": "Rasengan",
  "description": "A powerful spinning chakra technique",
  "type": "ninjutsu",
  "element": "neutral",
  "rank": "A",
  "maxLevel": 10,
  "requirements": {
    "minLevel": 10,
    "stats": {
      "ninjutsu": 20000,
      "chakra": 15000
    },
    "elements": [],
    "bloodline": null
  },
  "costs": {
    "chakra": 1000,
    "stamina": 500
  },
  "effects": {
    "damage": 5000,
    "accuracy": 0.9,
    "criticalChance": 0.1
  },
  "cooldown": 3,
  "isBloodline": false,
  "isAvailable": true,
  "createdAt": "2024-01-01T00:00:00Z"
}
```

### 7. Items Collection

**Document ID**: `{itemId}` (auto-generated)

```json
{
  "id": "item_sword_1",
  "name": "Steel Katana",
  "description": "A well-crafted steel katana",
  "type": "weapon",
  "equipmentSlot": "weapon",
  "statBonuses": {
    "strength": 500,
    "bukijutsu": 300
  },
  "statMultipliers": {},
  "specialEffects": ["sharp_edge"],
  "durability": 100,
  "maxDurability": 100,
  "isRepairable": true,
  "isTradeable": true,
  "isDroppable": true,
  "buyPrice": 1000,
  "sellPrice": 500,
  "shopCategory": "weapons",
  "isAvailableInShop": true,
  "requirements": {
    "level": 5,
    "stats": {},
    "elements": [],
    "bloodline": null
  },
  "rarity": "common",
  "isActive": true,
  "createdAt": "2024-01-01T00:00:00Z"
}
```

### 8. World Collection

**Document ID**: `world_map`

```json
{
  "id": "world_map",
  "width": 25,
  "height": 25,
  "tiles": [
    {
      "x": 12,
      "y": 12,
      "type": "village",
      "villageType": "konoha",
      "villageName": "Konohagakure",
      "description": "The Hidden Leaf Village",
      "availableActions": ["move", "rest", "shop", "train"],
      "isOccupied": false,
      "occupiedBy": null,
      "statModifiers": {
        "strength": 1.1,
        "chakra": 1.2
      },
      "specialEffects": ["village_protection"],
      "dangerLevel": 0,
      "isRestricted": false
    }
  ],
  "villageLocations": {
    "Konoha": {"x": 12, "y": 12},
    "Suna": {"x": 5, "y": 5},
    "Kiri": {"x": 20, "y": 5},
    "Iwa": {"x": 5, "y": 20},
    "Kumo": {"x": 20, "y": 20}
  },
  "activePlayers": ["char_123", "char_456"],
  "lastUpdated": "2024-01-15T10:30:00Z"
}
```

### 9. Chat Collection

**Document ID**: `{chatId}` (auto-generated)

```json
{
  "id": "global_chat",
  "type": "global",
  "village": null,
  "messages": [
    {
      "id": "msg_123",
      "characterId": "char_123",
      "characterName": "Naruto Uzumaki",
      "village": "Konoha",
      "message": "Hello everyone!",
      "timestamp": "2024-01-15T10:30:00Z",
      "isSystem": false
    }
  ],
  "lastMessageAt": "2024-01-15T10:30:00Z",
  "createdAt": "2024-01-01T00:00:00Z"
}
```

### 10. Battles Collection

**Document ID**: `{battleId}` (auto-generated)

```json
{
  "id": "battle_123",
  "type": "pvp",
  "participants": [
    {
      "characterId": "char_123",
      "name": "Naruto Uzumaki",
      "village": "Konoha",
      "initialHp": 150000,
      "finalHp": 50000,
      "result": "winner"
    },
    {
      "characterId": "char_456",
      "name": "Sasuke Uchiha",
      "village": "Konoha",
      "initialHp": 140000,
      "finalHp": 0,
      "result": "loser"
    }
  ],
  "turns": [
    {
      "turnNumber": 1,
      "attacker": "char_123",
      "defender": "char_456",
      "jutsuUsed": "rasengan",
      "damage": 5000,
      "timestamp": "2024-01-15T10:30:00Z"
    }
  ],
  "duration": 120,
  "location": {
    "x": 12,
    "y": 12,
    "village": "Konoha"
  },
  "startedAt": "2024-01-15T10:28:00Z",
  "endedAt": "2024-01-15T10:30:00Z",
  "createdAt": "2024-01-15T10:28:00Z"
}
```

### 11. Transactions Collection

**Document ID**: `{transactionId}` (auto-generated)

```json
{
  "id": "txn_123",
  "characterId": "char_123",
  "type": "missionReward",
  "amount": 500,
  "description": "Completed D-rank mission: Deliver Package",
  "timestamp": "2024-01-15T10:30:00Z",
  "recipientId": null,
  "metadata": {
    "missionId": "mission_d_rank_1",
    "missionTitle": "Deliver Package"
  },
  "createdAt": "2024-01-15T10:30:00Z"
}
```

### 12. Training Sessions Collection

**Document ID**: `{sessionId}` (auto-generated)

```json
{
  "id": "session_123",
  "characterId": "char_123",
  "characterName": "Naruto Uzumaki",
  "type": "stat_training",
  "statTrained": "strength",
  "pointsGained": 100,
  "cost": {
    "ryo": 1000,
    "stamina": 500
  },
  "duration": 300,
  "startedAt": "2024-01-15T10:25:00Z",
  "completedAt": "2024-01-15T10:30:00Z",
  "createdAt": "2024-01-15T10:25:00Z"
}
```

### 13. Hospital Records Collection

**Document ID**: `{recordId}` (auto-generated)

```json
{
  "id": "record_123",
  "patientId": "char_123",
  "patientName": "Naruto Uzumaki",
  "medicId": "char_medic_1",
  "medicName": "Sakura Haruno",
  "treatmentType": "medic_heal",
  "healingAmount": 50000,
  "cost": {
    "ryo": 2000,
    "medicChakra": 1000,
    "medicStamina": 500
  },
  "notes": "Healed after PvP battle",
  "treatedAt": "2024-01-15T10:30:00Z",
  "createdAt": "2024-01-15T10:30:00Z"
}
```

### 14. Game Updates Collection

**Document ID**: `{updateId}` (auto-generated)

```json
{
  "id": "update_123",
  "title": "New Mission Available",
  "content": "A new S-rank mission has been added to Konoha village.",
  "type": "announcement",
  "priority": "normal",
  "targetVillage": "Konoha",
  "isActive": true,
  "publishedAt": "2024-01-15T10:30:00Z",
  "expiresAt": null,
  "createdAt": "2024-01-15T10:30:00Z"
}
```

## Security Rules

### Basic Security Rules

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can only read/write their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Characters can only be accessed by their owner
    match /characters/{characterId} {
      allow read, write: if request.auth != null && 
        resource.data.userId == request.auth.uid;
    }
    
    // Public read-only data
    match /villages/{villageId} {
      allow read: if true;
      allow write: if false; // Only admins can modify
    }
    
    match /missions/{missionId} {
      allow read: if true;
      allow write: if false;
    }
    
    match /jutsus/{jutsuId} {
      allow read: if true;
      allow write: if false;
    }
    
    match /items/{itemId} {
      allow read: if true;
      allow write: if false;
    }
    
    // Chat messages - users can read all, write their own
    match /chat/{chatId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && 
        request.resource.data.characterId == get(/databases/$(database)/documents/characters/$(request.resource.data.characterId)).data.userId;
    }
  }
}
```

## Indexes

### Required Composite Indexes

```javascript
// Characters by village and rank
characters: village ASC, ninjaRank ASC

// Missions by village and rank
missions: village ASC, rank ASC, isAvailable ASC

// Chat messages by timestamp
chat: type ASC, timestamp DESC

// Battles by participants
battles: participants.characterId ASC, startedAt DESC

// Transactions by character and type
transactions: characterId ASC, type ASC, timestamp DESC
```

## Implementation Strategy

### Phase 1: Basic Setup
1. Set up Firebase project
2. Configure Firestore database
3. Implement basic CRUD operations
4. Add authentication

### Phase 2: Core Features
1. Character creation and management
2. Village and clan systems
3. Mission system
4. Basic chat functionality

### Phase 3: Advanced Features
1. Real-time multiplayer
2. PvP system
3. World map
4. Advanced clan features

### Phase 4: Optimization
1. Database indexing
2. Caching strategies
3. Performance monitoring
4. Security hardening

## Migration from Stub Data

1. **Export current stub data** to JSON format
2. **Create data migration scripts** to populate Firestore
3. **Implement gradual migration** - start with read-only Firestore
4. **Add write operations** once read operations are stable
5. **Remove stub data** once migration is complete

## Cost Considerations

### Firestore Pricing (as of 2024)
- **Read operations**: $0.06 per 100,000 reads
- **Write operations**: $0.18 per 100,000 writes
- **Delete operations**: $0.02 per 100,000 deletes
- **Storage**: $0.18 per GB/month

### Estimated Monthly Costs (100 active players)
- **Reads**: ~$5-10/month
- **Writes**: ~$15-25/month
- **Storage**: ~$2-5/month
- **Total**: ~$25-40/month

This is very cost-effective for an indie MMO project.
