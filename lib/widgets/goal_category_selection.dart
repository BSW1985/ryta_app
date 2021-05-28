import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:provider/provider.dart';
import 'package:ryta_app/models/goal.dart';
import 'package:ryta_app/models/unsplash_image.dart';
import 'package:ryta_app/models/user.dart';
import 'package:ryta_app/screens/wrapper.dart';
import 'package:ryta_app/services/database.dart';
import 'package:ryta_app/services/unsplash_image_provider.dart';

class FinishFloatingActionButton extends StatefulWidget {
  final String imageId, imageUrl, downloadLocationLink;
  final bool throughIntroduction;

  FinishFloatingActionButton(this.imageId, this.imageUrl,
      this.throughIntroduction, this.downloadLocationLink,
      {Key key})
      : super(key: key);

  @override
  _FinishFloatingActionButtonState createState() =>
      _FinishFloatingActionButtonState();
}

class _FinishFloatingActionButtonState
    extends State<FinishFloatingActionButton> {
  /// Displayed image.
  UnsplashImage image;
  bool showFab = true;
  bool healthVal = false;
  bool nutritionVal = false;
  bool sportsVal = false;
  bool mentalHealthVal = false;
  bool careerVal = false;
  bool educationVal = false;
  bool personalFinanceVal = false;
  bool networkingVal = false;
  bool productivityVal = false;
  bool leisureVal = false;
  bool personalGrowthVal = false;
  bool cultureVal = false;
  bool romanceVal = false;
  bool socialLifeVal = false;

  @override
  Widget build(BuildContext context) {
    //cache image
    CachedNetworkImage(
      imageUrl: widget.imageUrl,
      placeholder: (context, url) => CircularProgressIndicator(),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );

    return showFab
        ? FloatingActionButton.extended(
            icon: Icon(Icons.check),
            label: Text('FINISH'),
            backgroundColor: Color(0xFF995C75),
            onPressed: () async {
              var bottomSheetController = showBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return StatefulBuilder(
                        builder: (context, StateSetter setState) {
                      return Center(
                        child: Container(
                          // color: Colors.transparent,
                          decoration: BoxDecoration(
                            color: Colors.white70,
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          margin: const EdgeInsets.all(15),
                          // height: 410,
                          child: NotificationListener<
                                  OverscrollIndicatorNotification>(
                              // disabling a scroll glow
                              // ignore: missing_return
                              onNotification: (overscroll) {
                                overscroll.disallowGlow();
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 15.0, bottom: 15.0),
                                child: SingleChildScrollView(
                                  child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 15.0,
                                              left: 15.0,
                                              right: 15.0,
                                              bottom: 5.0),
                                          child: Text(
                                            'Where does your target fit the most?',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17.0,
                                            ),
                                          ),
                                        ),
                                        //checktiles of all the categories
                                        //undercategories open only if the coresponding category selected
                                        SizedBox(
                                          height: 40.0,
                                          child: CheckboxListTile(
                                              controlAffinity:
                                                  ListTileControlAffinity
                                                      .leading,
                                              // checkColor: Color(0xFFF9A825),
                                              activeColor: Color(0xFFF9A825),
                                              title: Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 8.0, top: 8.0),
                                                child: Text(
                                                  'Health',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 17.0),
                                                ),
                                              ),
                                              // subtitle: Text(
                                              //     'Stay on track with all the new stuff coming soon in Ryta!',
                                              //     style: TextStyle(fontSize: 17.0)),
                                              value: healthVal,
                                              onChanged: (value) {
                                                setState(() {
                                                  healthVal = !healthVal;
                                                  nutritionVal = false;
                                                  sportsVal = false;
                                                  mentalHealthVal = false;
                                                });
                                              }),
                                        ),

                                        Visibility(
                                            visible: (healthVal == true),
                                            child: Column(children: [
                                              SizedBox(
                                                height: 40.0,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 20.0),
                                                  child: CheckboxListTile(
                                                      controlAffinity:
                                                          ListTileControlAffinity
                                                              .leading,
                                                      // checkColor: Color(0xFFF9A825),
                                                      activeColor:
                                                          Color(0xFFF9A825),
                                                      title: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                bottom: 3.0,
                                                                top: 3.0),
                                                        child: Text(
                                                          'Nutrition',
                                                          style: TextStyle(
                                                              fontSize: 17.0),
                                                        ),
                                                      ),
                                                      // subtitle: Text(
                                                      //     'Stay on track with all the new stuff coming soon in Ryta!',
                                                      //     style: TextStyle(fontSize: 17.0)),
                                                      value: nutritionVal,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          nutritionVal =
                                                              !nutritionVal;
                                                        });
                                                      }),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 40.0,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 20.0),
                                                  child: CheckboxListTile(
                                                      controlAffinity:
                                                          ListTileControlAffinity
                                                              .leading,
                                                      // checkColor: Color(0xFFF9A825),
                                                      activeColor:
                                                          Color(0xFFF9A825),
                                                      title: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                bottom: 3.0,
                                                                top: 3.0),
                                                        child: Text(
                                                          'Sports',
                                                          style: TextStyle(
                                                              fontSize: 17.0),
                                                        ),
                                                      ),
                                                      // subtitle: Text(
                                                      //     'Stay on track with all the new stuff coming soon in Ryta!',
                                                      //     style: TextStyle(fontSize: 17.0)),
                                                      value: sportsVal,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          sportsVal =
                                                              !sportsVal;
                                                        });
                                                      }),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 40.0,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 20.0),
                                                  child: CheckboxListTile(
                                                      controlAffinity:
                                                          ListTileControlAffinity
                                                              .leading,
                                                      // checkColor: Color(0xFFF9A825),
                                                      activeColor:
                                                          Color(0xFFF9A825),
                                                      title: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                bottom: 3.0,
                                                                top: 3.0),
                                                        child: Text(
                                                          'Mental Health',
                                                          style: TextStyle(
                                                              fontSize: 17.0),
                                                        ),
                                                      ),
                                                      // subtitle: Text(
                                                      //     'Stay on track with all the new stuff coming soon in Ryta!',
                                                      //     style: TextStyle(fontSize: 17.0)),
                                                      value: mentalHealthVal,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          mentalHealthVal =
                                                              !mentalHealthVal;
                                                        });
                                                      }),
                                                ),
                                              ),
                                            ])),

                                        SizedBox(
                                          height: 40.0,
                                          child: CheckboxListTile(
                                              controlAffinity:
                                                  ListTileControlAffinity
                                                      .leading,
                                              // checkColor: Color(0xFFF9A825),
                                              activeColor: Color(0xFFF9A825),
                                              title: Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 8.0, top: 8.0),
                                                child: Text(
                                                  'Career',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 17.0),
                                                ),
                                              ),
                                              // subtitle: Text(
                                              //     'Stay on track with all the new stuff coming soon in Ryta!',
                                              //     style: TextStyle(fontSize: 17.0)),
                                              value: careerVal,
                                              onChanged: (value) {
                                                setState(() {
                                                  careerVal = !careerVal;
                                                  educationVal = false;
                                                  personalFinanceVal = false;
                                                  networkingVal = false;
                                                  productivityVal = false;
                                                });
                                              }),
                                        ),

                                        Visibility(
                                            visible: (careerVal == true),
                                            child: Column(children: [
                                              SizedBox(
                                                height: 40.0,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 20.0),
                                                  child: CheckboxListTile(
                                                      controlAffinity:
                                                          ListTileControlAffinity
                                                              .leading,
                                                      // checkColor: Color(0xFFF9A825),
                                                      activeColor:
                                                          Color(0xFFF9A825),
                                                      title: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                bottom: 3.0,
                                                                top: 3.0),
                                                        child: Text(
                                                          'Education',
                                                          style: TextStyle(
                                                              fontSize: 17.0),
                                                        ),
                                                      ),
                                                      // subtitle: Text(
                                                      //     'Stay on track with all the new stuff coming soon in Ryta!',
                                                      //     style: TextStyle(fontSize: 17.0)),
                                                      value: educationVal,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          educationVal =
                                                              !educationVal;
                                                        });
                                                      }),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 40.0,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 20.0),
                                                  child: CheckboxListTile(
                                                      controlAffinity:
                                                          ListTileControlAffinity
                                                              .leading,
                                                      // checkColor: Color(0xFFF9A825),
                                                      activeColor:
                                                          Color(0xFFF9A825),
                                                      title: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                bottom: 3.0,
                                                                top: 3.0),
                                                        child: Text(
                                                          'Personal Finance',
                                                          style: TextStyle(
                                                              fontSize: 17.0),
                                                        ),
                                                      ),
                                                      // subtitle: Text(
                                                      //     'Stay on track with all the new stuff coming soon in Ryta!',
                                                      //     style: TextStyle(fontSize: 17.0)),
                                                      value: personalFinanceVal,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          personalFinanceVal =
                                                              !personalFinanceVal;
                                                        });
                                                      }),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 40.0,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 20.0),
                                                  child: CheckboxListTile(
                                                      controlAffinity:
                                                          ListTileControlAffinity
                                                              .leading,
                                                      // checkColor: Color(0xFFF9A825),
                                                      activeColor:
                                                          Color(0xFFF9A825),
                                                      title: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                bottom: 3.0,
                                                                top: 3.0),
                                                        child: Text(
                                                          'Networking',
                                                          style: TextStyle(
                                                              fontSize: 17.0),
                                                        ),
                                                      ),
                                                      // subtitle: Text(
                                                      //     'Stay on track with all the new stuff coming soon in Ryta!',
                                                      //     style: TextStyle(fontSize: 17.0)),
                                                      value: networkingVal,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          networkingVal =
                                                              !networkingVal;
                                                        });
                                                      }),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 40.0,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 20.0),
                                                  child: CheckboxListTile(
                                                      controlAffinity:
                                                          ListTileControlAffinity
                                                              .leading,
                                                      // checkColor: Color(0xFFF9A825),
                                                      activeColor:
                                                          Color(0xFFF9A825),
                                                      title: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                bottom: 3.0,
                                                                top: 3.0),
                                                        child: Text(
                                                          'Productivity',
                                                          style: TextStyle(
                                                              fontSize: 17.0),
                                                        ),
                                                      ),
                                                      // subtitle: Text(
                                                      //     'Stay on track with all the new stuff coming soon in Ryta!',
                                                      //     style: TextStyle(fontSize: 17.0)),
                                                      value: productivityVal,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          productivityVal =
                                                              !productivityVal;
                                                        });
                                                      }),
                                                ),
                                              ),
                                            ])),
                                        SizedBox(
                                          height: 40.0,
                                          child: CheckboxListTile(
                                              controlAffinity:
                                                  ListTileControlAffinity
                                                      .leading,
                                              // checkColor: Color(0xFFF9A825),
                                              activeColor: Color(0xFFF9A825),
                                              title: Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 8.0, top: 8.0),
                                                child: Text(
                                                  'Leisure',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 17.0),
                                                ),
                                              ),
                                              // subtitle: Text(
                                              //     'Stay on track with all the new stuff coming soon in Ryta!',
                                              //     style: TextStyle(fontSize: 17.0)),
                                              value: leisureVal,
                                              onChanged: (value) {
                                                setState(() {
                                                  leisureVal = !leisureVal;
                                                  personalGrowthVal = false;
                                                  cultureVal = false;
                                                  romanceVal = false;
                                                  socialLifeVal = false;
                                                });
                                              }),
                                        ),

                                        Visibility(
                                            visible: (leisureVal == true),
                                            child: Column(children: [
                                              SizedBox(
                                                height: 40.0,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 20.0),
                                                  child: CheckboxListTile(
                                                      controlAffinity:
                                                          ListTileControlAffinity
                                                              .leading,
                                                      // checkColor: Color(0xFFF9A825),
                                                      activeColor:
                                                          Color(0xFFF9A825),
                                                      title: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                bottom: 3.0,
                                                                top: 3.0),
                                                        child: Text(
                                                          'Personal Growth',
                                                          style: TextStyle(
                                                              fontSize: 17.0),
                                                        ),
                                                      ),
                                                      // subtitle: Text(
                                                      //     'Stay on track with all the new stuff coming soon in Ryta!',
                                                      //     style: TextStyle(fontSize: 17.0)),
                                                      value: personalGrowthVal,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          personalGrowthVal =
                                                              !personalGrowthVal;
                                                        });
                                                      }),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 40.0,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 20.0),
                                                  child: CheckboxListTile(
                                                      controlAffinity:
                                                          ListTileControlAffinity
                                                              .leading,
                                                      // checkColor: Color(0xFFF9A825),
                                                      activeColor:
                                                          Color(0xFFF9A825),
                                                      title: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                bottom: 3.0,
                                                                top: 3.0),
                                                        child: Text(
                                                          'Culture',
                                                          style: TextStyle(
                                                              fontSize: 17.0),
                                                        ),
                                                      ),
                                                      // subtitle: Text(
                                                      //     'Stay on track with all the new stuff coming soon in Ryta!',
                                                      //     style: TextStyle(fontSize: 17.0)),
                                                      value: cultureVal,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          cultureVal =
                                                              !cultureVal;
                                                        });
                                                      }),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 40.0,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 20.0),
                                                  child: CheckboxListTile(
                                                      controlAffinity:
                                                          ListTileControlAffinity
                                                              .leading,
                                                      // checkColor: Color(0xFFF9A825),
                                                      activeColor:
                                                          Color(0xFFF9A825),
                                                      title: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                bottom: 3.0,
                                                                top: 3.0),
                                                        child: Text(
                                                          'Romance',
                                                          style: TextStyle(
                                                              fontSize: 17.0),
                                                        ),
                                                      ),
                                                      // subtitle: Text(
                                                      //     'Stay on track with all the new stuff coming soon in Ryta!',
                                                      //     style: TextStyle(fontSize: 17.0)),
                                                      value: romanceVal,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          romanceVal =
                                                              !romanceVal;
                                                        });
                                                      }),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 40.0,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 20.0),
                                                  child: CheckboxListTile(
                                                      controlAffinity:
                                                          ListTileControlAffinity
                                                              .leading,
                                                      // checkColor: Color(0xFFF9A825),
                                                      activeColor:
                                                          Color(0xFFF9A825),
                                                      title: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                bottom: 3.0,
                                                                top: 3.0),
                                                        child: Text(
                                                          'Social Life',
                                                          style: TextStyle(
                                                              fontSize: 17.0),
                                                        ),
                                                      ),
                                                      // subtitle: Text(
                                                      //     'Stay on track with all the new stuff coming soon in Ryta!',
                                                      //     style: TextStyle(fontSize: 17.0)),
                                                      value: socialLifeVal,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          socialLifeVal =
                                                              !socialLifeVal;
                                                        });
                                                      }),
                                                ),
                                              ),
                                            ])),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 30.0, bottom: 5.0),
                                          child: CategoryButton(
                                              'FINISH',
                                              widget.throughIntroduction,
                                              widget.imageId,
                                              widget.imageUrl,
                                              widget.downloadLocationLink,
                                              healthVal,
                                              nutritionVal,
                                              sportsVal,
                                              mentalHealthVal,
                                              careerVal,
                                              educationVal,
                                              personalFinanceVal,
                                              networkingVal,
                                              productivityVal,
                                              leisureVal,
                                              personalGrowthVal,
                                              cultureVal,
                                              romanceVal,
                                              socialLifeVal),
                                        ),
                                      ]),
                                ),
                              )),
                          //   )
                          // ]),
                        ),
                      );
                    });
                  });

              showFoatingActionButton(false);

              bottomSheetController.closed.then((value) {
                showFoatingActionButton(true);
              });
            },
          )
        : Container();
  }

  void showFoatingActionButton(bool value) {
    setState(() {
      showFab = value;
    });
  }
}

