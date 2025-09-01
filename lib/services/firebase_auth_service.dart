import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../models/models.dart';
import '../utils/logger.dart';

class FirebaseAuthService {
  static final FirebaseAuthService _instance = FirebaseAuthService._internal();
  factory FirebaseAuthService() => _instance;
  FirebaseAuthService._internal();

  firebase_auth.FirebaseAuth? _auth;
  FirebaseFirestore? _firestore;

  User? _currentUser;
  bool _isAuthenticated = false;

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _isAuthenticated;

  // Initialize Firebase services
  void _initializeFirebase() {
    try {
      _auth = firebase_auth.FirebaseAuth.instance;
      _firestore = FirebaseFirestore.instance;
         } catch (e) {
       Logger.warning('Firebase not initialized yet: $e');
       _auth = null;
       _firestore = null;
     }
  }

  // Get auth instance with initialization check
  firebase_auth.FirebaseAuth get auth {
    if (_auth == null) {
      _initializeFirebase();
    }
    return _auth!;
  }

  // Get firestore instance with initialization check
  FirebaseFirestore get firestore {
    if (_firestore == null) {
      _initializeFirebase();
    }
    return _firestore!;
  }

  Future<bool> register(String username, String password, String village) async {
    try {
      // Check if username already exists
      final existingUser = await firestore
          .collection('users')
          .where('username', isEqualTo: username)
          .get();

      if (existingUser.docs.isNotEmpty) {
        throw Exception('Username already exists');
      }

      // Create Firebase Auth user
      final userCredential = await auth.createUserWithEmailAndPassword(
        email: '$username@ninjaworld.com',
        password: password,
      );

      final firebaseUser = userCredential.user;
      if (firebaseUser == null) {
        throw Exception('Failed to create user');
      }

      // Create user document in Firestore
      final userId = firebaseUser.uid;
      final user = User(
        id: userId,
        username: username,
        email: '$username@ninjaworld.com',
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
        lastVillage: village,
        lastActivity: DateTime.now(),
        createdAt: DateTime.now(),
        lastLogin: DateTime.now(),
      );

      // Save user to Firestore
      await firestore.collection('users').doc(userId).set(user.toMap());

      // Create default character
      final defaultCharacter = _createDefaultCharacter(userId, username, village);
      
      // Save character to Firestore
      await firestore.collection('characters').doc(defaultCharacter.id).set(defaultCharacter.toMap());

      // Update user with character reference
      final updatedUser = user.copyWith(
        currentCharacterId: defaultCharacter.id,
        characterIds: [defaultCharacter.id],
      );
      await firestore.collection('users').doc(userId).update({
        'currentCharacterId': defaultCharacter.id,
        'characterIds': [defaultCharacter.id],
      });

      _currentUser = updatedUser;
      _isAuthenticated = true;

             Logger.success('User registered successfully: $username');
       return true;
     } catch (e) {
       Logger.error('Registration failed: $e');
       return false;
     }
  }

  Future<bool> login(String username, String password) async {
    try {
      // Find user by username in Firestore
      final userQuery = await firestore
          .collection('users')
          .where('username', isEqualTo: username)
          .get();

      if (userQuery.docs.isEmpty) {
        throw Exception('User not found');
      }

      final userDoc = userQuery.docs.first;
      final userData = userDoc.data();
      final email = userData['email'] as String;

      // Authenticate with Firebase Auth
      await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Load user data
      _currentUser = User.fromMap(userData);
      _isAuthenticated = true;

      // Update last login
      await firestore.collection('users').doc(userDoc.id).update({
        'lastLogin': DateTime.now(),
        'lastActivity': DateTime.now(),
      });

      // Ensure user has a character - create one if missing
      if (_currentUser!.characterIds.isEmpty) {
               Logger.warning('User has no characters, creating default character...');
       final defaultCharacter = _createDefaultCharacter(_currentUser!.id, username, _currentUser!.lastVillage ?? 'Konoha');
       await saveCharacter(defaultCharacter);
       
       // Update user with character reference
       final updatedUser = _currentUser!.copyWith(
         currentCharacterId: defaultCharacter.id,
         characterIds: [defaultCharacter.id],
       );
       await updateUser(updatedUser);
       _currentUser = updatedUser;
       Logger.success('Default character created for user: $username');
     }

     Logger.success('User logged in successfully: $username');
     return true;
   } catch (e) {
     Logger.error('Login failed: $e');
     return false;
   }
  }

