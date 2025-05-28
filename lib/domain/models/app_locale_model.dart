/// language : ""
/// country : ""

class AppLocaleModel {
  AppLocaleModel({
      this.language, 
      this.country,});

  AppLocaleModel.fromJson(dynamic json) {
    language = json['language'];
    country = json['country'];
  }
  String? language;
  String? country;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['language'] = language;
    map['country'] = country;
    return map;
  }

}