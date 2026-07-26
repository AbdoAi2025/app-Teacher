import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:teacher_app/utils/LogUtils.dart';
import 'package:teacher_app/utils/message_utils.dart';
import 'package:teacher_app/data/dataSource/whatsapp_share_preferences.dart';
import 'package:teacher_app/widgets/confirm_dailog_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:teacher_app/localization/generated/app_strings_keys.dart';

final MethodChannel _whatsappChannel = MethodChannel('whatsapp_share');

class WhatsappUtils {


  /// Shares file via WhatsApp using platform-specific approaches
  static void sendToWhatsAppFile(File file, String phoneNumber) async {
    try {

      await _copyPhoneNumberToClipboard(phoneNumber);

      if (Platform.isIOS) {
        await _shareWithOther(file.path);
        return;
      }

      // Check if user has selected "don't ask me again"
      final dontAskAgain = await WhatsAppSharePreferences.getDontAskAgain();

      if (dontAskAgain) {
        // Use the previously selected option
        final selectedOption = await WhatsAppSharePreferences.getSelectedOption();
        if (selectedOption != null) {
          await _shareFileWithOption(file, phoneNumber, selectedOption);
          return;
        }
      }

      // Show dialog to select sharing option
      _showShareOptionsDialog(file, phoneNumber);
    } catch (e) {
      appLog("Error in sendToWhatsAppFile: $e");
      if (Platform.isIOS) {
        await _shareWithOther(file.path);
      } else {
        _showShareOptionsDialog(file, phoneNumber);
      }
    }
  }

