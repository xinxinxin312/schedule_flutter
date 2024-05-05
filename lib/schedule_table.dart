import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:scheduling/database.dart';
import 'package:scheduling/teacher.dart';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class PlutoGridExamplePage extends StatefulWidget {
  final String year;
  const PlutoGridExamplePage(this.year, {super.key});

  @override
  State<PlutoGridExamplePage> createState() => _PlutoGridExamplePageState();
}

class _PlutoGridExamplePageState extends State<PlutoGridExamplePage> {
  final String subjectBoxName = "subjectBox";
  late final Box<String> subjectBox;

  final String teacherBoxName = "teacherBox";
  late final Box<String> teacherBox;
  @override
  void initState() {
    super.initState();
    subjectBox = Hive.box(subjectBoxName);
    teacherBox = Hive.box(teacherBoxName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.year} 第一组"),
      ),
      body: Container(
        padding: const EdgeInsets.all(30),
        child: PlutoGrid(
            columns: columns,
            rows: createPlutoRows(),
            onChanged: (PlutoGridOnChangedEvent event) {
              // print(event);
              // print("event.columnIdx: ${event.columnIdx}");
              // print("event.rowIdx: ${event.rowIdx}");
              // print("event.value.toString(): ${event.value.toString()}");

              if (event.columnIdx == 1) {
                subjectBox.put(event.rowIdx + 1, event.value.toString());
              }

              else if (event.columnIdx == 2) {
                teacherBox.put(event.rowIdx + 1, event.value.toString());
              }
            },
            onLoaded: (PlutoGridOnLoadedEvent event) {
              //print(event);
            }),
      ),
    );
  }

  List<PlutoColumn> columns = [
    /// Text Column definition
    PlutoColumn(
      title: 'month',
      field: 'month_field',
      type: PlutoColumnType.number(),
    ),

    /// Number Column definition
    PlutoColumn(
      title: '专业',
      field: 'subject_field',
      type:
          PlutoColumnType.select(Subject.values.map((e) => e.chinese).toList()),
    ),

    /// Select Column definition
    PlutoColumn(
      title: '指导教师',
      field: 'teacher_field',
      type:
          PlutoColumnType.select(Database.teachers.map((e) => e.name).toList()),
    ),
  ];

  List<PlutoRow> createPlutoRows() {
    List<int> months = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
    List<PlutoRow> rows = [];
    for (int month in months) {
      PlutoRow newRow = PlutoRow(
        cells: {
          'month_field': PlutoCell(value: month),
          'subject_field': PlutoCell(
              value: subjectBox.containsKey(month)
                  ? subjectBox.get(month)
                  : "null"),
          'teacher_field': PlutoCell(
              value: teacherBox.containsKey(month)
                  ? teacherBox.get(month)
                  : "null"),
        },
      );
      rows.add(newRow);
    }
    return rows;
  }
}
