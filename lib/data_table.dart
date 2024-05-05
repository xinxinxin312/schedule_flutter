import 'package:flutter/material.dart';
import 'package:scheduling/database.dart';
import 'package:scheduling/group.dart';
import 'package:scheduling/teacher.dart';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class MyDataTable extends StatefulWidget {
  final Group group;
  final int year;
  const MyDataTable(this.group, this.year, {super.key});
  @override
  MyDataTableState createState() => MyDataTableState();
}

class MyDataTableState extends State<MyDataTable> {
  int numOfRows = 12;
  int numOfcols = 3;

  final List<List<String>> selectedItem = [];

  @override
  void initState() {
    super.initState();
    List<List<String>> generatedList = List.generate(numOfRows, (index) {
      return List.generate(numOfcols, (index) => ""); // initialze all to ""
    });
    selectedItem.addAll(generatedList);
  }

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: createColumns(),
      rows: createRows(),
    );
  }

  List<DataColumn> createColumns() {
    List<DataColumn> columns = [];
    columns.add(const DataColumn(label: Text("月份")));
    columns.add(const DataColumn(label: Text("专业")));
    columns.add(const DataColumn(label: Text("指导教师")));

    return columns;
  }

  List<DataRow> createRows() {
    List<DataRow> rows = [];
    List<int> months = List.generate(12, (index) => index + 1);

    // create a new row
    for (int month in months) {
      List<DataCell> cells = [];
      cells.add(DataCell(Text("$month")));
      int rowIndex = month - 1;
      int colIndex = 1;
      cells.add(createDataCell(
          Subject.values.map((e) => e.chinese).toList(), rowIndex, colIndex));

      colIndex = 2;
      cells.add(createDataCell(
          Database.teachers.map((e) => e.name.toString()).toList(),
          rowIndex,
          colIndex));

      rows.add(DataRow(cells: cells));
    }

    return rows;
  }

  DataCell createDataCell(List<String> optionList, rowIndex, colIndex) {
    return DataCell(
      DropdownButton<String>(
        value: selectedItem[rowIndex][colIndex],
        onChanged: (String? newValue) {
          setState(() {
            selectedItem[rowIndex][colIndex] = newValue ?? "";
          });
        },
        items: optionList.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}
