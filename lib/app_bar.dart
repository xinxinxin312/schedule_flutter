import 'package:flutter/material.dart';

class MyAppBar extends AppBar implements PreferredSizeWidget {
  MyAppBar({super.key, super.title, super.bottom})
      : super(
          actions: [
            IconButton(
              icon: const Icon(
                  Icons.navigate_before), // come back from settings page
              onPressed: () {
                // TODO Navigation button pressed
              },
            ),
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                // TODO Settings button pressed
              },
            ),
            const ExportPopupMenuButton(),
          ],
        );
}
class ExportPopupMenuButton extends StatelessWidget {
  const ExportPopupMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'export',
          child: Text('Export'),
        ),
        const PopupMenuItem<String>(
          value: 'export_all',
          child: Text('Export All'),
        ),
      ],
      onSelected: (String value) {
        if (value == 'export') {
          // TODO Implement export logic for single item
        } else if (value == 'export_all') {
          // TODO Implement export logic for all items
        }
      },
    );
  }
}