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
          title: const Text('设置'),
          bottom: const TabBar(
            tabs: [
              Tab(text: '小组管理'),
              Tab(text: '专业管理'),
              Tab(text: '指导教师管理'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            GroupsTabView(),
            SubjectsTab(),
            TeachersTabView(),
          ],
        ),
      ),
    );
  }
}
