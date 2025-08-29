import '../models/models.dart';

class StubDataService {
  // Singleton pattern
  static final StubDataService _instance = StubDataService._internal();
  factory StubDataService() => _instance;
  StubDataService._internal();

  // Character data
  List<Character> get sampleCharacters => [
    Character(
      id: 'char_1',
      userId: 'user_1',
      name: 'Naruto Uzumaki',
      village: 'Konoha',
      clanId: 'clan_uzumaki',
      clanRank: 'member',
      ninjaRank: 'Genin',
      elements: ['wind'],
      bloodline: null,
      strength: 15000,
      intelligence: 8000,
      speed: 18000,
      defense: 12000,
      willpower: 20000,
      bukijutsu: 25000,
      ninjutsu: 30000,
      taijutsu: 28000,
      bloodlineEfficiency: 0,
      jutsuMastery: {'rasengan': 5, 'shadow_clone': 8},
      currentHp: 150000,
      currentChakra: 80000,
      currentStamina: 180000,
      experience: 45000,
      level: 12,
      ryoOnHand: 5000,
      ryoBanked: 15000,
      villageLoyalty: 85,
      outlawInfamy: 0,
      marriedTo: null,
      senseiId: 'char_kakashi',
      studentIds: [],
      pvpWins: 15,
      pvpLosses: 8,
      pveWins: 45,
      pveLosses: 3,
      avatarUrl: 'assets/avatars/naruto.png',
      gender: 'male',
    ),
    Character(
      id: 'char_2',
      userId: 'user_2',
      name: 'Sasuke Uchiha',
      village: 'Konoha',
      clanId: 'clan_uchiha',
      clanRank: 'member',
      ninjaRank: 'Genin',
      elements: ['fire', 'lightning'],
      bloodline: 'Sharingan',
      strength: 16000,
      intelligence: 12000,
      speed: 20000,
      defense: 10000,
      willpower: 15000,
      bukijutsu: 32000,
      ninjutsu: 35000,
      taijutsu: 30000,
      bloodlineEfficiency: 15000,
      jutsuMastery: {'chidori': 6, 'fireball': 7, 'sharingan': 3},
      currentHp: 160000,
      currentChakra: 120000,
      currentStamina: 200000,
      experience: 52000,
      level: 13,
      ryoOnHand: 8000,
      ryoBanked: 25000,
      villageLoyalty: 70,
      outlawInfamy: 5,
      marriedTo: null,
      senseiId: 'char_kakashi',
      studentIds: [],
      pvpWins: 22,
      pvpLosses: 5,
      pveWins: 52,
      pveLosses: 2,
      avatarUrl: 'assets/avatars/sasuke.png',
      gender: 'male',
    ),
  ];

  // Mission data
  List<Mission> get sampleMissions => [
    Mission(
      id: 'mission_1',
      title: 'Escort the Merchant',
      description: 'Protect a merchant traveling from Konoha to the next village. Bandits have been spotted in the area.',
      rank: MissionRank.D,
      type: MissionType.mission,
      village: 'Konoha',
      requiredLevel: 5,
      requiredRank: 1, // Genin
      experienceReward: 500,
      ryoReward: 1000,
      itemRewards: ['basic_scroll'],
      jutsuRewards: [],
      statRequirements: {'speed': 5000},
      requiredElements: [],
      requiredBloodline: null,
      estimatedDuration: 30,
      isRepeatable: true,
      isActive: true,
      expiryDate: null,
      isDarkOps: false,
      isStoryline: false,
      prerequisiteMissionId: null,
      tags: ['escort', 'combat'],
    ),
    Mission(
      id: 'mission_2',
      title: 'Investigate Missing Ninja',
      description: 'A Chunin has gone missing while on patrol. Investigate the area and report back.',
      rank: MissionRank.C,
      type: MissionType.mission,
      village: 'Konoha',
      requiredLevel: 15,
      requiredRank: 2, // Chunin
      experienceReward: 1500,
      ryoReward: 3000,
      itemRewards: ['chunin_scroll', 'medical_supplies'],
      jutsuRewards: [],
      statRequirements: {'intelligence': 8000, 'speed': 12000},
      requiredElements: [],
      requiredBloodline: null,
      estimatedDuration: 60,
      isRepeatable: false,
      isActive: true,
      expiryDate: null,
      isDarkOps: false,
      isStoryline: true,
      prerequisiteMissionId: 'mission_1',
      tags: ['investigation', 'storyline'],
    ),
    Mission(
      id: 'mission_3',
      title: 'Dark Ops: Infiltrate Enemy Base',
      description: 'Secret mission to infiltrate an enemy base and gather intelligence. Maximum secrecy required.',
      rank: MissionRank.A,
      type: MissionType.darkOps,
      village: 'Konoha',
      requiredLevel: 30,
      requiredRank: 2, // Chunin+
      experienceReward: 5000,
      ryoReward: 8000,
      itemRewards: ['elite_scroll', 'stealth_gear'],
      jutsuRewards: ['shadow_step'],
      statRequirements: {'speed': 20000, 'intelligence': 15000, 'ninjutsu': 25000},
      requiredElements: [],
      requiredBloodline: null,
      estimatedDuration: 120,
      isRepeatable: false,
      isActive: true,
      expiryDate: null,
      isDarkOps: true,
      isStoryline: false,
      prerequisiteMissionId: null,
      tags: ['stealth', 'intelligence', 'dark_ops'],
    ),
  ];

