import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:ryta_app/models/goal.dart';
import 'package:ryta_app/models/unsplash_image.dart';
import 'package:ryta_app/services/unsplash_image_provider.dart';
import 'package:ryta_app/shared/loading.dart';


/// Screen for showing an individual goal ---> Vusialization
class GoalPage extends StatefulWidget {
  final String imageId, imageUrl;
  
  final Goal goal;
  // GoalPage(this.imageId, this.imageUrl, {Key key}) : super(key: key);
  GoalPage(this.goal, this.imageId, this.imageUrl, {Key key}) : super(key: key);

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

  bool _motivationOn=false;

  @override
  Future<void> initState() {
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
        leading:
            // back button
            IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () => Navigator.pop(context)),
      );

  /// Returns PhotoView around given [imageId] & [imageUrl].
  Widget _buildPhotoView(String imageId, String imageUrl) => Hero(
        tag: imageId,
        child: PhotoView(
          imageProvider: NetworkImage(imageUrl),
          initialScale: PhotoViewComputedScale.covered,
          minScale: PhotoViewComputedScale.covered,
          maxScale: PhotoViewComputedScale.covered,
          loadingBuilder: (BuildContext context, ImageChunkEvent imageChunkEvent) {
            return Center(child: Loading(Colors.black));
          },
        ),
      );

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      // set the global key
      key: _scaffoldKey,
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          _buildPhotoView(widget.imageId, widget.imageUrl),
          // wrap in Positioned to not use entire screen
          
          Positioned(top: 0.0, left: 0.0, right: 0.0, child: _buildAppBar()),
          
          if (_motivationOn==false)
          Positioned(bottom: 75.0, left: 20.0, 
          // _selectedIndex == 0 ? Color(0xFF995C75) : Colors.grey[400]
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Container(
                color: goalBackgound.withOpacity(0.8),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SizedBox(
                    width: 180.0,
                    child: Text(
                      widget.goal.goalname,
                      softWrap: true,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 34.0, color: goalFont),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          ),
        if (_motivationOn==false)
        Align(
          alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: FloatingActionButton.extended(
                // icon: Icon(Icons.check),
                shape: RoundedRectangleBorder(
                                    side: BorderSide(color: goalBackgound, width: 1.0),
                                    borderRadius: BorderRadius.circular(15.0)),
                elevation: 0.0,
                label: Text(
                    'Why?',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0, color: goalBackgound)
                    ),
                tooltip: 'See the motivation!',
                onPressed: () {
                  setState(() {
                    _motivationOn=true;
                  });
                  showDialog(
                  barrierColor: Colors.white.withOpacity(0),
                  barrierDismissible: true,
                  context: context,
                  builder: (BuildContext context) {
                    return WillPopScope(
                          onWillPop: () {
                            Navigator.of(context).pop();     
                            setState(() {
                              _motivationOn=false;
                            });},
                      child: AlertDialog(
                      elevation:0.0,
                      shape: RoundedRectangleBorder(
                                    // side: BorderSide(color: goalFont, width: 1.0),
                                    borderRadius: BorderRadius.circular(15.0)),
                      backgroundColor: goalBackgound.withOpacity(0.8),
                      title: Text(widget.goal.goalname, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 34.0, color: goalFont), textAlign: TextAlign.center,),
                      content: Text(widget.goal.goalmotivation, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0, color: goalFont)),
                      // actions: <Widget>[
                      //   TextButton(
                      //     child: Text('Mach ich!'),
                      //     onPressed: (){
                      //       Navigator.of(context).pop();
                      //     }
                      //   ),
                      // ],
                    ),
                    );
                  },
                );
// showGeneralDialog(
//   context: context,
//   pageBuilder: (BuildContext buildContext,
//       Animation<double> animation,
//       Animation<double> secondaryAnimation) {
//     return SafeArea(
//       child: Builder(builder: (context) {
//         return Material(
//             color: Colors.transparent,
//             child: Align(
//                 alignment: Alignment.center,
//                 child: Container(
//                     height: 200.0,
//                     width: 250.0,
//                     color: Colors.transparent,
//                     child:
//                         Center(child: Text(widget.goal.goalmotivation, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0, color: goalFont))))));
//       }),
//     );
//   },
//   barrierDismissible: true,
//   barrierLabel: MaterialLocalizations.of(context)
//       .modalBarrierDismissLabel,
//   barrierColor: null,
//   transitionDuration: const Duration(milliseconds: 150));

                  // showDialog(
                  //     context: context,
                  //     builder: (context) =>
                  // AlertDialog(
                  //   elevation:0.0,
                  //     title: Text('Ask Marek for Unsplash keys'),
                  //     content: Text('Otherwise it will not work'),
                  //     // actions: <Widget>[
                  //     //   TextButton(
                  //     //     child: Text('Mach ich!'),
                  //     //     onPressed: (){
                  //     //       Navigator.of(context).pop();
                  //     //     }
                  //     //   ),
                  //     // ],
                  //   ),
                  // );

                  // infoBottomSheetController = _showInfoBottomSheet();

          //       showModalBottomSheet<void>(
          //   context: context,
          //   builder: (BuildContext context) {
          //     return Container(
          //       height: 200,
          //       color: Colors.transparent,
          //       child: Center(
          //         child: Column(
          //           mainAxisAlignment: MainAxisAlignment.center,
          //           mainAxisSize: MainAxisSize.min,
          //           children: <Widget>[
          //             const Text('Modal BottomSheet'),
          //             // ElevatedButton(
          //             //   child: const Text('Close BottomSheet'),
          //             //   onPressed: () => Navigator.pop(context),
          //             // )
          //           ],
          //         ),
          //       ),
          //     );
          //   },
          // );
                  },

                backgroundColor: Colors.transparent,
      ),
            ),
        ),

      
        ],
        
      ),

      

    // floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
  /// Shows a BottomSheet containing image info.
  PersistentBottomSheetController _showInfoBottomSheet() {
    return _scaffoldKey.currentState.showBottomSheet((context) => Text('ahoj'),
    
    // Card(
    //   margin: const EdgeInsets.all(0.0),
    //   elevation: 0.0,
    //   shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.only(topLeft: const Radius.circular(15.0), topRight: const Radius.circular(15.0)),
    //     side: BorderSide(color: goalBackgound, width: 1.0), 
    //     ),
    //   color: goalBackgound.withOpacity(0.8),
    //             child: Padding(
    //               padding: const EdgeInsets.all(20.0),
    //               child: Column(
    //                 crossAxisAlignment: CrossAxisAlignment.end,
    //                 mainAxisSize: MainAxisSize.min,
    //                 children: <Widget>[ InkWell(
    //                                       child: Text(
    //                     widget.goal.goalname,
    //                     softWrap: true,
    //                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 34.0, color: goalFont),
    //                     textAlign: TextAlign.center,
    //                   ),
    //                 ),
    //                 ],
    //               ),
    //             ),
    // )
    );
  }
  
  static Brightness estimateBrightnessForColor(Color color) {
  final double relativeLuminance = color.computeLuminance();

  // See <https://www.w3.org/TR/WCAG20/#contrast-ratiodef>
  // The spec says to use kThreshold=0.0525, but Material Design appears to bias
  // more towards using light text than WCAG20 recommends. Material Design spec
  // doesn't say what value to use, but 0.15 seemed close to what the Material
  // Design spec shows for its color palette on
  // <https://material.io/go/design-theming#color-color-palette>.
  const double kThreshold = 0.15;
  if ((relativeLuminance + 0.05) * (relativeLuminance + 0.05) > kThreshold)
    return Brightness.light;
  return Brightness.dark;
  }
  Color _getColorFromHex(String hexColor) {
  hexColor = hexColor.replaceAll("#", "");
  if (hexColor.length == 6) {
    hexColor = "FF" + hexColor;
  }
  if (hexColor.length == 8) {
    return Color(int.parse("0x$hexColor"));
  }
}
}

// Why button
          //  IconButton(
          //   icon: Icon(
          //     Icons.info_outline,
          //     color: Colors.white,
          //   ),
          //   tooltip: 'Image Info',
          //   onPressed: () => infoBottomSheetController = _showInfoBottomSheet(),
          // ),