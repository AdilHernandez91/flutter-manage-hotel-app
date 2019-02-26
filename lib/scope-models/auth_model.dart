import 'package:scoped_model/scoped_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user.dart';

mixin AuthModel on Model {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User _currentUser;

  User get currentUser {
    return _currentUser;
  }

  void authenticate(FirebaseUser user) {
    _currentUser = User(id: user.uid, email: user.email);
    notifyListeners();
  }

  Future<void> logIn(String email, String password) async {
    return await _auth
        .signInWithEmailAndPassword(email: email, password: password);
  }

  Future<FirebaseUser> getCurrentUser() async {
    return await _auth.currentUser();
  }

  Future<void> signUp(String email, String password) async {
    return await _auth
        .createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signOut() async {
    return await _auth.signOut();
  }
}