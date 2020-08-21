import 'package:walleye/src/data/model/photoEntity/photos.dart';

class PhotoEntity {
  int page;
  int per_page;
  List<Photos> photos;
  String next_page;

  PhotoEntity.fromJsonMap(Map<String, dynamic> map)
      : page = map["page"],
        per_page = map["per_page"],
        photos = List<Photos>.from(
            map["photos"].map((it) => Photos.fromJsonMap(it))),
        next_page = map["next_page"];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['page'] = page;
    data['per_page'] = per_page;
    data['photos'] =
        photos != null ? this.photos.map((v) => v.toJson()).toList() : null;
    data['next_page'] = next_page;
    return data;
  }
}
