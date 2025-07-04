// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:postalhub_admin_cms/main.dart';
// adjust this path

class AppearanceMain extends StatefulWidget {
  const AppearanceMain({super.key});
  @override
  State<AppearanceMain> createState() => _AppearanceMainState();
}

class _AppearanceMainState extends State<AppearanceMain> {
  String selectedOption = 'Auto';

  @override
  void initState() {
    super.initState();
    final mode = themeManager.value;
    selectedOption = switch (mode) {
      ThemeMode.light => 'Light',
      ThemeMode.dark => 'Dark',
      _ => 'Auto',
    };
  }

  void _onThemeChanged(String? value) {
    if (value == null) return;
    setState(() => selectedOption = value);
    final mode = switch (value) {
      'Light' => ThemeMode.light,
      'Dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
    themeManager.setTheme(mode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Appearance"),
        ),
        body: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 750),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15, bottom: 2, right: 15),
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25),
                          ),
                          child: Material(
                              color:
                                  Theme.of(context).colorScheme.surfaceVariant,
                              child: Padding(
                                padding: const EdgeInsets.all(0),
                                child: RadioListTile<String>(
                                  title: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 8, 0, 0),
                                    child: const Text('Light'),
                                  ),
                                  subtitle: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 0, 8),
                                    child: const Text(
                                      'Use light mode',
                                    ),
                                  ),
                                  value: 'Light',
                                  groupValue: selectedOption,
                                  onChanged: _onThemeChanged,
                                ),
                              )),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15, bottom: 2, right: 15),
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(0),
                            topRight: Radius.circular(0),
                          ),
                          child: Material(
                              color:
                                  Theme.of(context).colorScheme.surfaceVariant,
                              child: Padding(
                                padding: const EdgeInsets.all(0),
                                child: RadioListTile<String>(
                                  title: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 8, 0, 0),
                                    child: const Text('Dark'),
                                  ),
                                  subtitle: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 0, 8),
                                    child: const Text(
                                      'Use dark mode.',
                                    ),
                                  ),
                                  value: 'Dark',
                                  groupValue: selectedOption,
                                  onChanged: _onThemeChanged,
                                ),
                              )),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15, bottom: 2, right: 15),
                        child: ClipRRect(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(25),
                              bottomRight: Radius.circular(25),
                            ),
                            child: Material(
                              color:
                                  Theme.of(context).colorScheme.surfaceVariant,
                              child: RadioListTile<String>(
                                title: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 8, 0, 0),
                                  child: const Text('Use device settings'),
                                ),
                                subtitle: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 8),
                                  child: const Text(
                                    'Apply the same theme set on your device to the app.',
                                  ),
                                ),
                                value: 'Auto',
                                groupValue: selectedOption,
                                onChanged: _onThemeChanged,
                              ),
                            )),
                      ),
                    ]))));
  }
}
