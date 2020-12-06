import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:like_button/like_button.dart';
import 'package:walleye/src/data/model/photoEntity/photos.dart';
import 'package:walleye/src/ui/wallpaper_preview.dart';

class WallpaperTile extends StatelessWidget {
  final Photos _photo;
  final _cacheManager = DefaultCacheManager();

  WallpaperTile(this._photo);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) {
            return WallpaperPreview(_photo, _cacheManager);
          },
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Hero(
              tag: _photo.src.portrait,
              child: CachedNetworkImage(
                cacheManager: _cacheManager,
                imageUrl: _photo.src.portrait,
                fit: BoxFit.cover,
                progressIndicatorBuilder: (context, _, __) => Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.black, Colors.transparent],
                    begin: Alignment.bottomCenter,
                    stops: [0, .3],
                    end: Alignment.topCenter),
              ),
            ),
            Positioned(
              left: 15,
              bottom: 15,
              child: Text(
                _photo.photographer,
                style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Positioned(
              top: 10,
              left: 10,
              child: FutureBuilder(
                future: Hive.openBox<Photos>('userBox'),
                builder: (BuildContext context,
                    AsyncSnapshot<Box<Photos>> snapshot) {
                  if (snapshot.hasData) {
                    var photo = snapshot.data.toMap().values.toList();
                    if (photo.contains(_photo)) {
                      return LikeButton(
                        isLiked: true,
                        onTap: (isLiked) {
                          log(
                            snapshot.data.delete(_photo).toString(),
                          );
                          return Future.value(false);
                        },
                        likeBuilder: (isLiked) => Icon(
                          isLiked ? Icons.favorite : Icons.favorite_border,
                        ),
                      );
                    } else {
                      return LikeButton(
                        onTap: (isLiked) {
                          log(
                            snapshot.data.delete(_photo).toString(),
                          );
                          log(snapshot.data.values.toList().toString());
                          return Future.value(true);
                        },
                        likeBuilder: (isLiked) =>
                            Icon(
                              isLiked ? Icons.favorite : Icons.favorite_border,
                            ),
                        isLiked: false,
                      );
                    }
                  } else {
                    return LikeButton(
                      onTap: (isLiked) {
                        log(
                          snapshot.data.add(_photo).toString(),
                        );
                        return Future.value(true);
                      },
                      likeBuilder: (isLiked) =>
                          Icon(
                            isLiked ? Icons.favorite : Icons.favorite_border,
                          ),
                      isLiked: false,
                    );
                  }
                },
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                icon: Icon(
                  Icons.share,
                  color: Colors.white,
                ),
                onPressed: () => _showShareOptions(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _showShareOptions(BuildContext context) async {
    final _base64Image = base64Encode(await _cacheManager
        .getSingleFile(_photo.src.portrait)
        .then((value) => value.readAsBytes()));
    showModalBottomSheet(
        elevation: 6,
        barrierColor: Colors.black.withOpacity(.5),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        )),
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Share to...',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
                Divider(),
                ListTile(
                  title: Text('System Share'),
                  leading: FaIcon(
                    FontAwesomeIcons.share,
                    size: 20,
                  ),
                  onTap: () async {
                    Navigator.pop(context);
                    await FlutterShare.share(
                      title:
                          'Hey! Checkout this Photo by ${_photo.photographer}',
                      text:
                          'Hey! Checkout this Photo by ${_photo.photographer} \n I got it from WallEye',
                      linkUrl: _photo.src.portrait +
                          '\n\n Download WallEye :- // playStore link',
                    );
                  },
                ),
                ListTile(
                  title: Text('WhatsApp'),
                  leading: FaIcon(
                    FontAwesomeIcons.whatsapp,
                    size: 20,
                    color: Color(0xFF25D366),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    FlutterShareMe().shareToWhatsApp(
                      msg:
                          'Hey! Checkout this Photo by ${_photo.photographer} \n I got it from WallEye \n\n Download WallEye :- // playStore link',
                      base64Image: 'data:image/jpeg;base64,$_base64Image',
                    );
                  },
                ),
                ListTile(
                  title: Text('Facebook'),
                  leading: FaIcon(
                    FontAwesomeIcons.facebookF,
                    size: 20,
                    color: Color(0xFF3b5998),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    FlutterShareMe().shareToFacebook(
                      msg:
                          'Hey! Checkout this Photo by ${_photo.photographer} \n I got it from WallEye \n\n Download WallEye :- // playStore link',
                      url: _photo.src.portrait,
                    );
                  },
                ),
                ListTile(
                  title: Text('Twitter'),
                  leading: FaIcon(
                    FontAwesomeIcons.twitter,
                    size: 20,
                    color: Color(0xFF1DA1F2),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    FlutterShareMe().shareToTwitter(
                      msg:
                          'Hey! Checkout this Photo by ${_photo.photographer} \n I got it from WallEye \n\n Download WallEye :- // playStore link',
                      url: _photo.src.portrait,
                    );
                  },
                ),
              ],
            ),
          );
        },
        context: context);
  }
}
