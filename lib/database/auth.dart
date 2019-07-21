import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseAuth{
  Stream<String> get onAuthStateChanged;
  Future <String> signWithEmailAndPassword(
    String email,
    String password
  );
  Future<String> createUserWithEmailAndPassword(
    String email,
    String password
  );
  Future<String> currentUser();
  Future<String> signOut();
}

class Auth implements BaseAuth{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  // Tells whether or not a user is logged in or not with the user's uid property (user id)
  Stream<String> get onAuthStateChanged => _firebaseAuth.onAuthStateChanged.map((FirebaseUser user) => user?.uid,);

  @override
  // Creates a user with the passed information in our database and returns the user's unique id
  Future<String> createUserWithEmailAndPassword(String email, String password) async {
    return (await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password)).uid;
  }

  @override
  // Returns the current user's unique id
  Future<String> currentUser() async {
    return (await _firebaseAuth.currentUser()).uid;
  }

  @override
  Future<String> signOut() {
    return FirebaseAuth.instance.signOut();
  }

  @override
  Future<String> signWithEmailAndPassword(String email, String password) async {
    return (await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password)).uid;
  }

}