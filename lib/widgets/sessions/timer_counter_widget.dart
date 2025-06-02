import 'dart:async';

import 'package:flutter/cupertino.dart';

import '../../themes/app_colors.dart';
import '../../themes/txt_styles.dart';
import '../app_txt_widget.dart';

class TimerCounterWidget extends StatefulWidget{

  final DateTime? dateTime;

  final TextStyle? textStyle;

  const TimerCounterWidget({super.key, required this.dateTime , this.textStyle});



  @override
  State<TimerCounterWidget> createState() => _TimerCounterWidgetState();
}

class _TimerCounterWidgetState extends State<TimerCounterWidget> {

  late Timer _timer;
  String _elapsed = "";

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (_) => _updateTime());
  }

  void _updateTime() {
    final startTime = widget.dateTime;
    if(startTime != null){
      final now = DateTime.now();
      final isPast = now.isAfter(startTime);
      final diff =  now.difference(startTime);
      final hours = diff.inHours;
      final minutes = diff.inMinutes % 60;
      final seconds = diff.inSeconds % 60;
      setState(() {
        String hoursFormatted = hours.toString().padLeft(2, '0');
        String minutesFormatted = minutes.toString().padLeft(2, '0');
        String secondsFormatted = seconds.toString().padLeft(2, '0');
        _elapsed ="$hoursFormatted:$minutesFormatted:$secondsFormatted";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
   return AppTextWidget(
     _elapsed,
     style: widget.textStyle ?? AppTextStyle.title
         .copyWith(fontSize: 35, color: AppColors.appMainColor),
   );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }


}
