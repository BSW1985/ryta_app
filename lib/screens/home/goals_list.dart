import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:parallax_image/parallax_image.dart';
import 'package:provider/provider.dart';
import 'package:ryta_app/config/keys.dart';
import 'package:ryta_app/models/goal.dart';
import 'package:ryta_app/models/unsplash_image.dart';
import 'package:ryta_app/models/user.dart';
import 'package:ryta_app/models/user_file.dart';
import 'package:ryta_app/screens/home/goal_view.dart';
import 'package:ryta_app/services/auth.dart';
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
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final goals = Provider.of<List<Goal>>(context);
    final user = Provider.of<RytaUser>(context);
    final userfile = Provider.of<UserFile>(context);
    final height = MediaQuery.of(context).size.height;
    final introductionLocation = height / 2 - 150;

    String firstName;

    // extracting just the first name
    if (user.displayName != null) {
      if (user.displayName.length > 1) {
        List<String> wordList = user.displayName.split(" ");
        firstName = wordList[0];
      } else {
        firstName = user.displayName;
      }
    }

    // keys for Unsplash are confidential
    if (Keys.UNSPLASH_API_CLIENT_ID == "ask_Marek")
      return AlertDialog(
        title: Text('Ask Marek for Unsplash keys'),
        content: Text('Otherwise it will not work'),
        actions: <Widget>[
          TextButton(
              child: Text('Mach ich!'),
              onPressed: () {
                Navigator.of(context).pop();
              }),
        ],
      );
    if (user.emailVerified != true)
      return Container(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Please verify your email to continue.',
              style: TextStyle(color: Colors.black, fontSize: 17.0)),
          SizedBox(height: 20.0),
          Loading(Colors.white, Color(0xFF995C75)),
          SizedBox(height: 20.0),
          ElevatedButton(
              style: ButtonStyle(
                elevation: MaterialStateProperty.all<double>(0),
                padding: MaterialStateProperty.all(
                    EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0)),
                // backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                // foregroundColor: MaterialStateProperty.all<Color>(Color(0xFF995C75)),
                // shape: MaterialStateProperty.all(RoundedRectangleBorder(
                //         // side: BorderSide(color: Color(0xFF995C75), width: 1.0),
                //         borderRadius: BorderRadius.circular(15.0))),
              ),
              child: Text(
                'DONE - TAKE ME TO SIGN IN',
              ),
              onPressed: () async {
                DatabaseService(uid: user.uid)
                    .updateEmailVerified(user.emailVerified);
                // await FirebaseAuth.instance.currentUser.reload();
                await _auth.signOut();
              }),
          // SizedBox(height:10.0),
          // ElevatedButton(
          //   style: ButtonStyle(
          //   elevation: MaterialStateProperty.all<double>(0),
          //   padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0)),
          //   // backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
          //   // foregroundColor: MaterialStateProperty.all<Color>(Color(0xFF995C75)),
          //   // shape: MaterialStateProperty.all(RoundedRectangleBorder(
          //   //         // side: BorderSide(color: Color(0xFF995C75), width: 1.0),
          //   //         borderRadius: BorderRadius.circular(15.0))),
          //   ),
          //   child: Text(
          //     'LOGOUT',
          //     ),
          //   onPressed: () async {

          //   await _auth.signOut();

          //       }
          //   ),
        ],
      ));
    // print(user.emailVerified);

    // return
    //   Center(child: Text('please verify'));
    //   // Loading(Colors.white);
    if (goals == null) return Loading(Colors.white, Color(0xFF995C75));
    if (userfile == null) return Loading(Colors.white, Color(0xFF995C75));
    if (goals.length == 0 && userfile.throughIntroduction != false)
      return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome, $firstName!',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 28.0),
            ),
            SizedBox(height: 20.0),
            Text(
              "Let's define your first goal.",
              style: TextStyle(color: Colors.black, fontSize: 17.0),
            ),
            SizedBox(height: 100.0),
            Icon(Icons.arrow_downward_rounded, size: 50.0),
          ],
        ),
      );
    else
      return Scaffold(
        backgroundColor: Colors.white,
        body: NotificationListener<OverscrollIndicatorNotification>(
          // disabling a scroll glow
          // ignore: missing_return
          onNotification: (overscroll) {
            overscroll.disallowGlow();
          },
          child: ListView.builder(
            // body: ListView.builder(
            // controller: _controller,
            itemCount: goals == null ? 0 : goals.length,
            itemBuilder: (BuildContext context, int index) {
              return FutureBuilder<UnsplashImage>(
                future: UnsplashImageProvider.loadImage(goals[index].imageID),
                builder: (BuildContext context,
                    AsyncSnapshot<UnsplashImage> snapshot) {
                  if (snapshot.hasData == false)
                    return Padding(
                      padding: userfile.throughIntroduction == true
                          ? EdgeInsets.all(8.0)
                          : EdgeInsets.fromLTRB(
                              8.0, introductionLocation, 8.0, 0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                            height: 120.0,
                            child: Center(
                              child:
                                  Loading(Colors.grey[100], Color(0xFF995C75)),
                            )),
                      ),
                    );

                  try {
                    snapshot.data.getSmallUrl();
                  } catch (e) {
                    print(e.toString());
                    print('Unable to acces Unsplash');
                    return AlertDialog(
                      elevation: 5.0,
                      title: Text('001: Unable to acces Unsplash'),
                      content: Text('Please report the issue to Ryta team'),
                      // actions: <Widget>[
                      //   TextButton(
                      //     child: Text('Mach ich!'),
                      //     onPressed: (){
                      //       Navigator.of(context).pop();
                      //     }
                      //   ),
                      // ],
                    );
                  }

                  return Padding(
                    padding: userfile.throughIntroduction == true
                        ? EdgeInsets.all(8.0)
                        : EdgeInsets.fromLTRB(
                            8.0, introductionLocation, 8.0, 0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: InkWell(
                        onTap: () async {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  // open [ImagePage] with the given image
                                  GoalPage(goals[index], goals[index].imageID,
                                      goals[index].imageUrl, userfile),
                            ),
                          );
                        },
                        onLongPress: () {
                          _onBackPressed(context, user, goals[index]);
                        },
                        child: ParallaxImage(
                          image: Image.network(
                            snapshot.data.getSmallUrl(),
                            frameBuilder: (BuildContext context, Widget child,
                                int frame, bool wasSynchronouslyLoaded) {
                              return Padding(
                                  padding: EdgeInsets.all(8.0), child: child);
                            },
                            // loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent loadingProgress) {
                            //   if (loadingProgress == null) return child;
                            //   return Center(
                            //     child: CircularProgressIndicator(
                            //       value: loadingProgress.expectedTotalBytes != null
                            //           ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes
                            //           : null,
                            //       valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                            //     ),
                            //   );
                            // },
                          ).image,
                          extent: 120.0,
                          child: Center(
                            child: Padding(
                              padding:
                                  EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
                              child: Text(
                                goals[index].goalname,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 34.0,
                                    color: Colors
                                        .white), // _getColorFromHex(goals[index].goalFontColor)
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
        shape: RoundedRectangleBorder(
            // side: BorderSide(color: goalFont, width: 1.0),
            borderRadius: BorderRadius.circular(15.0)),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("No"),
            style: ButtonStyle(
              elevation: MaterialStateProperty.all<double>(0),
              padding: MaterialStateProperty.all(EdgeInsets.all(10.0)),
              backgroundColor:
                  MaterialStateProperty.all<Color>(Color(0xFF995C75)),
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  // side: BorderSide(color: Color(0xFF995C75), width: 1.0),
                  borderRadius: BorderRadius.circular(15.0))),
            ),
          ),
          SizedBox(height: 16),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              DatabaseService(uid: user.uid).deleteUserGoals(goal.goalID);
            },
            style: ButtonStyle(
              elevation: MaterialStateProperty.all<double>(0),
              padding: MaterialStateProperty.all(EdgeInsets.all(10.0)),
              backgroundColor:
                  MaterialStateProperty.all<Color>(Colors.transparent),
              foregroundColor:
                  MaterialStateProperty.all<Color>(Color(0xFF995C75)),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  side: BorderSide(color: Color(0xFF995C75), width: 1.0),
                  borderRadius: BorderRadius.circular(15.0))),
            ),
            child: Text("Yes"),
          ),
        ],
      ),
    );
  }
  //   Color _getColorFromHex(String hexColor) {
  //   hexColor = hexColor.replaceAll("#", "");
  //   if (hexColor.length == 6) {
  //     hexColor = "FF" + hexColor;
  //   }
  //   if (hexColor.length == 8) {
  //     return Color(int.parse("0x$hexColor"));
  //   }
  // }
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
