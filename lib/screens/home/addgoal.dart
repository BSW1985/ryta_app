/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ryta_app/services/database.dart';
import 'package:ryta_app/models/user.dart';

final databaseReference = FirebaseFirestore.instance;

void addGoal(RytaUser user, String name, String url) async {

  await databaseReference
      .collection("ryta_users")
      .doc(user.uid)
      .collection('goals')
      .add({
        'goal': name,
        'imageUrl': url,
      });
}

void updateGoal(RytaUser user, String name, String url) {
    try {
      databaseReference
          .collection('ryta_users')
          .doc(user.uid)
          .collection('goals')
          .update({
            'goal': name,
            'imageUrl': url,
          });
    } catch (e) {
      print(e.toString());
    }
  }

void deleteGoal(RytaUser user, String name) {
  try {
    databaseReference
        .collection('ryta_users')
        .doc(user.uid)
        .collection('goals')
        .delete();
  } catch (e) {
    print(e.toString());
  }
}
*/