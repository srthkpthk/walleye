import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:walleye/src/data/model/photoEntity/PhotoEntity.dart';
import 'package:walleye/src/data/model/photoEntity/photos.dart';
import 'package:walleye/src/data/repository/WallpaperRepository.dart';

part 'curated_wallpapers_event.dart';

part 'curated_wallpapers_state.dart';

class CuratedWallpapersBloc
    extends Bloc<CuratedWallpapersEvent, CuratedWallpapersState> {
  final WallpaperRepository _wallpaperRepository;

  CuratedWallpapersBloc(this._wallpaperRepository)
      : super(CuratedWallpapersInitial());

  static int currentPageNumber = 0;
  static List<Photos> photos = [];

  @override
  Stream<CuratedWallpapersState> mapEventToState(
    CuratedWallpapersEvent event,
  ) async* {
    if (event is FetchCuratedWallpapers) {
      yield* _fetchWallpaper(currentPageNumber);
    }
  }

  Stream<CuratedWallpapersState> _fetchWallpaper(int currentPageNumber) async* {
    try {
      log(currentPageNumber.toString());
      PhotoEntity photoEntity =
          await _wallpaperRepository.getCuratedPhotos(currentPageNumber + 1);
      currentPageNumber = photoEntity.page;
      photos.addAll(photoEntity.photos);
      yield CuratedWallpapersSuccess(photos);
    } catch (e) {
      yield CuratedWallpapersFailed();
    }
  }
}
