import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:ryta_app/models/goal.dart';

class DatabaseService {
  
  final String uid;
  DatabaseService({ this.uid });

  // collection reference
  final CollectionReference rytaUsersCollection = FirebaseFirestore.instance.collection('ryta_users');

  Future updateUserData(String name, String email) async {
    return await rytaUsersCollection.doc(uid).set({
      'name': name,
      'email': email,
    });
  }

  Future addUserGoals(String goalname, String goalmotivation, String imageUrl, String imageID, String goalBackgoundColor, String goalFontColor, String goalCategory) async {
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

  // Testing button
  Future updateUserWillingnessToPay(bool willToPay) async {
    return await rytaUsersCollection.doc(uid).update({
        'willToPay': willToPay,
    });
  }

  // Currenty unused
    Future updateUserGoals(String goalname, String goalmotivation, String imageUrl) async {
    return await rytaUsersCollection.doc(uid).collection('goals').doc().update({
        'goalname': goalname,
        'goalmotivation': goalmotivation,
        'imageUrl': imageUrl,
    });
  }

  Future deleteUserGoals(String goalID) async {
    return await rytaUsersCollection.doc(uid).collection('goals').doc(goalID).delete();
  }

  // goal list from snapshot
  List<Goal> _goalListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc){
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
    return rytaUsersCollection.doc(uid).collection('goals').snapshots()
    .map(_goalListFromSnapshot);
  }
}