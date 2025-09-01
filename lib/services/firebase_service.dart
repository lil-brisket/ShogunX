import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../models/models.dart';
import 'banking_service.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;

  // Collection references
  CollectionReference get users => _firestore.collection('users');
  CollectionReference get characters => _firestore.collection('characters');
  CollectionReference get villages => _firestore.collection('villages');
  CollectionReference get clans => _firestore.collection('clans');
  CollectionReference get missions => _firestore.collection('missions');
  CollectionReference get jutsus => _firestore.collection('jutsus');
  CollectionReference get items => _firestore.collection('items');
  CollectionReference get world => _firestore.collection('world');
  CollectionReference get chat => _firestore.collection('chat');
  CollectionReference get battles => _firestore.collection('battles');
  CollectionReference get transactions => _firestore.collection('transactions');
  CollectionReference get trainingSessions => _firestore.collection('training_sessions');
  CollectionReference get hospitalRecords => _firestore.collection('hospital_records');
  CollectionReference get gameUpdates => _firestore.collection('game_updates');

  // Authentication
  firebase_auth.User? get currentUser => _auth.currentUser;
  bool get isAuthenticated => _auth.currentUser != null;

  // Auth methods
  Future<firebase_auth.UserCredential> signInWithEmailAndPassword(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<firebase_auth.UserCredential> createUserWithEmailAndPassword(String email, String password) async {
    return await _auth.createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  // User operations
  Future<void> createUser(User user) async {
    await users.doc(user.id).set(user.toJson());
  }

  Future<User?> getUser(String userId) async {
    final doc = await users.doc(userId).get();
    if (doc.exists) {
      final data = doc.data()!;
      return User.fromJson(Map<String, dynamic>.from(data as Map));
    }
    return null;
  }

  Future<void> updateUser(String userId, Map<String, dynamic> data) async {
    await users.doc(userId).update(data);
  }

  // Character operations
  Future<void> createCharacter(Character character) async {
    await characters.doc(character.id).set(character.toJson());
  }

  Future<Character?> getCharacter(String characterId) async {
    final doc = await characters.doc(characterId).get();
    if (doc.exists) {
      final data = doc.data()!;
      return Character.fromJson(Map<String, dynamic>.from(data as Map));
    }
    return null;
  }

  Future<List<Character>> getCharactersByUser(String userId) async {
    final querySnapshot = await characters
        .where('userId', isEqualTo: userId)
        .get();
    
    return querySnapshot.docs
        .map((doc) => Character.fromJson(Map<String, dynamic>.from(doc.data() as Map)))
        .toList();
  }

  Future<void> updateCharacter(String characterId, Map<String, dynamic> data) async {
    await characters.doc(characterId).update({
      ...data,
      'lastUpdated': FieldValue.serverTimestamp(),
    });
  }

  Future<List<Character>> getCharactersByVillage(String village) async {
    final querySnapshot = await characters
        .where('village', isEqualTo: village)
        .get();
    
    return querySnapshot.docs
        .map((doc) => Character.fromJson(Map<String, dynamic>.from(doc.data() as Map)))
        .toList();
  }

  // Village operations
  Future<Village?> getVillage(String villageName) async {
    final doc = await villages.doc(villageName).get();
    if (doc.exists) {
      final data = doc.data()!;
      return Village.fromJson(Map<String, dynamic>.from(data as Map));
    }
    return null;
  }

  Future<List<Village>> getAllVillages() async {
    final querySnapshot = await villages.get();
    return querySnapshot.docs
        .map((doc) => Village.fromJson(Map<String, dynamic>.from(doc.data() as Map)))
        .toList();
  }

  // Clan operations
  Future<void> createClan(Clan clan) async {
    await clans.doc(clan.id).set(clan.toJson());
  }

  Future<Clan?> getClan(String clanId) async {
    final doc = await clans.doc(clanId).get();
    if (doc.exists) {
      final data = doc.data()!;
      return Clan.fromJson(Map<String, dynamic>.from(data as Map));
    }
    return null;
  }

  Future<List<Clan>> getClansByVillage(String village) async {
    final querySnapshot = await clans
        .where('village', isEqualTo: village)
        .get();
    
    return querySnapshot.docs
        .map((doc) => Clan.fromJson(Map<String, dynamic>.from(doc.data() as Map)))
        .toList();
  }

  Future<void> updateClan(String clanId, Map<String, dynamic> data) async {
    await clans.doc(clanId).update({
      ...data,
      'lastUpdated': FieldValue.serverTimestamp(),
    });
  }

  // Mission operations
  Future<List<Mission>> getMissionsByVillage(String village) async {
    final querySnapshot = await missions
        .where('village', isEqualTo: village)
        .where('isAvailable', isEqualTo: true)
        .get();
    
    return querySnapshot.docs
        .map((doc) => Mission.fromJson(Map<String, dynamic>.from(doc.data() as Map)))
        .toList();
  }

  Future<List<Mission>> getMissionsByRank(String village, String rank) async {
    final querySnapshot = await missions
        .where('village', isEqualTo: village)
        .where('rank', isEqualTo: rank)
        .where('isAvailable', isEqualTo: true)
        .get();
    
    return querySnapshot.docs
        .map((doc) => Mission.fromJson(Map<String, dynamic>.from(doc.data() as Map)))
        .toList();
  }

  // Jutsu operations
  Future<List<Jutsu>> getAllJutsus() async {
    final querySnapshot = await jutsus
        .where('isAvailable', isEqualTo: true)
        .get();
    
    return querySnapshot.docs
        .map((doc) => Jutsu.fromJson(Map<String, dynamic>.from(doc.data() as Map)))
        .toList();
  }

  Future<Jutsu?> getJutsu(String jutsuId) async {
    final doc = await jutsus.doc(jutsuId).get();
    if (doc.exists) {
      final data = doc.data()!;
      return Jutsu.fromJson(Map<String, dynamic>.from(data as Map));
    }
    return null;
  }

  // Item operations
  Future<List<Item>> getItemsByCategory(String category) async {
    final querySnapshot = await items
        .where('shopCategory', isEqualTo: category)
        .where('isAvailableInShop', isEqualTo: true)
        .get();
    
    return querySnapshot.docs
        .map((doc) => Item.fromJson(Map<String, dynamic>.from(doc.data() as Map)))
        .toList();
  }

  Future<Item?> getItem(String itemId) async {
    final doc = await items.doc(itemId).get();
    if (doc.exists) {
      final data = doc.data()!;
      return Item.fromJson(Map<String, dynamic>.from(data as Map));
    }
    return null;
  }

  // World operations
  Future<World?> getWorld() async {
    final doc = await world.doc('world_map').get();
    if (doc.exists) {
      final data = doc.data()!;
      return World.fromJson(Map<String, dynamic>.from(data as Map));
    }
    return null;
  }

  Future<void> updateWorldPosition(String characterId, int x, int y, String village) async {
    await characters.doc(characterId).update({
      'worldPosition': {
        'x': x,
        'y': y,
        'village': village,
      },
      'lastUpdated': FieldValue.serverTimestamp(),
    });
  }

  // Chat operations
  Stream<QuerySnapshot> getChatStream(String chatType, {String? village}) {
    Query query = chat.where('type', isEqualTo: chatType);
    if (village != null) {
      query = query.where('village', isEqualTo: village);
    }
    return query.orderBy('lastMessageAt', descending: true).limit(50).snapshots();
  }

  Future<void> sendChatMessage(String chatId, ChatMessage message) async {
    await chat.doc(chatId).update({
      'messages': FieldValue.arrayUnion([message.toJson()]),
      'lastMessageAt': FieldValue.serverTimestamp(),
    });
  }

  // Battle operations
  Future<void> createBattle(Battle battle) async {
    await battles.doc(battle.id).set(battle.toJson());
  }

  Future<List<Battle>> getBattlesByCharacter(String characterId) async {
    final querySnapshot = await battles
        .where('participants.characterId', arrayContains: characterId)
        .orderBy('startedAt', descending: true)
        .limit(20)
        .get();
    
    return querySnapshot.docs
        .map((doc) => Battle.fromJson(Map<String, dynamic>.from(doc.data() as Map)))
        .toList();
  }

  // Transaction operations
  Future<void> createTransaction(BankTransaction transaction) async {
    await transactions.doc(transaction.id).set(transaction.toJson());
  }

  Future<List<BankTransaction>> getTransactionsByCharacter(String characterId) async {
    final querySnapshot = await transactions
        .where('characterId', isEqualTo: characterId)
        .orderBy('timestamp', descending: true)
        .limit(50)
        .get();
    
    return querySnapshot.docs
        .map((doc) => BankTransaction.fromJson(Map<String, dynamic>.from(doc.data() as Map)))
        .toList();
  }

  // Training operations
  Future<void> createTrainingSession(TrainingSession session) async {
    await trainingSessions.doc(session.id).set(session.toJson());
  }

  Future<List<TrainingSession>> getTrainingSessionsByCharacter(String characterId) async {
    final querySnapshot = await trainingSessions
        .where('characterId', isEqualTo: characterId)
        .orderBy('startedAt', descending: true)
        .limit(20)
        .get();
    
    return querySnapshot.docs
        .map((doc) => TrainingSession.fromJson(Map<String, dynamic>.from(doc.data() as Map)))
        .toList();
  }

  // Hospital operations
  Future<void> createHospitalRecord(HospitalRecord record) async {
    await hospitalRecords.doc(record.id).set(record.toJson());
  }

  Future<List<HospitalRecord>> getHospitalRecordsByCharacter(String characterId) async {
    final querySnapshot = await hospitalRecords
        .where('patientId', isEqualTo: characterId)
        .orderBy('treatedAt', descending: true)
        .limit(20)
        .get();
    
    return querySnapshot.docs
        .map((doc) => HospitalRecord.fromJson(Map<String, dynamic>.from(doc.data() as Map)))
        .toList();
  }

  // Game updates operations
  Stream<QuerySnapshot> getGameUpdatesStream() {
    return gameUpdates
        .where('isActive', isEqualTo: true)
        .orderBy('publishedAt', descending: true)
        .limit(10)
        .snapshots();
  }

  // Real-time listeners
  Stream<DocumentSnapshot> characterStream(String characterId) {
    return characters.doc(characterId).snapshots();
  }

  Stream<QuerySnapshot> villageCharactersStream(String village) {
    return characters
        .where('village', isEqualTo: village)
        .snapshots();
  }

  Stream<DocumentSnapshot> clanStream(String clanId) {
    return clans.doc(clanId).snapshots();
  }

  // Batch operations
  Future<void> updateCharacterStats(String characterId, Map<String, dynamic> stats) async {
    final batch = _firestore.batch();
    
    batch.update(characters.doc(characterId), {
      ...stats,
      'lastUpdated': FieldValue.serverTimestamp(),
    });
    
    await batch.commit();
  }

  Future<void> processMissionCompletion(String characterId, String missionId, Map<String, dynamic> rewards) async {
    final batch = _firestore.batch();
    
    // Update character stats
    batch.update(characters.doc(characterId), {
      'experience': FieldValue.increment(rewards['experience'] ?? 0),
      'ryoOnHand': FieldValue.increment(rewards['ryo'] ?? 0),
      'lastUpdated': FieldValue.serverTimestamp(),
    });
    
    // Create transaction record
    final transactionId = 'txn_${DateTime.now().millisecondsSinceEpoch}';
    final transaction = BankTransaction(
      id: transactionId,
      characterId: characterId,
      type: TransactionType.missionReward,
      amount: rewards['ryo'] ?? 0,
      description: 'Completed mission: ${rewards['missionTitle'] ?? 'Unknown'}',
      timestamp: DateTime.now(),
      metadata: {
        'missionId': missionId,
        'missionTitle': rewards['missionTitle'],
        'experience': rewards['experience'],
      },
    );
    
    batch.set(transactions.doc(transactionId), transaction.toJson());
    
    await batch.commit();
  }

  // Error handling
  String handleFirebaseError(dynamic error) {
    if (error is FirebaseException) {
      switch (error.code) {
        case 'permission-denied':
          return 'You do not have permission to perform this action.';
        case 'not-found':
          return 'The requested data was not found.';
        case 'already-exists':
          return 'This item already exists.';
        case 'resource-exhausted':
          return 'Service temporarily unavailable. Please try again later.';
        case 'failed-precondition':
          return 'Operation failed due to a precondition not being met.';
        case 'aborted':
          return 'Operation was aborted. Please try again.';
        case 'out-of-range':
          return 'The operation is out of range.';
        case 'unimplemented':
          return 'This operation is not implemented.';
        case 'internal':
          return 'An internal error occurred. Please try again.';
        case 'unavailable':
          return 'Service is currently unavailable. Please try again later.';
        case 'data-loss':
          return 'Data loss occurred. Please contact support.';
        case 'unauthenticated':
          return 'You must be logged in to perform this action.';
        default:
          return 'An error occurred: ${error.message}';
      }
    }
    return 'An unexpected error occurred.';
  }
}

// Extension methods for model conversion
extension UserExtension on User {
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'createdAt': createdAt.toIso8601String(),
      'lastLogin': lastLogin.toIso8601String(),
      'isActive': isActive,
      'isVerified': isVerified,
      'displayName': displayName,
      'avatarUrl': avatarUrl,
      'bio': bio,
      'preferences': preferences,
      'isBanned': isBanned,
      'banReason': banReason,
      'banExpiry': banExpiry?.toIso8601String(),
      'warningCount': warningCount,
      'friends': friends,
      'blockedUsers': blockedUsers,
      'ignoredUsers': ignoredUsers,
      'currentCharacterId': currentCharacterId,
      'characterIds': characterIds,
      'lastVillage': lastVillage,
      'lastActivity': lastActivity?.toIso8601String(),
    };
  }
}

// Note: You'll need to add similar extension methods for other models
// (Village, Battle, TrainingSession, HospitalRecord) or update their existing toJson/fromJson methods
// to be compatible with Firestore data types.
