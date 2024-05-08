import 'package:flutter/material.dart';
import 'package:scheduling/database.dart';
import 'package:scheduling/screens/home_screen.dart';

import '../models/group.dart';

class GroupsTabView extends StatefulWidget {
  final List<Group> groups = Database.groups;
  GroupsTabView({super.key}); // Sample groups
  @override
  GroupsTabViewState createState() => GroupsTabViewState();
}

class GroupsTabViewState extends State<GroupsTabView> {
  final TextEditingController _studentNameController = TextEditingController();
  final TextEditingController _startYearController = TextEditingController();
  final TextEditingController _groupNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DataTable(
          columns: const [
            DataColumn(label: Text('入学年份')), // Enrollment Year
            DataColumn(label: Text('编号')), // ID
            DataColumn(label: Text('学生')), // Student
          ],
          rows: [
            for (Group group in groups)
              DataRow(cells: [
                DataCell(
                    Text(group.startYear.toString())), // Sample enrollment year
                DataCell(Text(group.groupNumber.toString())), // Sample ID
                DataCell(
                    Text(group.studentNames.toString())), // Sample student name
              ]),
            // Add more DataRow as needed
            DataRow(
              cells: [
                DataCell(
                  TextField(
                    controller: _startYearController,
                    decoration: const InputDecoration(hintText: '入学年份'),
                  ),
                ),
                DataCell(
                  TextField(
                    controller: _groupNumberController,
                    decoration: const InputDecoration(hintText: '编号'),
                  ),
                ),
                DataCell(
                  TextField(
                    controller: _studentNameController,
                    decoration: const InputDecoration(hintText: '学生'),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16.0),
        ElevatedButton(
          onPressed: _addTeacher,
          child: const Text('Add Teacher'),
        ),
      ],
    );
  }

  void _addTeacher() {
    String newStudent = _studentNameController.text.trim();
    String startYearString = _startYearController.text.trim();
    String groupNumberString = _groupNumberController.text.trim();

    if (newStudent.isNotEmpty &&
        startYearString.isNotEmpty &&
        groupNumberString.isNotEmpty) {
      int startYear = int.parse(startYearString);
      int groupNumber = int.parse(groupNumberString);
      setState(() {
        groups.add(Group(startYear, groupNumber, [newStudent]));
        _studentNameController.clear();
        _startYearController.clear();
        _groupNumberController.clear();
      });
    }
  }

  @override
  void dispose() {
    _studentNameController.dispose();
    super.dispose();
  }
}
