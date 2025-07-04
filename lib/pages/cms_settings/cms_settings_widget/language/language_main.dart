import 'package:flutter/material.dart';

class LanguageMain extends StatefulWidget {
  const LanguageMain({super.key});
  @override
  State<LanguageMain> createState() => _LanguageMainState();
}

class _LanguageMainState extends State<LanguageMain> {
  String selectedOption = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Language"),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 750,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 15, bottom: 2, right: 15),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                    child: Material(
                        color: Theme.of(context).colorScheme.surfaceVariant,
                        child: Padding(
                          padding: const EdgeInsets.all(0),
                          child: RadioListTile<String>(
                            title: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: const Text('English'),
                            ),
                            value: 'English',
                            groupValue: selectedOption,
                            onChanged: (value) {
                              setState(() {
                                selectedOption = value!;
                              });
                            },
                          ),
                        )),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 15, bottom: 2, right: 15),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(0),
                      topRight: Radius.circular(0),
                    ),
                    child: Material(
                        color: Theme.of(context).colorScheme.surfaceVariant,
                        child: Padding(
                          padding: const EdgeInsets.all(0),
                          child: RadioListTile<String>(
                              title: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                child: const Text('Bahasa Melayu'),
                              ),
                              value: 'Bahasa Melayu',
                              groupValue: selectedOption,
                              onChanged: null),
                        )),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 15, bottom: 2, right: 15),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(0),
                      topRight: Radius.circular(0),
                    ),
                    child: Material(
                        color: Theme.of(context).colorScheme.surfaceVariant,
                        child: Padding(
                          padding: const EdgeInsets.all(0),
                          child: RadioListTile<String>(
                              title: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                child: const Text('中文 (简体)'),
                              ),
                              value: '中文(简体)',
                              groupValue: selectedOption,
                              onChanged: null),
                        )),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 15, bottom: 2, right: 15),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(0),
                      topRight: Radius.circular(0),
                    ),
                    child: Material(
                        color: Theme.of(context).colorScheme.surfaceVariant,
                        child: Padding(
                          padding: const EdgeInsets.all(0),
                          child: RadioListTile<String>(
                              title: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                child: const Text('中文 (繁體)'),
                              ),
                              value: '中文(繁體)',
                              groupValue: selectedOption,
                              onChanged: null),
                        )),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 15, bottom: 2, right: 15),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25),
                    ),
                    child: Material(
                        color: Theme.of(context).colorScheme.surfaceVariant,
                        child: Padding(
                          padding: const EdgeInsets.all(0),
                          child: RadioListTile<String>(
                              title: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                child: const Text('தமிழ்'),
                              ),
                              value: 'தமிழ்',
                              groupValue: selectedOption,
                              onChanged: null),
                        )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
