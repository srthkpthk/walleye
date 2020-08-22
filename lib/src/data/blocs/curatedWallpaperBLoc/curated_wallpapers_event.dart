import 'package:flutter/cupertino.dart';

@immutable
abstract class CuratedWallpapersEvent {}

class FetchCuratedWallpapers extends CuratedWallpapersEvent {
  final int currentPageNumber;

  FetchCuratedWallpapers(this.currentPageNumber);
}
