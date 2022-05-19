import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fly_ads_demo1/models/user_model.dart';
import 'package:fly_ads_demo1/utils/constants.dart';

class AuthenticationHelper {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get user => _auth.currentUser;

  //SIGN UP METHOD
  Future signUp({required UserModel userModel}) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: userModel.email,
        password: userModel.password,
      );

      if (user != null) {
        user!.updateDisplayName(userModel.userName);
      }

      await db.collection('users').add(userModel.toMap());

      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //SIGN IN METHOD
  Future signIn({required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //SIGN OUT METHOD
  Future signOut() async {
    await _auth.signOut();
    log('sign-out');
  }
}
