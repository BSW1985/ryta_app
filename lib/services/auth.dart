import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ryta_app/models/user.dart';
import 'package:ryta_app/services/database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user object based on firebase user
  RytaUser _userFromFirebaseUser(User user) {
    return user != null
        ? RytaUser(
            uid: user.uid,
            email: user.email,
            displayName: user.displayName,
            emailVerified: user.emailVerified)
        : null;
  }

  // Gets called when Auth changes occurs.
  // Sign in: RytaUser object
  // Sign out: null
  Stream<RytaUser> get user {
    return _auth
        .authStateChanges()
        //.map((User user) => _userFromFirebaseUser(user));
        .map(_userFromFirebaseUser);
  }

  // Sign in anom. Throws an eror if User doesn't have a valid uid.
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;

      //Update the emailVerified bool in Firestore
      DatabaseService(uid: user.uid).updateEmailVerified(user.emailVerified);

      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // register with email and password
  Future registerWithEmailAndPassword(
      String email, String password, String username) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      user.updateProfile(displayName: username);
      await user.sendEmailVerification();

      // create a new document for the user with the uid
      await DatabaseService(uid: user.uid).initializeUserData(username, email,
          user.emailVerified); //pass the name from registration form
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //Log in using google
  Future<dynamic> googleSignIn() async {
    try {
      // Step 1
      GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
      // Step 2
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      UserCredential _res = await _auth.signInWithCredential(credential);
      User user = _res.user;

      // create a new document for the user with the uid
      await DatabaseService(uid: user.uid).initializeUserData(
          user.displayName,
          user.email,
          user.emailVerified); //pass the name from registration form
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
  //   //Add the data to the database
  //   userProfile = UserProfile.fromFirebaseUser(firebaseUser);
  //   await FirestoreService.getUserData();
  //   if (userProfile.uid == null || userProfile.email == null) {
  //     userProfile = UserProfile.fromFirebaseUser(firebaseUser);
  //     await FirestoreService.setUserData();
  //   }

  //   //Get the data from the database
  //   FirestoreService.getUserData();

  //   return firebaseUser;
  // }

}
