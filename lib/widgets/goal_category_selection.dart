import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:provider/provider.dart';
import 'package:ryta_app/models/goal.dart';
import 'package:ryta_app/models/unsplash_image.dart';
import 'package:ryta_app/models/user.dart';
import 'package:ryta_app/screens/home/home.dart';
import 'package:ryta_app/services/database.dart';
import 'package:ryta_app/shared/loading.dart';


class FinishFloatingActionButton extends StatefulWidget {
  final String imageId, imageUrl;

  FinishFloatingActionButton(this.imageId, this.imageUrl, {Key key}) : super(key: key);

  @override
  _FinishFloatingActionButtonState createState() => _FinishFloatingActionButtonState();
  }

class _FinishFloatingActionButtonState extends State<FinishFloatingActionButton> {

  /// Displayed image.
  UnsplashImage image;
  bool showFab = true;


  @override
  Widget build(BuildContext context) {
    return showFab
        ? FloatingActionButton.extended(
          icon: Icon(Icons.check),
          label: Text('FINISH'),
          backgroundColor: Color(0xFF995C75),
          onPressed: () {
              var bottomSheetController = showBottomSheet(
                context: context,
                builder: (context) => Container(
                    color: Colors.transparent,
                    margin: const EdgeInsets.only(top: 5, left: 15, right: 15),
                    height: 410,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            height: 375,
                            decoration: BoxDecoration(
                                color: Colors.white70,
                                borderRadius: BorderRadius.all(Radius.circular(15)),
                                ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: SheetButton(widget.imageId, widget.imageUrl),
                                ),

                                Padding(
                                  padding: const EdgeInsets.only(left:15.0, right:15.0,bottom:20.0),
                                  child: Text(
                                    'Into which category fits your goal the most?',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0, ),
                                    ),
                                ),
                                
                                CategoryButton('Category 1', widget.imageId, widget.imageUrl),
                                CategoryButton('Category 2', widget.imageId, widget.imageUrl),
                                CategoryButton('Category 3', widget.imageId, widget.imageUrl),
                                CategoryButton('Category 4', widget.imageId, widget.imageUrl),
                              ]
                            ),
                        )



                      ]
                    ),
                  )
                  );
                  
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

class CategoryButton extends StatelessWidget {

  final String buttonName;
  final String imageId, imageUrl;

  CategoryButton(this.buttonName, this.imageId, this.imageUrl);

  @override
  Widget build(BuildContext context) {

    final goal = Provider.of<Goal>(context);
    final user = Provider.of<RytaUser>(context);


    return ElevatedButton(
          child: Text(
            buttonName,
            ),
          style: ButtonStyle(
            elevation: MaterialStateProperty.all<double>(0),
            padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0)),
            // backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
          ),
          onPressed: () async {

              DatabaseService(uid: user.uid).addUserGoals(
                goal.goalname.toString(), 
                goal.goalmotivation.toString(), 
                imageUrl, 
                imageId, 
                goal.goalBackgoundColor,
                goal.goalFontColor,
                buttonName,
                );
              Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Home(),
                          ),
                 );

  
          }
    );
  }
}

class SheetButton extends StatefulWidget {

  final String imageId, imageUrl;

  SheetButton(this.imageId, this.imageUrl, {Key key}) : super(key: key);

@override
  _SheetButtonState createState() => _SheetButtonState();
}

class _SheetButtonState extends State<SheetButton> {

  /// Displayed image.
  UnsplashImage image;

  String goalBackgoundColor;
  String goalFontColor;
  PaletteGenerator paletteGenerator;
  bool generatingPalette =true;


