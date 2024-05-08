import 'package:flutter/material.dart';
class TeachersTabView extends StatefulWidget {
  const TeachersTabView({super.key});

  @override
  TeachersTabViewState createState() => TeachersTabViewState();
}

class TeachersTabViewState extends State<TeachersTabView> {
  final List<String> subjects = [
    'Math',
    'Science',
    'History'
  ]; // Sample subjects
  List<String> teachers = ['Alice', 'Bob', 'Carol']; // Sample teachers
  final Map<String, List<bool>> teacherSubjectMap = {
    // Sample teacher-subject map where true indicates the teacher can teach the subject
    'Alice': [true, false, true],
    'Bob': [true, true, false],
    'Carol': [false, true, true],
  };
  final TextEditingController _newTeacherController = TextEditingController();
  List<bool> _newTeacherSubjects = [];

  @override
  void initState() {
    super.initState();
    _newTeacherSubjects = List.generate(subjects.length, (_) => false);
  }

  void _addTeacher() {
    String newTeacher = _newTeacherController.text.trim();
    if (newTeacher.isNotEmpty) {
      setState(() {
        teachers.add(newTeacher);
        teacherSubjectMap[newTeacher] = List.from(_newTeacherSubjects);
        _newTeacherController.clear();
        _newTeacherSubjects = List.generate(subjects.length, (_) => false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DataTable(
          columns: [
            const DataColumn(label: Text('Teachers')),
            for (String subject in subjects) DataColumn(label: Text(subject)),
          ],
          rows: [
            for (String teacher in teachers)
              DataRow(
                cells: [
                  DataCell(Text(teacher)),
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
                ],
              ),
            DataRow(
              cells: [
                DataCell(
                  TextField(
                    controller: _newTeacherController,
                    decoration:
                        const InputDecoration(hintText: 'Enter Teacher Name'),
                  ),
                ),
                for (int i = 0; i < subjects.length; i++)
                  DataCell(
                    Checkbox(
                      value: _newTeacherSubjects[i],
                      onChanged: (value) {
                        setState(() {
                          _newTeacherSubjects[i] = value!;
                        });
                      },
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

  @override
  void dispose() {
    _newTeacherController.dispose();
    super.dispose();
  }
}