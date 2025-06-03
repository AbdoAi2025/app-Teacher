

import 'package:teacher_app/utils/LogUtils.dart';

class ProfileInfoModel {

  final String id;
  final String name;

  ProfileInfoModel({required this.id, required this.name});


  factory ProfileInfoModel.fromJson(Map<String, dynamic> json) {
    appLog("ProfileInfoModel.fromJson json:$json", "ProfileInfoModel");
    return ProfileInfoModel(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    appLog("ProfileInfoModel.toJson data:$data", "UserAuthModel");
    return data;
  }
}