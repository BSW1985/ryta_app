import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:ryta_app/models/unsplash_image.dart';
import 'package:ryta_app/services/unsplash_image_provider.dart';
import 'package:ryta_app/shared/loading.dart';
import 'package:ryta_app/models/goal.dart';
import 'package:ryta_app/shared/constants.dart';
import 'package:provider/provider.dart';
import 'package:parallax_image/parallax_image.dart';

/// Screen for showing an individual goal ---> Visualization
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

  /// Displayed image.
  UnsplashImage image;

  @override
  void initState() {
    super.initState();
    // load image
    _loadImage();
  }

  /// Reloads the image from unsplash to get extra data, like: exif, location, ...
  _loadImage() async {
    UnsplashImage image = await UnsplashImageProvider.loadImage(widget.imageId);
    setState(() {
      this.image = image;
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
    final _formKey = new GlobalKey<FormState>();

    String goalname = '';
    String goalmotivation = '';
    String error = '';

    final goal = Provider.of<Goal>(context);

    return Scaffold(
        key: _formKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            color: Colors.black,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: Colors.white,
          elevation: 0.0,
          centerTitle: true,
          title: SizedBox(
            height: 70,
            child: Image.asset("assets/ryta_logo.png"),),
        ),
        body: ListView (
            padding: EdgeInsets.symmetric(horizontal: 25.0),
            children: [
              Form(
                key: _scaffoldKey,
                child: Column(
                  children: <Widget>[
                    // Input goal name
                  SizedBox(height: 40.0),
                  SizedBox(height: 50.0),
                  Text(
                    "What is your goal/target?",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
                  ),
                  SizedBox(height: 15.0),
                  TextFormField(
                    initialValue: widget.goal.goalname,
                    decoration: textInputDecoration.copyWith(hintText: 'The target'),
                    validator: (val) => val.isEmpty ? 'Enter the target title' : null,
                    onChanged: (val) {
                      setState(() => goalname = val);
                    }
                  ),
                  SizedBox(height: 30.0),
                  Text(
                    "Why do you want to achieve/reach it?",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
                  ),
                  SizedBox(height: 15.0),
                  TextFormField(
                    initialValue: widget.goal.goalmotivation,
                    keyboardType: TextInputType.multiline,
                    maxLines: 3,
                    decoration: textInputDecoration.copyWith(hintText: 'Your motivation'),
                    validator: (val) => val.isEmpty ? 'Your motivation is important part of the definition!' : null,
                    onChanged: (val) {
                      setState(() => goalmotivation = val);
                    }
                  ),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                      child: Text(
                        "SAVE",
                        //style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          goal.goalname = goalname;
                          goal.goalmotivation = goalmotivation;
                          Navigator.pop(context);
                        }
                      }
                  ),
                ]
              ),
              ),
          ]
        ),
    );
  }
}