  // Clan data
  List<Clan> get sampleClans => [
    Clan(
      id: 'clan_uzumaki',
      name: 'Uzumaki Clan',
      description: 'Ancient clan known for their sealing techniques and spiral patterns. Masters of fuinjutsu.',
      village: 'Konoha',
      leaderId: 'char_uzumaki_leader',
      advisorIds: ['char_uzumaki_advisor_1', 'char_uzumaki_advisor_2'],
      memberIds: ['char_1', 'char_uzumaki_member_1'],
      createdAt: DateTime(2020, 1, 1),
      isActive: true,
      statBonuses: {'chakra': 0.15, 'willpower': 0.10},
      specialAbilities: ['Fuinjutsu Mastery', 'Chakra Sensing'],
      maxMembers: 20,
      isPublic: true,
      isDarkOps: false,
      requirements: 'Must demonstrate sealing aptitude',
      applicationFee: 1000,
    ),
    Clan(
      id: 'clan_uchiha',
      name: 'Uchiha Clan',
      description: 'Prestigious clan with the Sharingan bloodline. Masters of fire techniques and genjutsu.',
      village: 'Konoha',
      leaderId: 'char_uchiha_leader',
      advisorIds: ['char_uchiha_advisor_1'],
      memberIds: ['char_2', 'char_uchiha_member_1'],
      createdAt: DateTime(2020, 1, 1),
      isActive: true,
      statBonuses: {'ninjutsu': 0.20, 'intelligence': 0.15},
      specialAbilities: ['Sharingan', 'Fire Affinity', 'Genjutsu Resistance'],
      maxMembers: 25,
      isPublic: false,
      isDarkOps: false,
      requirements: 'Must possess Uchiha bloodline',
      applicationFee: 5000,
    ),
  ];

