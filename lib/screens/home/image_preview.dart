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
import 'package:ryta_app/widgets/goal_category_selection.dart';
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
  PersistentBottomSheetController infoBottomSheetController;

  /// Displayed image.
  UnsplashImage image;

  String goalBackgoundColor;
  String goalFontColor;
  PaletteGenerator paletteGenerator;

  // visualize the color palette
  bool paletteVisualization = false;


  @override
  void initState() {
    super.initState();

    // load image
    _loadImage();

    // get the colors
    // _getColor();

  }

  /// Reloads the image from unsplash to get extra data, like: exif, location, ...
  _loadImage() async {

    UnsplashImage image = await UnsplashImageProvider.loadImage(widget.imageId);
    // NetworkImage imageasset = NetworkImage(widget.imageUrl);
    setState(() {
      this.image = image;
      // this.imageasset = imageasset;
      // reload bottom sheet if open
      if (infoBottomSheetController != null) _showInfoBottomSheet();
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

if(paletteGenerator != null && paletteVisualization == true)
          Positioned(bottom: 80.0, left: 20.0, 
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                color: _getColorFromHex(goalBackgoundColor).withOpacity(0.8),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SizedBox(
                    width: 100.0,
                    child: Text('target', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0, color: _getColorFromHex(goalFontColor)),
                      textAlign: TextAlign.center,),
                  ),
                ),
              ),
            ),
          ),

if(paletteGenerator != null && paletteVisualization == true)
          Positioned(bottom: 80.0, right: 20.0, 
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                color: paletteGenerator.dominantColor?.color,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SizedBox(
                    width: 80.0,
                    child: Text('dominant', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ),
            ),
          ),

if(paletteGenerator != null && paletteVisualization == true)
          Positioned(bottom: 160.0, right: 20.0, 
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                color: paletteGenerator.vibrantColor?.color,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SizedBox(
                    width: 80.0,
                    child: Text('vibrant', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ),
            ),
          ),

if(paletteGenerator != null && paletteVisualization == true)
          Positioned(bottom: 240.0, right: 20.0, 
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                color: paletteGenerator.lightVibrantColor?.color,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SizedBox(
                    width: 80.0,
                    child: Text('light vibrant', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ),
            ),
          ),

if(paletteGenerator != null && paletteVisualization == true)
          Positioned(bottom: 320.0, right: 20.0, 
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                color: paletteGenerator.darkVibrantColor?.color,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SizedBox(
                    width: 80.0,
                    child: Text('dark vibrant', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ),
            ),
          ),

if(paletteGenerator != null && paletteVisualization == true)
          Positioned(bottom: 400.0, right: 20.0, 
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                color: paletteGenerator.mutedColor?.color,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SizedBox(
                    width: 80.0,
                    child: Text('muted', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ),
            ),
          ),

if(paletteGenerator != null && paletteVisualization == true)
          Positioned(bottom: 480.0, right: 20.0, 
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                color: paletteGenerator.lightMutedColor?.color,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SizedBox(
                    width: 80.0,
                    child: Text('light muted', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ),
            ),
          ),

