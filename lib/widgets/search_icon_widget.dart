import 'package:flutter/material.dart';
import 'package:teacher_app/themes/app_colors.dart';

class SearchIconWidget extends StatelessWidget{
  const SearchIconWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Icon(Icons.search_sharp , color: AppColors.appMainColor,);
  }


}
