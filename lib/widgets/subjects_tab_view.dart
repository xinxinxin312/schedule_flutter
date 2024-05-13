import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../consts/hive_consts.dart';

class SubjectsTab extends StatefulWidget {
  const SubjectsTab({super.key});
  @override
  SubjectsTabState createState() => SubjectsTabState();
}

class SubjectsTabState extends State<SubjectsTab> {
  late final List<String> subjects; // Initial subjects list
  final TextEditingController subjectController = TextEditingController();
  late final Box<List<String>> subjectBox;

  @override
  void initState() {
    super.initState();
    subjectBox = Hive.box(subjectBoxName);
    subjects = subjectBox.get(subjectsBoxKey) ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: ListView.builder(
              itemCount: subjects.length + 1,
              itemBuilder: (BuildContext context, int index) {
                if (index < subjects.length) {
                  return SizedBox(
                      width: 400,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: 200,
                            child: Text(subjects[index]),
                          ),
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () {
                              setState(() {
                                subjects.removeAt(index);
                              });
                            },
                          ),
                        ],
                      ));
                } else {
                  return SizedBox(
                      width: 400,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: 200,
                            child: TextField(
                              controller: subjectController,
                              decoration: const InputDecoration(
                                hintText: '添加专业',
                              ),
                            ),
                          ),
                          //const SizedBox(width: 10),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              setState(() {
                                String newSubject = subjectController.text;
                                if (newSubject.isNotEmpty) {
                                  subjects.add(newSubject);
                                  subjectController.clear();
                                }
                              });
                            },
                          ),
                        ],
                      ));
                }
              }),
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    subjectBox.put(subjectsBoxKey, subjects);
  }
}
