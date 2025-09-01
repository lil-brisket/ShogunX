import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(firebaseAuthProvider).authStateChanges();
});

final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(authStateProvider).value;
});

final isAdminProvider = FutureProvider<bool>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return false;
  
  try {
    final adminDoc = await ref
        .read(firestoreProvider)
        .collection('admins')
        .doc(user.uid)
        .get();
    
    return adminDoc.exists;
  } catch (e) {
    return false;
  }
});

class AuthService {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  
  AuthService(this._auth, this._firestore);
  
  Future<UserCredential> signInWithEmailAndPassword(
    String email, 
    String password,
  ) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
  
  Future<void> signOut() async {
    await _auth.signOut();
  }
  
  Future<bool> isAdmin(String userId) async {
    try {
      final adminDoc = await _firestore
          .collection('admins')
          .doc(userId)
          .get();
      
      return adminDoc.exists;
    } catch (e) {
      return false;
    }
  }
}
