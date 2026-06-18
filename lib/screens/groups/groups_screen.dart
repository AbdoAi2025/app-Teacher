import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/navigation/app_navigator.dart';
import 'package:teacher_app/themes/app_colors.dart';
import 'package:teacher_app/themes/txt_styles.dart';
import 'package:teacher_app/utils/Keyboard_utils.dart';
import 'package:teacher_app/utils/date_filter_manager.dart';
import 'package:teacher_app/widgets/app_txt_widget.dart';
import '../../widgets/groups/groups_empty_data_widget.dart';
import 'package:teacher_app/widgets/loading_widget.dart';
import '../../widgets/error_view_widget.dart';
import '../../widgets/filters/current_filters_display_widget.dart';
import '../../widgets/filters/grade_filter_chip_widget.dart';
import '../../widgets/groups/group_item_widget.dart';
import '../../widgets/info_chip_widget.dart';
import 'groups_controller.dart';
import 'groups_state.dart';
import 'package:teacher_app/localization/generated/app_strings_keys.dart';

class GroupsScreen extends StatefulWidget {
  const GroupsScreen({super.key});

  @override
  State<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  TextEditingController searchController = TextEditingController();
  GroupsController controller = Get.put(GroupsController());
  bool searchState = false;
  String currentSearchText = '';
  late DateFilterManager dateFilterManager;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.white,
        appBar: _appBar(),
        body: SafeArea(
          child: GestureDetector(
              onTapDown: (v) {
                KeyboardUtils.hideKeyboard(context);
              },
              child: _content()),
        ),
        floatingActionButton: _createGroupFab(),
    );
  }

  _appBar() {
    return _appBarWithActions();
  }

  _appBarWithActions() => AppBar(
    backgroundColor: AppColors.white,
    elevation: 0,
    surfaceTintColor: Colors.transparent,
    automaticallyImplyLeading: false,
    toolbarHeight: 0,
  );

  Widget _content() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        spacing: 15,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _controlsSection(),
            ],
          ),
          Expanded(
            child: Obx(() {
              var state = controller.state.value;
              switch (state) {
                case GroupsStateLoading():
                  return Center(child: LoadingWidget());
                case GroupsStateSuccess():
                  return _groupsList(state);
                case GroupsStateError():
                  return _errorView(state);
              }
            }),
          ),
        ],
      ),
    );
  }

  Widget _controlsSection() {
    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         _title(),
        _header(),
        _searchAndSortBar(),
      ],
    );
  }

  Widget _title() {
   return AppTextWidget(
      AppStringsKeys.groups.tr,
      style: AppTextStyle.title.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: AppColors.colorBlack,
      ),
    );
  }

  Widget _header() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: _filterIcon(),
        ),
        Container(
          width: 1,
          height: 35,
          color: AppColors.color_DBD5CC.withValues(alpha: 0.6),
          padding: EdgeInsets.symmetric(horizontal: 10 , vertical: 4),
          margin: EdgeInsets.symmetric(horizontal: 10 , vertical: 4),
        ),

        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              spacing: 8,
              children: [
                CurrentFiltersDisplayWidget(filterManager: controller.dateFilterManager),
                GradeFilterChipWidget(
                  selectedGrade: controller.selectedGradeFilter,
                  onSelected: controller.onGradeFilterSelected,
                  onReset: controller.resetGradeFilter,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }


  Widget _filterIcon() {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.appMainColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        Icons.tune_rounded,
        size: 18,
        color: AppColors.appMainColor,
      ),
    );
  }



  Widget _searchAndSortBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 0),
      decoration: BoxDecoration(
        color: AppColors.colorOffWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.color_DBD5CC.withOpacity(0.5),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: _searchField(),
            ),
          ),
          // Divider
          Container(
            width: 1,
            height: 32,
            color: AppColors.color_DBD5CC.withValues(alpha: 0.5),
            margin: EdgeInsets.symmetric(horizontal: 8),
          ),

          // Sort button
          _sortButton(
            icon: Icons.sort_rounded,
            color: AppColors.primaryButtonColor,
            onTap: onSortClick,
            tooltip: AppStringsKeys.sort.tr,
          ),
        ],
      ),
    );
  }

  Widget _sortButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.all(8),
            child: Icon(
              icon,
              color: color,
              size: 22,
            ),
          ),
        ),
      ),
    );
  }


  refresh() {
    controller.refreshGroups();
  }

  Widget _groupsList(GroupsStateSuccess state) {
    var items = state.uiStates;
    if (items.isEmpty) {
      return _emptyView();
    }
    return RefreshIndicator(
      onRefresh: () async {
        controller.refreshGroups();
      },
      backgroundColor: AppColors.white,
      color: AppColors.appMainColor,
      child: ListView.separated(
          padding: EdgeInsets.only(bottom: 50),
          itemBuilder: (context, index) {
            var uiState = items[index];
            if (uiState is GroupItemTitleUiState) {
              return Row(
                spacing: 10,
                children: [
                  AppTextWidget(
                    uiState.title,
                    style: AppTextStyle.title.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.colorBlack,
                    ),
                  ),

                  InfoChipWidget(
                    icon: Icons.group,
                    text: "${uiState.count} ${AppStringsKeys.groups.tr}",
                    color : AppColors.orange,
                  ),

                ],
              );
            }

            return GroupItemWidget(
              uiState: uiState,
            );
          },
          separatorBuilder: (context, index) => SizedBox(height: 12),
          itemCount: items.length),
    );
  }



  _emptyView() {
    return GroupsEmptyDataWidget(
      onCreateGroup: () => AppNavigator.navigateToCreateGroup(),
    );
  }

  void onSortClick() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.color_DBD5CC,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  AppTextWidget(
                    AppStringsKeys.sortGroups.tr,
                    style: AppTextStyle.title.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(Icons.close, color: AppColors.textSecondaryColor),
                  ),
                ],
              ),
              SizedBox(height: 24),
              _sortOption(Icons.calendar_today, AppStringsKeys.byDay.tr, onSortByDayClick),
              SizedBox(height: 12),
              _sortOption(Icons.school, AppStringsKeys.byGrade.tr, onSortByGradeClick),
              SizedBox(height: 12),
              _sortOption(Icons.refresh, AppStringsKeys.reset.tr, onSortResetClick),
              SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  Widget _sortOption(IconData icon, String title, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: AppColors.colorOffWhite,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.appMainColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: AppColors.appMainColor,
                  size: 20,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: AppTextWidget(
                  title,
                  style: AppTextStyle.label.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: AppColors.textSecondaryColor,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onSortByDayClick() {
    Get.back();
    controller.sortByDay();
  }

  void onSortByGradeClick() {
    Get.back();
    controller.sortByGrade();
  }

  void onSortResetClick() {
    Get.back();
    controller.resetSort();
  }

  Widget _errorView(GroupsStateError state) {
    return Center(
        child: ErrorViewWidget(
      message: state.message,
      onRetry: refresh,
    ));
  }

  Widget _createGroupFab() {
    return Container(
      margin: EdgeInsets.only(bottom: 16, right: 4),
      child: FloatingActionButton.extended(
        onPressed: () {
          AppNavigator.navigateToCreateGroup();
        },
        backgroundColor: AppColors.appMainColor,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        icon: Icon(
          Icons.add,
          color: Colors.white,
          size: 24,
        ),
        label: AppTextWidget(
          AppStringsKeys.newGroup.tr,
          style: AppTextStyle.label.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  _searchField() {
    return TextField(
      controller: searchController,
      onChanged: (value) {
        setState(() {
          currentSearchText = value;
        });
        controller.onSearchChanged(value);
      },
      style: AppTextStyle.label.copyWith(
        fontSize: 14,
        color: AppColors.colorBlack,
      ),
      decoration: InputDecoration(
        hintText: AppStringsKeys.searchGroups2.tr,
        hintStyle: AppTextStyle.label.copyWith(
          color: AppColors.textSecondaryColor,
          fontSize: 14,
        ),
        prefixIcon: Container(
          padding: EdgeInsets.all(8),
          child: Icon(
            Icons.search_rounded,
            color: AppColors.textSecondaryColor,
            size: 20,
          ),
        ),
        suffixIcon: currentSearchText.isNotEmpty
            ? Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () {
              setState(() {
                currentSearchText = '';
              });

              searchController.text = '';
              controller.onCloseSearch();
            },
            child: Container(
              padding: EdgeInsets.all(8),
              child: Icon(
                Icons.close_rounded,
                color: AppColors.textSecondaryColor,
                size: 20,
              ),
            ),
          ),
        )
            : null,
        filled: false,
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}
