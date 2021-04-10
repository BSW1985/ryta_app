import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:ryta_app/models/goal.dart';
import 'package:ryta_app/models/unsplash_image.dart';
import 'package:ryta_app/models/user.dart';
import 'package:ryta_app/screens/home/home.dart';
import 'package:ryta_app/services/database.dart';
import 'package:ryta_app/services/unsplash_image_provider.dart';
import 'package:ryta_app/shared/loading.dart';
import 'package:ryta_app/widgets/info_sheet.dart';

/// Screen for showing an individual [UnsplashImage].
class ImagePage extends StatefulWidget {
  final String imageId, imageUrl;

  ImagePage(this.imageId, this.imageUrl, {Key key}) : super(key: key);

  @override
  _ImagePageState createState() => _ImagePageState();
}

/// Provide a state for [ImagePage].
class _ImagePageState extends State<ImagePage> {

  /// create global key to show info bottom sheet
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  /// Bottomsheet controller
  PersistentBottomSheetController infoBottomSheetController, collectionsBottomSheetController;

  /// Displayed image.
  UnsplashImage image;

  String maincolor;
  Brightness brightness;

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
      // reload bottom sheet if open
      if (infoBottomSheetController != null) _showInfoBottomSheet();
    });
  }

  _getColor() async {
    Color color = await getImagePalette(NetworkImage(widget.imageUrl));
    maincolor='#${color.value.toRadixString(16)}';
    setState(() {
      this.maincolor = maincolor;
    }); 
  }

  /// Returns AppBar.
  Widget _buildAppBar(user, goal, String imageUrl, String imageID) => AppBar(
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
        actions: <Widget>[
          // show image info
          IconButton(
            icon: Icon(
              Icons.info_outline,
              color: Colors.white,
            ),
            tooltip: 'Image Info',
            onPressed: () => infoBottomSheetController = _showInfoBottomSheet(),
          ),
        ],
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

    final goal = Provider.of<Goal>(context);
    final user = Provider.of<RytaUser>(context);

    return Scaffold(
      // set the global key
      key: _scaffoldKey,
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          _buildPhotoView(widget.imageId, widget.imageUrl),
          // wrap in Positioned to not use entire screen
          Positioned(top: 0.0, left: 0.0, right: 0.0, child: _buildAppBar(user, goal, widget.imageUrl, widget.imageId)),
          
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.check),
        label: Text('FINISH'),
          onPressed: () async {
              print(maincolor);
              DatabaseService(uid: user.uid).addUserGoals(
                goal.goalname.toString(), 
                goal.goalmotivation.toString(), 
                widget.imageUrl, 
                widget.imageId, 
                maincolor);
              Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Home(),
                          ),
                 );
          },
          backgroundColor: Color(0xFF995C75),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  /// Shows a BottomSheet containing image info.
  PersistentBottomSheetController _showInfoBottomSheet() {
    return _scaffoldKey.currentState.showBottomSheet((context) => InfoSheet(image));
  }
    Future<Color> getImagePalette (ImageProvider imageProvider) async {
    final PaletteGenerator paletteGenerator = await PaletteGenerator
        .fromImageProvider(imageProvider);
    return paletteGenerator.dominantColor.color;
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
}