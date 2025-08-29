import '../models/models.dart';
import 'game_service.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  User? _currentUser;
  bool _isAuthenticated = false;

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _isAuthenticated;

  Future<bool> login(String username, String password) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Stub authentication logic
    if (username.isNotEmpty && password.isNotEmpty) {
      _currentUser = User(
        id: 'user_${username.hashCode}',
        username: username,
        email: '$username@example.com',
        isActive: true,
        isVerified: false,
        displayName: username,
        avatarUrl: null,
        bio: null,
        preferences: {},
        isBanned: false,
        banReason: null,
        banExpiry: null,
        warningCount: 0,
        friends: [],
        blockedUsers: [],
        ignoredUsers: [],
        currentCharacterId: null,
        characterIds: [],
        lastVillage: 'Konoha',
        lastActivity: DateTime.now(),
        createdAt: DateTime.now(),
        lastLogin: DateTime.now(),
      );
      _isAuthenticated = true;
      return true;
    }
    return false;
  }

  Future<bool> register(String username, String password, String village) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Stub registration logic
    if (username.isNotEmpty && password.isNotEmpty && village.isNotEmpty) {
      final userId = 'user_${username.hashCode}';
      
      // Create a default character for the new user
      final defaultCharacter = _createDefaultCharacter(userId, username, village);
      
      // Save the character to the game service
      await GameService().createCharacter(defaultCharacter);
      
      _currentUser = User(
        id: userId,
        username: username,
        email: '$username@example.com',
        isActive: true,
        isVerified: false,
        displayName: username,
        avatarUrl: null,
        bio: null,
        preferences: {},
        isBanned: false,
        banReason: null,
        banExpiry: null,
        warningCount: 0,
        friends: [],
        blockedUsers: [],
        ignoredUsers: [],
        currentCharacterId: defaultCharacter.id,
        characterIds: [defaultCharacter.id],
        lastVillage: village,
        lastActivity: DateTime.now(),
        createdAt: DateTime.now(),
        lastLogin: DateTime.now(),
      );
      _isAuthenticated = true;
      return true;
    }
    return false;
  }

  Character _createDefaultCharacter(String userId, String username, String village) {
    return Character(
      id: 'char_${userId}_${DateTime.now().millisecondsSinceEpoch}',
      userId: userId,
      name: username,
      village: village,
      clanId: null,
      clanRank: null,
      ninjaRank: 'Genin',
      elements: _getRandomElements(),
      bloodline: null,
      strength: 1000,
      intelligence: 1000,
      speed: 1000,
      defense: 1000,
      willpower: 1000,
      bukijutsu: 1000,
      ninjutsu: 1000,
      taijutsu: 1000,
      bloodlineEfficiency: 0,
      jutsuMastery: {},
      currentHp: 40000, // maxHp = (1000*2 + 1000) * 10 = 30000, but we'll set it higher for starting
      currentChakra: 30000, // maxChakra = (1000*2 + 1000) * 10 = 30000
      currentStamina: 30000, // maxStamina = (1000*2 + 1000) * 10 = 30000
      experience: 0,
      level: 1,
      ryoOnHand: 1000,
      ryoBanked: 0,
      villageLoyalty: 100,
      outlawInfamy: 0,
      marriedTo: null,
      senseiId: null,
      studentIds: [],
      pvpWins: 0,
      pvpLosses: 0,
      pveWins: 0,
      pveLosses: 0,
      avatarUrl: null,
      gender: 'Unknown',
    );
  }

  List<String> _getRandomElements() {
    final allElements = ['Fire', 'Water', 'Earth', 'Wind', 'Lightning'];
    final random = DateTime.now().millisecondsSinceEpoch % allElements.length;
    return [allElements[random]];
  }

  Future<void> logout() async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 200));
    
    _currentUser = null;
    _isAuthenticated = false;
  }

  Future<void> updateUser(User user) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 300));
    
    _currentUser = user;
  }

  List<String> getAvailableVillages() {
    return [
      'Konoha',
      'Suna',
      'Kiri',
      'Kumo',
      'Iwa',
    ];
  }
}
