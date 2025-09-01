import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/admin_user.dart';

class UsersService {
  final FirebaseFirestore _firestore;
  
  UsersService(this._firestore);
  
  /// Get all users from Firestore
  Future<List<AdminUser>> getAllUsers() async {
    try {
      final querySnapshot = await _firestore.collection('users').get();
      return querySnapshot.docs.map((doc) {
        return AdminUser.fromFirestore(doc.data(), doc.id);
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch users: $e');
    }
  }
  
  /// Get a specific user by ID
  Future<AdminUser?> getUserById(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        return AdminUser.fromFirestore(doc.data()!, doc.id);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to fetch user: $e');
    }
  }
  
  /// Update user data
  Future<void> updateUser(AdminUser user) async {
    try {
      await _firestore
          .collection('users')
          .doc(user.id)
          .update(user.toFirestore());
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }
  
  /// Reset all cooldowns for a user
  Future<void> resetCooldowns(String userId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .update({
        'cooldowns': {},
        'lastUpdated': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to reset cooldowns: $e');
    }
  }
  
  /// Add item to user inventory
  Future<void> addItemToInventory(String userId, String itemId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .update({
        'inventory': FieldValue.arrayUnion([itemId]),
        'lastUpdated': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to add item to inventory: $e');
    }
  }
  
  /// Remove item from user inventory
  Future<void> removeItemFromInventory(String userId, String itemId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .update({
        'inventory': FieldValue.arrayRemove([itemId]),
        'lastUpdated': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to remove item from inventory: $e');
    }
  }
  
  /// Add jutsu to user
  Future<void> addJutsuToUser(String userId, String jutsuId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .update({
        'jutsus': FieldValue.arrayUnion([jutsuId]),
        'lastUpdated': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to add jutsu to user: $e');
    }
  }
  
  /// Remove jutsu from user
  Future<void> removeJutsuFromUser(String userId, String jutsuId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .update({
        'jutsus': FieldValue.arrayRemove([jutsuId]),
        'lastUpdated': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to remove jutsu from user: $e');
    }
  }
  
  /// Search users by username or email
  Future<List<AdminUser>> searchUsers(String query) async {
    try {
              final querySnapshot = await _firestore
            .collection('users')
            .where('username', isGreaterThanOrEqualTo: query)
            .where('username', isLessThan: '$query\uf8ff')
            .get();
        
        final emailQuerySnapshot = await _firestore
            .collection('users')
            .where('email', isGreaterThanOrEqualTo: query)
            .where('email', isLessThan: '$query\uf8ff')
            .get();
      
      final allDocs = {...querySnapshot.docs, ...emailQuerySnapshot.docs};
      
      return allDocs.map((doc) {
        return AdminUser.fromFirestore(doc.data(), doc.id);
      }).toList();
    } catch (e) {
      throw Exception('Failed to search users: $e');
    }
  }
}