  // Jutsu data
  List<Jutsu> get sampleJutsus => [
    Jutsu(
      id: 'rasengan',
      name: 'Rasengan',
      description: 'A powerful sphere of rotating chakra that causes massive damage on impact.',
      type: JutsuType.ninjutsu,
      element: JutsuElement.neutral,
      bloodline: null,
      chakraCost: 500,
      staminaCost: 200,
      cooldownTurns: 3,
      range: 2,
      basePower: 800,
      statScaling: {'chakra': 0.5, 'intelligence': 0.3},
      effects: ['high_damage', 'piercing'],
      maxMasteryLevel: 10,
      masteryBonuses: {1: 0, 2: 50, 3: 100, 4: 150, 5: 200, 6: 250, 7: 300, 8: 350, 9: 400, 10: 500},
      requiredLevel: 10,
      statRequirements: {'chakra': 10000, 'intelligence': 8000},
      requiredElements: [],
      requiredBloodline: null,
      iconPath: 'assets/jutsus/rasengan.png',
      tags: ['ninjutsu', 'high_power', 'signature'],
      isActive: true,
    ),
    Jutsu(
      id: 'chidori',
      name: 'Chidori',
      description: 'A lightning technique that concentrates chakra into the hand, creating a powerful piercing attack.',
      type: JutsuType.ninjutsu,
      element: JutsuElement.lightning,
      bloodline: null,
      chakraCost: 600,
      staminaCost: 300,
      cooldownTurns: 4,
      range: 1,
      basePower: 900,
      statScaling: {'chakra': 0.6, 'speed': 0.4},
      effects: ['high_damage', 'lightning', 'piercing'],
      maxMasteryLevel: 10,
      masteryBonuses: {1: 0, 2: 60, 3: 120, 4: 180, 5: 240, 6: 300, 7: 360, 8: 420, 9: 480, 10: 540},
      requiredLevel: 12,
      statRequirements: {'chakra': 12000, 'speed': 15000},
      requiredElements: ['lightning'],
      requiredBloodline: null,
      iconPath: 'assets/jutsus/chidori.png',
      tags: ['ninjutsu', 'lightning', 'high_power'],
      isActive: true,
    ),
    Jutsu(
      id: 'sharingan',
      name: 'Sharingan',
      description: 'The legendary dojutsu of the Uchiha clan. Provides enhanced perception and genjutsu abilities.',
      type: JutsuType.bloodline,
      element: JutsuElement.neutral,
      bloodline: 'Sharingan',
      chakraCost: 100,
      staminaCost: 50,
      cooldownTurns: 0,
      range: 0,
      basePower: 0,
      statScaling: {},
      effects: ['enhanced_perception', 'genjutsu_boost', 'copy_techniques'],
      maxMasteryLevel: 15,
      masteryBonuses: {1: 0, 2: 100, 3: 200, 4: 300, 5: 400, 6: 500, 7: 600, 8: 700, 9: 800, 10: 900, 11: 1000, 12: 1100, 13: 1200, 14: 1300, 15: 1500},
      requiredLevel: 8,
      statRequirements: {'bloodlineEfficiency': 5000},
      requiredElements: [],
      requiredBloodline: 'Sharingan',
      iconPath: 'assets/jutsus/sharingan.png',
      tags: ['bloodline', 'dojutsu', 'perception'],
      isActive: true,
    ),
  ];

  // Item data
  List<Item> get sampleItems => [
    Item(
      id: 'item_1',
      name: 'Kunai',
      description: 'A standard throwing knife used by ninja. Basic but reliable weapon.',
      type: ItemType.weapon,
      equipmentSlot: EquipmentSlot.weapon,
      statBonuses: {'strength': 100, 'speed': 50},
      statMultipliers: {},
      specialEffects: ['throwing_weapon'],
      durability: 100,
      maxDurability: 100,
      isRepairable: true,
      isTradeable: true,
      isDroppable: true,
      buyPrice: 100,
      sellPrice: 50,
      shopCategory: 'weapons',
      isAvailableInShop: true,
      requiredLevel: 1,
      statRequirements: {},
      requiredElements: [],
      requiredBloodline: null,
      iconPath: 'assets/items/kunai.png',
      tags: ['weapon', 'throwing', 'basic'],
      isActive: true,
      rarity: 'Common',
    ),
    Item(
      id: 'item_2',
      name: 'Chakra Potion',
      description: 'Restores chakra when consumed. Essential for long missions.',
      type: ItemType.consumable,
      equipmentSlot: null,
      statBonuses: {},
      statMultipliers: {},
      specialEffects: ['restore_chakra'],
      durability: null,
      maxDurability: null,
      isRepairable: false,
      isTradeable: true,
      isDroppable: true,
      buyPrice: 200,
      sellPrice: 100,
      shopCategory: 'consumables',
      isAvailableInShop: true,
      requiredLevel: 1,
      statRequirements: {},
      requiredElements: [],
      requiredBloodline: null,
      iconPath: 'assets/items/chakra_potion.png',
      tags: ['consumable', 'chakra', 'healing'],
      isActive: true,
      rarity: 'Common',
    ),
    Item(
      id: 'item_3',
      name: 'Elite Shinobi Vest',
      description: 'High-quality armor worn by experienced ninja. Provides excellent protection.',
      type: ItemType.armor,
      equipmentSlot: EquipmentSlot.body,
      statBonuses: {'defense': 500, 'willpower': 200},
      statMultipliers: {'defense': 1.1},
      specialEffects: ['damage_reduction', 'chakra_resistance'],
      durability: 200,
      maxDurability: 200,
      isRepairable: true,
      isTradeable: true,
      isDroppable: false,
      buyPrice: 5000,
      sellPrice: 2500,
      shopCategory: 'armor',
      isAvailableInShop: true,
      requiredLevel: 15,
      statRequirements: {'defense': 8000},
      requiredElements: [],
      requiredBloodline: null,
      iconPath: 'assets/items/shinobi_vest.png',
      tags: ['armor', 'body', 'elite'],
      isActive: true,
      rarity: 'Rare',
    ),
  ];

