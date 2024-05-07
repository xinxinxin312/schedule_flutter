import 'student.dart';

class Group {
  final int startYear;
  final int groupNumber;
  final List<Student> students;
  final List<String> studentNames;
  final int id;
   Group(this.startYear, this.groupNumber, this.studentNames)
      : id = startYear * 10 + groupNumber,
        students = createStudents(studentNames, startYear, groupNumber);
}

List<Student> createStudents(
    List<String> studentNames, int startYear, int groupNumber) {
  List<Student> students = [];

  for (String name in studentNames) {
    students.add(Student(startYear, name, groupNumber));
  }
  return students;
}

//TODO: group management -- add new groups