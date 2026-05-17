import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/domain/groups/groups_managers.dart';
import 'package:teacher_app/screens/groups/groups_state.dart';
import 'package:teacher_app/themes/app_colors.dart';
import 'package:teacher_app/themes/txt_styles.dart';
import 'package:teacher_app/widgets/app_txt_widget.dart';
import 'package:teacher_app/widgets/loading_widget.dart';
import 'package:teacher_app/widgets/primary_button_widget.dart';

class SelectGroupBottomSheet extends StatefulWidget {
  final Function(GroupItemUiState) onGroupSelected;
  final String? currentGroupId;

  const SelectGroupBottomSheet({
    super.key,
    required this.onGroupSelected,
    this.currentGroupId,
  });

  @override
  State<SelectGroupBottomSheet> createState() => _SelectGroupBottomSheetState();

  static void show({
    required BuildContext context,
    required Function(GroupItemUiState) onGroupSelected,
    String? currentGroupId,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: SelectGroupBottomSheet(
            onGroupSelected: onGroupSelected,
            currentGroupId: currentGroupId,
          ),
        ),
      ),
    );
  }
}

class _SelectGroupBottomSheetState extends State<SelectGroupBottomSheet> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  GroupItemUiState? _selectedGroup;

  @override
  void initState() {
    super.initState();
    _loadGroups();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadGroups() {
    final state = GroupsManagers.state.value;
    if (state is! GroupsStateSuccess) {
      GroupsManagers.loadGroups();
    }
  }

  List<GroupItemUiState> _filterGroups(List<GroupItemUiState> groups) {
    final items = groups.whereType<GroupItemUiState>()
        .where((g) => g is! GroupItemTitleUiState)
        .toList();
    if (_searchQuery.isEmpty) return items;
    return items
        .where((g) => g.groupName.toLowerCase().contains(_searchQuery))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          SizedBox(height: 16),
          _buildSearchField(),
          SizedBox(height: 16),
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: AppTextWidget(
            'Select Group'.tr,
            style: AppTextStyle.title.copyWith(fontSize: 18),
          ),
        ),
        IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.close, color: AppColors.textSecondaryColor),
        ),
      ],
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: 'Search groups'.tr,
        prefixIcon: Icon(Icons.search, color: AppColors.textSecondaryColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.color_DBD5CC),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.color_DBD5CC),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
    );
  }

  Widget _buildContent() {
    return Obx(() {
      final state = GroupsManagers.state.value;
      switch (state) {
        case GroupsStateLoading():
          return Center(child: LoadingWidget());
        case GroupsStateError():
          return _buildErrorView(state);
        case GroupsStateSuccess():
          return _buildGroupsList(state);
      }
    });
  }

  Widget _buildErrorView(GroupsStateError state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: AppColors.textSecondaryColor),
          SizedBox(height: 16),
          AppTextWidget(
            state.message ?? 'Failed to load groups'.tr,
            style: AppTextStyle.label.copyWith(color: AppColors.textSecondaryColor),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => GroupsManagers.onRefresh(),
            child: AppTextWidget('Retry'.tr, style: AppTextStyle.label),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupsList(GroupsStateSuccess state) {
    final filtered = _filterGroups(state.uiStates);

    if (filtered.isEmpty) {
      return Center(
        child: AppTextWidget(
          'No groups found'.tr,
          style: AppTextStyle.label.copyWith(color: AppColors.textSecondaryColor),
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            itemCount: filtered.length,
            separatorBuilder: (_, __) => Container(
              height: 0.5,
              color: AppColors.color_DBD5CC,
              margin: EdgeInsets.symmetric(horizontal: 16),
            ),
            itemBuilder: (_, index) => _buildGroupItem(filtered[index]),
          ),
        ),
        SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: PrimaryButtonWidget(
            text: 'Select'.tr,
            onClick: _onSelectTap,
            enabled: _selectedGroup != null,
          ),
        ),
      ],
    );
  }

  Widget _buildGroupItem(GroupItemUiState group) {
    final isSelected = _selectedGroup?.groupId == group.groupId;
    return InkWell(
      onTap: () => setState(() => _selectedGroup = group),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          children: [
            _buildRadio(isSelected),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppTextWidget(
                    group.groupName,
                    style: AppTextStyle.label.copyWith(
                      color: isSelected ? AppColors.appMainColor : AppColors.colorBlack,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                  if (group.gradeName.isNotEmpty)
                    AppTextWidget(
                      group.gradeName,
                      style: AppTextStyle.small.copyWith(
                        color: AppColors.appMainColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  AppTextWidget(
                    '${group.dayName} • ${group.timeFrom} - ${group.timeTo}',
                    style: AppTextStyle.value.copyWith(color: AppColors.textSecondaryColor),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRadio(bool isSelected) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? AppColors.appMainColor : AppColors.color_DBD5CC,
          width: 2,
        ),
      ),
      child: isSelected
          ? Center(
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.appMainColor,
                ),
              ),
            )
          : null,
    );
  }

  void _onSelectTap() {
    if (_selectedGroup != null) {
      Get.back();
      widget.onGroupSelected(_selectedGroup!);
    }
  }
}