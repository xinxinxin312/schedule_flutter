// import 'package:flutter/material.dart';
// import 'package:pluto_grid/pluto_grid.dart';
// import 'package:scheduling/database.dart';
// import 'package:scheduling/group.dart';
// import 'package:scheduling/teacher.dart';

// import 'package:hive/hive.dart';
// import 'package:hive_flutter/hive_flutter.dart';

// class PlutoGridExamplePage extends StatefulWidget {
//   final Group group;
//   final int year;
//   const PlutoGridExamplePage(this.group, this.year, {super.key});

//   @override
//   State<PlutoGridExamplePage> createState() => _PlutoGridExamplePageState();
// }

// class _PlutoGridExamplePageState extends State<PlutoGridExamplePage> {
//   late final Group group;
//   late final int groupNumber;
//   late final int groupId;
//   late final int year;

//   late final String subjectBoxName;
//   late final Box<String> subjectBox;

//   late final String teacherBoxName;
//   late final Box<String> teacherBox;

//   late PlutoGridStateManager stateManager;
//   @override
//   void initState() {
//     super.initState();
//     group = widget.group;
//     groupNumber = group.groupNumber;
//     groupId = group.id;
//     year = widget.year;
//     initBoxs();
//   }

//   void initBoxs() {
//     subjectBoxName = "$year${groupId}subjectBox";
//     teacherBoxName = "$year${groupId}teacherBox";

//     subjectBox = Hive.box(subjectBoxName);
//     teacherBox = Hive.box(teacherBoxName);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text("$year年 第${group.startYear}/$groupNumber组"),
//         ),
//         body: Container(
//           padding: const EdgeInsets.all(30),
//           child: PlutoGrid(
//               columns: columns,
//               rows: createPlutoRows(),
//               onChanged: (PlutoGridOnChangedEvent event) {
//                 // print(event);
//                 // print("event.columnIdx: ${event.columnIdx}");
//                 // print("event.rowIdx: ${event.rowIdx}");
//                 // print("event.value.toString(): ${event.value.toString()}");

//                 if (event.columnIdx == 1) {
//                   subjectBox.put(event.rowIdx + 1, event.value.toString());
//                 } else if (event.columnIdx == 2) {
//                   teacherBox.put(event.rowIdx + 1, event.value.toString());
//                 }
//               },
//               onLoaded: (PlutoGridOnLoadedEvent event) {
//                 //print(event);
//                 stateManager = event.stateManager;
//               },
//               onSelected: (event) {
//                   print(event);

//                   //TODO: filter the teachers that has the subject chosen in this row

//               },),
//         ));
//   }

//   List<PlutoColumn> columns = [
//     /// Text Column definition
//     PlutoColumn(
//       title: 'month',
//       field: 'month_field',
//       type: PlutoColumnType.number(),
//     ),

//     /// Number Column definition
//     PlutoColumn(
//       title: '专业',
//       field: 'subject_field',
//       type: PlutoColumnType.select(
//           Subject.values.map((subject) => subject.chinese).toList()),
//     ),

//     /// Select Column definition
//     PlutoColumn(
//       title: '指导教师',
//       field: 'teacher_field',
//       type: PlutoColumnType.select(
//           Database.teachers.map((teacher) => teacher.name).toList(),
//           enableColumnFilter: true),
//     ),
//   ];

//   List<PlutoRow> createPlutoRows() {
//     List<int> months = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
//     List<PlutoRow> rows = [];
//     for (int month in months) {
//       PlutoRow newRow = PlutoRow(
//         cells: {
//           'month_field': PlutoCell(value: month),
//           'subject_field': PlutoCell(
//               value: subjectBox.containsKey(month)
//                   ? subjectBox.get(month)
//                   : "null"),
//           'teacher_field': PlutoCell(
//               value: teacherBox.containsKey(month)
//                   ? teacherBox.get(month)
//                   : "null"),
//         },
//       );
//       rows.add(newRow);
//     }
//     return rows;
//   }
// }
