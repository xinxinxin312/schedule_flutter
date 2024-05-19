import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:scheduling/consts/hive_consts.dart';

import '../models/teacher.dart';

class TeachersTabView extends StatefulWidget {
  const TeachersTabView({super.key});

  @override
  TeachersTabViewState createState() => TeachersTabViewState();
}

class TeachersTabViewState extends State<TeachersTabView> {
  late final Box<List<String>> subjectBox;
  late final List<String> subjects; // Sample subjects
  late final Box<Teacher> teachersBox;
  late final List<String> teacherNames;
  late final List<Teacher> teachers;

  final Map<String, List<bool>> teacherSubjectMap = {};
  final TextEditingController _newTeacherController = TextEditingController();
  late List<bool> _newTeacherSubjects;
  late List<DataRow> _rows;

  @override
  void initState() {
    super.initState();
    subjectBox = Hive.box(subjectBoxName);
    subjects = subjectBox.get(subjectsBoxKey) ?? [];

    teachersBox = Hive.box(teachersBoxName);
    teachers = teachersBox.values.toList();
    teacherNames = teachers.map((e) => e.name).toList();
    _newTeacherSubjects = List.generate(subjects.length, (_) => false);
    _initTeacherSubjectMap();
  }

  void _initTeacherSubjectMap() {
    for (Teacher teacher in teachers) {
      List<bool> canTeach = [];
      for (String subject in subjects) {
        if (teacher.subjects.contains(subject)) {
          canTeach.add(true);
        } else {
          canTeach.add(false);
        }
      }
      teacherSubjectMap[teacher.name] = canTeach;
    }
  }

  void _addTeacher() {
    String newTeacherName = _newTeacherController.text.trim();
    if (newTeacherName.isNotEmpty) {
      if (mounted) {
        setState(() {
          teacherNames.add(newTeacherName);
          teacherSubjectMap[newTeacherName] = _newTeacherSubjects;
          List<String> teachableSubjects = [];
          for (int i = 0; i < _newTeacherSubjects.length; i++) {
            if (_newTeacherSubjects[i]) {
              teachableSubjects.add(subjects[i]);
            }
          }
          var newTeacher = Teacher(newTeacherName, teachableSubjects);
          teachersBox.add(newTeacher);

          _newTeacherController.clear();
          _newTeacherSubjects = List.generate(subjects.length, (_) => false);
        });
      }
    }
  }

  final ScrollController controllerVertical = ScrollController();
  final ScrollController controllerHorizontal = ScrollController();

  @override
  Widget build(BuildContext context) {
    _rows = _createRows();
    return Scrollbar(
        controller: controllerHorizontal,
        child: SingleChildScrollView(
            controller: controllerHorizontal,
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
                controller: controllerVertical,
                scrollDirection: Axis.vertical,
                child: DataTable(
                  sortAscending: false,
                  columns: [
                    const DataColumn(
                        label: Expanded(child: Center(child: Text('指导教师')))),
                    for (String subject in subjects)
                      DataColumn(
                          label: Expanded(child: Center(child: Text(subject)))),
                    const DataColumn(label: Text("")),
                  ],
                  rows: _rows,
                ))));
  }

  List<DataRow> _createRows() {
    List<DataRow> rows = [];

    for (int i = 0; i < teacherNames.length; i++) {
      String teacher = teacherNames[i];
      rows.add(DataRow(cells: [
        DataCell(Center(child: Text(teacher))),

        // Sample enrollment year
        for (int i = 0; i < subjects.length; i++)
          DataCell(
            Container(
              color: teacherSubjectMap[teacher]![i]
                  ? Colors.green
                  : Theme.of(context).scaffoldBackgroundColor,
            ),
          ),
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
              controller: _newTeacherController,
              decoration: const InputDecoration(hintText: '添加指导教师'),
            ),
          ),
          for (int i = 0; i < subjects.length; i++)
            DataCell(Center(
              child: Checkbox(
                value: _newTeacherSubjects[i],
                onChanged: (value) {
                  if (mounted) {
                    setState(() => _newTeacherSubjects[i] = value!);
                  }
                },
              ),
            )),
          DataCell(
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                if (mounted) {
                  setState(() => _addTeacher());
                }
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
        teacherNames.removeAt(index);
      });
    }
    teachersBox.deleteAt(index);
  }

  @override
  void dispose() {
    _newTeacherController.dispose();
    super.dispose();
  }
}
