import 'dart:io';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:teacher_app/utils/LogUtils.dart';
import 'package:teacher_app/utils/message_utils.dart';
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
    var filePath = file.path;
    try {

      var result  = await _whatsappChannel.invokeMethod('sendFileToWhatsApp', {
        'filePath': filePath,
        'phone': phoneNumber.replaceAll(RegExp(r'[+\s-]'), ''),
      });
      appLog("sendToWhatsAppFile result:${result.toString()}");
      if(result == true) return;

    } catch (e) {
      appLog("sendToWhatsAppFile ex:${e.toString()}");
      // Fallback to share_plus if WhatsApp not installed
      // await Share.shareXFiles([XFile(filePath)]);
    }

    await SharePlus.instance.share(
        ShareParams(
          files:[XFile(filePath)],
        ));

    // final uri = Uri.parse(
    //   "whatsapp://send?text=Check this out!&file=${file.path}",
    // );
    //
    // if (await canLaunchUrl(uri)) {
    //   await launchUrl(uri);
    // } else {
    //   print("WhatsApp not installed");
    //   // Fallback to generic share
    //   await Share.shareXFiles([XFile(file.path)]);
    // }
    //
    //

    //    "whatsapp://send?text=Check this out!&file=${file.path}",

    // try{
    //
    //   // var fileUrl = file.path; // Replace with the URL of the file you want to send
    //   // var url = Uri.parse("whatsapp://send?phone=$phoneNumber&file=$fileUrl");
    //
    //   final url = Uri.parse(
    //     "whatsapp://wa.me/$phoneNumber?file=${file.path}",
    //   );
    //   if (await canLaunchUrl(url)) {
    //     await launchUrl(url, mode: LaunchMode.externalApplication);
    //   } else {
    //     await Share.shareXFiles([XFile(file.path)]);
    //   }
    // }catch(e){
    //   appLog(e.toString());
    //   showErrorMessage('Could not launch WhatsApp'.tr);
    // }
  }
}
