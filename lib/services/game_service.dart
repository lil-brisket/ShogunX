import '../models/models.dart';

class GameService {
  static final GameService _instance = GameService._internal();
  factory GameService() => _instance;
  GameService._internal();

  // In-memory storage for demo purposes
  final Map<String, Character> _characters = {};
  final Map<String, List<Mission>> _missionsByVillage = {};
  final Map<String, List<Clan>> _clansByVillage = {};
  final List<ChatMessage> _chatMessages = [];

  // Character Management
  Future<Character?> getCharacter(String characterId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _characters[characterId];
  }

  Future<List<Character>> getUserCharacters(String userId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _characters.values.where((char) => char.userId == userId).toList();
  }

  Future<void> saveCharacter(Character character) async {
    await Future.delayed(const Duration(milliseconds: 150));
    _characters[character.id] = character;
  }

  Future<Character> createCharacter(Character character) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _characters[character.id] = character;
    return character;
  }

  // Mission Management
  Future<List<Mission>> getMissionsByVillage(String village) async {
    await Future.delayed(const Duration(milliseconds: 200));
    
    if (!_missionsByVillage.containsKey(village)) {
      _missionsByVillage[village] = _generateMissionsForVillage(village);
    }
    
    return _missionsByVillage[village]!;
  }

  List<Mission> _generateMissionsForVillage(String village) {
    return [
      Mission(
        id: 'mission_${village}_1',
        title: 'Patrol the Village',
        description: 'Help maintain security by patrolling the village streets.',
        rank: MissionRank.D,
        type: MissionType.mission,
        village: village,
        requiredLevel: 1,
        requiredRank: 0,
        ryoReward: 100,
        experienceReward: 50,
        itemRewards: [],
        jutsuRewards: [],
        statRequirements: {},
        requiredElements: [],
        estimatedDuration: 30,
        isRepeatable: true,
        isActive: true,
        isDarkOps: false,
        isStoryline: false,
        tags: ['patrol', 'village'],
      ),
      Mission(
        id: 'mission_${village}_2',
        title: 'Deliver Important Documents',
        description: 'Deliver classified documents to a nearby village.',
        rank: MissionRank.C,
        type: MissionType.mission,
        village: village,
        requiredLevel: 5,
        requiredRank: 1,
        ryoReward: 300,
        experienceReward: 150,
        itemRewards: [],
        jutsuRewards: [],
        statRequirements: {'speed': 1000},
        requiredElements: [],
        estimatedDuration: 60,
        isRepeatable: true,
        isActive: true,
        isDarkOps: false,
        isStoryline: false,
        tags: ['delivery', 'documents'],
      ),
      Mission(
        id: 'mission_${village}_3',
        title: 'Escort Merchant Caravan',
        description: 'Protect a merchant caravan from bandits.',
        rank: MissionRank.B,
        type: MissionType.mission,
        village: village,
        requiredLevel: 10,
        requiredRank: 2,
        ryoReward: 500,
        experienceReward: 250,
        itemRewards: ['kunai'],
        jutsuRewards: [],
        statRequirements: {'strength': 2000, 'defense': 1500},
        requiredElements: [],
        estimatedDuration: 120,
        isRepeatable: false,
        isActive: true,
        isDarkOps: false,
        isStoryline: false,
        tags: ['escort', 'caravan'],
      ),
      Mission(
        id: 'mission_${village}_4',
        title: 'Investigate Missing Ninja',
        description: 'Investigate the disappearance of a fellow ninja.',
        rank: MissionRank.A,
        type: MissionType.mission,
        village: village,
        requiredLevel: 15,
        requiredRank: 3,
        ryoReward: 1000,
        experienceReward: 500,
        itemRewards: [],
        jutsuRewards: [],
        statRequirements: {'intelligence': 3000},
        requiredElements: [],
        estimatedDuration: 180,
        isRepeatable: false,
        isActive: true,
        isDarkOps: false,
        isStoryline: true,
        tags: ['investigation', 'storyline'],
      ),
      Mission(
        id: 'mission_${village}_5',
        title: 'Assassinate High-Profile Target',
        description: 'Eliminate a dangerous criminal mastermind.',
        rank: MissionRank.S,
        type: MissionType.darkOps,
        village: village,
        requiredLevel: 20,
        requiredRank: 4,
        ryoReward: 2000,
        experienceReward: 1000,
        itemRewards: [],
        jutsuRewards: [],
        statRequirements: {'strength': 5000, 'speed': 4000, 'intelligence': 3000},
        requiredElements: [],
        estimatedDuration: 240,
        isRepeatable: false,
        isActive: true,
        isDarkOps: true,
        isStoryline: true,
        tags: ['assassination', 'dark-ops'],
      ),
    ];
  }

  // Clan Management
  Future<List<Clan>> getClansByVillage(String village) async {
    await Future.delayed(const Duration(milliseconds: 200));
    
    if (!_clansByVillage.containsKey(village)) {
      _clansByVillage[village] = _generateClansForVillage(village);
    }
    
    return _clansByVillage[village]!;
  }

  List<Clan> _generateClansForVillage(String village) {
    return [
      Clan(
        id: 'clan_${village}_1',
        name: '$village Elite',
        description: 'An elite clan focused on protecting the village and training strong ninja.',
        leaderId: 'leader_1',
        advisorIds: ['advisor_1', 'advisor_2'],
        memberIds: ['leader_1', 'member_1', 'member_2'],
        maxMembers: 20,
        village: village,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        isActive: true,
        statBonuses: {'strength': 500, 'defense': 500},
        specialAbilities: ['Elite Training'],
        isPublic: true,
        isDarkOps: false,
        requirements: 'Level 10+, Good reputation',
        applicationFee: 1000,
      ),
      Clan(
        id: 'clan_${village}_2',
        name: '$village Shadows',
        description: 'A secretive clan specializing in stealth and intelligence gathering.',
        leaderId: 'leader_2',
        advisorIds: ['advisor_3'],
        memberIds: ['leader_2', 'member_3'],
        maxMembers: 15,
        village: village,
        createdAt: DateTime.now().subtract(const Duration(days: 60)),
        isActive: true,
        statBonuses: {'speed': 500, 'intelligence': 500},
        specialAbilities: ['Shadow Techniques'],
        isPublic: false,
        isDarkOps: true,
        requirements: 'Invitation only',
        applicationFee: 0,
      ),
    ];
  }

  // Chat Management
  Future<List<ChatMessage>> getChatMessages() async {
    await Future.delayed(const Duration(milliseconds: 100));
    
    if (_chatMessages.isEmpty) {
      _chatMessages.addAll([
        ChatMessage(
          id: 'msg_1',
          senderId: 'system',
          senderName: 'System',
          content: 'Welcome to Ninja World MMO!',
          chatType: ChatType.world,
          messageType: MessageType.system,
          timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
          editedAt: null,
          isEdited: false,
          isDeleted: false,
          villageName: null,
          clanName: null,
          recipientId: null,
          mentions: [],
          attachments: [],
          metadata: {},
          isModerated: false,
          moderationReason: null,
          isPinned: false,
          reactions: {},
          reactionCount: 0,
        ),
        ChatMessage(
          id: 'msg_2',
          senderId: 'user_1',
          senderName: 'NinjaMaster',
          content: 'Anyone up for some training?',
          chatType: ChatType.world,
          messageType: MessageType.text,
          timestamp: DateTime.now().subtract(const Duration(minutes: 3)),
          editedAt: null,
          isEdited: false,
          isDeleted: false,
          villageName: null,
          clanName: null,
          recipientId: null,
          mentions: [],
          attachments: [],
          metadata: {},
          isModerated: false,
          moderationReason: null,
          isPinned: false,
          reactions: {},
          reactionCount: 0,
        ),
        ChatMessage(
          id: 'msg_3',
          senderId: 'user_2',
          senderName: 'ShadowWalker',
          content: 'I\'m heading to the training grounds now!',
          chatType: ChatType.world,
          messageType: MessageType.text,
          timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
          editedAt: null,
          isEdited: false,
          isDeleted: false,
          villageName: null,
          clanName: null,
          recipientId: null,
          mentions: [],
          attachments: [],
          metadata: {},
          isModerated: false,
          moderationReason: null,
          isPinned: false,
          reactions: {},
          reactionCount: 0,
        ),
      ]);
    }
    
    return _chatMessages;
  }

  Future<void> sendChatMessage(ChatMessage message) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _chatMessages.add(message);
  }

  // World Management
  Future<World> getWorld() async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    final tiles = <WorldTile>[];
    
    // Generate a 25x25 world grid
    for (int x = 0; x < 25; x++) {
      for (int y = 0; y < 25; y++) {
        TileType tileType;
        
        // Village locations
        if ((x == 12 && y == 12) || // Center
            (x == 6 && y == 6) ||   // Top-left village
            (x == 6 && y == 18) ||  // Top-right village
            (x == 18 && y == 6) ||  // Bottom-left village
            (x == 18 && y == 18)) { // Bottom-right village
          tileType = TileType.village;
        }
        // Safe zones around villages
        else if ((x >= 5 && x <= 7 && y >= 5 && y <= 7) ||
                 (x >= 5 && x <= 7 && y >= 17 && y <= 19) ||
                 (x >= 17 && x <= 19 && y >= 5 && y <= 7) ||
                 (x >= 17 && x <= 19 && y >= 17 && y <= 19) ||
                 (x >= 11 && x <= 13 && y >= 11 && y <= 13)) {
          tileType = TileType.safe;
        }
        // PvP zones (edges)
        else if (x == 0 || x == 24 || y == 0 || y == 24) {
          tileType = TileType.pvp;
        }
        // PvE zones (middle areas)
        else if (x >= 8 && x <= 16 && y >= 8 && y <= 16) {
          tileType = TileType.pve;
        }
        // Dangerous zones (random patches)
        else if ((x * y) % 13 == 0) {
          tileType = TileType.dangerous;
        }
        // Wilderness
        else {
          tileType = TileType.wilderness;
        }
        
        tiles.add(WorldTile(
          x: x,
          y: y,
          type: tileType,
          villageType: null,
          villageName: null,
          description: 'Open wilderness',
          availableActions: ['explore', 'gather'],
          isOccupied: false,
          occupiedBy: null,
          statModifiers: {},
          specialEffects: [],
          dangerLevel: 1,
          isRestricted: false,
        ));
      }
    }
    
    return World(
      id: 'world_1',
      width: 25,
      height: 25,
      tiles: tiles,
      villageLocations: {},
      activePlayers: <String>[],
      lastUpdated: DateTime.now(),
    );
  }
}
