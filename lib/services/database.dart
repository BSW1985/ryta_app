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
  Future initializeUserData(String name, String email, bool emailVerified,
      Timestamp eventTimeStamp) async {
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
      "timeRegistered": eventTimeStamp,
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
      email: snapshot.data()['email'] ?? '',
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
    bool healthVal,
    bool nutritionVal,
    bool sportsVal,
    bool mentalHealthVal,
    bool careerVal,
    bool educationVal,
    bool personalFinanceVal,
    bool networkingVal,
    bool productivityVal,
    bool leisureVal,
    bool personalGrowthVal,
    bool cultureVal,
    bool romanceVal,
    bool socialLifeVal,
    Timestamp eventTimeStamp,
  ) async {
    return await rytaUsersCollection.doc(uid).collection('goals').doc().set({
      'goalname': goalname,
      'goalmotivation': goalmotivation,
      'imageUrl': imageUrl,
      'imageID': imageID,
      'goalBackgoundColor': goalBackgoundColor,
      'goalFontColor': goalFontColor,
      "timeDefined": eventTimeStamp,
      "goalCategory": {
        "health": healthVal,
        "nutrition": nutritionVal,
        "sports": sportsVal,
        "mentalHealth": mentalHealthVal,
        "career": careerVal,
        "education": educationVal,
        "personalFinance": personalFinanceVal,
        "networking": networkingVal,
        "productivity": productivityVal,
        "leisure": leisureVal,
        "personalGrowth": personalGrowthVal,
        "culture": cultureVal,
        "romance": romanceVal,
        "socialLife": socialLifeVal
      }
    });
  }

  Future editUserGoals(int goalIndex, String goalname, String goalmotivation,
      String imageUrl) async {
    //get the coresponding goal from firebase
    final goalFirestoreId = await getGoalId(goalIndex);
    DateTime currentPhoneDate = DateTime.now(); //DateTime
    Timestamp eventTimeStamp = Timestamp.fromDate(currentPhoneDate);

    await rytaUsersCollection
        .doc(uid)
        .collection('goals')
        .doc(goalFirestoreId)
        .collection('goalEdited')
        .add({
      "opened": eventTimeStamp,
    });

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

  Future deleteUserData(bool deleted, String name, String email) async {
    DateTime currentPhoneDate = DateTime.now(); //DateTime
    Timestamp eventTimeStamp = Timestamp.fromDate(currentPhoneDate);
    //delete personal data from firebase
    //add dead instead
    //ad time accountDeleted
    if (deleted == true) {
      return await rytaUsersCollection.doc(uid).update({
        'name': "accountDeleted",
        'email': "accountDeleted",
        "timeAccountDeleted": eventTimeStamp
      });
    } else {
      return await rytaUsersCollection
          .doc(uid)
          .update({'name': name, 'email': email});
    }
  }

  Future writeGoalOpenedTime(int goalIndex) async {
    //get the coresponding goal from firebase
    final goalFirestoreId = await getGoalId(goalIndex);
    DateTime currentPhoneDate = DateTime.now(); //DateTime
    Timestamp eventTimeStamp = Timestamp.fromDate(currentPhoneDate);
    try {
      return await rytaUsersCollection
          .doc(uid)
          .collection('goals')
          .doc(goalFirestoreId)
          .collection('goalOpened')
          .add({
        "opened": eventTimeStamp,
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

  Future deleteUserGoals(String goalID, bool wasReached) async {
    DateTime currentPhoneDate = DateTime.now(); //DateTime
    Timestamp eventTimeStamp = Timestamp.fromDate(currentPhoneDate);

    DocumentReference copyFrom =
        rytaUsersCollection.doc(uid).collection('goals').doc(goalID);

    DocumentReference copyTo =
        rytaUsersCollection.doc(uid).collection('goals_archive').doc(goalID);

    //copy goal
    await copyFrom
        .get()
        .then((value) => {copyTo.set(Map.fromEntries(value.data().entries))});
    try {
      //copy opened times
      await copyFrom.collection('goalOpened').get().then((querySnapshot) {
        querySnapshot.docs.forEach((result) {
          copyTo.collection('goalOpened').doc().set(result.data());
        });
      });
    } catch (e) {}

    //copy edited times
    try {
      await copyFrom.collection('goalEdited').get().then((querySnapshot) {
        querySnapshot.docs.forEach((result) {
          copyTo.collection('goalEdited').doc().set(result.data());
        });
      });
    } catch (e) {}

    //add deleted time & reached bool?
    try {
      await copyTo
          .update({"TimeDeleted": eventTimeStamp, "wasReached": wasReached});
    } catch (e) {}

    //delete subcollections
    try {
      await copyFrom.collection('goalOpened').get().then((querySnapshot) {
        querySnapshot.docs.forEach((result) {
          copyFrom.collection('goalOpened').doc(result.id).delete();
        });
      });
    } catch (e) {}

    try {
      await copyFrom.collection('goalEdited').get().then((querySnapshot) {
        querySnapshot.docs.forEach((result) {
          copyFrom.collection('goalEdited').doc(result.id).delete();
        });
      });
    } catch (e) {}

    //delete goal
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
