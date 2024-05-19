import 'package:flutter/material.dart';
import 'package:scheduling/screens/settings_screen.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  // final Color backgroundColor;
  final PreferredSizeWidget? bottom;
  const CustomAppBar({super.key, required this.title, this.bottom});
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      bottom: bottom,
      actions: [
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const SettingsScreen()));
          },
        ),
        const ExportPopupMenuButton(),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 50);
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
          // TODO Implement export logic for single table
        } else if (value == 'export_all') {
          // TODO Implement export logic for all tables
        }
      },
    );
  }
}
