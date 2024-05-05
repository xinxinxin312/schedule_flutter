import 'package:scheduling/group.dart';
import 'package:scheduling/student.dart';
import 'package:scheduling/teacher.dart';

class Database {
  static List<Student> students = [
    const Student(2022, "李海宇", 1),
    const Student(2022, "卢思源", 2),
    const Student(2023, "马琳", 1),
    const Student(2023, "魏依卓", 1),
    const Student(2023, "王献", 2),
    const Student(2023, "赵凯月", 3),
    const Student(2023, "张远洋", 3)
  ];

  static List<Teacher> teachers = [
    const Teacher("樊琪", [Subject.belly, Subject.heart]),
    const Teacher("赵连蒙", [Subject.xinzangfuchan, Subject.pufangweichang]),
    const Teacher("谢丹", [Subject.emergency, Subject.puwai]),
    const Teacher("张禄桐", [Subject.fangshe, Subject.fubujieru]),

  ];

  static List<Group> groups = [];
}
