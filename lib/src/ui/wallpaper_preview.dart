import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:photo_view/photo_view.dart';
import 'package:simple_speed_dial/simple_speed_dial.dart';
import 'package:toast/toast.dart';
import 'package:walleye/src/data/model/photoEntity/photos.dart';
import 'package:wallpaper_manager/wallpaper_manager.dart';

class WallpaperPreview extends StatelessWidget {
  final Photos photo;
  final DefaultCacheManager cacheManager;

  WallpaperPreview(this.photo, this.cacheManager);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${photo.photographer} \'s Photo'),
      ),
      body: Hero(
        tag: photo.src.portrait,
        child: PhotoView(
          minScale: PhotoViewComputedScale.covered,
          maxScale: PhotoViewComputedScale.covered * 2,
          loadingBuilder: (_, __) => Center(
            child: CircularProgressIndicator(),
          ),
          imageProvider: CachedNetworkImageProvider(photo.src.portrait),
        ),
      ),
      floatingActionButton: SpeedDial(
        labelsStyle: TextStyle(color: Colors.black),
        child: Icon(Icons.settings_system_daydream),
        speedDialChildren: [
          SpeedDialChild(
            child: Icon(Icons.done),
            label: 'Both Homescreen and Lockscreen',
            onPressed: () async => await _setWallpaper(3, context),
          ),
          SpeedDialChild(
            child: Icon(Icons.lock),
            label: 'Lockscreen Only',
            onPressed: () async => await _setWallpaper(2, context),
          ),
          SpeedDialChild(
            child: Icon(Icons.home),
            label: 'Homescreen only',
            onPressed: () async => await _setWallpaper(1, context),
          ),
        ],
      ),
    );
  }

  Future<void> _setWallpaper(int screen, BuildContext context) async {
    var x = await WallpaperManager.setWallpaperFromFile(
        await cacheManager
            .getSingleFile(photo.src.original)
            .then((value) => value.path),
        screen);
    Toast.show(x, context);
  }
}
