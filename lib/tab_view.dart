import 'package:flutter/material.dart';
import 'package:scheduling/data_table.dart';
import 'package:scheduling/database.dart';
import 'package:scheduling/group.dart';
import 'package:scheduling/schedule_table.dart';

class TabByYear extends StatelessWidget {
  const TabByYear({super.key});
  final List<int> years = const [2021, 2022, 2023, 2024];

  @override
  Widget build(BuildContext context) {
    //final List<PlutoGridExamplePage> pages = [];
    final List<NestedTab1> subTabs = [];
    final List<Tab> tabs = [];

    for (int year in years) {
      tabs.add(Tab(text: "$year "));
      subTabs.add(NestedTab1(year));
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
          children: subTabs,
        ),
      ),
    );
  }
}

final List<Group> groups = Database.groups;

class NestedTab1 extends StatelessWidget {
  final int year;
  const NestedTab1(this.year, {super.key});

  @override
  Widget build(BuildContext context) {
    final List<Tab> tabs = [];
    final List<NestedTab2> subTabs = [];
    final List<int> uniqueStartYears =
        groups.map((group) => group.startYear).toSet().toList();

    for (int startYear in uniqueStartYears) {
      if (startYear <= year) {
        tabs.add(Tab(text: '入学年份 $startYear'));
        List<Group> filteredGroups =
            groups.where((group) => group.startYear == year).toList();
        subTabs.add(NestedTab2(filteredGroups, year));
      }
    }
    return DefaultTabController(
      length: tabs.length, // Number of nested tabs
      child: Scaffold(
        appBar: AppBar(
          //title: const Text('Nested Tab 1'),
          bottom: TabBar(
            tabs: tabs,
          ),
        ),
        body: TabBarView(
          children: subTabs,
        ),
      ),
    );
  }
}

class NestedTab2 extends StatelessWidget {
  final List<Group> groups;
  final int year;
  const NestedTab2(this.groups, this.year, {super.key});

  @override
  Widget build(BuildContext context) {
    final List<Tab> tabs = []; // one tab for each group
    final List<MyDataTable> tables = [];
    for (Group group in groups) {
      tabs.add(Tab(text: '第${group.groupNumber}组'));
      tables.add(MyDataTable(group, year));
    }

    return DefaultTabController(
        length: tabs.length, // Number of nested tabs
        child: Scaffold(
          appBar: AppBar(
            // title: const Text('Nested Tab 1'),
            bottom: TabBar(
              tabs: tabs,
            ),
          ),
          body: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height -
                  kToolbarHeight -
                  kBottomNavigationBarHeight -
                  MediaQuery.of(context).padding.top,
              // Adjust the height as needed based on your layout
              child: TabBarView(children: tables),
            ),
          ),
        ));
  }
}
