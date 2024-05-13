import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:scheduling/models/group.dart';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:scheduling/models/teacher.dart';

import '../consts/hive_consts.dart';

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

// TODO maybe one box for all the tables
  late final Box<List<String>> subjectBox;
  late final List<String> subjects;

  // late final String teacherNameBoxName;
  // late final Box<String> teacherNameBox;

  late final List<Teacher> teachers;
  late final Box<Teacher> teachersBox;

  /// {$year$groupid, map<month, [subject, teacher]>}
  late final Box<Map<dynamic, dynamic>> scheduleBox;

  /// map<month, [subject, teacher]>
  late final Map<int, List<String>> schedules;
  final subjectIndex = 0; // [subject, teacher]
  final teacherIndex = 1;
  late final List<DataColumn> columns;
  late final List<DataRow> rows;
  List<String> selectedTeacher = List<String>.filled(12, '');

  @override
  void initState() {
    super.initState();
    year = widget.year;
    groupId = widget.group.id;
    initBoxs();
    columns = createColumns();
    rows = createRows();
  }

  void initBoxs() {
    scheduleBox = Hive.box(scheduleBoxName);
    String scheduleKey = "$year$groupId";
    schedules = scheduleBox.containsKey(scheduleKey)
        ? scheduleBox.get(scheduleKey,
            defaultValue: <int, List<String>>{})!.cast<int, List<String>>()
        : {};

    teachersBox = Hive.box(teachersBoxName);
    teachers = teachersBox.values.toList();
    subjectBox = Hive.box(subjectBoxName);
    subjects = subjectBox.get(subjectsBoxKey) ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: columns,
      rows: createRows(),
    );
  }

  @override
  void dispose() {
    disposeBoxs();
    super.dispose();
  }

  Future disposeBoxs() async {
    scheduleBox.put("$year$groupId", schedules.cast<int, List<String>>());
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
      rows.add(createRow(rowIndex));
    }

    return rows;
  }

  DataRow createRow(int rowIndex) {
    int month = rowIndex + 1;

    List<DataCell> cells = [];
    cells.add(DataCell(Text("$month")));
    int colIndex = 1;
    cells.add(createDataCell(subjects.toSet(), rowIndex, colIndex));
    colIndex = 2;
    var availableTeachers = findAvailableTeachers(month);
    cells.add(createDataCell(availableTeachers, rowIndex, colIndex));

    return DataRow(cells: cells);
  }

  DataCell createDataCell(Set<String> optionList, int rowIndex, int colIndex) {
    Set<String> optionSet = optionList.toSet();

    String value;
    int month = rowIndex + 1;
    if (colIndex == 1) {
      value =
          (schedules.containsKey(month) ? schedules[month]![subjectIndex] : "");
    } else {
      value =
          (schedules.containsKey(month) ? schedules[month]![teacherIndex] : "");
    }
    //log("selcted value: $value");
    optionSet.add("");
    if (!optionSet.contains(value)) {
      log("optionset ${optionSet.toString()} doesnt contains value $value");
      value = "";
      //optionSet.add(value);
    }
    optionSet.add("");
    log("optionSet: $optionSet");
    log("selcted value: $value");
    
    return DataCell(
      DropdownButton<String>(
        value: value,
        onChanged: (String? newValue) {
          int month = rowIndex + 1;
          String nonNullNewValue = newValue ?? "";

          if (colIndex == 1) {
            onSubjectChanged(nonNullNewValue, month);
          } else {
            onTeacherChanged(nonNullNewValue, month);
          }
          setState(() {});
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

  void onSubjectChanged(String newSubject, int month) {
    if (schedules.containsKey(month)) {
      schedules[month]![subjectIndex] = newSubject;
      log("selected new subject: ${schedules[month]![subjectIndex]} => $newSubject");
    } else {
      // it was emtpy
      schedules[month] = [newSubject, ""];
    }
    log("new subject for month# $month ${schedules[month]}");

    //TODO update teacher's options
    scheduleBox.put("$year$groupId", schedules);
  }

  void onTeacherChanged(String newTeacher, int month) {
    if (schedules.containsKey(month)) {
      schedules[month]![teacherIndex] = newTeacher;
      log("selected new teacher: ${schedules[month]![teacherIndex]} => $newTeacher");
    } else {
      // it was emtpy
      schedules[month] = ["", newTeacher];
    }
    log("new teacher for month# $month ${schedules[month]}");
    selectedTeacher[month - 1] = newTeacher;
    scheduleBox.put("$year$groupId", schedules);
  }

  /// find all teachers that are free in this month in this year
  Set<String> findAvailableTeachers(int month) {
    Set<String> qualifiedTeachers = teachers
        .where((teacher) => teacher.subjects.contains(
            (schedules.containsKey(month)
                ? schedules[month]![subjectIndex]
                : '')))
        .map((e) => e.name.toString())
        .toSet();
    log("all qualified teachers: ${qualifiedTeachers.toString()}");

    Set<dynamic> scheduleBoxKeys = scheduleBox.keys.toSet();
    String currentKey = "$year$groupId";
    scheduleBoxKeys.remove(currentKey);

    List<Map<int, List<String>>> allYearSchedules = [];
    for (String key in scheduleBoxKeys) {
      if (key.startsWith("$year")) {
        allYearSchedules.add(scheduleBox.get(key)!.cast());
      }
    }
    log("all year schedules: ${allYearSchedules.toString()}");

    Set<String> unavailableTeachers = {};
    for (var schedule in allYearSchedules) {
      if (schedule.containsKey(month)) {
        log("${schedule[month]![subjectIndex]} should be taught by ${schedule[month]![teacherIndex]}");
        unavailableTeachers.add(schedule[month]![teacherIndex]);
      }
    }
    log("all unavailable teachers: ${unavailableTeachers.toString()}");

    qualifiedTeachers.removeAll(unavailableTeachers);
    qualifiedTeachers.add("");
    log("all available teachers: ${qualifiedTeachers.toString()}");

    return qualifiedTeachers;
  }
}
