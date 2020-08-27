import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_permission_validator/easy_permission_validator.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
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
        backgroundColor: Theme.of(context).accentColor,
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
                  ListTile(
                    title: Text('Download'),
                    leading: Icon(Icons.file_download),
                    onTap: () {
                      Navigator.pop(context);
                      _downLoadWallpaperBottomSheet(context);
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
    var pix = MediaQuery.of(context).devicePixelRatio;
    var x = await WallpaperManager.setWallpaperFromFileWithCrop(
        await widget.cacheManager
            .getSingleFile(widget.photo.src.large2x)
            .then((value) => value.path),
        screen,
        d.position.dx.floor().abs().toInt(),
        0,
        (MediaQuery.of(context).size.height * pix).toInt(),
        (MediaQuery.of(context).size.height * pix).toInt());
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(x),
      ),
    );
    setState(
      () {
        shouldShowFABLoading = false;
      },
    );
  }

  void _downLoadWallpaperBottomSheet(BuildContext context) {
    _scaffoldKey.currentState.showBottomSheet(
      (context) => Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('Original'),
              leading: Icon(Icons.crop_original),
              onTap: () {
                Navigator.pop(context);
                _downloadWallpaper(widget.photo.src.original);
              },
            ),
            ListTile(
              title: Text('Portrait'),
              leading: Icon(Icons.portrait),
              onTap: () {
                Navigator.pop(context);
                _downloadWallpaper(widget.photo.src.portrait);
              },
            ),
            ListTile(
              title: Text('Large'),
              leading: Icon(Icons.photo_size_select_large),
              onTap: () {
                Navigator.pop(context);
                _downloadWallpaper(widget.photo.src.large2x);
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
  }

  Future<void> _downloadWallpaper(String photoUrl) async {
    await _permissionRequest();
    final taskId = await FlutterDownloader.enqueue(
      url: photoUrl,
      savedDir: await ExtStorage.getExternalStoragePublicDirectory(
          ExtStorage.DIRECTORY_DOWNLOADS),
      showNotification: true,
      openFileFromNotification: true,
    );
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(taskId),
      ),
    );
  }

  _permissionRequest() async => EasyPermissionValidator(
        context: context,
        appName: 'WallEye',
      );
}
