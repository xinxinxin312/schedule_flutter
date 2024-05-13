import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '/app_bar.dart';
import '/consts/hive_consts.dart';
import '/widgets/schedule_data_table.dart';
import '/models/group.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  late final List<Group> groups;
  late final Box<Group> groupBox;
  @override
  void initState() {
    super.initState();
    groupBox = Hive.box(groupBoxName);
    groups = groupBox.values.toList();
  }

  @override
  Widget build(BuildContext context) {
    final List<TabByStartYear> subTabs = [];
    List<int> years = _getMeaningfulYears(groups);

    /// tabs by year
    final List<Tab> tabs = [];

    for (int year in years) {
      tabs.add(Tab(text: "$year "));
      subTabs.add(TabByStartYear(year, groups));
    }
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: CustomAppBar(
          bottom: TabBar(
            tabs: tabs,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
          ),
          title: '超声科规培排班表',
        ),
        body: TabBarView(
          children: subTabs,
        ),
      ),
    );
  }

  List<int> _getMeaningfulYears(List<Group> groups) {
    Set<int> years = {};

    for (Group group in groups) {
      Set<int> duration = {};
      for (int i = group.startYear; i <= group.endYear; i++) {
        duration.add(i);
      }
      years.addAll(duration);
    }
    List<int> yearsList = years.toList();
    yearsList.sort();

    return yearsList;
  }
}

class TabByStartYear extends StatelessWidget {
  final int year;
  final List<Group> groups;
  const TabByStartYear(this.year, this.groups, {super.key});

  @override
  Widget build(BuildContext context) {
    final List<Tab> tabs = [];
    final List<TabByGroup> subTabs = [];
    final List<int> uniqueStartYears =
        groups.map((group) => group.startYear).toSet().toList();

    for (int startYear in uniqueStartYears) {
      if (startYear <= year && startYear + 2 >= year) {
        tabs.add(Tab(text: '入学年份 $startYear'));
        List<Group> filteredGroups =
            groups.where((group) => group.startYear == startYear).toList();
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
    // List<Widget> tables = [];
    groups.sort(((a, b) => a.groupNumber - b.groupNumber));
    for (Group group in groups) {
      tabs.add(Tab(text: '第${group.groupNumber}组'));
      tables.add(MyDataTable(group, year));
      // tables.add(Text("dfkjsl"));
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
