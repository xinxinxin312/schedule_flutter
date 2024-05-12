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

  @override
  Widget build(BuildContext context) {
    _rows = _createRows();
    return Column(
      children: [
        DataTable(
          columns: [
            const DataColumn(label: Text('指导教师姓名')),
            for (String subject in subjects) DataColumn(label: Text(subject)),
            const DataColumn(label: Text("")),
          ],
          rows: _rows,
        ),
      ],
    );
  }

  List<DataRow> _createRows() {
    List<DataRow> rows = [];

    for (int i = 0; i < teacherNames.length; i++) {
      String teacher = teacherNames[i];
      rows.add(DataRow(cells: [
        DataCell(Text(teacher)),
        // Sample enrollment year
        for (int i = 0; i < subjects.length; i++)
          DataCell(
            Container(
              color: teacherSubjectMap[teacher]![i]
                  ? Colors.green
                  : Theme.of(context).scaffoldBackgroundColor,
              child: const SizedBox(
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),
        DataCell(IconButton(
          icon: const Icon(Icons.remove),
          onPressed: () {
            if (mounted) {
              setState(() {
                _deleteRow(i);
              });
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
              decoration: const InputDecoration(hintText: '指导教师姓名'),
            ),
          ),
          for (int i = 0; i < subjects.length; i++)
            DataCell(
              Checkbox(
                value: _newTeacherSubjects[i],
                onChanged: (value) {
                  if (mounted) {
                    setState(() {
                      _newTeacherSubjects[i] = value!;
                    });
                  }
                },
              ),
            ),
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
