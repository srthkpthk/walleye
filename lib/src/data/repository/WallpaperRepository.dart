import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:walleye/src/data/model/photoEntity/PhotoEntity.dart';
import 'package:walleye/src/data/model/photoEntity/photos.dart';
import 'package:walleye/src/util/api_key.dart';

class WallpaperRepository {
  final _dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.pexels.com/v1/',
      headers: {'Authorization': ApiHelper.API_KEY},
    ),
  );

  Future<PhotoEntity> getCuratedPhotos(int pageNumber) async {
    final response = await _dio.get(
      'curated',
      queryParameters: {'page': pageNumber},
    );
    if (response.statusCode == 200) {
      PhotoEntity photoEntity = PhotoEntity.fromJsonMap(response.data);
      print('Page Number = ${photoEntity.page}');
      return photoEntity;
    } else {
      throw Exception('Photo Repository getCuratedPhotos Error');
    }
  }

  Future<PhotoEntity> searchPhoto(String searchText) async {
    final response = await _dio.get(
      'search',
      queryParameters: {'query': searchText},
    );
    if (response.statusCode == 200) {
      PhotoEntity photoEntity = PhotoEntity.fromJsonMap(response.data);
      print('Page Number = ${photoEntity.page}');
      return photoEntity;
    } else {
      throw Exception('Photo Repository searchPhoto Error');
    }
  }

  Future<Photos> getPhoto(int id) async {
    final response = await _dio.get(
      'photos/$id',
    );
    if (response.statusCode == 200) {
      return Photos.fromJsonMap(response.data);
    } else {
      throw Exception('Photo Repository getPhoto Error');
    }
  }

}
