
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../themes/app_colors.dart'; // Ensure correct path
import 'package:teacher_app/localization/generated/app_strings_keys.dart';


class SettingItemModel{
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  SettingItemModel({required this.title, required this.icon, required this.onTap});

  factory SettingItemModel.editItem(VoidCallback onTap) => SettingItemModel(title: AppStringsKeys.edit.tr, icon: Icons.edit, onTap: onTap);
  factory SettingItemModel.upgradeItem(VoidCallback onTap) => SettingItemModel(title: AppStringsKeys.upgrade.tr, icon: Icons.upgrade, onTap: onTap);
  factory SettingItemModel.deleteItem(VoidCallback onTap) => SettingItemModel(title: AppStringsKeys.delete.tr, icon: Icons.delete, onTap: onTap);
  factory SettingItemModel.addStudentToGroup(VoidCallback onTap) => SettingItemModel(title: AppStringsKeys.addToGroup.tr, icon: Icons.people_outline, onTap: onTap);

}

class SettingBottomSheet extends StatelessWidget {

  final List<SettingItemModel> itemsModels;

  const SettingBottomSheet({
    super.key,
    required this.itemsModels,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...itemsModels.map((e) => settingItem(e, context))
        ],
      ),
    );
  }

  static void show({
    required BuildContext context,
    required List<SettingItemModel> itemsModels
  }) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SettingBottomSheet(
        itemsModels: itemsModels,
      ),
    );
  }

  Widget settingItem(SettingItemModel itemModel , BuildContext context) {
    return ListTile(
      leading:  Icon(itemModel.icon, color: AppColors.appMainColor),
      title: Text(itemModel.title),
      onTap: () {
        Navigator.pop(context);
        itemModel.onTap();
      },
    );
  }
}