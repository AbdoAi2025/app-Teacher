import '../utils/localized_name_model.dart';

class GradeApiModel {
  GradeApiModel({
    this.id,
    this.nameEn,
    this.nameAr,
    this.localizedName,
  });

  GradeApiModel.fromJson(dynamic json) {
    id = json['id'];
    nameEn = json['nameEn'];
    nameAr = json['nameAr'];
    localizedName =
        LocalizedNameModel(nameEn: nameEn ?? "", nameAr: nameAr ?? "");
  }

  int? id;
  String? nameEn;
  String? nameAr;
  LocalizedNameModel? localizedName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['nameEn'] = nameEn;
    map['nameAr'] = nameAr;
    return map;
  }
}
