import 'package:flutter/material.dart';
import 'package:parallax_image/parallax_image.dart';
import 'package:provider/provider.dart';
import 'package:ryta_app/config/keys.dart';
import 'package:ryta_app/models/goal.dart';
import 'package:ryta_app/models/unsplash_image.dart';
import 'package:ryta_app/models/user.dart';
import 'package:ryta_app/screens/home/goal_view.dart';
import 'package:ryta_app/services/database.dart';
import 'package:ryta_app/services/unsplash_image_provider.dart';
import 'package:ryta_app/shared/loading.dart';

/// Screen for showing a list of all the goals from [User].
class GoalsList extends StatefulWidget {
  @override
  _GoalsListState createState() => _GoalsListState();
}

/// Provide a state for [GoalsList].
class _GoalsListState extends State<GoalsList> {

  // final _controller = new ScrollController();

  @override
  Widget build(BuildContext context) { 
    
      final goals = Provider.of<List<Goal>>(context);
      final user = Provider.of<RytaUser>(context);

      // keys for Unsplash are confidential
                if (Keys.UNSPLASH_API_CLIENT_ID == "ask_Marek")
                    return AlertDialog(
                      title: Text('Ask Marek for Unsplash keys'),
                      content: Text('Othewise it will not work'),
                      actions: <Widget>[
                        TextButton(
                          child: Text('Mach ich!'),
                          onPressed: (){
                            Navigator.of(context).pop();
                          }
                        ),
                      ],
                    );

      return Scaffold(
          backgroundColor: Colors.white,
          body:NotificationListener<OverscrollIndicatorNotification>( // disabling a scroll glow
            // ignore: missing_return
            onNotification: (overscroll) {
              overscroll.disallowGlow();
            },
            child:ListView.builder(
                // controller: _controller,
                itemCount: goals == null ? 0 : goals.length,
                itemBuilder: (BuildContext context, int index) {
                  return FutureBuilder<UnsplashImage>(
                    future: UnsplashImageProvider.loadImage(goals[index].imageID),
                    builder: (BuildContext context, AsyncSnapshot<UnsplashImage> snapshot) {
                        if (snapshot.hasData == false) return Center(child: Loading(Colors.white));

                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: InkWell(
                              onTap: () async {
                                Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      // open [ImagePage] with the given image
                                      GoalPage(goals[index].imageID, goals[index].imageUrl),
                                  ),
                                  );
                                },
                              onLongPress: () {
                              _onBackPressed(context, user, goals[index]);
                              },
                              child: ParallaxImage(
                                  image: Image.network(
                                    snapshot.data.getSmallUrl(),
                                    frameBuilder: (BuildContext context, Widget child, int frame, bool wasSynchronouslyLoaded) {
                                      return Padding(padding: EdgeInsets.all(8.0), child: child);
                                    },
                                    loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value: loadingProgress.expectedTotalBytes != null
                                              ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes
                                              : null,
                                          valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                                        ),
                                      );
                                    },
                                  ).image,
                                  extent: 120.0,
                                  child: Center(
                                    child: Padding(
                                        padding: EdgeInsets.only(left:15.0, right: 15.0),
                                            child: Text(
                                              goals[index].goalname,
                                              style: Theme.of(context).textTheme.headline4.copyWith(color: Colors.white),
                                              textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  // controller: _controller,
                                ),
                            ),
                          ),
                        );
                    },
                  );
                },
              ),
          ),

        );
  }


  // delet the goal on long press dialog 
  Future<bool> _onBackPressed(context, RytaUser user, goal) {
  return showDialog(
    context: context,
    builder: (context) => new AlertDialog(
      title: new Text('Delete this goal?'),
      // content: new Text('Do you want to delete the goal?'),
      actions: <Widget>[
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("No"),
          ),
        SizedBox(height: 16),
        TextButton(
          onPressed: () async {
            Navigator.of(context).pop();
            DatabaseService(uid: user.uid).deleteUserGoals(goal.goalID);
          },
          child: Text("Yes"),
        ),
      ],
    ),
  );
  }
}

///// OLD GoalsList using GoalTile

// class GoalsList extends StatefulWidget {
//   @override
//   _GoalsListState createState() => _GoalsListState();
// }

// class _GoalsListState extends State<GoalsList> {
//   @override
//   Widget build(BuildContext context) {

//     final goals = Provider.of<List<Goal>>(context);
//     final user = Provider.of<RytaUser>(context);

//                   if (Keys.UNSPLASH_API_CLIENT_ID == "ask_Marek")
//                     return AlertDialog(
//                       title: Text('Ask Marek for Unsplash keys'),
//                       content: Text('Othewise it will not work'),
//                       actions: <Widget>[
//                         TextButton(
//                           child: Text('Mach ich!'),
//                           onPressed: (){
//                             // Hier passiert etwas
//                             // Navigator.of(context).pop();
//                           }
//                         ),
//                       ],
//                     );
    
//     return Scaffold(
//         body: 

        
        
//         ListView.builder(
//         itemCount: goals == null ? 0 : goals.length,
//         itemBuilder: (context, index) {
//           return GoalTile(goal: goals[index]);
//         }),
        
//         // add goal to Firebase
//         floatingActionButton: FloatingActionButton(
//               onPressed: () async {
//                 Navigator.push(context, MaterialPageRoute(builder: (context) => GoalDefinition()));
               
//               },
//               child: Icon(Icons.add),
//               backgroundColor: Color(0xFF995C75),
//             ),
//         floatingActionButtonLocation:    
//           FloatingActionButtonLocation.centerFloat,

//     ); 
//   }
// }