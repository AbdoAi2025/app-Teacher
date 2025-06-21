import 'dart:ui';

/// language : ""
/// country : ""

class AppLocaleModel {


  final _AR = "ar";
  final _EN = "en";
  final _EG = "eg";

  AppLocaleModel({
      this.language,
      this.country,
  });

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


  AppLocaleModel copyWithArabic({
    String? country,
  }) {
    return AppLocaleModel(
      language: _AR,
      country: country ?? this.country,
    );
  }


  AppLocaleModel copyWithEnglish({
    String? country,
  }) {
    return AppLocaleModel(
      language: _EN,
      country: country ?? this.country,
    );
  }

  bool get isArabic => language == _AR;
  bool get isEnglish => language == _EN;

  String get label => isEnglish ? "English" : "Arabic";

  Locale toLocale() => Locale(language ?? _EN , country ?? _EG);


}