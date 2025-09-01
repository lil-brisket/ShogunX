import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseTest {
  static Future<bool> testConnection() async {
    try {
      // Test Firestore connection
      final firestore = FirebaseFirestore.instance;
      final testDoc = firestore.collection('test').doc('connection_test');
      
      // Write test data
      await testDoc.set({
        'timestamp': FieldValue.serverTimestamp(),
        'test': true,
        'message': 'Firebase connection test successful',
      });
      
      // Read test data
      final doc = await testDoc.get();
      if (doc.exists) {
        print('✅ Firebase connection test successful!');
        print('📄 Test document data: ${doc.data()}');
        
        // Clean up test data
        await testDoc.delete();
        print('🧹 Test data cleaned up');
        
        return true;
      } else {
        print('❌ Firebase connection test failed: Document not found');
        return false;
      }
    } catch (e) {
      print('❌ Firebase connection test failed: $e');
      return false;
    }
  }
  
  static Future<void> testCollections() async {
    try {
      final firestore = FirebaseFirestore.instance;
      
      // Test collections exist
      final collections = [
        'users',
        'characters', 
        'villages',
        'clans',
        'missions',
        'jutsus',
        'items',
        'world',
        'chat',
        'battles',
        'transactions',
        'training_sessions',
        'hospital_records',
        'game_updates',
      ];
      
      print('🔍 Testing Firestore collections...');
      
      for (final collectionName in collections) {
        try {
          final collection = firestore.collection(collectionName);
          final snapshot = await collection.limit(1).get();
          print('✅ Collection "$collectionName" is accessible');
        } catch (e) {
          print('⚠️ Collection "$collectionName" has issues: $e');
        }
      }
      
      print('🎉 Firestore collections test completed!');
    } catch (e) {
      print('❌ Firestore collections test failed: $e');
    }
  }
}
