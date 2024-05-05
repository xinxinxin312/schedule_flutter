import 'package:flutter/material.dart';
import 'package:scheduling/group.dart';
import 'package:scheduling/schedule_table.dart';

class TabByYear extends StatelessWidget {
  const TabByYear({super.key});
  final List<int> years = const [2021, 2022, 2023, 2024];

  @override
  Widget build(BuildContext context) {
    final List<PlutoGridExamplePage> pages = [];
    final List<Tab> tabs = [];
    for (int year in years) {
      for (Group group in groups) {
        if (group.startYear <= year) {
          tabs.add(Tab(text: "$year ${group.id}"));
          pages.add(PlutoGridExamplePage(group, year));
        }
      }
    }

    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: tabs,
          ),
          title: const Text('超声科规培排班表'),
        ),
        body: TabBarView(
          children: pages,
        ),
      ),
    );
  }

  // List<PlutoGridExamplePage> createPlutoPages() {
  //   List<PlutoGridExamplePage> pages = [];
  //   for (int year in years) {
  //     for (Group group in groups) {
  //       if (group.startYear <= year) {
  //         pages.add(PlutoGridExamplePage(group, year));
  //       }
  //     }
  //   }
  //   return pages;
  // }
}
