import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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

  //reset password
  Future passwordReset(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return "success";
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
      //initialize timestamp
      DateTime currentPhoneDate = DateTime.now(); //DateTime
      Timestamp eventTimeStamp = Timestamp.fromDate(currentPhoneDate);
      await DatabaseService(uid: user.uid).addUserGoals(
        "Visualization is powerful",
        "Visualization techniques have been used by successful people for ages, helping them create their dream lives. We all have this awesome power, but most of us have never been taught to use it effectively.",
        "https://images.unsplash.com/photo-1542224566-6e85f2e6772f?crop=entropy&cs=srgb&fm=jpg&ixid=MnwyMTc1MzV8MHwxfHNlYXJjaHwxOHx8bW91bnRhaW5zfGVufDB8fDF8fDE2MTkwMjkyMTg&ixlib=rb-1.2.1&q=85",
        "dI7vfR1Bqcg",
        "#ff2a2609",
        "#fff7c759",
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        eventTimeStamp,
      );

      // cache the intro image
      CachedNetworkImage(
        imageUrl:
            "https://images.unsplash.com/photo-1542224566-6e85f2e6772f?crop=entropy&cs=srgb&fm=jpg&ixid=MnwyMTc1MzV8MHwxfHNlYXJjaHwxOHx8bW91bnRhaW5zfGVufDB8fDF8fDE2MTkwMjkyMTg&ixlib=rb-1.2.1&q=85",
        placeholder: (context, url) => CircularProgressIndicator(),
        errorWidget: (context, url, error) => Icon(Icons.error),
      );
      // create a new document for the user with the uid
      await DatabaseService(uid: user.uid).initializeUserData(
          username,
          email,
          user.emailVerified,
          eventTimeStamp); //pass the name from registration form
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

  // delete user
  Future deleteUser(String uid, String name, String email) async {
    // String uid=_auth.currentUser.uid;
    bool deleted;
    try {
      //delete user data
      deleted = true;
      await DatabaseService(uid: uid).deleteUserData(deleted, name, email);

      await _auth.currentUser.delete();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        //reauthenticate user
        //google
        // Step 1
        try {
          GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
          // Step 2
          GoogleSignInAuthentication googleAuth =
              await googleUser.authentication;
          final AuthCredential credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );
          await _auth.currentUser.reauthenticateWithCredential(credential);

          //delete user data
          deleted = true;
          await DatabaseService(uid: uid).deleteUserData(deleted, name, email);

          await _auth.currentUser.delete();
        } catch (f) {
          print(
              'The user must reauthenticate before this operation can be executed.');
          deleted = false;
          await DatabaseService(uid: uid).deleteUserData(deleted, name, email);
          return f;
          // await _auth.currentUser.reauthenticateWithCredential(credential);
          // await _auth.currentUser.delete();
        }
      }
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
      //only if the user does not exist yet
      // try {
      //   _auth.createUserWithEmailAndPassword(
      //       email: user.email, password: 'password');
      // } catch (signUpError) {
      //   if (signUpError.code == 'email-already-in-use') {
      //       /// email has already been registered.
      //     } else {
      //       // create a new document for the user with the uid
      //       await DatabaseService(uid: user.uid).initializeUserData(
      //           user.displayName, user.email, user.emailVerified);
      //       await DatabaseService(uid: user.uid).addUserGoals(
      //         "Visualization is powerful",
      //         "motivation1",
      //         "https://images.unsplash.com/photo-1542224566-6e85f2e6772f?crop=entropy&cs=srgb&fm=jpg&ixid=MnwyMTc1MzV8MHwxfHNlYXJjaHwxOHx8bW91bnRhaW5zfGVufDB8fDF8fDE2MTkwMjkyMTg&ixlib=rb-1.2.1&q=85",
      //         "dI7vfR1Bqcg",
      //         "#ff2a2609",
      //         "#fff7c759",
      //         "introduction",
      //       );
      //     }
      //   }
      try {
        await DatabaseService(uid: user.uid).getUID();
      } catch (e) {
        print(e.toString());

        // cache the intro image
        CachedNetworkImage(
          imageUrl:
              "https://images.unsplash.com/photo-1542224566-6e85f2e6772f?crop=entropy&cs=srgb&fm=jpg&ixid=MnwyMTc1MzV8MHwxfHNlYXJjaHwxOHx8bW91bnRhaW5zfGVufDB8fDF8fDE2MTkwMjkyMTg&ixlib=rb-1.2.1&q=85",
          placeholder: (context, url) => CircularProgressIndicator(),
          errorWidget: (context, url, error) => Icon(Icons.error),
        );
        //initialize timestamp
        DateTime currentPhoneDate = DateTime.now(); //DateTime
        Timestamp eventTimeStamp = Timestamp.fromDate(currentPhoneDate);
        await DatabaseService(uid: user.uid).initializeUserData(
            user.displayName, user.email, user.emailVerified, eventTimeStamp);
        await DatabaseService(uid: user.uid).addUserGoals(
          "Visualization is powerful",
          "motivation1",
          "https://images.unsplash.com/photo-1542224566-6e85f2e6772f?crop=entropy&cs=srgb&fm=jpg&ixid=MnwyMTc1MzV8MHwxfHNlYXJjaHwxOHx8bW91bnRhaW5zfGVufDB8fDF8fDE2MTkwMjkyMTg&ixlib=rb-1.2.1&q=85",
          "dI7vfR1Bqcg",
          "#ff2a2609",
          "#fff7c759",
          false,
          false,
          false,
          false,
          false,
          false,
          false,
          false,
          false,
          false,
          false,
          false,
          false,
          false,
          eventTimeStamp,
        );
        // return null;
        return _userFromFirebaseUser(user);
      }

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
