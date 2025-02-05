import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/groups/groups_bloc.dart';
import '../bloc/groups/groups_state.dart';
import '../models/group.dart';
import 'group_details_screen.dart';

class GroupsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<GroupsBloc, GroupsState>(
        builder: (context, state) {
          if (state is GroupsLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is GroupsLoaded && state.groups.isNotEmpty) {
            return ListView.builder(
              itemCount: state.groups.length,
              itemBuilder: (context, index) {
                final group = state.groups[index];
                return Card(
                  margin: EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(group.name ?? "مجموعة بدون اسم"),
                    subtitle: Text("الصف: ${group.classroom}"),
                    trailing: Icon(Icons.arrow_forward),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GroupDetailsScreen(group: group),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          } else {
            return Center(child: Text("لا توجد مجموعات متاحة"));
          }
        },
      ),
    );
  }
}
