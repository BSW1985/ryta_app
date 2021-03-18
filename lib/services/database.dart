import 'package:cloud_firestore/cloud_firestore.dart';

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

}