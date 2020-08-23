import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:photo_view/photo_view.dart';
import 'package:walleye/src/data/model/photoEntity/photos.dart';
import 'package:wallpaper_manager/wallpaper_manager.dart';

class WallpaperPreview extends StatefulWidget {
  final Photos photo;
  final DefaultCacheManager cacheManager;

  WallpaperPreview(this.photo, this.cacheManager);

  @override
  _WallpaperPreviewState createState() => _WallpaperPreviewState();
}

class _WallpaperPreviewState extends State<WallpaperPreview> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool shouldShowFABLoading = false;
  PhotoViewController d = PhotoViewController();

  @override
  Widget build(BuildContext context) {
//    print(widget.photo.src.toString());
    d.addIgnorableListener(() {
      log(d.position.dx.toString());
    });
//    var pix = MediaQuery.of(context).devicePixelRatio;
//    print(MediaQuery.of(context).size.height / pix);
//    print(MediaQuery.of(context).size.width / pix);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('${widget.photo.photographer} \'s Photo'),
      ),
      body: Hero(
        tag: widget.photo.src.portrait,
        child: PhotoView(
          controller: d,
          basePosition: Alignment.topLeft,
          minScale: PhotoViewComputedScale.covered,
          maxScale: PhotoViewComputedScale.covered * 2,
          loadingBuilder: (_, __) => Center(
            child: CircularProgressIndicator(),
          ),
          imageProvider: CachedNetworkImageProvider(widget.photo.src.large2x),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        isExtended: shouldShowFABLoading ? false : true,
        icon: shouldShowFABLoading ? null : Icon(Icons.done),
        onPressed: () {
          _scaffoldKey.currentState.showBottomSheet(
            (context) => Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: Text('Both Homescreen and Lockscreen'),
                    leading: Icon(Icons.add_to_home_screen),
                    onTap: () {
                      Navigator.pop(context);
                      _setWallpaper(3);
                    },
                  ),
                  ListTile(
                    title: Text('Only Lockscreen'),
                    leading: Icon(Icons.lock),
                    onTap: () {
                      Navigator.pop(context);
                      _setWallpaper(2);
                    },
                  ),
                  ListTile(
                    title: Text('Only Homescreen '),
                    leading: Icon(Icons.home),
                    onTap: () {
                      Navigator.pop(context);
                      _setWallpaper(1);
                    },
                  ),
                ],
              ),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            elevation: 6,
          );
        },
        label: shouldShowFABLoading
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircularProgressIndicator(
                  backgroundColor: Colors.white,
                ),
              )
            : Text('Set Wallpaper'),
      ),
    );
  }

  Future<void> _setWallpaper(int screen) async {
    setState(
      () {
        shouldShowFABLoading = true;
      },
    );

    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text('Patience is the Key'),
        duration: Duration(milliseconds: 500),
      ),
    );
//    var x = await WallpaperManager.setWallpaperFromFile(
//      await widget.cacheManager
//          .getSingleFile(widget.photo.src.large2x)
//          .then((value) => value.path),
//      screen,
//    );
    var pix = MediaQuery.of(context).devicePixelRatio;
    print(MediaQuery.of(context).size.topCenter(Offset(0, 0)) * pix);
    print(MediaQuery.of(context).size.height * pix);
    print(MediaQuery.of(context).size.width * pix);

    var x = await WallpaperManager.setWallpaperFromFileWithCrop(
        await widget.cacheManager
            .getSingleFile(widget.photo.src.large2x)
            .then((value) => value.path),
        screen,
        d.position.dx.floor().abs().toInt(),
        0,
        widget.photo.width,
        widget.photo.height);
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(''),
      ),
    );
    setState(
      () {
        shouldShowFABLoading = false;
      },
    );
  }
}
