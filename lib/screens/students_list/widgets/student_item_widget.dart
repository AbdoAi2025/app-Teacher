import 'package:flutter/material.dart';
import 'package:teacher_app/screens/students_list/states/student_item_ui_state.dart';

class StudentItemWidget extends StatefulWidget {

  final StudentItemUiState uiState;
  final Function(StudentItemUiState) onItemClick;

  const StudentItemWidget({super.key, required this.uiState, required this.onItemClick});

  @override
  State<StudentItemWidget> createState() => _StudentItemWidgetState();
}

class _StudentItemWidgetState extends State<StudentItemWidget> {
  late StudentItemUiState uiState = widget.uiState;

  @override
  Widget build(BuildContext context) {
   return   InkWell(
     onTap: (){
       widget.onItemClick(uiState);
     },
     child: Card(
       elevation: 4,
       margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
       child: ListTile(
         title: Text(uiState.name,
             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
         subtitle: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             Row(children: [
               Icon(Icons.phone, color: Colors.green, size: 18),
               SizedBox(width: 6),
               Text(uiState.parentPhone)
             ]),
             Row(children: [
               Icon(Icons.school, color: Colors.blue, size: 18),
               SizedBox(width: 6),
               Text(uiState.grade)
             ]),
           ],
         ),
         trailing: IconButton(
           icon: Icon(Icons.delete, color: Colors.red),
           onPressed: () {},
         ),
       ),
     ),
   );
  }
}
