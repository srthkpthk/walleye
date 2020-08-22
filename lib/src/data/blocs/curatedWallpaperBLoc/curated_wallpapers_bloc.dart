import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:walleye/src/data/blocs/curatedWallpaperBLoc/curated_wallpapers_event.dart';
import 'package:walleye/src/data/blocs/curatedWallpaperBLoc/curated_wallpapers_state.dart';
import 'package:walleye/src/data/model/photoEntity/PhotoEntity.dart';
import 'package:walleye/src/data/model/photoEntity/photos.dart';
import 'package:walleye/src/data/repository/WallpaperRepository.dart';

class CuratedWallpapersBloc
    extends Bloc<CuratedWallpapersEvent, CuratedWallpapersState> {
  final WallpaperRepository _wallpaperRepository;

  CuratedWallpapersBloc(this._wallpaperRepository)
      : super(CuratedWallpapersInitial());

  static List<Photos> photos = [];

  @override
  Stream<CuratedWallpapersState> mapEventToState(
    CuratedWallpapersEvent event,
  ) async* {
    if (event is FetchCuratedWallpapers) {
      yield* _fetchWallpaper(
        event.currentPageNumber,
      );
    }
  }

  Stream<CuratedWallpapersState> _fetchWallpaper(
    int currentPageNumber,
  ) async* {
    try {
      PhotoEntity photoEntity = await _wallpaperRepository.getCuratedPhotos(
        currentPageNumber + 1,
      );
      photos.addAll(photoEntity.photos);
      yield CuratedWallpapersSuccess(
        photos,
        photoEntity.page,
      );
    } catch (e) {
      yield CuratedWallpapersFailed();
    }
  }
}
