import 'package:get/get.dart';
import 'package:teacher_app/utils/message_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class WhatsappUtils {

  static void sendToWhatsApp( String message,String phoneNumber) async {

    try{
      final url = Uri.parse(
        "https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}",
      );
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        showErrorMessage('Could not launch WhatsApp'.tr);
      }
    }catch(e){
      showErrorMessage(e.toString());
    }


  }
}
