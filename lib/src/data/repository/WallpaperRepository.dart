import 'package:dio/dio.dart';
import 'package:walleye/src/util/api_key.dart';

class WallpaperRepository {
  final _dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.pexels.com/v1',
      headers: {'Authorization': ApiHelper.API_KEY},
    ),
  );

  getCuratedPhotos() async {
    
  }
}
