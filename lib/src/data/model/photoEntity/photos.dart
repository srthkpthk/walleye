import 'package:hive/hive.dart';
import 'package:walleye/src/data/model/photoEntity/src.dart';

part 'photos.g.dart';

@HiveType(typeId: 1)
class Photos {
  @HiveField(0)
  int id;
  int width;
  int height;
  @HiveField(1)
  String url;
  @HiveField(2)
  String photographer;
  String photographer_url;
  int photographer_id;
  @HiveField(3)
  Src src;
  bool liked;

  Photos(this.id, this.url, this.photographer);

  Photos.fromJsonMap(Map<String, dynamic> map)
      : id = map["id"],
        width = map["width"],
        height = map["height"],
        url = map["url"],
        photographer = map["photographer"],
        photographer_url = map["photographer_url"],
        photographer_id = map["photographer_id"],
        src = Src.fromJsonMap(map["src"]),
        liked = map["liked"];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['width'] = width;
    data['height'] = height;
    data['url'] = url;
    data['photographer'] = photographer;
    data['photographer_url'] = photographer_url;
    data['photographer_id'] = photographer_id;
    data['src'] = src == null ? null : src.toJson();
    data['liked'] = liked;
    return data;
  }
}
