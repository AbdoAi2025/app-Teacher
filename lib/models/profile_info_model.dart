

import 'package:teacher_app/models/gender_model.dart';
import 'package:teacher_app/utils/LogUtils.dart';

class ProfileInfoModel {

  final String id;
  final String name;
  final GenderModel gender;

  ProfileInfoModel({required this.id, required this.name, GenderModel? gender}) : gender = gender ?? GenderModel(null);


  factory ProfileInfoModel.fromJson(Map<String, dynamic> json) {
    appLog("ProfileInfoModel.fromJson json:$json", "ProfileInfoModel");
    return ProfileInfoModel(
      id: json['id'],
      name: json['name'],
      gender: GenderModel(json['gender']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['gender'] = gender.type;
    appLog("ProfileInfoModel.toJson data:$data", "UserAuthModel");
    return data;
  }
}