  // World data
  World get sampleWorld => World(
    id: 'world_1',
    width: 25,
    height: 25,
    tiles: _generateWorldTiles(),
    villageLocations: _generateVillageLocations(),
    activePlayers: ['user_1', 'user_2'],
    lastUpdated: DateTime.now(),
  );

  // Helper methods
  List<WorldTile> _generateWorldTiles() {
    final tiles = <WorldTile>[];
    
    for (int y = 0; y < 25; y++) {
      for (int x = 0; x < 25; x++) {
        // Village tiles
        if ((x == 12 && y == 12) || // Konoha center
            (x == 2 && y == 2) ||   // Suna
            (x == 22 && y == 2) ||  // Kiri
            (x == 2 && y == 22) ||  // Iwa
            (x == 22 && y == 22)) { // Kumo
          tiles.add(WorldTile(
            x: x,
            y: y,
            type: TileType.village,
            villageType: _getVillageType(x, y),
            villageName: _getVillageName(x, y),
            description: 'A bustling ninja village',
            availableActions: ['move', 'rest', 'shop', 'train'],
            isOccupied: false,
            occupiedBy: null,
            statModifiers: {'defense': 1.2, 'willpower': 1.1},
            specialEffects: ['safe_zone', 'healing'],
            dangerLevel: 0,
            isRestricted: false,
          ));
        }
        // PvP zones
        else if ((x == 10 && y == 10) || (x == 14 && y == 14)) {
          tiles.add(WorldTile(
            x: x,
            y: y,
            type: TileType.pvp,
            villageType: null,
            villageName: null,
            description: 'Dangerous PvP zone',
            availableActions: ['move', 'fight', 'gather'],
            isOccupied: false,
            occupiedBy: null,
            statModifiers: {'speed': 1.1, 'strength': 1.1},
            specialEffects: ['pvp_enabled', 'increased_rewards'],
            dangerLevel: 8,
            isRestricted: false,
          ));
        }
        // PvE zones
        else if ((x == 5 && y == 5) || (x == 19 && y == 19)) {
          tiles.add(WorldTile(
            x: x,
            y: y,
            type: TileType.pve,
            villageType: null,
            villageName: null,
            description: 'Wilderness with monsters',
            availableActions: ['move', 'hunt', 'gather'],
            isOccupied: false,
            occupiedBy: null,
            statModifiers: {'experience': 1.2},
            specialEffects: ['monster_spawns', 'resource_rich'],
            dangerLevel: 5,
            isRestricted: false,
          ));
        }
        // Default wilderness
        else {
          tiles.add(WorldTile(
            x: x,
            y: y,
            type: TileType.wilderness,
            villageType: null,
            villageName: null,
            description: 'Peaceful wilderness area',
            availableActions: ['move', 'rest', 'gather'],
            isOccupied: false,
            occupiedBy: null,
            statModifiers: {},
            specialEffects: [],
            dangerLevel: 2,
            isRestricted: false,
          ));
        }
      }
    }
    
    return tiles;
  }

  Map<String, WorldTile> _generateVillageLocations() {
    final locations = <String, WorldTile>{};
    final tiles = _generateWorldTiles();
    
    locations['konoha'] = tiles.firstWhere((t) => t.x == 12 && t.y == 12);
    locations['suna'] = tiles.firstWhere((t) => t.x == 2 && t.y == 2);
    locations['kiri'] = tiles.firstWhere((t) => t.x == 22 && t.y == 2);
    locations['iwa'] = tiles.firstWhere((t) => t.x == 2 && t.y == 22);
    locations['kumo'] = tiles.firstWhere((t) => t.x == 22 && t.y == 22);
    
    return locations;
  }

