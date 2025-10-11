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

class SettingsScreen extends StatefulWidget{

  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    appLog("SettingsScreen build");
    return Scaffold(
      appBar: AppToolbarWidget.appBar(title: "Settings".tr, hasLeading: false),
      body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              spacing: 20,
              children: [
                _language(),
                _mySubscription(),
                _privacyPolicy(),
                _deleteAccount()
              ],
            ),
          )),
    );
  }

  _language() {
    return InkWell(
      onTap: (){
        setState(() {
          onChangeLanguageClick();
        });

      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15 , vertical: 10),
        decoration: AppBackgroundStyle.backgroundWithShadow(),
        child: Row(
          spacing: 5,
          children: [
            Icon(Icons.language),
            Expanded(child: AppTextWidget("Language".tr)),
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

  _mySubscription() {
    return _cell("My Subscription".tr, Icons.payment, onMySubscriptionClick);
  }

  _privacyPolicy() {
    return  _cell("Privacy Policy".tr , Icons.privacy_tip_outlined ,onPrivacyPolicyClick );
  }

  _deleteAccount() {
    return  _cell("Delete Account".tr , Icons.person_off ,onDeleteAccount );
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

  void onMySubscriptionClick() {
    appLog("Navigate to subscription screen");
    AppNavigator.navigateToSubscription();
  }

  void onDeleteAccount() {
    showConfirmationMessage("delete_account_confirm_message", (){
      LogoutUseCase().execute();
      AppNavigator.navigateToLogin();
    });

  }

  Widget _cell(String text , IconData icon , Function() onClick) {
    return InkWell(
      onTap: onClick,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15 , vertical: 10),
        decoration: AppBackgroundStyle.backgroundWithShadow(),
        child: Row(
          spacing: 5,
          children: [
            Icon(icon),
            Expanded(child: AppTextWidget(text)),
            Icon(Icons.arrow_back_ios_sharp , textDirection: !AppSetting.isArabic ?  TextDirection.rtl : TextDirection.ltr,)
          ],
        ),
      ),
    );
  }

}
