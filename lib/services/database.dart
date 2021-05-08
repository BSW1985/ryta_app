import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ryta_app/models/goal.dart';
import 'package:ryta_app/models/user_file.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  // collection reference
  final CollectionReference rytaUsersCollection =
      FirebaseFirestore.instance.collection('ryta_users');

  // check if a document with the same user uid already exist or not
  Future getUID() async {
    return await rytaUsersCollection
        .doc(uid)
        .get()
        .then((variable) => print(variable.data()['email'].toString()));
  }

  // USERFILE - Handling communication with Firestore
  Future initializeUserData(
      String name, String email, bool emailVerified) async {
    // initialize the price between 2.99 and 7.99
    double randomNumber = 0.99 + 2 + Random().nextInt(5);

    return await rytaUsersCollection.doc(uid).set({
      'name': name,
      'email': email,
      'emailVerified': emailVerified,
      'willToPay': false,
      'package1': false,
      'package2': false,
      'package3': false,
      // 'package4': false,
      'price': 0.111,
      'priceInitialized': randomNumber,
      'throughIntroduction': false,
      'newsletterSubscription': true,
    });
  }

  Future updateEmailVerified(bool emailVerified) async {
    return await rytaUsersCollection.doc(uid).update({
      'emailVerified': emailVerified,
    });
  }

  // Testing button
  Future updateUserWillingnessToPay(bool willToPay, bool package1,
      bool package2, bool package3, double price) async {
    return await rytaUsersCollection.doc(uid).update({
      'willToPay': willToPay,
      'package1': package1,
      'package2': package2,
      'package3': package3,
      // 'package4': package4,
      'price': price,
    });
  }

  // Is user through Introduction?
  Future updateThroughIntroduction(bool throughIntroduction) async {
    return await rytaUsersCollection.doc(uid).update({
      'throughIntroduction': throughIntroduction,
    });
  }

  // Newsletter subscription?
  Future updateNewsletterSubscription(bool newsletterSubscription) async {
    return await rytaUsersCollection.doc(uid).update({
      'newsletterSubscription': newsletterSubscription,
    });
  }

// Stream of USERFILE called in home
//
  Stream<UserFile> get userfile {
    try {
      return rytaUsersCollection
          .doc(uid)
          .snapshots()
          .map(_userFileFromSnapshot);
    } catch (e) {
      return null;
    }
  }

  UserFile _userFileFromSnapshot(DocumentSnapshot snapshot) {
    return UserFile(
      name: snapshot.data()['name'] ?? '',
      willToPay: snapshot.data()['willToPay'] ?? '',
      package1: snapshot.data()['package1'] ?? '',
      package2: snapshot.data()['package2'] ?? '',
      package3: snapshot.data()['package3'] ?? '',
      // package4: snapshot.data()['package4'] ?? '',
      price: snapshot.data()['price'] ?? '',
      priceInitialized: snapshot.data()['priceInitialized'] ?? '',
      throughIntroduction: snapshot.data()['throughIntroduction'] ?? '',
      newsletterSubscription: snapshot.data()['newsletterSubscription'] ?? '',
    );
  }

  // GOALS - Handling communication with Firestore

  Future addUserGoals(
      String goalname,
      String goalmotivation,
      String imageUrl,
      String imageID,
      String goalBackgoundColor,
      String goalFontColor,
      String goalCategory) async {
    return await rytaUsersCollection.doc(uid).collection('goals').doc().set({
      'goalname': goalname,
      'goalmotivation': goalmotivation,
      'imageUrl': imageUrl,
      'imageID': imageID,
      'goalBackgoundColor': goalBackgoundColor,
      'goalFontColor': goalFontColor,
      'goalCategory': goalCategory,
    });
  }

  Future editUserGoals(int goalIndex, String goalname, String goalmotivation,
      String imageUrl) async {
    //get the coresponding goal from firebase
    final goalFirestoreId = await getGoalId(goalIndex);
    try {
      return await rytaUsersCollection
          .doc(uid)
          .collection('goals')
          .doc(goalFirestoreId)
          .update({
        'goalname': goalname,
        'goalmotivation': goalmotivation,
      });
    } catch (e) {
      print(e);
    }
  }

  //get goal ID
  Future<String> getGoalId(int goalIndex) async {
    int i = 0;
    dynamic goalFirestoreId = '';
    await rytaUsersCollection.doc(uid).collection('goals').get().then(
          (QuerySnapshot snapshot) => {
            snapshot.docs.forEach((f) {
              if (i == goalIndex) goalFirestoreId = f.reference.id;
              i = i + 1;
            }),
          },
        );
    return goalFirestoreId;
  }

  Future deleteUserGoals(String goalID) async {
    return await rytaUsersCollection
        .doc(uid)
        .collection('goals')
        .doc(goalID)
        .delete();
  }

// Stream of goals called in home
  // goal list from snapshot
  List<Goal> _goalListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Goal(
        goalID: doc.id,
        goalname: doc.data()['goalname'] ?? '',
        goalmotivation: doc.data()['goalmotivation'] ?? '',
        imageUrl: doc.data()['imageUrl'] ?? '',
        imageID: doc.data()['imageID'] ?? '',
        goalBackgoundColor: doc.data()['goalBackgoundColor'] ?? '',
        goalFontColor: doc.data()['goalFontColor'] ?? '',
        goalCategory: doc.data()['goalCategory'] ?? '',
      );
    }).toList();
  }

  // // get goals stream
  Stream<List<Goal>> get goals {
    return rytaUsersCollection
        .doc(uid)
        .collection('goals')
        .snapshots()
        .map(_goalListFromSnapshot);
  }
}
