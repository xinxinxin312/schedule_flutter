import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:scheduling/consts/hive_consts.dart';
import 'package:scheduling/models/group.dart';
import 'package:scheduling/models/teacher.dart';
import 'package:scheduling/screens/home_screen.dart';

void main() async {
  await Hive.initFlutter();

  Hive.registerAdapter(GroupAdapter());
  Hive.registerAdapter(TeacherAdapter());

  Box<Group> groupBox = await Hive.openBox<Group>(groupBoxName);
  List<Group> groups = groupBox.values.toList();
  Box<Teacher> teachers = await Hive.openBox<Teacher>(teachersBoxName);
  Box<List<String>> subjects = await Hive.openBox<List<String>>(subjectBoxName);

  /// {$year$groupid, map<month, [subject, teacher]>}
  Box<Map<dynamic, dynamic>> schedules = await Hive.openBox<Map<dynamic, dynamic>>(scheduleBoxName);

  // for (Group group in groups) {
  //   for (int year = group.startYear; year <= group.endYear; year++) {
  //     int groupId = group.id;
  //     await Hive.openBox<String>("$year${groupId}subjectBox");
  //     await Hive.openBox<String>("$year${groupId}teacherBox");
  //   }
  // }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: 72,
            fontWeight: FontWeight.bold,
          ),
          titleLarge: TextStyle(
            fontSize: 30,
          ),
          titleMedium: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
          titleSmall: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
          bodyMedium: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.normal,
          ),
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
