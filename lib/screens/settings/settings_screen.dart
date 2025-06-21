import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/domain/models/app_locale_model.dart';
import 'package:teacher_app/utils/LogUtils.dart';
import 'package:teacher_app/utils/app_background_styles.dart';
import 'package:teacher_app/utils/app_localization_utils.dart';
import 'package:teacher_app/widgets/app_txt_widget.dart';
import 'package:teacher_app/widgets/dialog_loading_widget.dart';

import '../../domain/usecases/change_app_locale_use_case.dart';
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
      appBar: AppToolbarWidget.appBar("Settings".tr, hasLeading: false),
      body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                _language()
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
            Expanded(child: AppTextWidget("Language")),
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
       AppLocalizationUtils.getCurrentLocale().label);
  }

  Future<void> onChangeLanguageClick() async {
    showDialogLoading();
    AppLocaleModel currentAppLocale = AppLocalizationUtils.getCurrentLocale();
    AppLocaleModel changeAppLocal  = currentAppLocale.isEnglish ? currentAppLocale.copyWithArabic() : currentAppLocale.copyWithEnglish();
    ChangeAppLocaleUseCase changeAppLocaleUseCase = ChangeAppLocaleUseCase();
    await changeAppLocaleUseCase.execute(changeAppLocal);
    hideDialogLoading();
  }
}
