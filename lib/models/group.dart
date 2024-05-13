import 'package:flutter/rendering.dart';
import 'package:hive/hive.dart';
import 'package:scheduling/consts/hive_consts.dart';
part 'group.g.dart';

@HiveType(typeId: groupTypeId)
class Group extends HiveObject implements Comparable<Group> {
  @HiveField(0)
  final int startYear;
  // TODO startMonth // endMonth
  @HiveField(1)
  final int groupNumber;
  @HiveField(2)
  final List<String> studentNames;
  final int id;
  final int endYear; // duration is 3 years

  Group(this.startYear, this.groupNumber, this.studentNames)
      : id = startYear * 10 + groupNumber,
        endYear = startYear + 2;

  @override
  int compareTo(Group group) {
    if (startYear < group.startYear) {
      return -1;
    }
    if (startYear > group.startYear) {
      return 1;
    }
    if (groupNumber < group.groupNumber) {
      return -1;
    }
    if (groupNumber > group.groupNumber) {
      return 1;
    }
    return 0;
  }
}