  static void sendToWhatsApp(String message, String phoneNumber) async {
    try {
      final url = Uri.parse(
        "https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}",
      );
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        showErrorMessage('Could not launch WhatsApp'.tr);
      }
    } catch (e) {
      showErrorMessage(e.toString());
    }
  }

  static Future<void> shareParentLoginInfo(String message , String parentPhone) async {

    // Copy phone number to clipboard
    await _copyPhoneNumberToClipboard(parentPhone);
    _selectShareOptionsDialog(
        onWhatsApp: () {
          WhatsappUtils.sendToWhatsApp(message, parentPhone);
        },
        onWhatsAppBusiness: () {
          WhatsappUtils.sendToWhatsApp(message, parentPhone);
        },
        onOther: () async {
          await SharePlus.instance.share(ShareParams(text: message));
        }
    );
  }

  static Future<void> _shareImageWithWhatsAppApp(String filePath, String phoneNumber, bool isBusinessApp) async {

    final methodName = isBusinessApp ? 'sendFileToWhatsAppBusiness' : 'sendFileToWhatsApp';
    final appName = isBusinessApp ? 'WhatsAppBusiness' : 'WhatsApp';

    try {
      var result = await _whatsappChannel.invokeMethod(methodName, {
        'filePath': filePath,
        'phone': phoneNumber.replaceAll(RegExp(r'[+\s-]'), ''),
      });
      appLog("sendTo$appName result: ${result.toString()}");
      if (result == true) return;
    } catch (e) {
      appLog("sendTo$appName ex: ${e.toString()}");
    }

    // Fallback logic based on which app was attempted
    if (isBusinessApp) {
      // Fallback to regular WhatsApp if WhatsApp Business method channel fails
      await _shareImageWithWhatsAppApp(filePath, phoneNumber, false);
    } else {
      // Fallback to generic share if WhatsApp method channel fails
      await _shareWithOther(filePath);
    }
  }

  static void _showShareOptionsDialog(File file, String phoneNumber) {
    bool dontAskAgain = false;
    WhatsAppShareOption? selectedOption;
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),

              Text(
                AppStringsKeys.shareVia.tr,
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // WhatsApp option
              ListTile(
                leading: Radio<WhatsAppShareOption>(
                  value: WhatsAppShareOption.whatsapp,
                  groupValue: selectedOption,
                  onChanged: (value) {
                    setState(() {
                      selectedOption = value;
                    });
                  },
                ),
                title: Text(AppStringsKeys.whatsapp.tr),
                onTap: () {
                  setState(() {
                    selectedOption = WhatsAppShareOption.whatsapp;
                  });
                },
              ),

              // WhatsApp Business option
              ListTile(
                leading: Radio<WhatsAppShareOption>(
                  value: WhatsAppShareOption.whatsappBusiness,
                  groupValue: selectedOption,
                  onChanged: (value) {
                    setState(() {
                      selectedOption = value;
                    });
                  },
                ),
                title: Text(AppStringsKeys.whatsappBusiness.tr),
                onTap: () {
                  setState(() {
                    selectedOption = WhatsAppShareOption.whatsappBusiness;
                  });
                },
              ),

              // Other option
              ListTile(
                leading: Radio<WhatsAppShareOption>(
                  value: WhatsAppShareOption.other,
                  groupValue: selectedOption,
                  onChanged: (value) {
                    setState(() {
                      selectedOption = value;
                    });
                  },
                ),
                title: Text(AppStringsKeys.other.tr),
                onTap: () {
                  setState(() {
                    selectedOption = WhatsAppShareOption.other;
                  });
                },
              ),

              const SizedBox(height: 16),

              // Don't ask me again checkbox
              CheckboxListTile(
                value: dontAskAgain,
                onChanged: (value) {
                  setState(() {
                    dontAskAgain = value ?? false;
                  });
                },
                title: Text(AppStringsKeys.key325666021.tr),
                controlAffinity: ListTileControlAffinity.leading,
              ),

              const SizedBox(height: 16),

              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(AppStringsKeys.cancel.tr),
                  ),
                  ElevatedButton(
                    onPressed: selectedOption == null ? null : () async {
                      Navigator.of(context).pop();

                      // Save preferences if user checked "don't ask me again"
                      if (dontAskAgain) {
                        await WhatsAppSharePreferences.setDontAskAgain(true);
                        await WhatsAppSharePreferences.setSelectedOption(selectedOption!);
                      }

                      // Share the file with selected option
                      await _shareFileWithOption(file, phoneNumber, selectedOption!);
                    },
                    child: Text(AppStringsKeys.share.tr),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void _selectShareOptionsDialog(
      {required  Function() onWhatsApp, required Function() onWhatsAppBusiness, required Function() onOther}) {
    bool dontAskAgain = false;
    WhatsAppShareOption? selectedOption;
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),

              Text(
                AppStringsKeys.shareVia.tr,
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // WhatsApp option
              ListTile(
                leading: Radio<WhatsAppShareOption>(
                  value: WhatsAppShareOption.whatsapp,
                  groupValue: selectedOption,
                  onChanged: (value) {
                    setState(() {
                      selectedOption = value;
                    });
                  },
                ),
                title: Text(AppStringsKeys.whatsapp.tr),
                onTap: () {
                  setState(() {
                    selectedOption = WhatsAppShareOption.whatsapp;
                  });
                },
              ),

              // WhatsApp Business option
              ListTile(
                leading: Radio<WhatsAppShareOption>(
                  value: WhatsAppShareOption.whatsappBusiness,
                  groupValue: selectedOption,
                  onChanged: (value) {
                    setState(() {
                      selectedOption = value;
                    });
                  },
                ),
                title: Text(AppStringsKeys.whatsappBusiness.tr),
                onTap: () {
                  setState(() {
                    selectedOption = WhatsAppShareOption.whatsappBusiness;
                  });
                },
              ),

              // Other option
              ListTile(
                leading: Radio<WhatsAppShareOption>(
                  value: WhatsAppShareOption.other,
                  groupValue: selectedOption,
                  onChanged: (value) {
                    setState(() {
                      selectedOption = value;
                    });
                  },
                ),
                title: Text(AppStringsKeys.other.tr),
                onTap: () {
                  setState(() {
                    selectedOption = WhatsAppShareOption.other;
                  });
                },
              ),

              const SizedBox(height: 16),

              // Don't ask me again checkbox
              CheckboxListTile(
                value: dontAskAgain,
                onChanged: (value) {
                  setState(() {
                    dontAskAgain = value ?? false;
                  });
                },
                title: Text(AppStringsKeys.key325666021.tr),
                controlAffinity: ListTileControlAffinity.leading,
              ),

              const SizedBox(height: 16),

              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(AppStringsKeys.cancel.tr),
                  ),
                  ElevatedButton(
                    onPressed: selectedOption == null ? null : () async {
                      Navigator.of(context).pop();

                      // Save preferences if user checked "don't ask me again"
                      if (dontAskAgain) {
                        await WhatsAppSharePreferences.setDontAskAgain(true);
                        await WhatsAppSharePreferences.setSelectedOption(selectedOption!);
                      }

                      if(selectedOption == WhatsAppShareOption.whatsapp){
                        onWhatsApp();
                      }else if(selectedOption == WhatsAppShareOption.whatsappBusiness){
                        onWhatsAppBusiness();
                      }else{
                        onOther();
                      }
                    },
                    child: Text(AppStringsKeys.share.tr),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Future<void> _shareFileWithOption(File file, String phoneNumber, WhatsAppShareOption option) async {
    final filePath = file.path;

    switch (option) {
      case WhatsAppShareOption.whatsapp:
        await _shareWithWhatsApp(filePath, phoneNumber);
        break;
      case WhatsAppShareOption.whatsappBusiness:
        await _shareWithWhatsAppBusiness(filePath, phoneNumber);
        break;
      case WhatsAppShareOption.other:
        await _shareWithOther(filePath);
        break;
    }
  }

  static Future<void> _shareWithWhatsApp(String filePath, String phoneNumber) async {
    await _shareImageWithWhatsAppApp(filePath, phoneNumber, false);
  }

  static Future<void> _shareWithWhatsAppBusiness(String filePath, String phoneNumber) async {
    await _shareImageWithWhatsAppApp(filePath, phoneNumber, true);
  }

  static Future<void> _shareWithOther(String filePath) async {
    try {
      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(filePath)],
          sharePositionOrigin: Platform.isIOS
              ? Rect.fromLTWH(0, 0, Get.width, Get.height / 2)
              : null,
        ),
      );
    } catch (e) {
      appLog("shareWithOther ex: ${e.toString()}");
      showErrorMessage(AppStringsKeys.couldNotShareFile.tr);
    }
  }

  static Future<void> _copyPhoneNumberToClipboard(String parentPhone) async {
    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(
          AppStringsKeys.parentPhoneNumberCopiedToClipboard.tr,
          style: const TextStyle(color: Colors.white),
        ),
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.grey[800],
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
      ),
    );
    Clipboard.setData(ClipboardData(text: parentPhone));
    await Future.delayed(Duration(seconds: 3));

    // await Future.delayed(Duration(seconds: 2));

  }

}
