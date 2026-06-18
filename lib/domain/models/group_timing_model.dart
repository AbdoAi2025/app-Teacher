import 'package:flutter/material.dart';

class GroupTimingModel {
  int? id;
  int? day;
  TimeOfDay? timeFrom;
  TimeOfDay? timeTo;

  GroupTimingModel({this.id, this.day, this.timeFrom, this.timeTo});

  Map<String, dynamic> toJson(String Function(TimeOfDay) timeFormat) => {
        'day': day,
        'timeFrom': timeFrom != null ? timeFormat(timeFrom!) : null,
        'timeTo': timeTo != null ? timeFormat(timeTo!) : null,
      };

  bool get isComplete => day != null && timeFrom != null && timeTo != null;
}