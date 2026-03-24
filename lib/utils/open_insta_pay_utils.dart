import 'package:url_launcher/url_launcher.dart';

import 'LogUtils.dart';

class OpenInstaPayUtils {


  OpenInstaPayUtils._();

  static Future<void> openUrl() async {
    final Uri url = Uri.parse("https://ipn.eg/S/hamdycib/instapay/2JJxT2");
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      appLog("Could not launch payment URL");
    }
  }
}
