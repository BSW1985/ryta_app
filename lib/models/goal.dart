import 'package:cloud_firestore/cloud_firestore.dart';

class Goal {

  final String goal;
  final String imageUrl;

  Goal({ this.goal, this.imageUrl });

  factory Goal.fromMap(DocumentSnapshot doc)
  {
    Map data = doc.data as Map ;
    return Goal(
        goal: data['goal'],
        imageUrl: data['imageUrl'],
    );
  }


}

// class Goal {

//   final String name;
//   final String numberOfGoals;

//   Goal({ this.name, this.numberOfGoals });

// }