import 'package:flutter/material.dart';
import 'package:scheduling/app_bar.dart';
import 'package:scheduling/widgets/data_table.dart';
import 'package:scheduling/database.dart';
import 'package:scheduling/models/group.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  final List<int> years = const [2021, 2022, 2023, 2024];

  @override
  Widget build(BuildContext context) {
    final List<TabByStartYear> subTabs = [];
    /// tabs by year
    final List<Tab> tabs = [];

    for (int year in years) {
      tabs.add(Tab(text: "$year "));
      subTabs.add(TabByStartYear(year));
    }
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: MyAppBar(
          bottom: TabBar(
            tabs: tabs,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
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

class TabByStartYear extends StatelessWidget {
  final int year;
  const TabByStartYear(this.year, {super.key});

  @override
  Widget build(BuildContext context) {
    final List<Tab> tabs = [];
    final List<TabByGroup> subTabs = [];
    final List<int> uniqueStartYears =
        groups.map((group) => group.startYear).toSet().toList();

    for (int startYear in uniqueStartYears) {
      if (startYear <= year) {
        tabs.add(Tab(text: '入学年份 $startYear'));
        List<Group> filteredGroups =
            groups.where((group) => group.startYear == year).toList();
        subTabs.add(TabByGroup(filteredGroups, year));
      }
    }
    return DefaultTabController(
      length: tabs.length, // Number of nested tabs
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TabBar(
                tabs: tabs,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
              ),
            ],
          ),
          backgroundColor: const Color.fromARGB(255, 31, 29, 29),
        ),
        body: TabBarView(
          children: subTabs,
        ),
      ),
    );
  }
}

class TabByGroup extends StatelessWidget {
  final List<Group> groups;
  final int year;
  const TabByGroup(this.groups, this.year, {super.key});

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
            flexibleSpace: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TabBar(
                  tabs: tabs,
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                ),
              ],
            ),
            backgroundColor: const Color.fromARGB(255, 31, 30, 30),
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
