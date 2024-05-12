import 'package:hive/hive.dart';
import 'package:scheduling/consts/hive_consts.dart';
part 'group.g.dart';

@HiveType(typeId: groupTypeId)
class Group extends HiveObject {
  @HiveField(0)
  final int startYear;
  final int endYear; // duration is 3 years
  // TODO startMonth // endMonth
  @HiveField(1)
  final int groupNumber;
  @HiveField(2)
  final List<String> studentNames;
  @HiveField(3)
  final int id;

  Group(this.startYear, this.groupNumber, this.studentNames)
      : id = startYear * 10 + groupNumber,
        endYear = startYear + 3;
}
