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

final MethodChannel _whatsappChannel = MethodChannel('whatsapp_share');

class WhatsappUtils {

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

  static void sendToWhatsAppFile(File file, String phoneNumber) async {
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
                "Share via".tr,
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
                title: Text("WhatsApp".tr),
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
                title: Text("WhatsApp Business".tr),
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
                title: Text("Other".tr),
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
                title: Text("Don't ask me again".tr),
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
                    child: Text("Cancel".tr),
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
                    child: Text("Share".tr),
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

  static Future<void> _shareWithWhatsAppApp(String filePath, String phoneNumber, bool isBusinessApp) async {
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
      await _shareWithWhatsAppApp(filePath, phoneNumber, false);
    } else {
      // Fallback to generic share if WhatsApp method channel fails
      await _shareWithOther(filePath);
    }
  }

  static Future<void> _shareWithWhatsApp(String filePath, String phoneNumber) async {
    await _shareWithWhatsAppApp(filePath, phoneNumber, false);
  }

  static Future<void> _shareWithWhatsAppBusiness(String filePath, String phoneNumber) async {
    await _shareWithWhatsAppApp(filePath, phoneNumber, true);
  }

  static Future<void> _shareWithOther(String filePath) async {
    try {
      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(filePath)],
        ),
      );
    } catch (e) {
      appLog("shareWithOther ex: ${e.toString()}");
      showErrorMessage('Could not share file'.tr);
    }
  }
}
