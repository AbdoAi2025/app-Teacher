import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/appSetting/appSetting.dart';
import 'package:teacher_app/domain/models/app_locale_model.dart';
import 'package:teacher_app/domain/usecases/logout_use_case.dart';
import 'package:teacher_app/utils/LogUtils.dart';
import 'package:teacher_app/utils/app_background_styles.dart';
import 'package:teacher_app/utils/app_localization_utils.dart';
import 'package:teacher_app/utils/message_utils.dart';
import 'package:teacher_app/widgets/app_txt_widget.dart';
import 'package:teacher_app/widgets/dialog_loading_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../domain/usecases/change_app_locale_use_case.dart';
import '../../navigation/app_navigator.dart';
import '../../navigation/app_routes.dart';
import '../../widgets/app_toolbar_widget.dart';
import '../subscription_plans/states/subscription_plans_state.dart';
import '../subscription_plans/subscription_plans_controller.dart';
import 'widgets/current_subscription_plan_bottom_sheet.dart';
import '../profile/profile_controller.dart';
import 'package:teacher_app/localization/generated/app_strings_keys.dart';

class SettingsScreen extends StatefulWidget{

  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _profileController = Get.put(ProfileController());

  get appVersion => AppSetting.getAppSetting().appVersion;

  @override
  Widget build(BuildContext context) {
    appLog("SettingsScreen build");
    return Scaffold(
      appBar: AppToolbarWidget.appBar(title: AppStringsKeys.settings.tr, hasLeading: false),
      body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Column(
                  spacing: 20,
                  children: [
                    _profileSection(),
                    _language(),
                    _mySubscription(),
                    _privacyPolicy(),
                    _contactUs(),
                    _deleteAccount(),
                    _logout(),

                  ],
                ),

                if(appVersion != null)...{
                  Spacer(),
                  _versionInfo(appVersion!.toString()),
                }

              ],
            ),
          )),
    );
  }

  Widget _profileSection() {
    return InkWell(
      onTap: AppNavigator.navigateToProfile,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
        decoration: AppBackgroundStyle.backgroundWithShadow(),
        child: Obx(() {
          final profile = _profileController.profile.value;
          final isLoading = _profileController.isLoading.value;
          final initials = _profileInitials(profile?.name);
          return Row(
            spacing: 12,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Theme.of(context).primaryColor,
                child: isLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : Text(
                        initials,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppTextWidget(
                      isLoading
                          ? '...'
                          : profile?.name ?? AppStringsKeys.profile.tr,
                    ),
                    if (!isLoading && profile?.email != null)
                      Text(
                        profile!.email!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_back_ios_sharp,
                textDirection: !AppSetting.isArabic
                    ? TextDirection.rtl
                    : TextDirection.ltr,
                size: 16,
              ),
            ],
          );
        }),
      ),
    );
  }

  String _profileInitials(String? name) {
    if (name == null || name.trim().isEmpty) return '?';
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts[1][0]}'.toUpperCase();
    }
    return parts.first[0].toUpperCase();
  }

  _language() {
    return InkWell(
      onTap: (){
        setState(() {
          onChangeLanguageClick();
        });

      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15 , vertical: 15),
        decoration: AppBackgroundStyle.backgroundWithShadow(),
        child: Row(
          spacing: 5,
          children: [
            Icon(Icons.language),
            Expanded(child: AppTextWidget(AppStringsKeys.language.tr)),
            _selectedLanguage()
          ],
        ),
      ),
    );
  }

  _selectedLanguage() {
    var selectedLanguage = AppLocalizationUtils.getCurrentLocale();
    appLog("_selectedLanguage selectedLanguage:${selectedLanguage.language}");
   return  AppTextWidget(
       AppLocalizationUtils.getCurrentLocale().label.tr);
  }

  Future<void> onChangeLanguageClick() async {
    showDialogLoading();
    AppLocaleModel currentAppLocale = AppLocalizationUtils.getCurrentLocale();
    AppLocaleModel changeAppLocal  = currentAppLocale.isEnglish ? currentAppLocale.copyWithArabic() : currentAppLocale.copyWithEnglish();
    ChangeAppLocaleUseCase changeAppLocaleUseCase = ChangeAppLocaleUseCase();
    await changeAppLocaleUseCase.execute(changeAppLocal);
    hideDialogLoading();
  }

  _privacyPolicy() {
    return  _cell(AppStringsKeys.privacyPolicy.tr , Icons.privacy_tip_outlined ,onPrivacyPolicyClick );
  }

  _contactUs() {
    return  _cell(AppStringsKeys.contactUs.tr , Icons.support_agent ,onContactUsClick );
  }

  _mySubscription() {
    return _cell(AppStringsKeys.mySubscription.tr , Icons.subscriptions_outlined , onMySubscriptionClick );
  }

  _logout() {
    return _cell(AppStringsKeys.logout.tr, Icons.logout, onLogout, color: Colors.red);
  }

  _deleteAccount() {
    return  _cell(AppStringsKeys.deleteAccount.tr , Icons.person_off ,onDeleteAccount );
  }

  Future<void> onPrivacyPolicyClick() async {

    final String url = "https://assistant-app-2136afb92d95.herokuapp.com/privacyPolicy";
    final Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication, // ensures browser opens
      );
    } else {
      debugPrint("❌ Could not launch $url");
    }
  }

  Future<void> onContactUsClick() async {
    final String phoneNumber = "+201063271529";
    final String whatsappUrl = "https://wa.me/$phoneNumber";
    final Uri uri = Uri.parse(whatsappUrl);

    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } else {
      debugPrint("❌ Could not launch WhatsApp with $phoneNumber");
    }
  }

  void onMySubscriptionClick() {
    AppNavigator.navigateToSubscriptionPlans();
    //
    // if(subscriptionPlansController.state.value is! SubscriptionPlansStateSuccess){
    //   subscriptionPlansController.loadAllData();
    // }
    // CurrentSubscriptionPlanBottomSheet.show(context, subscriptionPlansController);
  }

  void onLogout() {
    showConfirmationMessage(AppStringsKeys.areYouSureToLogout.tr, () {
      LogoutUseCase().execute();
      AppNavigator.navigateToLogin();
    });
  }

  void onDeleteAccount() {
    showConfirmationMessage(AppStringsKeys.deleteAccountConfirmMessage.tr, (){
      LogoutUseCase().execute();
      AppNavigator.navigateToLogin();
    });

  }

  Widget _versionInfo(String version) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Text(
        "Version $version",
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 14,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _cell(String text, IconData icon, Function() onClick, {Color? color}) {
    return InkWell(
      onTap: onClick,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15 , vertical: 10),
        decoration: AppBackgroundStyle.backgroundWithShadow(),
        child: Row(
          spacing: 5,
          children: [
            Icon(icon, color: color),
            Expanded(child: AppTextWidget(text, color: color)),
            Icon(Icons.arrow_back_ios_sharp, color: color, textDirection: !AppSetting.isArabic ? TextDirection.rtl : TextDirection.ltr)
          ],
        ),
      ),
    );
  }

}
