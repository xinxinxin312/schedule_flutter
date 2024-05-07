import 'package:scheduling/models/subject.dart';

class Teacher {
  final String name;
  final List<Subject> subjects;
  Teacher(this.name, List<Subject> subjects) : subjects = List.from(subjects)..add(Subject.empty);
}
