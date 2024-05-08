// TODO management and hive
// add new students
// add new groups
// group displaying view
// add new teachers
// teacher displaying view
// add new years
//

import 'package:flutter/material.dart';
import '../widgets/group_tab_view.dart';
import '../widgets/teachers_tab_view.dart';
import '../widgets/subjects_tab_view.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
          bottom: const TabBar(
            tabs: [
              Tab(text: '小组管理'),
              Tab(text: '指导教师管理'),
              Tab(text: '专业管理'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            GroupsTabView(),
            const TeachersTabView(),
            const SubjectsTab(),
          ],
        ),
      ),
    );
  }
}