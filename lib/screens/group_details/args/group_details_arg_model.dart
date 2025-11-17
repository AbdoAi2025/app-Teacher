import 'package:teacher_app/utils/LogUtils.dart';

class GroupDetailsArgModel {
  final String id;

  GroupDetailsArgModel({required this.id});

  @override
  String toString() {
    return 'GroupDetailsArgModel{id: $id}';
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
    };
  }


  factory GroupDetailsArgModel.fromMap(Map<String, dynamic> map) {
    appLog("GroupDetailsArgModel fromMap : $map");
    return GroupDetailsArgModel(
      id: map['id'] as String,
    );
  }
}
