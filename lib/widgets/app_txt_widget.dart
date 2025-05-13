import 'package:flutter/material.dart';
import 'package:teacher_app/appSetting/appSetting.dart';
import 'package:teacher_app/utils/LogUtils.dart';
import 'package:teacher_app/utils/numbers_format_utils.dart';


class AppTextWidget extends StatelessWidget {

  final String text;
  final TextAlign? textAlign;
  final int? maxLines;
  final Color? color;
  final TextOverflow? overflow;
  final bool italic;
  final bool underline;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextStyle? style;

  const AppTextWidget(this.text,
      {super.key,
      this.textAlign,
      this.maxLines,
      this.color,
      this.fontSize = 16,
      this.italic = false,
      this.underline = false,
      this.overflow,
      this.fontWeight,
      this.style
      });

  @override
  Widget build(BuildContext context) {
    return Text(
      _getText(),
      textAlign: textAlign,
      maxLines: maxLines,
      style: style ?? TextStyle(
        fontSize: fontSize,
        fontStyle: italic ? FontStyle.italic : FontStyle.normal,
        fontWeight: fontWeight ?? FontWeight.normal,
        color: color ?? Theme.of(context).textTheme.titleSmall!.color,
        fontFamily: AppSetting.appLanguage == "en"
            ? 'english_font'
            : 'arabic_font',
        overflow: overflow,
        decoration: underline ? TextDecoration.underline : TextDecoration.none,
      ),
    );
  }

  String _getText() {
    _log("_getText text:$text");
    var formatted = NumbersFormatUtils.replaceArabicNumbersToEnglish(text);
    _log("_getText formatted:$formatted");
    return formatted;
  }

  void _log(String s) {
    appLog("AppTextWidget $s");
  }
}
