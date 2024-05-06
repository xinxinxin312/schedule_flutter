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
  final int numOfRows = 12;
  final int numOfcols = 3;
  late final int year;
  late final int groupId;

  late final String subjectBoxName;
  late final Box<String> subjectBox;

  late final String teacherBoxName;
  late final Box<String> teacherBox;

  @override
  void initState() {
    super.initState();
    year = widget.year;
    groupId = widget.group.id;
    initBoxs();
  }

  void initBoxs() {
    subjectBoxName = "$year${groupId}subjectBox";
    teacherBoxName = "$year${groupId}teacherBox";

    subjectBox = Hive.box(subjectBoxName);
    teacherBox = Hive.box(teacherBoxName);
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
      // print(
      //     "selectedItem[rowIndex][colIndex]: ${selectedItem[rowIndex][colIndex]}");

      colIndex = 2;

      List<String> filteredTeachers = Database.teachers
          .where((teacher) => teacher.subjects.contains(findSubject(
              (subjectBox.containsKey(month) ? subjectBox.get(month) : '')!)))
          .map((e) => e.name.toString())
          .toList();

      // check availablility of the teacher
      // one teacher can only exist in 1 row in all the tables of this year
      List<String> removeList = [];

      for (Group group in Database.groups) {
        if (group.startYear <= year && group.id != groupId) {
          String boxName = "$year${group.id}teacherBox";
          for (String name in filteredTeachers) {
            Box<String> box = Hive.box(boxName);
            if (box.get(month) == name) {
              // this teacher is assigned to a group in this month already
              removeList.add(name);
              print(
                  "this teacher is assigned to a group in this month already");
            }
          }
        }
      }
      filteredTeachers.removeWhere((element) => removeList.contains(element));
      cells.add(createDataCell(filteredTeachers, rowIndex, colIndex));
      rows.add(DataRow(cells: cells));
    }

    return rows;
  }

  DataCell createDataCell(List<String> optionList, rowIndex, colIndex) {
   
 Set<String> optionSet = optionList.toSet();
    // if (!optionList.contains(selectedItem[rowIndex][colIndex])) {
    //   selectedItem[rowIndex][colIndex] = "";
    // }
    String value;
    int month = rowIndex + 1;
    if (colIndex == 1) {
      value = (subjectBox.containsKey(month) ? subjectBox.get(month) : "")!;
    } else {
      value = (teacherBox.containsKey(month) ? teacherBox.get(month) : "")!;
    }
    if (!optionSet.contains(value)) {
      value = "";
    }
    optionSet.add("");
    print("optionSet: $optionSet");
    return DataCell(
      DropdownButton<String>(
        value: value,
        onChanged: (String? newValue) {
          setState(() {
            // selectedItem[rowIndex][colIndex] = newValue ?? "";
            if (colIndex == 1 && newValue != null) {
              subjectBox.put(rowIndex + 1, newValue);
            } else if (colIndex == 2 && newValue != null) {
              teacherBox.put(rowIndex + 1, newValue);
            }
            // print(
            //     "update cell value: row$rowIndex col$colIndex = ${selectedItem[rowIndex][colIndex]}");
          });
        },
        items: optionSet.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}
