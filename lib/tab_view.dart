import 'package:flutter/material.dart';
import 'package:scheduling/schedule_table.dart';

class TabByYear extends StatelessWidget {
  const TabByYear({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(
                text: "2021",
              ),
              Tab(
                text: "2022",
              ),
              Tab(
                text: "2023",
              ),
            ],
          ),
          title: const Text('超声科规培排班表'),
        ),
        body: const TabBarView(
          children: [
           PlutoGridExamplePage("2021"),
           PlutoGridExamplePage("2022"),
           PlutoGridExamplePage("2023"),
          ],
        ),
      ),
    );
  }
}
