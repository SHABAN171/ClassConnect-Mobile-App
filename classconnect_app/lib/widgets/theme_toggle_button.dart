import 'package:flutter/material.dart';

import '../services/theme_controller.dart';

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key, required this.themeController});

  final ThemeController themeController;

  IconData _iconFor(ThemeMode mode) => switch (mode) {
    ThemeMode.system => Icons.brightness_auto,
    ThemeMode.light => Icons.light_mode,
    ThemeMode.dark => Icons.dark_mode,
  };

  String _labelFor(ThemeMode mode) => switch (mode) {
    ThemeMode.system => 'System',
    ThemeMode.light => 'Light',
    ThemeMode.dark => 'Dark',
  };

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeController,
      builder: (context, mode, _) {
        return PopupMenuButton<ThemeMode>(
          icon: Icon(_iconFor(mode)),
          tooltip: 'Theme',
          onSelected: themeController.setThemeMode,
          itemBuilder: (context) => ThemeMode.values
              .map(
                (m) => PopupMenuItem(
                  value: m,
                  child: Row(
                    children: [
                      Icon(_iconFor(m)),
                      const SizedBox(width: 12),
                      Text(_labelFor(m)),
                      if (m == mode) ...[
                        const Spacer(),
                        const Icon(Icons.check, size: 18),
                      ],
                    ],
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }
}
