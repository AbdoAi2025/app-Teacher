import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:teacher_app/domain/usecases/add_student_use_case.dart';
import 'package:teacher_app/requests/add_student_request.dart';
import 'package:teacher_app/utils/extensions_utils.dart';

import '../../base/AppResult.dart';
import '../../domain/usecases/get_grades_list_use_case.dart';
import '../../widgets/item_selection_widget/item_selection_ui_state.dart';
import '../create_group/grades/grades_selection_state.dart';
import 'states/add_student_state.dart';

class AddStudentController extends GetxController{

  final formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController parentPhoneController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController gradeController = TextEditingController();

  /*grades selection*/
  final Rx<ItemSelectionUiState?> selectedGrade = Rx(null);
  final Rx<GradesSelectionState> gradeSelectionState =
  Rx(GradesSelectionStateLoading());


  @override
  void onInit() {
    super.onInit();
    _loadGrades();
  }

  Future<void> _loadGrades() async {
    var result = await GetGradesListUseCase().execute();

    if (result is AppResultSuccess) {
      var uiState = result.data?.map(
            (e) => ItemSelectionUiState(
            id: e.id?.toString() ?? "",
            name: e.localizedName?.toLocalizedName() ?? "",
            isSelected: e.id?.toString() == selectedGrade.value?.id
        ),
      );
      gradeSelectionState.value = GradesSelectionStateSuccess(uiState?.toList() ?? List.empty());
      return;
    }

    if(result is AppResultError){
      gradeSelectionState.value = GradesSelectionStateError(result.error.toString());
    }
  }


  checkGradesState() async {

    var state = gradeSelectionState.value;

    if(state is GradesSelectionStateSuccess && state.items.isNotEmpty){
      return;
    }

    updateSate(GradesSelectionStateLoading());
     _loadGrades();
  }

  void onSelectedGrade(ItemSelectionUiState? item) {
    var grades = getGradesList();

    for (var grade in grades) {
      grade.isSelected = grade.id == (item?.id ?? "") ;
    }

    selectedGrade.value = item;
  }

  List<ItemSelectionUiState> getGradesList() {
    var grades = gradeSelectionState.value;
    if (grades is GradesSelectionStateSuccess) {
      return grades.items;
    }
    return List.empty();
  }


  Stream<AddStudentState> onSave() async* {
    var isValid = formKey.currentState?.validate() ?? false;

    if (!isValid) {
      yield AddStudentStateFormValidation();
      return;
    }

    AddStudentUseCase addGroupUseCase = AddStudentUseCase();
    yield AddStudentStateLoading();
    AddStudentRequest request = getRequest();

    var result = await addGroupUseCase.execute(request);
    if (result is AppResultSuccess) {
      yield SaveStateSuccess();
    } else {
      yield AddStudentStateError(result.error);
    }
  }

  AddStudentRequest getRequest() {
    return AddStudentRequest(
      name: nameController.text.trim(),
      parentPhone: parentPhoneController.text.trim(),
      phone: phoneController.text.trim(),
      gradeId: selectedGrade.value?.id,
    );
  }

  void updateSate(GradesSelectionState state) {
    gradeSelectionState.value = state;
  }

}
