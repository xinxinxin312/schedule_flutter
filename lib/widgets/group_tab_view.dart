import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../consts/hive_consts.dart';
import '../models/group.dart';

class GroupsTabView extends StatefulWidget {
  const GroupsTabView({super.key});
  @override
  GroupsTabViewState createState() => GroupsTabViewState();
}

class GroupsTabViewState extends State<GroupsTabView> {
  final TextEditingController _studentNameController1 = TextEditingController();
  final TextEditingController _studentNameController2 = TextEditingController();

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
  }

  @override
  Widget build(BuildContext context) {
    _rows = _createRows();
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: DataTable(
          columns: const [
            DataColumn(
                label: Text(
              '入学年份',
            )),
            DataColumn(label: Text('编号')),
            DataColumn(label: Text('学生1')),
            DataColumn(label: Text('学生2')),
            DataColumn(label: Text("")),
          ],
          rows: _rows,
        ));
  }

  List<DataRow> _createRows() {
    List<DataRow> rows = [];

    for (int i = 0; i < groups.length; i++) {
      Group group = groups[i];
      rows.add(DataRow(cells: [
        DataCell(Text(group.startYear.toString())),
        DataCell(Text(group.groupNumber.toString())),
        DataCell(Text(group.studentNames[0])),
        DataCell(
            Text(group.studentNames.length <= 1 ? "" : group.studentNames[1])),
        DataCell(IconButton(
          icon: const Icon(Icons.remove),
          onPressed: () {
            if (mounted) {
              setState(() => _deleteRow(i));
            }
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
              controller: _studentNameController1,
              decoration: const InputDecoration(hintText: '学生1'),
            ),
          ),
          DataCell(
            TextField(
              controller: _studentNameController2,
              decoration: const InputDecoration(hintText: '学生2'),
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
  }

  void _addGroup() {
    String newStudent1 = _studentNameController1.text.trim();
    String newStudent2 = _studentNameController2.text.trim();
    List<String> newStudents = [newStudent1, newStudent2];

    String startYearString = _startYearController.text.trim();
    String groupNumberString = _groupNumberController.text.trim();

    if (newStudent1.isNotEmpty &&
        startYearString.isNotEmpty &&
        groupNumberString.isNotEmpty) {
      int startYear = int.parse(startYearString);
      int groupNumber = int.parse(groupNumberString);

      if (mounted) {
        setState(() {
          var newGroup = Group(startYear, groupNumber, newStudents);
          if (groups.contains(newGroup)) {
            callShowDialog("小组已存在, 不能添加重复小组");
          } else {
            groups.add(newGroup);
            groups.sort();
          }

          _studentNameController1.clear();
          _studentNameController2.clear();
          _startYearController.clear();
          _groupNumberController.clear();
        });
      }
    }
  }

  @override
  void dispose() {
    _studentNameController1.dispose();
    _studentNameController2.dispose();
    _saveGroups();
    super.dispose();
  }

  Future _saveGroups() async {
    await groupBox.clear();
    await groupBox.addAll(groups);
  }

  Future<dynamic> callShowDialog(String textMsg) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('提示'),
          content: Text(textMsg),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('确定'),
            ),
          ],
        );
      },
    );
  }
}
