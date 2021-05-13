import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:ryta_app/models/goal.dart';
import 'package:ryta_app/models/unsplash_image.dart';
import 'package:ryta_app/models/user.dart';
import 'package:ryta_app/models/user_file.dart';
import 'package:ryta_app/screens/wrapper.dart';
import 'package:ryta_app/services/database.dart';
import 'package:ryta_app/services/unsplash_image_provider.dart';
import 'package:ryta_app/shared/loading.dart';
import 'package:ryta_app/widgets/edit_goal.dart';

/// Screen for showing an individual goal ---> Visualization
class GoalPage extends StatefulWidget {
  // final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final String imageId, imageUrl;
  final int index;

  final Goal goal;
  final UserFile userfile;
  // GoalPage(this.imageId, this.imageUrl, {Key key}) : super(key: key);
  GoalPage(this.index, this.goal, this.imageId, this.imageUrl, this.userfile,
      {Key key})
      : super(key: key);

  @override
  _GoalPageState createState() => _GoalPageState();
}

/// Provide a state for [GoalPage].
class _GoalPageState extends State<GoalPage> {
  /// create global key to show info bottom sheet
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  /// Bottomsheet controller
  PersistentBottomSheetController infoBottomSheetController;

  // Color maincolor;
  Brightness brightness;

  /// Displayed image.
  UnsplashImage image;

  Color goalBackgound;
  Color goalFont;
  bool _motivationOn = false;

  @override
  void initState() {
    super.initState();
    // load image
    _loadImage();
    _getColor();
  }

  /// Reloads the image from unsplash to get extra data, like: exif, location, ...
  _loadImage() async {
    UnsplashImage image = await UnsplashImageProvider.loadImage(widget.imageId);
    setState(() {
      this.image = image;
    });
  }

  _getColor() async {
    Color goalBackgound = _getColorFromHex(widget.goal.goalBackgoundColor);
    Color goalFont = _getColorFromHex(widget.goal.goalFontColor);
    setState(() {
      this.goalBackgound = goalBackgound;
      this.goalFont = goalFont;
    });
  }

