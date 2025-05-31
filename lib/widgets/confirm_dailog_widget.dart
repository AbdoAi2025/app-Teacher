import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/widgets/app_txt_widget.dart';
import 'package:teacher_app/widgets/primary_button_widget.dart';

class ConfirmDailogWidget extends StatelessWidget {


  String? title;
  String? sub_title;
  String? positive_button_text;
  String? negative_button_text;
  Function()? onSuccess;
  Function()? onCancel;
  bool showCancelBtn;
  Widget? leading;
  EdgeInsets? margin;
  bool autoDismiss;
  Color? buttonColor;
  Color? borderColor;

  ConfirmDailogWidget(
      {super.key,
      this.title,
      this.sub_title,
      this.onSuccess,
      this.onCancel,
      this.leading,
      this.margin,
      this.buttonColor,
      this.borderColor,
      this.positive_button_text,
      this.negative_button_text,
      this.showCancelBtn = true,
      this.autoDismiss = true});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: margin ?? const EdgeInsets.symmetric(horizontal: 50),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                color: Theme.of(context).scaffoldBackgroundColor,
                boxShadow: [
                  BoxShadow(color: Colors.grey.shade300, blurRadius: 5)
                ]),
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                if (title != null)
                  AppTextWidget(
                    title!,
                    textAlign: TextAlign.center,
                  ),
                if (sub_title != null) ...{
                  const SizedBox(
                    height: 10,
                  ),
                  AppTextWidget(
                    sub_title!,
                    textAlign: TextAlign.center,
                  ),
                },
                const SizedBox(
                  height: 10,
                ),
                PrimaryButtonWidget(
                  text: positive_button_text ?? 'ok'.tr,
                  onClick: () {
                    if (autoDismiss) {
                      Navigator.pop(context);
                    }
                    onSuccess?.call();
                  },
                ),
                Visibility(
                    visible: showCancelBtn,
                    child: PrimaryButtonWidget(
                      text: negative_button_text ?? 'cancel'.tr,
                      onClick: () {
                        Navigator.pop(context);
                        onCancel?.call();
                      },
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
