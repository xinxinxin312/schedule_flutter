import 'package:scheduling/models/group.dart';
// import 'package:scheduling/student.dart';
import 'package:scheduling/models/teacher.dart';
import 'package:scheduling/models/subject.dart';

class Database {
  // static List<Student> students = [
  //   const Student(2022, "李海宇", 1),
  //   const Student(2022, "卢思源", 2),
  //   const Student(2023, "马琳", 1),
  //   const Student(2023, "魏依卓", 1),
  //   const Student(2023, "王献", 2),
  //   const Student(2023, "赵凯月", 3),
  //   const Student(2023, "张远洋", 3)
  // ];

  static List<Teacher> teachers = [
    Teacher("", Subject.values),
    Teacher("范洁", [Subject.xueguan, Subject.heart]),
    Teacher("施群", [Subject.fuchan, Subject.heart]),
    Teacher("郑桂霞", [Subject.fuchan, Subject.heart, Subject.jidong]),
    Teacher(
        "樊琪", [Subject.fuchan, Subject.heart, Subject.belly, Subject.xiaoer]),
    Teacher("赵连蒙",
        [Subject.xinzangfuchan, Subject.pufangweichang, Subject.qianbiao]),
    Teacher("谢丹", [Subject.qianbiao, Subject.belly]),
    Teacher("张禄桐", [Subject.heart, Subject.xueguan, Subject.qianbiao]),
    Teacher("秦悦洋", [Subject.belly, Subject.heart]),
    Teacher("刘霞", [Subject.belly, Subject.heart]),
    Teacher("李娜", [Subject.qianbiao, Subject.heart]),
    Teacher("张丹丹", [
      Subject.xueguan,
      Subject.xiaoer,
      Subject.qianbiao,
      Subject.fuchan,
      Subject.xinzangfuchan
    ]),
    Teacher("姜晓龙",
        [Subject.jidong, Subject.jieru, Subject.belly, Subject.fubujieru]),
  ];

  static List<Group> groups = [
    Group(2021, 1, ["刘月"]),
    Group(2021, 2, ["焦雪倩", "唐先辉"]),
    Group(2021, 3, ["张来鑫"]),
    Group(2022, 1, ["李海宇", "王雪"]),
    Group(2022, 2, ["卢思源", "刘金荣"]),
    Group(2022, 3, ["张媛媛", "于世秀"]),
    Group(2022, 4, ["夏昕", "徐欢"]),
    Group(2023, 1, ["马琳", "魏依卓"]),
    Group(2023, 2, ["王献", "王朗润"]),
    Group(2023, 3, ["赵凯月", "张远洋"]),
    Group(2023, 4, ["王朗润"]),
  ];
}
