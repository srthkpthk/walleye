import 'package:flutter/cupertino.dart';
import 'package:walleye/src/data/model/photoEntity/photos.dart';

@immutable
abstract class CuratedWallpapersState {}

class CuratedWallpapersInitial extends CuratedWallpapersState {}

class CuratedWallpapersFailed extends CuratedWallpapersState {}

class CuratedWallpapersSuccess extends CuratedWallpapersState {
  final List<Photos> photos;
  final int currentPageNumber;

  CuratedWallpapersSuccess(this.photos, this.currentPageNumber);
}