if(paletteGenerator != null && paletteVisualization == true)
          Positioned(bottom: 560.0, right: 20.0, 
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                color: paletteGenerator.darkMutedColor?.color,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SizedBox(
                    width: 80.0,
                    child: Text('dark muted', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ),
            ),
          ),
          

        ],
      ),
      floatingActionButton: FinishFloatingActionButton(widget.imageId, widget.imageUrl),

      

      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  /// Shows a BottomSheet containing image info.
  PersistentBottomSheetController _showInfoBottomSheet() {
    return _scaffoldKey.currentState.showBottomSheet((context) => InfoSheet(image));
  }
  Future<PaletteGenerator> getImagePalette (ImageProvider imageProvider) async {
    PaletteGenerator paletteGenerator = await PaletteGenerator
        .fromImageProvider(imageProvider,
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


  _getColor() async {

    Brightness brightnessDominant;
    Brightness brightnessVibrant;
    Brightness brightnessMuted;
    Brightness brightnessDarkVibrant;
    Brightness brightnessLightVibrant;
    Brightness brightnessLightMuted;

    // get the whole palette
    PaletteGenerator paletteGenerator = await getImagePalette(NetworkImage(widget.imageUrl));
    
    // get brightness of each color
    if (paletteGenerator.dominantColor?.color!=null)
    brightnessDominant = estimateBrightnessForDominantColor(paletteGenerator.dominantColor?.color);
    print(brightnessDominant);
    if (paletteGenerator.vibrantColor?.color!=null)
    brightnessVibrant = estimateBrightnessForColor(paletteGenerator.vibrantColor?.color);
    print(brightnessVibrant);
    if (paletteGenerator.mutedColor?.color!=null)
    brightnessMuted = estimateBrightnessForColor(paletteGenerator.mutedColor?.color);
    print(brightnessMuted);
    if (paletteGenerator.darkVibrantColor?.color!=null)
    brightnessDarkVibrant = estimateBrightnessForColor(paletteGenerator.darkVibrantColor?.color);
    print(brightnessDarkVibrant);
    if (paletteGenerator.lightVibrantColor?.color!=null)
    brightnessLightVibrant = estimateBrightnessForColor(paletteGenerator.lightVibrantColor?.color);
    print(brightnessLightVibrant);
    if (paletteGenerator.lightMutedColor?.color!=null)
    brightnessLightMuted = estimateBrightnessForColor(paletteGenerator.lightMutedColor?.color);
    print(brightnessLightMuted);
    
    
    // color picker algorithm
    // dominant color is dark and exists
    if (paletteGenerator.dominantColor?.color!=null && brightnessDominant==Brightness.dark)
      // vibrant color is dark and exists
      (paletteGenerator.vibrantColor?.color!=null && brightnessVibrant==Brightness.light) 
      // (paletteGenerator.vibrantColor?.color!=null)
        ?
          // take it
          goalFontColor='#${paletteGenerator.vibrantColor.color.value.toRadixString(16)}'
        : 
          // is not light, look at dark vibrant color
          // dark vibrant color is light and exists
          (paletteGenerator.darkVibrantColor?.color!=null && brightnessDarkVibrant==Brightness.light) 
            ?
              // take it
              goalFontColor='#${paletteGenerator.darkVibrantColor.color.value.toRadixString(16)}'
            : 
              // is not light, look at light vibrant color
              // light vibrant color exists
              (paletteGenerator.lightVibrantColor?.color!=null && brightnessLightVibrant==Brightness.light) 
                ?
                  // take it
                  goalFontColor='#${paletteGenerator.lightVibrantColor.color.value.toRadixString(16)}'
                : 
                  // does not exist, look at muted color
                  // muted color is light and exists
                  (paletteGenerator.mutedColor?.color!=null && brightnessMuted==Brightness.light) 
                    ?
                      // take it
                      goalFontColor='#${paletteGenerator.mutedColor.color.value.toRadixString(16)}'
                    : 
                      // does not exist, look at light muted color
                      // light muted color exists
                      (paletteGenerator.lightMutedColor?.color!=null && brightnessLightMuted==Brightness.light) 
                        ?
                          // take it
                          goalFontColor='#${paletteGenerator.lightMutedColor.color.value.toRadixString(16)}'
                        : 
                          // does not exist, take white
                          goalFontColor='#FFFFFF';
              

    // dominant color is light
      else
      // vibrant color exists
      (paletteGenerator.vibrantColor?.color!=null && brightnessVibrant==Brightness.dark) 
        ?
          // take it
          goalFontColor='#${paletteGenerator.vibrantColor.color.value.toRadixString(16)}'
        : 
          // is not dark, look at dark vibrant color
          // dark vibrant color is dark and exists
          (paletteGenerator.darkVibrantColor?.color!=null && brightnessDarkVibrant==Brightness.dark) 
            ?
              // take it
              goalFontColor='#${paletteGenerator.darkVibrantColor.color.value.toRadixString(16)}'
            : 
              // is not dark, look at light vibrant color
              // light vibrant color in dark and exists
              (paletteGenerator.lightVibrantColor?.color!=null && brightnessLightVibrant==Brightness.dark) 
                ?
                  // take it
                  goalFontColor='#${paletteGenerator.lightVibrantColor.color.value.toRadixString(16)}'
                : 
                  // is not dark, look at muted color
                  // muted color is dark and exists
                  (paletteGenerator.mutedColor?.color!=null && brightnessMuted==Brightness.dark) 
                    ?
                      // take it
                      goalFontColor='#${paletteGenerator.mutedColor.color.value.toRadixString(16)}'
                    : 
                      // does not exist, look at dark muted color
                      // dark muted color exists
                      (paletteGenerator.darkMutedColor?.color!=null) 
                        ?
                          // take it
                          goalFontColor='#${paletteGenerator.darkMutedColor.color.value.toRadixString(16)}'
                        : 
                          // does not exist, take black
                          goalFontColor='#000000';

    // convert to hex string
    goalBackgoundColor='#${paletteGenerator.dominantColor.color.value.toRadixString(16)}';

    setState(() {
      this.goalBackgoundColor = goalBackgoundColor;
      this.paletteGenerator = paletteGenerator;
    }); 
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