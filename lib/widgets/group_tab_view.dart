import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../consts/hive_consts.dart';
import '../models/group.dart';

class GroupsTabView extends StatefulWidget {
  const GroupsTabView({super.key}); // Sample groups
  @override
  GroupsTabViewState createState() => GroupsTabViewState();
}

class GroupsTabViewState extends State<GroupsTabView> {
  final TextEditingController _studentNameController = TextEditingController();
  final TextEditingController _startYearController = TextEditingController();
  final TextEditingController _groupNumberController = TextEditingController();

  late final Box<Group> groupBox;
  late final List<Group> groups;
  late final Box<List<int>> yearBox;
  late final List<int> years;

  late List<DataRow> _rows;

  @override
  void initState() {
    super.initState();
    groupBox = Hive.box(groupBoxName);
    groups = groupBox.values.toList();
    yearBox = Hive.box(yearBoxName);
    years = yearBox.get(yearsKey) ?? [];
  }

  @override
  Widget build(BuildContext context) {
    _rows = _createRows();
    return Column(
      children: [
        DataTable(
          columns: const [
            DataColumn(label: Text('入学年份')), // Enrollment Year
            DataColumn(label: Text('编号')), // ID
            DataColumn(label: Text('学生')),
            //TODO: add more columns if there are more students
            DataColumn(label: Text("")),
          ],
          rows: _rows,
        ),
      ],
    );
  }

  List<DataRow> _createRows() {
    List<DataRow> rows = [];

    for (int i = 0; i < groups.length; i++) {
      Group group = groups[i];
      rows.add(DataRow(cells: [
        DataCell(Text(group.startYear.toString())), // Sample enrollment year
        DataCell(Text(group.groupNumber.toString())), // Sample ID
        DataCell(Text(group.studentNames.toString())), // Sample student name
        DataCell(IconButton(
          icon: const Icon(Icons.remove),
          onPressed: () {
            setState(() {
              _deleteRow(i);
            });
          },
        ))
      ]));
    }

    rows.add(
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
          DataCell(
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                setState(() => _addGroup());
              },
            ),
          ),
        ],
      ),
    );
    return rows;
  }

  void _deleteRow(int index) {
    if (mounted) {
      setState(() {
        groups.removeAt(index);
      });
    }
    groupBox.deleteAt(index);
  }

  void _addGroup() {
    String newStudent = _studentNameController.text.trim();
    String startYearString = _startYearController.text.trim();
    String groupNumberString = _groupNumberController.text.trim();

    if (newStudent.isNotEmpty &&
        startYearString.isNotEmpty &&
        groupNumberString.isNotEmpty) {
      int startYear = int.parse(startYearString);
      int groupNumber = int.parse(groupNumberString);

      if (mounted) {
        setState(() {
          //TODO sort by start year and group number
          var newGroup = Group(startYear, groupNumber, [newStudent]);
          groups.add(newGroup);
          groupBox.add(newGroup);
          years.addAll([startYear, startYear + 1, startYear + 2]);
          years.toSet().toList().sort();
          yearBox.put(yearsKey, years);

          _studentNameController.clear();
          _startYearController.clear();
          _groupNumberController.clear();
        });
      }
    }
  }

  @override
  void dispose() {
    _studentNameController.dispose();
    super.dispose();
  }
}
