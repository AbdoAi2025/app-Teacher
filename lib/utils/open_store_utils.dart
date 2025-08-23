import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../main.dart';

class OpenStoreUtils {


  static Future<void> openStore() async {

    const String androidAppId = "com.assistant.teacher"; // replace with your package name
    const String iosAppId = "1234567890"; // replace with your App Store ID

    final Uri url = Uri.parse(
      Theme.of(navigatorKey.currentContext!).platform == TargetPlatform.iOS
          ? "https://apps.apple.com/app/id$iosAppId"
          : "https://play.google.com/store/apps/details?id=$androidAppId",
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw "Could not launch $url";
    }
  }
}