class CategoryButton extends StatefulWidget {
  final String buttonName;
  final bool throughIntroduction;
  final String imageId, imageUrl, downloadLocationLink;
  final bool healthVal;
  final bool nutritionVal;
  final bool sportsVal;
  final bool mentalHealthVal;
  final bool careerVal;
  final bool educationVal;
  final bool personalFinanceVal;
  final bool networkingVal;
  final bool productivityVal;
  final bool leisureVal;
  final bool personalGrowthVal;
  final bool cultureVal;
  final bool romanceVal;
  final bool socialLifeVal;

  CategoryButton(
      this.buttonName,
      this.throughIntroduction,
      this.imageId,
      this.imageUrl,
      this.downloadLocationLink,
      this.healthVal,
      this.nutritionVal,
      this.sportsVal,
      this.mentalHealthVal,
      this.careerVal,
      this.educationVal,
      this.personalFinanceVal,
      this.networkingVal,
      this.productivityVal,
      this.leisureVal,
      this.personalGrowthVal,
      this.cultureVal,
      this.romanceVal,
      this.socialLifeVal,
      {Key key})
      : super(key: key);

  @override
  _CategoryButtonState createState() => _CategoryButtonState();
}

class _CategoryButtonState extends State<CategoryButton> {
  UnsplashImage image;

