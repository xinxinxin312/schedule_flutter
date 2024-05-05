import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:scheduling/database.dart';
import 'package:scheduling/group.dart';

import 'tab_view.dart';

void main() async {
  await Hive.initFlutter();
  const List<int> years = [2021, 2022, 2023, 2024];

  for (int year in years) {
    for (Group group in Database.groups) {
      int groupId = group.id;
      await Hive.openBox<String>("$year${groupId}subjectBox");
      await Hive.openBox<String>("$year${groupId}teacherBox");
    }
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
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
      home: const TabByYear(),
    );
  }
}
