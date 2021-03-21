import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ryta_app/models/goal.dart';



class DatabaseService {
  
  final String uid;
  DatabaseService({ this.uid });

  // collection reference
  final CollectionReference rytaUsersCollection = FirebaseFirestore.instance.collection('ryta_users');
  // final CollectionReference goalsCollection = FirebaseFirestore.instance.collection('goals');

  Future updateUserData(String name, int numberOfGoals) async {
    return await rytaUsersCollection.doc(uid).set({
      'name': name,
      'numberOfGoals': numberOfGoals,
    });
  }

  Future updateUserGoals(String goal, String imageUrl) async {
    return await rytaUsersCollection.doc(uid).collection('goals').doc().set({
        'goal': goal,
        'imageUrl': imageUrl,
    });
  }

  // Future getUserGoals() async {
  //   return await rytaUsersCollection.doc(uid).collection('goals').doc().get({
  //       'goal': goal,
  //       'imageUrl': imageUrl,
  //   });
  // }
  // goal list from snapshot
  List<Goal> _goalListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc){
      return Goal(
        goal: doc.data()['goal'] ?? '',
        imageUrl: doc.data()['imageUrl'] ?? '',
      );
    }).toList();
  }

  // // get goals stream
  Stream<List<Goal>> get goals {
    // Stream<QuerySnapshot> get goals {
    return rytaUsersCollection.doc(uid).collection('goals').snapshots()
    // return goalsCollection.doc(goal).snapshots()
    .map(_goalListFromSnapshot);
  }

  // get snapshot test
  Stream<QuerySnapshot> get testgoals {
    // return rytaUsersCollection.doc(uid).collection('goals').snapshots();
    return rytaUsersCollection.snapshots();
      // .map(_goalListFromSnapshot);
  }

  Future <List<Goal>> getGoals() async {
    // ignore: non_constant_identifier_names
    List<Goal> GoalsListList = [];
    var queryOfGoals  = await rytaUsersCollection.doc(uid).collection('goals').get();
            queryOfGoals.docs.forEach((goal) {
            GoalsListList.add(Goal.fromMap(goal));
          });
    return GoalsListList;



  // // ignore: non_constant_identifier_names
  // ListOfGoals() async
  // {
  //   //  List list_of_masters = await                                   Firestore.instance.collection("masters")
  //   // .getDocuments()
  //   // .then((val) => val.documents);
  // // for (int i=0; i<list_of_masters.length; i++)
  //   // {
  //        FirebaseFirestore.instance.collection("ryta_users").doc(
  //     uid.toString()).collection("goals").snapshots().listen(CreateListofCourses);
  //   //  }
  //   return finalGoalsList;
  // }

  // // ignore: non_constant_identifier_names
  // CreateListofCourses(QuerySnapshot snapshot)async 
  // {
  //      var goalss = snapshot.docs;
  //      for (var Doc in goalss)
  //        {
  //         finalGoalsList.add(Goal.fromFireStore(Doc));
  //        }
  // }


}
}