import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:scheduling/database.dart';
import 'package:scheduling/teacher.dart';

class PlutoGridExamplePage extends StatefulWidget {
  final String year;
  const PlutoGridExamplePage(this.year, {super.key});

  @override
  State<PlutoGridExamplePage> createState() => _PlutoGridExamplePageState();
}

class _PlutoGridExamplePageState extends State<PlutoGridExamplePage> {
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
            rows: rows,
            onChanged: (PlutoGridOnChangedEvent event) {
              print(event);
            },
            onLoaded: (PlutoGridOnLoadedEvent event) {
              print(event);
            }),
      ),
    );
  }

  List<PlutoColumn> columns = [
    /// Text Column definition
    PlutoColumn(
      title: 'months',
      field: 'text_field',
      type: PlutoColumnType.number(),
    ),

    /// Number Column definition
    PlutoColumn(
      title: '专业',
      field: 'number_field',
      type: PlutoColumnType.select(Subject.values.map((e) => e.chinese).toList()),
    ),

    /// Select Column definition
    PlutoColumn(
      title: '指导教师',
      field: 'select_field',
      type:
          PlutoColumnType.select(Database.teachers.map((e) => e.name).toList()),
    ),
  ];

  List<PlutoRow> rows = [
    PlutoRow(
      cells: {
        'text_field': PlutoCell(value: 1),
        'number_field': PlutoCell(),
        'select_field': PlutoCell(),
        'date_field': PlutoCell(),
        'time_field': PlutoCell(),
      },
    ),
    PlutoRow(
      cells: {
        'text_field': PlutoCell(value: 2),
        'number_field': PlutoCell(),
        'select_field': PlutoCell(),
        'date_field': PlutoCell(),
        'time_field': PlutoCell(),
      },
    ),
    PlutoRow(
      cells: {
        'text_field': PlutoCell(value: 3),
        'number_field': PlutoCell(),
        'select_field': PlutoCell(),
        'date_field': PlutoCell(),
        'time_field': PlutoCell(),
      },
    ),
    PlutoRow(
      cells: {
        'text_field': PlutoCell(value: 4),
        'number_field': PlutoCell(),
        'select_field': PlutoCell(),
        'date_field': PlutoCell(),
        'time_field': PlutoCell(),
      },
    ),
    PlutoRow(
      cells: {
        'text_field': PlutoCell(value: 5),
        'number_field': PlutoCell(),
        'select_field': PlutoCell(),
        'date_field': PlutoCell(),
        'time_field': PlutoCell(),
      },
    ),
    PlutoRow(
      cells: {
        'text_field': PlutoCell(value: 6),
        'number_field': PlutoCell(),
        'select_field': PlutoCell(),
        'date_field': PlutoCell(),
        'time_field': PlutoCell(),
      },
    ),
    PlutoRow(
      cells: {
        'text_field': PlutoCell(value: 7),
        'number_field': PlutoCell(),
        'select_field': PlutoCell(),
        'date_field': PlutoCell(),
        'time_field': PlutoCell(),
      },
    ),
    PlutoRow(
      cells: {
        'text_field': PlutoCell(value: 8),
        'number_field': PlutoCell(),
        'select_field': PlutoCell(),
        'date_field': PlutoCell(),
        'time_field': PlutoCell(),
      },
    ),
    PlutoRow(
      cells: {
        'text_field': PlutoCell(value: 9),
        'number_field': PlutoCell(),
        'select_field': PlutoCell(),
        'date_field': PlutoCell(),
        'time_field': PlutoCell(),
      },
    ),
    PlutoRow(
      cells: {
        'text_field': PlutoCell(value: 10),
        'number_field': PlutoCell(),
        'select_field': PlutoCell(),
        'date_field': PlutoCell(),
        'time_field': PlutoCell(),
      },
    ),
    PlutoRow(
      cells: {
        'text_field': PlutoCell(value: 11),
        'number_field': PlutoCell(),
        'select_field': PlutoCell(),
        'date_field': PlutoCell(),
        'time_field': PlutoCell(),
      },
    ),
    PlutoRow(
      cells: {
        'text_field': PlutoCell(value: 12),
        'number_field': PlutoCell(),
        'select_field': PlutoCell(),
        'date_field': PlutoCell(),
        'time_field': PlutoCell(),
      },
    ),
  ];
}
