import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ryta_app/models/goal.dart';

class DatabaseService {
  
  final String uid;
  DatabaseService({ this.uid });

  // collection reference
  final CollectionReference rytaUsersCollection = FirebaseFirestore.instance.collection('ryta_users');

  Future updateUserData(String name, int numberOfGoals) async {
    return await rytaUsersCollection.doc(uid).set({
      'name': name,
      'numberOfGoals': numberOfGoals,
    });
  }

  Future addUserGoals(String goal, String imageUrl) async {
    return await rytaUsersCollection.doc(uid).collection('goals').doc().set({
        'goal': goal,
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
        goal: doc.data()['goal'] ?? '',
        imageUrl: doc.data()['imageUrl'] ?? '',
      );
    }).toList();
  }

  // // get goals stream
  Stream<List<Goal>> get goals {
    return rytaUsersCollection.doc(uid).collection('goals').snapshots()
    .map(_goalListFromSnapshot);
  }
}