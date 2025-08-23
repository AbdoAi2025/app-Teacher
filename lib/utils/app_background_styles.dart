import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import '../themes/app_colors.dart';

class AppBackgroundStyle {

  AppBackgroundStyle._();

  static Decoration bottomBorder(Color borderColor , { double borderWidth = 1.5, Color backgroundColor = Colors.transparent} ){
    return BoxDecoration(
      color: backgroundColor,
      border: Border(
        bottom: BorderSide(width: borderWidth, color: borderColor),
      ),
    );
  }



  static Decoration getColorDBD5CCBackgroundRounded() =>
      getColoredBackgroundRounded(20, AppColors.color_DBD5CC);

  static Decoration getColorE8E5E0BackgroundRounded12() =>
      getColoredBackgroundRounded(12, AppColors.color_E8E5E0);

  static Decoration getBackgroundBlack() =>
      getColoredBackgroundRounded(20, Colors.black.withOpacity(0.3));

  static Decoration getRoundedBackground20(Color color) =>
      getColoredBackgroundRounded(20, color);

  static Decoration getBackgroundRounded(double radius) =>
      BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(radius)));

  static Decoration getColoredBackgroundRounded(double radius, Color color) =>
      BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(Radius.circular(radius))
      );

  static Decoration getColoredBackgroundRoundedBorder(
          {required double radius,
          required Color bgColor,
          required Color borderColor,
          double borderWidth = 1}) =>
      BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.all(Radius.circular(radius)),
          border: Border.all(color: borderColor, width: borderWidth));

  static Decoration decoration({
    Color backgroundColor = AppColors.white,
    Color borderColor = AppColors.color_919191,
    double borderRadius = 20,
    double borderWidth = 0,
    List<BoxShadow>? boxShadow,
  }) =>
      BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: borderColor, width: borderWidth),
        boxShadow: boxShadow,
        borderRadius: BorderRadius.circular(borderRadius),
      );


  static getBlackGrediantBackground() => BoxDecoration(
      gradient: LinearGradient(
          colors: [
             Color(0x0),
             Color(0x99000000),
          ],
          tileMode: TileMode.mirror,
          end: AlignmentDirectional.topCenter,
          begin: AlignmentDirectional.bottomCenter
      ));


  static getBlackFromTopToBottomGrediantBackground() => BoxDecoration(
      gradient: LinearGradient(
          colors: [
             Color(0x0),
             Color(0x99000000),
          ],
          tileMode: TileMode.mirror,
        begin: AlignmentDirectional.topCenter,
        end: AlignmentDirectional.bottomCenter,
      ));


  static backgroundWithShadow({
    Color? backgroundColor,
    double? borderRadius,
    Color? borderColor,
    double? borderWidth,
    Color? shadowColor,
    double? shadowRadius,
    double? blurRadius,
    Offset? offset,
  }) => BoxDecoration(
    color: backgroundColor ?? Colors.white,
    borderRadius: BorderRadius.all(Radius.circular( borderRadius?? 15)),
    border: Border.all(color:  borderColor?? AppColors.color_F0F0F0, width: borderWidth ?? 1),
    boxShadow: [
      BoxShadow(
        color: shadowColor ??  AppColors.color_000714,
        blurRadius: blurRadius ?? .5,
        offset: offset ?? const Offset(0, 0), // changes position of shadow
      ),
    ],
  );

  static backgroundWithShadowOnly({
    Color? backgroundColor,
    double? borderRadius,
    Color? borderColor,
    double? borderWidth,
    Color? shadowColor,
    double? shadowRadius,
    double? blurRadius,
    Offset? offset,
    Radius? topLeftRadius,
    Radius? topRightRadius,
    Radius? bottomLeftRadius,
    Radius? bottomRightRadius,
  }) => BoxDecoration(
    color: backgroundColor ?? Colors.white,
    borderRadius: BorderRadius.only(
        topLeft: topLeftRadius ?? Radius.zero,
        topRight: topRightRadius ?? Radius.zero,
      bottomLeft: bottomLeftRadius ?? Radius.zero,
      bottomRight: bottomRightRadius ?? Radius.zero
    ),
    border: Border.all(color:  borderColor?? AppColors.color_F0F0F0, width: borderWidth ?? 1),
    boxShadow: [
      BoxShadow(
        color: shadowColor ??  AppColors.color_000714,
        blurRadius: blurRadius ?? .5,
        offset: offset ?? const Offset(0, 0), // changes position of shadow
      ),
    ],
  );

}
