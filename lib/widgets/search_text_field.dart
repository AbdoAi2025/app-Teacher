import 'dart:async';

import 'package:flutter/cupertino.dart';

import '../utils/LogUtils.dart';
import 'app_text_field_widget.dart';

class SearchTextField extends StatefulWidget {
  
  final String hint;
  final TextEditingController controller;
  final Function(String?) onChanged;

  const SearchTextField(
      {super.key,
      required this.hint,
      required this.controller,
      required this.onChanged});

  @override
  State<SearchTextField> createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {


  Timer? _debounce;

  @override
  Widget build(BuildContext context) {
    return AppTextFieldWidget(
      hint: widget.hint,
      onChanged: _onSearchChanged,
      controller: widget.controller,
      textInputAction: TextInputAction.search,
    );
  }

  void _onSearchChanged(String? query) {
    if (query == null) return;
    // Cancel previous timer if still active
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    // Start new debounce timer
    _debounce = Timer(const Duration(milliseconds: 1000), () {
      appLog("_onSearchChanged query:$query ");
      widget.onChanged(query);
    });
  }
}
