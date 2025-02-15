class GradeApiModel {
  GradeApiModel({
      this.id, 
      this.nameEn, 
      this.nameAr,});

  GradeApiModel.fromJson(dynamic json) {
    id = json['id'];
    nameEn = json['nameEn'];
    nameAr = json['nameAr'];
  }
  int? id;
  String? nameEn;
  String? nameAr;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['nameEn'] = nameEn;
    map['nameAr'] = nameAr;
    return map;
  }

}