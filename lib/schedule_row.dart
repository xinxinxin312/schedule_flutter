import "package:scheduling/teacher.dart";

class ScheduleRow {
  final int month;
  final Subject subject;
  final Teacher teacher;

  const ScheduleRow(this.month, this.subject, this.teacher);
}