  String _getVillageType(int x, int y) {
    if (x == 12 && y == 12) return 'konoha';
    if (x == 2 && y == 2) return 'suna';
    if (x == 22 && y == 2) return 'kiri';
    if (x == 2 && y == 22) return 'iwa';
    if (x == 22 && y == 22) return 'kumo';
    return 'unknown';
  }

  String _getVillageName(int x, int y) {
    if (x == 12 && y == 12) return 'Konohagakure';
    if (x == 2 && y == 2) return 'Sunagakure';
    if (x == 22 && y == 2) return 'Kirigakure';
    if (x == 2 && y == 22) return 'Iwagakure';
    if (x == 22 && y == 22) return 'Kumogakure';
    return 'Unknown Village';
  }

  // Chat messages
  List<ChatMessage> get sampleChatMessages => [
    ChatMessage(
      id: 'msg_1',
      senderId: 'user_1',
      senderName: 'Naruto Uzumaki',
      senderAvatar: 'assets/avatars/naruto.png',
      chatType: ChatType.world,
      messageType: MessageType.text,
      content: 'Hey everyone! Just completed my first C-rank mission! 🎉',
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      editedAt: null,
      isEdited: false,
      isDeleted: false,
      targetId: null,
      villageName: null,
      clanName: null,
      recipientId: null,
      mentions: [],
      attachments: [],
      metadata: {},
      isModerated: false,
      moderationReason: null,
      isPinned: false,
      reactions: {'👍': ['user_2'], '🎉': ['user_3']},
      reactionCount: 2,
    ),
    ChatMessage(
      id: 'msg_2',
      senderId: 'user_2',
      senderName: 'Sasuke Uchiha',
      senderAvatar: 'assets/avatars/sasuke.png',
      chatType: ChatType.village,
      messageType: MessageType.text,
      content: 'Anyone up for some training at the arena?',
      timestamp: DateTime.now().subtract(const Duration(minutes: 3)),
      editedAt: null,
      isEdited: false,
      isDeleted: false,
      targetId: 'konoha',
      villageName: 'Konoha',
      clanName: null,
      recipientId: null,
      mentions: [],
      attachments: [],
      metadata: {},
      isModerated: false,
      moderationReason: null,
      isPinned: false,
      reactions: {'⚔️': ['user_1']},
      reactionCount: 1,
    ),
  ];

  // User data
  List<User> get sampleUsers => [
    User(
      id: 'user_1',
      username: 'naruto_uzumaki',
      email: 'naruto@konoha.com',
      createdAt: DateTime(2020, 1, 1),
      lastLogin: DateTime.now(),
      isActive: true,
      isVerified: true,
      displayName: 'Naruto Uzumaki',
      avatarUrl: 'assets/avatars/naruto.png',
      bio: 'Believe it! Future Hokage!',
      preferences: {'theme': 'dark', 'notifications': true},
      isBanned: false,
      banReason: null,
      banExpiry: null,
      warningCount: 0,
      friends: ['user_2', 'user_3'],
      blockedUsers: [],
      ignoredUsers: [],
      currentCharacterId: 'char_1',
      characterIds: ['char_1'],
      lastVillage: 'Konoha',
      lastActivity: DateTime.now(),
    ),
    User(
      id: 'user_2',
      username: 'sasuke_uchiha',
      email: 'sasuke@konoha.com',
      createdAt: DateTime(2020, 1, 1),
      lastLogin: DateTime.now().subtract(const Duration(hours: 1)),
      isActive: true,
      isVerified: true,
      displayName: 'Sasuke Uchiha',
      avatarUrl: 'assets/avatars/sasuke.png',
      bio: 'Seeking power to restore my clan.',
      preferences: {'theme': 'dark', 'notifications': false},
      isBanned: false,
      banReason: null,
      banExpiry: null,
      warningCount: 1,
      friends: ['user_1'],
      blockedUsers: [],
      ignoredUsers: [],
      currentCharacterId: 'char_2',
      characterIds: ['char_2'],
      lastVillage: 'Konoha',
      lastActivity: DateTime.now().subtract(const Duration(hours: 1)),
    ),
  ];
}