  String goalBackgoundColor;
  String goalFontColor;
  PaletteGenerator paletteGenerator;
  bool generatingPalette = true;

  @override
  Widget build(
    BuildContext context,
  ) {
    return StatefulBuilder(builder: (context, StateSetter setState) {
      final goal = Provider.of<Goal>(context);
      final user = Provider.of<RytaUser>(context);

      return ElevatedButton(
          child: Text(
            widget.buttonName,
          ),
          style: ButtonStyle(
            elevation: MaterialStateProperty.all<double>(0),
          ),
          onPressed: () async {
            showDialog(
                barrierColor: Colors.white.withOpacity(0.8),
                barrierDismissible: false,
                context: context,
                builder: (BuildContext context) {
                  return StatefulBuilder(
                      builder: (context, StateSetter setState) {
                    return AlertDialog(
                      elevation: 0.0,
                      backgroundColor: Colors.white.withOpacity(0),
                      content: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/ryta_logo.png",
                            height: 150,
                            // width: 100,
                          ),
                          Text(
                            'Your visualization is getting ready!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 17.0),
                          )
                        ],
                      ),
                    );
                  });
                });
            //wait for the dialog to show properly
            await Future.delayed(Duration(milliseconds: 500));
            var res = await _getColor(goal, generatingPalette);

            if (res != null) {
              if (widget.throughIntroduction == false) {
                final goalFirestoreId =
                    await DatabaseService(uid: user.uid).getGoalId(0);
                DatabaseService(uid: user.uid).updateThroughIntroduction(true);
                DatabaseService(uid: user.uid)
                    .deleteUserGoals(goalFirestoreId, true);
              }
              //trigger unsplash download
              await UnsplashImageProvider.triggerDownload(
                  widget.downloadLocationLink);

              DateTime currentPhoneDate = DateTime.now(); //DateTime
              Timestamp eventTimeStamp = Timestamp.fromDate(currentPhoneDate);
              await DatabaseService(uid: user.uid).addUserGoals(
                  goal.goalname.toString(),
                  goal.goalmotivation.toString(),
                  widget.imageUrl,
                  widget.imageId,
                  goal.goalBackgoundColor,
                  goal.goalFontColor,
                  widget.healthVal,
                  widget.nutritionVal,
                  widget.sportsVal,
                  widget.mentalHealthVal,
                  widget.careerVal,
                  widget.educationVal,
                  widget.personalFinanceVal,
                  widget.networkingVal,
                  widget.productivityVal,
                  widget.leisureVal,
                  widget.personalGrowthVal,
                  widget.cultureVal,
                  widget.romanceVal,
                  widget.socialLifeVal,
                  eventTimeStamp
                  //array of categories selected by user
                  );
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Wrapper(),
                ),
              );
            } else {
              final snackBar = SnackBar(
                  content: Text('Something went wrong... Please try again!'));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              Navigator.pop(context);
            }
          });
    });
  }

  Future<PaletteGenerator> getImagePalette(ImageProvider imageProvider) async {
    PaletteGenerator paletteGenerator =
        await PaletteGenerator.fromImageProvider(imageProvider,
            // size: Size(600,600),
            maximumColorCount: 20);
    return paletteGenerator;
  }

  static Brightness estimateBrightnessForColor(Color color) {
    final double relativeLuminance = color.computeLuminance();

    // See <https://www.w3.org/TR/WCAG20/#contrast-ratiodef>
    // The spec says to use kThreshold=0.0525, but Material Design appears to bias
    // more towards using light text than WCAG20 recommends. Material Design spec
    // doesn't say what value to use, but 0.15 seemed close to what the Material
    // Design spec shows for its color palette on
    // <https://material.io/go/design-theming#color-color-palette>.
    // const double kThreshold = 0.05;
    if ((relativeLuminance + 0.05) * (relativeLuminance + 0.05) > 0.35)
      return Brightness.light;
    if ((relativeLuminance + 0.05) * (relativeLuminance + 0.05) < 0.05)
      return Brightness.dark;
    return null;
  }

  static Brightness estimateBrightnessForDominantColor(Color color) {
    final double relativeLuminance = color.computeLuminance();
    const double kThreshold = 0.15;
    if ((relativeLuminance + 0.05) * (relativeLuminance + 0.05) > kThreshold)
      return Brightness.light;
    return Brightness.dark;
  }

  _getColor(Goal goal, bool generatingPalette) async {
    // await Future.delayed(Duration(milliseconds: 200));
    try {
      Brightness brightnessDominant;
      Brightness brightnessVibrant;
      Brightness brightnessMuted;
      Brightness brightnessDarkVibrant;
      Brightness brightnessLightVibrant;
      Brightness brightnessLightMuted;

      // get the whole palette
      PaletteGenerator paletteGenerator = await getImagePalette(
              CachedNetworkImageProvider(widget.imageUrl,
                  maxHeight: 1200, maxWidth: 1200))
          .timeout(const Duration(seconds: 5));
      // await getImagePalette(NetworkImage(widget.imageUrl));

      // get brightness of each color
      if (paletteGenerator.dominantColor?.color != null)
        brightnessDominant = estimateBrightnessForDominantColor(
            paletteGenerator.dominantColor?.color);
      // print(brightnessDominant);
      if (paletteGenerator.vibrantColor?.color != null)
        brightnessVibrant =
            estimateBrightnessForColor(paletteGenerator.vibrantColor?.color);
      // print(brightnessVibrant);
      if (paletteGenerator.mutedColor?.color != null)
        brightnessMuted =
            estimateBrightnessForColor(paletteGenerator.mutedColor?.color);
      // print(brightnessMuted);
      if (paletteGenerator.darkVibrantColor?.color != null)
        brightnessDarkVibrant = estimateBrightnessForColor(
            paletteGenerator.darkVibrantColor?.color);
      // print(brightnessDarkVibrant);
      if (paletteGenerator.lightVibrantColor?.color != null)
        brightnessLightVibrant = estimateBrightnessForColor(
            paletteGenerator.lightVibrantColor?.color);
      // print(brightnessLightVibrant);
      if (paletteGenerator.lightMutedColor?.color != null)
        brightnessLightMuted =
            estimateBrightnessForColor(paletteGenerator.lightMutedColor?.color);
      // print(brightnessLightMuted);

      // color picker algorithm
      // dominant color is dark and exists
      if (paletteGenerator.dominantColor?.color != null &&
          brightnessDominant == Brightness.dark)
        // vibrant color is dark and exists
        (paletteGenerator.vibrantColor?.color != null &&
                brightnessVibrant == Brightness.light)
            // (paletteGenerator.vibrantColor?.color!=null)
            ?
            // take it
            goal.goalFontColor =
                '#${paletteGenerator.vibrantColor.color.value.toRadixString(16)}'
            :
            // is not light, look at dark vibrant color
            // dark vibrant color is light and exists
            (paletteGenerator.darkVibrantColor?.color != null &&
                    brightnessDarkVibrant == Brightness.light)
                ?
                // take it
                goal.goalFontColor =
                    '#${paletteGenerator.darkVibrantColor.color.value.toRadixString(16)}'
                :
                // is not light, look at light vibrant color
                // light vibrant color exists
                (paletteGenerator.lightVibrantColor?.color != null &&
                        brightnessLightVibrant == Brightness.light)
                    ?
                    // take it
                    goal.goalFontColor =
                        '#${paletteGenerator.lightVibrantColor.color.value.toRadixString(16)}'
                    :
                    // does not exist, look at muted color
                    // muted color is light and exists
                    (paletteGenerator.mutedColor?.color != null &&
                            brightnessMuted == Brightness.light)
                        ?
                        // take it
                        goal.goalFontColor =
                            '#${paletteGenerator.mutedColor.color.value.toRadixString(16)}'
                        :
                        // does not exist, look at light muted color
                        // light muted color exists
                        (paletteGenerator.lightMutedColor?.color != null &&
                                brightnessLightMuted == Brightness.light)
                            ?
                            // take it
                            goal.goalFontColor =
                                '#${paletteGenerator.lightMutedColor.color.value.toRadixString(16)}'
                            :
                            // does not exist, take white
                            goal.goalFontColor = '#FFFFFF';

      // dominant color is light
      else
        // vibrant color exists
        (paletteGenerator.vibrantColor?.color != null &&
                brightnessVibrant == Brightness.dark)
            ?
            // take it
            goal.goalFontColor =
                '#${paletteGenerator.vibrantColor.color.value.toRadixString(16)}'
            :
            // is not dark, look at dark vibrant color
            // dark vibrant color is dark and exists
            (paletteGenerator.darkVibrantColor?.color != null &&
                    brightnessDarkVibrant == Brightness.dark)
                ?
                // take it
                goal.goalFontColor =
                    '#${paletteGenerator.darkVibrantColor.color.value.toRadixString(16)}'
                :
                // is not dark, look at light vibrant color
                // light vibrant color in dark and exists
                (paletteGenerator.lightVibrantColor?.color != null &&
                        brightnessLightVibrant == Brightness.dark)
                    ?
                    // take it
                    goal.goalFontColor =
                        '#${paletteGenerator.lightVibrantColor.color.value.toRadixString(16)}'
                    :
                    // is not dark, look at muted color
                    // muted color is dark and exists
                    (paletteGenerator.mutedColor?.color != null &&
                            brightnessMuted == Brightness.dark)
                        ?
                        // take it
                        goal.goalFontColor =
                            '#${paletteGenerator.mutedColor.color.value.toRadixString(16)}'
                        :
                        // does not exist, look at dark muted color
                        // dark muted color exists
                        (paletteGenerator.darkMutedColor?.color != null)
                            ?
                            // take it
                            goal.goalFontColor =
                                '#${paletteGenerator.darkMutedColor.color.value.toRadixString(16)}'
                            :
                            // does not exist, take black
                            goal.goalFontColor = '#000000';

      // convert to hex string
      goalBackgoundColor =
          '#${paletteGenerator.dominantColor.color.value.toRadixString(16)}';
      // print('FERTIG');
      setState(() {
        goal.goalBackgoundColor = goalBackgoundColor;
        this.paletteGenerator = paletteGenerator;
        this.generatingPalette = false;
      });
      return "success";
    } on TimeoutException catch (_) {
      print(_);
      return null;
    }
  }

  // Color _getColorFromHex(String hexColor) {
  //   hexColor = hexColor.replaceAll("#", "");
  //   if (hexColor.length == 6) {
  //     hexColor = "FF" + hexColor;
  //   }
  //   if (hexColor.length == 8) {
  //     return Color(int.parse("0x$hexColor"));
  //   }
  // }
}