  Future<void> logout() async {
    try {
      await auth.signOut();
      _currentUser = null;
      _isAuthenticated = false;
             Logger.success('User logged out successfully');
     } catch (e) {
       Logger.error('Logout failed: $e');
     }
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
      genjutsu: 0,
      jutsuMastery: {},
      currentHp: 40000,
      currentChakra: 30000,
      currentStamina: 30000,
      experience: 0,
      level: 1,
      hpRegenRate: 100,
      cpRegenRate: 100,
      spRegenRate: 100,
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
      medicalExp: 0,
      avatarUrl: null,
      gender: 'Unknown',
      inventory: [],
      equippedItems: {},
    );
  }

  List<String> _getRandomElements() {
    final allElements = ['Fire', 'Water', 'Earth', 'Wind', 'Lightning'];
    final random = DateTime.now().millisecondsSinceEpoch % allElements.length;
    return [allElements[random]];
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

  Future<List<Character>> getUserCharacters() async {
    if (_currentUser == null) return [];
    
    try {
      final charactersQuery = await firestore
          .collection('characters')
          .where('userId', isEqualTo: _currentUser!.id)
          .get();

      return charactersQuery.docs
          .map((doc) => Character.fromMap(doc.data()))
          .toList();
    } catch (e) {
             Logger.error('Failed to get user characters: $e');
       return [];
     }
  }

  Future<void> updateUser(User user) async {
    try {
      await firestore.collection('users').doc(user.id).update(user.toMap());
      _currentUser = user;
             Logger.success('User updated successfully');
     } catch (e) {
       Logger.error('Failed to update user: $e');
     }
  }

  Future<void> updateCharacter(Character character) async {
    try {
      await firestore.collection('characters').doc(character.id).update(character.toMap());
             Logger.success('Character updated successfully: ${character.name}');
     } catch (e) {
       Logger.error('Failed to update character: $e');
     }
  }

  Future<void> saveCharacter(Character character) async {
    try {
      await firestore.collection('characters').doc(character.id).set(character.toMap());
             Logger.success('Character saved successfully: ${character.name}');
     } catch (e) {
       Logger.error('Failed to save character: $e');
     }
  }

  // Save training session to Firebase
  Future<void> saveTrainingSession(TrainingSession session) async {
    try {
      await firestore.collection('training_sessions').doc(session.id).set(session.toMap());
             Logger.success('Training session saved successfully: ${session.id}');
     } catch (e) {
       Logger.error('Failed to save training session: $e');
     }
  }

  // Load training sessions for a character
  Future<List<TrainingSession>> getCharacterTrainingSessions(String characterId) async {
    try {
      final sessionsQuery = await firestore
          .collection('training_sessions')
          .where('characterId', isEqualTo: characterId)
          .where('isActive', isEqualTo: true)
          .get();

      return sessionsQuery.docs
          .map((doc) => TrainingSession.fromMap(doc.data()))
          .toList();
    } catch (e) {
             Logger.error('Failed to get training sessions: $e');
       return [];
     }
  }

  // Delete training session from Firebase
  Future<void> deleteTrainingSession(String sessionId) async {
    try {
      await firestore.collection('training_sessions').doc(sessionId).delete();
             Logger.success('Training session deleted successfully: $sessionId');
     } catch (e) {
       Logger.error('Failed to delete training session: $e');
     }
  }
}
