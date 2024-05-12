import 'package:hive/hive.dart';
import 'package:scheduling/consts/hive_consts.dart';

part 'teacher.g.dart';
@HiveType(typeId: teacherTypeId)
class Teacher extends HiveObject {
   @HiveField(0)
  final String name;
   @HiveField(1)
  final List<String> subjects;
  Teacher(this.name, List<String> subjects) : subjects = List.from(subjects)..add("");
}
