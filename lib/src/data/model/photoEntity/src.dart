class Src {
  String original;
  String large2x;
  String large;
  String medium;
  String small;
  String portrait;

  String landscape;
  String tiny;

  Src.fromJsonMap(Map<String, dynamic> map)
      : original = map["original"],
        large2x = map["large2x"],
        large = map["large"],
        medium = map["medium"],
        small = map["small"],
        portrait = map["portrait"],
        landscape = map["landscape"],
        tiny = map["tiny"];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['original'] = original;
    data['large2x'] = large2x;
    data['large'] = large;
    data['medium'] = medium;
    data['small'] = small;
    data['portrait'] = portrait;
    data['landscape'] = landscape;
    data['tiny'] = tiny;
    return data;
  }
}
