import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:ryta_app/models/goal.dart';
import 'package:ryta_app/models/unsplash_image.dart';
import 'package:ryta_app/services/unsplash_image_provider.dart';
import 'package:ryta_app/shared/constants.dart';
import 'package:ryta_app/shared/loading.dart';
import 'package:ryta_app/widgets/image_tile.dart';

// second screen of the goal definition process - unsplash image search
class GoalImageSearch extends StatefulWidget {
  final String goalname;
  GoalImageSearch(this.goalname);

  @override
  _GoalImageSearchState createState() => _GoalImageSearchState();
}

class _GoalImageSearchState extends State<GoalImageSearch> {
  /// Stores the current page index for the api requests.
  int page = 0, totalPages = -1;

  /// Stores the currently loaded loaded images.
  List<UnsplashImage> images = [];

  /// States whether there is currently a task running loading images.
  bool loadingImages = false;

  /// Stored the currently searched keyword.
  String keyword;

  TextEditingController nameHolder = TextEditingController();

  @override
  initState() {
    super.initState();
    // initial image Request
    _loadImages();
  }

  /// Resets the state to the initial state.
  _resetImages() {
    // clear image list
    images = [];
    // reset page counter
    page = 0;
    totalPages = -1;
    // reset keyword
    keyword = null;
    // show regular images
    _loadImages();
  }

  /// Requests a list of [UnsplashImage] for a given [keyword].
  /// If the given [keyword] is null, trending images are loaded.
  _loadImages({String keyword}) async {
    // check if there is currently a loading task running
    if (loadingImages) {
      // there is currently a task running
      return;
    }
    // check if all pages are already loaded
    if (totalPages != -1 && page >= totalPages) {
      // all pages already loaded
      return;
    }
    // set loading state
    // delay setState, otherwise: Unhandled Exception: setState() or markNeedsBuild() called during build.
    await Future.delayed(Duration(microseconds: 1));
    setState(() {
      // set loading
      loadingImages = true;
      // check if new search
      if (this.keyword != keyword) {
        // clear images for new search
        this.images = [];
        // reset page counter
        this.page = 0;
      }
      // keyword null
      this.keyword = keyword;
    });

    // load images
    List<UnsplashImage> images;
    if (keyword == null) {
      // load images from the next page of trending images
      images = await UnsplashImageProvider.loadImages(page: ++page);
    } else {
      // load images from the next page with a keyword
      List res = await UnsplashImageProvider.loadImagesWithKeyword(keyword,
          page: ++page);
      // set totalPages
      totalPages = res[0];
      // set images
      images = res[1];
    }

    // ignore: todo
    // TODO: handle errors

    // update the state
    setState(() {
      // done loading
      loadingImages = false;
      // set new loaded images
      this.images.addAll(images);
    });
  }

  @override
  Widget build(BuildContext context) {
    final goal = Provider.of<Goal>(context);

    return WillPopScope(
      onWillPop: () async {
        if (keyword != null) {
          _resetImages();
          return false;
        }
        return true;
      },
      child: NotificationListener<OverscrollIndicatorNotification>(
        // disabling a scroll glow
        // ignore: missing_return
        onNotification: (overscroll) {
          overscroll.disallowGlow();
        },
        child: Scaffold(
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
            elevation: 1.0,
            centerTitle: true,
            title: SizedBox(
              height: 70,
              child: Image.asset("assets/ryta_logo.png"),
            ),
          ),
          body: OrientationBuilder(
            builder: (context, orientation) => CustomScrollView(
              // put AppBar in NestedScrollView to have it sliver off on scrolling
              slivers: <Widget>[
                // Title
                _buildTitle(),

                //App bar
                _buildSearchAppBar(goal),

                //Grid view with all the images
                _buildImageGrid(orientation: orientation),

                // loading indicator at the bottom of the list
                loadingImages
                    ? SliverToBoxAdapter(child: Loading(Colors.white))
                    : null,

                // filter null views
              ].where((w) => w != null).toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() => SliverPadding(
        padding: const EdgeInsets.all(16.0),
        sliver: SliverToBoxAdapter(
          child: Center(
            child: Text(
              "Let's find an image for your target",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
            ),
          ),
        ),
      );

  Widget _buildSearchAppBar(goal) => SliverAppBar(
        backgroundColor: Colors.white,
        //Appbar Title
        title:

            // either search-field or just the title
            TextField(
          keyboardType: TextInputType.text,
          decoration: textInputDecoration.copyWith(hintText:  'Search...'),
          // decoration: InputDecoration(hintText: 'Search...', border: InputBorder.none),
          onSubmitted: (String keyword) =>

              // search and display images associated to the keyword
              _loadImages(keyword: keyword),

          controller: nameHolder,
          // autofocus: true,
        ),

        // const Text('Define Your Goal', style: TextStyle(color: Colors.black87)),

        //Appbar actions
        // leading: new Container(),
        automaticallyImplyLeading: false,
      );

  /// Returns the grid that displays images.
  /// [orientation] can be used to adjust the grid column count.
  Widget _buildImageGrid({orientation = Orientation.portrait}) {
    // calc columnCount based on orientation
    int columnCount = orientation == Orientation.portrait ? 2 : 3;
    // return staggered grid

    return SliverPadding(
      padding: const EdgeInsets.all(16.0),
      sliver: SliverStaggeredGrid.countBuilder(
        // set column count
        crossAxisCount: columnCount,
        itemCount: images.length,
        // set itemBuilder
        itemBuilder: (BuildContext context, int index) =>
            _buildImageItemBuilder(index),
        staggeredTileBuilder: (int index) =>
            _buildStaggeredTile(images[index], columnCount),
        mainAxisSpacing: 16.0,
        crossAxisSpacing: 16.0,
      ),
    );
  }

  /// Returns a FutureBuilder to load a [UnsplashImage] for a given [index].
  Widget _buildImageItemBuilder(int index) => FutureBuilder(
        // pass image loader
        future: _loadImage(index),
        builder: (context, snapshot) =>
            // image loaded return [_ImageTile]
            ImageTile(snapshot.data),
      );

  /// Asynchronously loads a [UnsplashImage] for a given [index].
  Future<UnsplashImage> _loadImage(int index) async {
    // check if new images need to be loaded
    if (index >= images.length - 2) {
      // Reached the end of the list. Try to load more images.
      _loadImages(keyword: keyword);
    }
    return index < images.length ? images[index] : null;
  }

  /// Returns a StaggeredTile for a given [image].
  StaggeredTile _buildStaggeredTile(UnsplashImage image, int columnCount) {
    // calc image aspect ration
    double aspectRatio =
        image.getHeight().toDouble() / image.getWidth().toDouble();
    // calc columnWidth
    double columnWidth = MediaQuery.of(context).size.width / columnCount;
    // not using [StaggeredTile.fit(1)] because during loading StaggeredGrid is really jumpy.
    return StaggeredTile.extent(1, aspectRatio * columnWidth);
  }
}
