import 'package:flutter/material.dart';
import 'package:teacher_app/base/AppResult.dart';
import 'package:teacher_app/data/repositories/groups_repository.dart';
import 'package:teacher_app/domain/base_use_case.dart';
import 'package:teacher_app/domain/models/group_timing_model.dart';

import '../groups/groups_managers.dart';

class UpdateGroupTimingsUseCase extends BaseUseCase<void> {
  final _repository = GroupsRepository();

  Future<AppResult<void>> execute(String groupId, List<GroupTimingModel> timings) async {
    return call(() async {
      final data = timings
          .map((t) => {
                'day': t.day,
                'timeFrom': _fmt(t.timeFrom!),
                'timeTo': _fmt(t.timeTo!),
              })
          .toList();
      await _repository.updateGroupTimings(groupId, data);
      GroupsManagers.onGroupUpdated(groupId);
      return AppResult.success(null);
    });
  }

  String _fmt(TimeOfDay time) =>
      '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
}