import 'package:firebase_auth/firebase_auth.dart';
import 'package:ryta_app/models/user.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  //create user object based on firebase user
  RytaUser _userFromFirebaseUser(User user) {
    return user != null ? RytaUser(uid: user.uid) : null;
  }

  // auth change user stream
  Stream<RytaUser> get user {
    return _auth.authStateChanges()
      //.map((User user) => _userFromFirebaseUser(user));
      .map(_userFromFirebaseUser);
  }
  
  // sing in anom
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

  //register with email and password

  //sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch(e){
      print(e.toString());
      return null;
    }
  }

}