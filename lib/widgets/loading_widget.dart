import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {

  final AlignmentGeometry? alignment;

  const LoadingWidget({super.key, this.alignment});

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: alignment ?? AlignmentDirectional.topCenter,
        child: CircularProgressIndicator());
  }
}
