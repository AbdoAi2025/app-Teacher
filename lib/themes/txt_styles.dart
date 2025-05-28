import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppTextStyle {


  AppTextStyle._();

  static TextStyle get title =>
      teshrinArLtRegular.copyWith(fontSize: 16, fontWeight: FontWeight.w600);

  static TextStyle get appToolBarTitle =>
      teshrinArLtRegular.copyWith(fontSize: 18, fontWeight: FontWeight.w600);

  static TextStyle get textFieldStyle =>
      teshrinArLtRegular;

  static const TextStyle inter =
      TextStyle(fontSize: 12, color: Colors.black, fontFamily: "inter");

  static const TextStyle interItalic =
      TextStyle(fontSize: 12, color: Colors.black, fontFamily: "inter_italic");

  static const TextStyle teshrinArLtRegular = TextStyle(
      fontSize: 12, color: Colors.black, fontFamily: "teshrin_ar_lt_regular");

  static TextStyle teshrinArLtRegularBold = teshrinArLtRegular.copyWith(
    fontFamily: "teshrin_ar_lt_bold",
  );

  static const TextStyle normalFont24BlackW500 = TextStyle(
      fontSize: 24,
      color: Colors.black,
      fontWeight: FontWeight.w500,
      fontFamily: "english_font");

  static const TextStyle normalFont22BlackW400 = TextStyle(
      fontSize: 22,
      color: Colors.black,
      fontWeight: FontWeight.w400,
      fontFamily: "english_font");

  static const TextStyle normalFont18BlackW300 = TextStyle(
      fontSize: 18,
      color: Colors.black,
      fontWeight: FontWeight.w300,
      fontFamily: "english_font");

  static const TextStyle normalFont18BlackW600 = TextStyle(
      fontSize: 18,
      color: Colors.black,
      fontWeight: FontWeight.w600,
      fontFamily: "english_font");

  static const TextStyle normalFont16BlackW300 = TextStyle(
      fontSize: 16,
      color: Colors.black,
      fontWeight: FontWeight.w300,
      fontFamily: "english_font");

  static const TextStyle normalFont32BlackW500 = TextStyle(
      fontSize: 36,
      color: Colors.black,
      fontWeight: FontWeight.w500,
      fontFamily: "english_font");
  static const TextStyle normalFont14BlackW300 = TextStyle(
      fontSize: 14,
      color: Colors.black,
      fontWeight: FontWeight.w300,
      fontFamily: "english_font");

  static const TextStyle normalFont12BlackW300 = TextStyle(
      fontSize: 12,
      color: Colors.black,
      fontWeight: FontWeight.w300,
      fontFamily: "english_font");

  static const TextStyle normalFont14BlackBold = TextStyle(
      fontSize: 14,
      color: Colors.black,
      fontWeight: FontWeight.w900,
      fontFamily: "english_font");

  static const TextStyle garbataFont18BlackW400 = TextStyle(
      fontSize: 18,
      color: Colors.black,
      fontWeight: FontWeight.w400,
      fontFamily: "garbata_regular");

  static const TextStyle garbataRegular = TextStyle(
      fontSize: 18, color: Colors.black, fontFamily: "garbata_regular");

  static const TextStyle garbataFont18BlackWBold = TextStyle(
      fontSize: 18,
      color: Colors.black,
      fontWeight: FontWeight.w800,
      fontFamily: "arabic_font");

  static const TextStyle garbataFont25Black = TextStyle(
    fontSize: 25,
    color: Colors.black,
    fontFamily: "garbata_regular",
  );

  static const TextStyle garbataLightFont50BlackW400 = TextStyle(
      fontSize: 50,
      color: Colors.black,
      fontWeight: FontWeight.w400,
      fontFamily: "garbata_regular");
  static const TextStyle normalFont50BlackW400 = TextStyle(
      fontSize: 50,
      color: Colors.black,
      fontWeight: FontWeight.w400,
      fontFamily: "arabic_font");

  static TextStyle getMainFontStyle() {
    if (Get.locale == Locale("ar")) {
      return const TextStyle(
          fontSize: 25,
          color: Colors.black,
          fontWeight: FontWeight.w400,
          fontFamily: "arabic_font");
    }
    return const TextStyle(
        fontSize: 25,
        color: Colors.black,
        fontWeight: FontWeight.w500,
        fontFamily: "english_font");
  }

  static TextStyle getMainFontStyleWithGarbata() {
    if (Get.locale == Locale("ar")) {
      return const TextStyle(
          fontSize: 25,
          color: Colors.black,
          fontWeight: FontWeight.w400,
          fontFamily: "arabic_font");
    }
    return const TextStyle(
        fontSize: 25,
        color: Colors.black,
        fontWeight: FontWeight.w500,
        fontFamily: "garbata_regular");
  }
}
