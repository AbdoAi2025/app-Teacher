import 'package:flutter/material.dart';

import 'label_widget.dart';
import 'value_widget.dart';

class AppRadioWidget extends StatelessWidget{

  final bool value;
  final String? label;
  final Function() onChanged;

  const AppRadioWidget({
    super.key,
    required this.value,
    this.label,
    required this.onChanged
  });

  @override
  Widget build(BuildContext context) {

    var label = this.label ?? "";

    return InkWell(
      onTap: (){
        onChanged();
      },
      child: Row(
        spacing: 5,
        children: [
          Icon(value ? Icons.radio_button_checked : Icons.radio_button_off),
          if(label.isNotEmpty)
          Expanded(child: ValueWidget(label),)
        ],
      ),
    );
  }
}
