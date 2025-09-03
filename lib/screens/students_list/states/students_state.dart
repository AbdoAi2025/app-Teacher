import 'package:teacher_app/screens/students_list/states/student_item_ui_state.dart';

import '../../../models/student.dart';

abstract class StudentsState {}

class StudentsStateLoading extends StudentsState {}

class StudentsStateSuccess extends StudentsState {
  final List<StudentItemUiState> uiStates;
  final bool isNextPage;
  final bool isLoadingMore;
  final int totalRecords;

  StudentsStateSuccess(
      {required this.uiStates,
      required this.isNextPage,
      required this.totalRecords,
      required this.isLoadingMore
      });

  StudentsStateSuccess copyWith({
    List<StudentItemUiState>? uiStates,
    bool? isNextPage,
    bool? isLoadingMore,
    int? totalRecords,
  }) {
    return StudentsStateSuccess(
      uiStates: uiStates ?? this.uiStates,
      isNextPage: isNextPage ?? this.isNextPage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      totalRecords: totalRecords ?? this.totalRecords,
    );
  }
}

class StudentsStateError extends StudentsState {
  final Exception? message;

  StudentsStateError(this.message);
}
