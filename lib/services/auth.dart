import 'package:firebase_auth/firebase_auth.dart';
import 'package:ryta_app/models/user.dart';
import 'package:ryta_app/services/database.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user object based on firebase user
  RytaUser _userFromFirebaseUser(User user) {
    return user != null ? RytaUser(uid: user.uid, email: user.email, name: user.displayName) : null;
  }

  // Gets called when Auth changes occurs.
  // Sign in: RytaUser object
  // Sign out: null
  Stream<RytaUser> get user {
    return _auth.authStateChanges()
      //.map((User user) => _userFromFirebaseUser(user));
      .map(_userFromFirebaseUser);
  }
  
  // Sign in anom. Throws an eror if User doesn't have a valid uid.
    Future signInAnon() async {
      try {
        UserCredential result = await _auth.signInAnonymously();
        User user = result.user;
        return _userFromFirebaseUser(user);
      } catch(e) {
        print(e.toString());
        return null;
      }

    }

  // sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User user = result.user;
      return _userFromFirebaseUser(user);
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  // register with email and password
  Future registerWithEmailAndPassword(String email, String password, String username) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User user = result.user;

      // create a new document for the user with the uid
      await DatabaseService(uid: user.uid).updateUserData(username, email); //pass the name from registration form
      return _userFromFirebaseUser(user);
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch(e){
      print(e.toString());
      return null;
    }
  }

}
