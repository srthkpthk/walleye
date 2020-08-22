part of 'curated_wallpapers_bloc.dart';

@immutable
abstract class CuratedWallpapersState {}

class CuratedWallpapersInitial extends CuratedWallpapersState {}

class CuratedWallpapersFailed extends CuratedWallpapersState {}

class CuratedWallpapersSuccess extends CuratedWallpapersState {
  final List<Photos> photos;

  CuratedWallpapersSuccess(this.photos);
}
