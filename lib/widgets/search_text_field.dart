import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/LogUtils.dart';
import 'app_text_field_widget.dart';

class SearchTextField extends StatefulWidget {
  final String? hint;
  final TextEditingController controller;
  final Function(String?) onChanged;

  const SearchTextField({
    super.key,
    this.hint,
    required this.controller,
    required this.onChanged,
  });

  @override
  State<SearchTextField> createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
  Timer? _debounce;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _hasText = widget.controller.text.isNotEmpty;
    widget.controller.addListener(_onControllerChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    widget.controller.removeListener(_onControllerChanged);
    super.dispose();
  }

  void _onControllerChanged() {
    final hasText = widget.controller.text.isNotEmpty;
    if (hasText != _hasText) {
      setState(() => _hasText = hasText);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppTextFieldWidget(
      hint: widget.hint ?? 'Search'.tr,
      onChanged: _onSearchChanged,
      controller: widget.controller,
      textInputAction: TextInputAction.search,
      suffixIcon: _hasText
          ? IconButton(
              icon: const Icon(Icons.close, size: 18),
              onPressed: _onClear,
            )
          : null,
    );
  }

  void _onSearchChanged(String? query) {
    if (query == null) return;
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 1000), () {
      appLog("_onSearchChanged query:$query ");
      widget.onChanged(query);
    });
  }

  void _onClear() {
    _debounce?.cancel();
    widget.controller.clear();
    widget.onChanged('');
  }
}