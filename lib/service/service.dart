import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print("User: ${userCredential.user}");
      return userCredential.user;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return null;
  }

  Future<User?> signUp(String email, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print("User: ${userCredential.user}");
      return userCredential.user;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return null;
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  get currentUser => _auth.currentUser;

  Future<Map<String, dynamic>> getUserData(String userId) async {
    final DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection("users").doc(userId).get();
    return userDoc.data() as Map<String, dynamic>;
  }
}