  /// Returns AppBar.
  Widget _buildAppBar() => AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading:
            widget.userfile.throughIntroduction == true ? true : false,
        leading:
            // back button
            widget.userfile.throughIntroduction == true
                ? IconButton(
                    icon: Icon(Icons.arrow_back, color: goalFont),
                    onPressed: () => Navigator.pop(context))
                : null,
        actions: <Widget>[
          // show image info
          if (widget.userfile.throughIntroduction == true)
            IconButton(
              icon: Icon(Icons.settings, color: goalFont),
              tooltip: 'Edit your target',
              onPressed: () async {
                _scaffoldKey.currentState.showBottomSheet((context) => EditGoal(
                    widget.index,
                    widget.goal,
                    widget.imageId,
                    widget.imageUrl));
              },
            ),
        ],
      );

  /// Returns PhotoView around given [imageId] & [imageUrl].
  Widget _buildPhotoView(String imageId, String imageUrl) => Hero(
        tag: imageId,
        child: PhotoView(
          imageProvider: CachedNetworkImageProvider(imageUrl),
          initialScale: PhotoViewComputedScale.covered,
          minScale: PhotoViewComputedScale.covered,
          maxScale: PhotoViewComputedScale.covered,
          loadingBuilder:
              (BuildContext context, ImageChunkEvent imageChunkEvent) {
            return Center(child: Loading(Colors.black, Colors.grey));
          },
        ),
      );

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<RytaUser>(context);
    CachedNetworkImage(
      imageUrl: widget.imageUrl,
      placeholder: (context, url) => CircularProgressIndicator(),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
    return Scaffold(
      // set the global key
      key: _scaffoldKey,
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          _buildPhotoView(widget.imageId, widget.imageUrl),
          // wrap in Positioned to not use entire screen

          Positioned(top: 0.0, left: 0.0, right: 0.0, child: _buildAppBar()),

          if (_motivationOn == false)
            Positioned(
              bottom: 75.0, left: 20.0,
              // _selectedIndex == 0 ? Color(0xFF995C75) : Colors.grey[400]
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  color: goalBackgound.withOpacity(0.8),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: SizedBox(
                      width: 220.0,
                      child: Text(
                        widget.goal.goalname,
                        softWrap: true,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 34.0,
                            color: goalFont),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
            ),

          // if (_motivationOn == false)
          // Align(
          //   alignment: Alignment.topRight,
          //   child: Padding(
          //     padding: const EdgeInsets.all(8.0),
          //     child: FloatingActionButton(
          //       child: Icon(Icons.settings, color:widget.userfile.throughIntroduction == false
          //                     ? goalFont
          //                     : goalBackgound),
          //       backgroundColor: Colors.transparent,
          //       elevation: 0.0,
          //       onPressed: () {

          //       },
          //     ),
          //   ),
          // ),

          if (_motivationOn == false)
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: FloatingActionButton.extended(
                  // icon: Icon(Icons.check),
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: goalFont, width: 1.0),
                      borderRadius: BorderRadius.circular(15.0)),
                  elevation: 0.0,
                  label: Text('Why?',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25.0,
                          color: goalFont)),
                  tooltip: 'See the motivation!',
                  onPressed: () {
                    setState(() {
                      _motivationOn = true;
                    });
                    showDialog(
                      barrierColor: Colors.white.withOpacity(0),
                      barrierDismissible:
                          widget.userfile.throughIntroduction == false
                              ? false
                              : true,
                      context: _scaffoldKey.currentContext,
                      builder: (BuildContext context) {
                        return WillPopScope(
                          onWillPop: () {
                            if (widget.userfile.throughIntroduction == true) {
                              Navigator.of(context).pop();
                              setState(() {
                                _motivationOn = false;
                              });
                              return null;
                            } else {
                              return null;
                            }
                          },
                          child: AlertDialog(
                            actions: [
                              widget.userfile.throughIntroduction == false
                                  ? IconButton(
                                      color: goalFont,
                                      icon:
                                          Icon(Icons.arrow_forward_ios_rounded),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        //introduction
                                        showDialog(
                                          barrierColor:
                                              Colors.white.withOpacity(0),
                                          barrierDismissible: false,
                                          context: _scaffoldKey.currentContext,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              actions: [
                                                IconButton(
                                                  color: goalFont,
                                                  icon: Icon(Icons
                                                      .arrow_forward_ios_rounded),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                    //next motivation screen
                                                    showDialog(
                                                      barrierColor: Colors.white
                                                          .withOpacity(0),
                                                      barrierDismissible: false,
                                                      context: _scaffoldKey
                                                          .currentContext,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          actions: [
                                                            IconButton(
                                                              color: goalFont,
                                                              icon: Icon(Icons
                                                                  .arrow_forward_ios_rounded),
                                                              onPressed:
                                                                  () async {
                                                                //Show Ryta logo
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                                showDialog(
                                                                  barrierColor: Colors
                                                                      .white
                                                                      .withOpacity(
                                                                          0.8),
                                                                  barrierDismissible:
                                                                      false,
                                                                  context:
                                                                      _scaffoldKey
                                                                          .currentContext,
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                                    return AlertDialog(
                                                                      elevation:
                                                                          0.0,
                                                                      backgroundColor: Colors
                                                                          .white
                                                                          .withOpacity(
                                                                              0),
                                                                      content: Image
                                                                          .asset(
                                                                        "assets/ryta_logo.png",
                                                                        height:
                                                                            150,
                                                                        // width: 100,
                                                                      ),
                                                                    );
                                                                  },
                                                                );
                                                                //Delete the introduction set through introduction to true, get back to home screen
                                                                DatabaseService(
                                                                        uid: user
                                                                            .uid)
                                                                    .updateThroughIntroduction(
                                                                        true);
                                                                Timer(
                                                                    Duration(
                                                                        seconds:
                                                                            1),
                                                                    () {
                                                                  DatabaseService(
                                                                          uid: user
                                                                              .uid)
                                                                      .deleteUserGoals(widget
                                                                          .goal
                                                                          .goalID, true);
                                                                  if (user !=
                                                                      null)
                                                                    Navigator
                                                                        .push(
                                                                      _scaffoldKey
                                                                          .currentContext,
                                                                      MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                Wrapper(),
                                                                      ),
                                                                    );
                                                                });
                                                              },
                                                            )
                                                          ],
                                                          elevation: 0.0,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                                  // side: BorderSide(color: goalFont, width: 1.0),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              15.0)),
                                                          backgroundColor:
                                                              goalBackgound
                                                                  .withOpacity(
                                                                      0.8),
                                                          content: RichText(
                                                            text: TextSpan(
                                                                children: [
                                                                  TextSpan(
                                                                      text:
                                                                          "Lets reach your ",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              25.0,
                                                                          color:
                                                                              goalFont,
                                                                          fontFamily:
                                                                              'CenturyGothic')),
                                                                  TextSpan(
                                                                      text:
                                                                          "full potential",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              25.0,
                                                                          color: Colors
                                                                              .white,
                                                                          fontFamily:
                                                                              'CenturyGothic',
                                                                          fontWeight:
                                                                              FontWeight.bold)),
                                                                  TextSpan(
                                                                      text:
                                                                          '''! 
                                                                                                                                                                  Lets reach your ''',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              25.0,
                                                                          color:
                                                                              goalFont,
                                                                          fontFamily:
                                                                              'CenturyGothic')),
                                                                  TextSpan(
                                                                      text:
                                                                          "targets",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              25.0,
                                                                          color: Colors
                                                                              .white,
                                                                          fontFamily:
                                                                              'CenturyGothic',
                                                                          fontWeight:
                                                                              FontWeight.bold)),
                                                                  TextSpan(
                                                                      text: "!",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              25.0,
                                                                          color:
                                                                              goalFont,
                                                                          fontFamily:
                                                                              'CenturyGothic')),
                                                                ]),
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  },
                                                )
                                              ],
                                              elevation: 0.0,
                                              shape: RoundedRectangleBorder(
                                                  // side: BorderSide(color: goalFont, width: 1.0),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.0)),
                                              backgroundColor: goalBackgound
                                                  .withOpacity(0.8),
                                              content: RichText(
                                                text: TextSpan(children: [
                                                  TextSpan(
                                                      text:
                                                          '''Elite athletes use it. 
                                              The super-rich use it. 
                                              Peak performers in all fields use it. 
                                              And you can use it too! That power is called ''',
                                                      style: TextStyle(
                                                          fontSize: 20.0,
                                                          color: goalFont,
                                                          fontFamily:
                                                              'CenturyGothic')),
                                                  TextSpan(
                                                      text: "visualization",
                                                      style: TextStyle(
                                                          fontSize: 20.0,
                                                          color: Colors.white,
                                                          fontFamily:
                                                              'CenturyGothic',
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  TextSpan(
                                                      text: ".",
                                                      style: TextStyle(
                                                          fontSize: 20.0,
                                                          color: goalFont,
                                                          fontFamily:
                                                              'CenturyGothic')),
                                                ]),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    )
                                  : null
                            ],
                            scrollable: true,
                            elevation: 0.0,
                            shape: RoundedRectangleBorder(
                                // side: BorderSide(color: goalFont, width: 1.0),
                                borderRadius: BorderRadius.circular(15.0)),
                            backgroundColor: goalBackgound.withOpacity(0.8),
                            title: Text(widget.goal.goalname,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 34.0,
                                    color:
                                        goalFont)), //, textAlign: TextAlign.center,
                            content: widget.userfile.throughIntroduction == true
                                ? Text(widget.goal.goalmotivation,
                                    style: TextStyle(
                                        fontSize: 25.0, color: goalFont))
                                : RichText(
                                    text: TextSpan(children: [
                                      TextSpan(
                                          text:
                                              '''Visualization techniques have been used by successful people for ages, helping them create their dream lives. 
                                              We all have this ''',
                                          style: TextStyle(
                                              fontSize: 20.0,
                                              color: goalFont,
                                              fontFamily: 'CenturyGothic')),
                                      TextSpan(
                                          text: "awesome power",
                                          style: TextStyle(
                                              fontSize: 20.0,
                                              color: Colors.white,
                                              fontFamily: 'CenturyGothic',
                                              fontWeight: FontWeight.bold)),
                                      TextSpan(
                                          text:
                                              ", but most of us have never been taught to use it effectively.",
                                          style: TextStyle(
                                              fontSize: 20.0,
                                              color: goalFont,
                                              fontFamily: 'CenturyGothic')),
                                    ]),
                                  ),
                          ),
                        );
                      },
                    );
                  },

                  backgroundColor: Colors.transparent,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Color _getColorFromHex(String hexColor) {
    hexColor = hexColor.replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    if (hexColor.length == 8) {
      return Color(int.parse("0x$hexColor"));
    } else
      return null;
  }
}
