import 'package:flutter/cupertino.dart';

class KeyboardUtils {

  static  void hideKeyboard(BuildContext context) async{
    // FocusScope.of(context).requestFocus(FocusNode());
    FocusScope.of(context).unfocus();
  }
}