  @override
  Widget build(BuildContext context) {

    final goal = Provider.of<Goal>(context);

    if (generatingPalette == true)
    _getColor(goal, generatingPalette);

    return generatingPalette
        ? Center(child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text('Your visualization is getting ready!'),
            ),
            Loading(Colors.transparent),
          ],
        ))

        : Padding(
          padding: const EdgeInsets.all(7.5),
          child: Icon(
              Icons.check,
              color: Colors.black,
              size: 40.0,
            ),
        );

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


  _getColor(Goal goal, bool generatingPalette) async {

    await Future.delayed(Duration(milliseconds: 1000));

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
    // print(brightnessDominant);
    if (paletteGenerator.vibrantColor?.color!=null)
    brightnessVibrant = estimateBrightnessForColor(paletteGenerator.vibrantColor?.color);
    // print(brightnessVibrant);
    if (paletteGenerator.mutedColor?.color!=null)
    brightnessMuted = estimateBrightnessForColor(paletteGenerator.mutedColor?.color);
    // print(brightnessMuted);
    if (paletteGenerator.darkVibrantColor?.color!=null)
    brightnessDarkVibrant = estimateBrightnessForColor(paletteGenerator.darkVibrantColor?.color);
    // print(brightnessDarkVibrant);
    if (paletteGenerator.lightVibrantColor?.color!=null)
    brightnessLightVibrant = estimateBrightnessForColor(paletteGenerator.lightVibrantColor?.color);
    // print(brightnessLightVibrant);
    if (paletteGenerator.lightMutedColor?.color!=null)
    brightnessLightMuted = estimateBrightnessForColor(paletteGenerator.lightMutedColor?.color);
    // print(brightnessLightMuted);
    
    
    // color picker algorithm
    // dominant color is dark and exists
    if (paletteGenerator.dominantColor?.color!=null && brightnessDominant==Brightness.dark)
      // vibrant color is dark and exists
      (paletteGenerator.vibrantColor?.color!=null && brightnessVibrant==Brightness.light) 
      // (paletteGenerator.vibrantColor?.color!=null)
        ?
          // take it
          goal.goalFontColor='#${paletteGenerator.vibrantColor.color.value.toRadixString(16)}'
        : 
          // is not light, look at dark vibrant color
          // dark vibrant color is light and exists
          (paletteGenerator.darkVibrantColor?.color!=null && brightnessDarkVibrant==Brightness.light) 
            ?
              // take it
              goal.goalFontColor='#${paletteGenerator.darkVibrantColor.color.value.toRadixString(16)}'
            : 
              // is not light, look at light vibrant color
              // light vibrant color exists
              (paletteGenerator.lightVibrantColor?.color!=null && brightnessLightVibrant==Brightness.light) 
                ?
                  // take it
                  goal.goalFontColor='#${paletteGenerator.lightVibrantColor.color.value.toRadixString(16)}'
                : 
                  // does not exist, look at muted color
                  // muted color is light and exists
                  (paletteGenerator.mutedColor?.color!=null && brightnessMuted==Brightness.light) 
                    ?
                      // take it
                      goal.goalFontColor='#${paletteGenerator.mutedColor.color.value.toRadixString(16)}'
                    : 
                      // does not exist, look at light muted color
                      // light muted color exists
                      (paletteGenerator.lightMutedColor?.color!=null && brightnessLightMuted==Brightness.light) 
                        ?
                          // take it
                          goal.goalFontColor='#${paletteGenerator.lightMutedColor.color.value.toRadixString(16)}'
                        : 
                          // does not exist, take white
                          goal.goalFontColor='#FFFFFF';
              

    // dominant color is light
      else
      // vibrant color exists
      (paletteGenerator.vibrantColor?.color!=null && brightnessVibrant==Brightness.dark) 
        ?
          // take it
          goal.goalFontColor='#${paletteGenerator.vibrantColor.color.value.toRadixString(16)}'
        : 
          // is not dark, look at dark vibrant color
          // dark vibrant color is dark and exists
          (paletteGenerator.darkVibrantColor?.color!=null && brightnessDarkVibrant==Brightness.dark) 
            ?
              // take it
              goal.goalFontColor='#${paletteGenerator.darkVibrantColor.color.value.toRadixString(16)}'
            : 
              // is not dark, look at light vibrant color
              // light vibrant color in dark and exists
              (paletteGenerator.lightVibrantColor?.color!=null && brightnessLightVibrant==Brightness.dark) 
                ?
                  // take it
                  goal.goalFontColor='#${paletteGenerator.lightVibrantColor.color.value.toRadixString(16)}'
                : 
                  // is not dark, look at muted color
                  // muted color is dark and exists
                  (paletteGenerator.mutedColor?.color!=null && brightnessMuted==Brightness.dark) 
                    ?
                      // take it
                      goal.goalFontColor='#${paletteGenerator.mutedColor.color.value.toRadixString(16)}'
                    : 
                      // does not exist, look at dark muted color
                      // dark muted color exists
                      (paletteGenerator.darkMutedColor?.color!=null) 
                        ?
                          // take it
                          goal.goalFontColor='#${paletteGenerator.darkMutedColor.color.value.toRadixString(16)}'
                        : 
                          // does not exist, take black
                          goal.goalFontColor='#000000';

    // convert to hex string
    goalBackgoundColor='#${paletteGenerator.dominantColor.color.value.toRadixString(16)}';
    // print('FERTIG');
    setState(() {
      goal.goalBackgoundColor = goalBackgoundColor;
      this.paletteGenerator = paletteGenerator;
      this.generatingPalette = false;
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