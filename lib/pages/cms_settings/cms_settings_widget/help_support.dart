// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:postalhub_admin_cms/pages/cms_settings/cms_settings_widget/others/updates_info_at.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpSupportWidgets extends StatefulWidget {
  const HelpSupportWidgets({super.key});

  @override
  State<HelpSupportWidgets> createState() => HelpSupportWidgetsState();
}

Future<void> _launchUrl(String url) async {
  if (!await launchUrl(Uri.parse(url))) {
    throw Exception('Could not launch $url');
  }
}

class HelpSupportWidgetsState extends State<HelpSupportWidgets> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Padding(
            padding: EdgeInsets.only(
              top: 5,
              bottom: 5,
            ),
            child: Text(
              'HELP & SUPPORT',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
            )),
        Padding(
            padding: const EdgeInsets.only(
              top: 5,
              left: 15,
              right: 15,
              bottom: 10,
            ),
            child: Card(
              elevation: 0,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              child: Column(
                children: [
                  SizedBox.fromSize(
                    size: const Size(400, 55),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(15),
                        topLeft: Radius.circular(15),
                      ),
                      child: Material(
                        color:
                            Theme.of(context).colorScheme.surfaceContainerHigh,
                        child: InkWell(
                          onTap: () =>
                              _launchUrl('https://forms.gle/fqQoFRbx4GHY8oUx9'),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Unified Support Services",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox.fromSize(
                    size: const Size(400, 55),
                    child: ClipRRect(
                      child: Material(
                        color:
                            Theme.of(context).colorScheme.surfaceContainerHigh,
                        child: InkWell(
                          onTap: () => _launchUrl(
                              'https://www.termsfeed.com/live/9187d68f-f1e8-4d89-921f-f8432437ba97'),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Security Policy",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox.fromSize(
                    size: const Size(400, 55),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(15),
                        bottomLeft: Radius.circular(15),
                      ),
                      child: Material(
                        color:
                            Theme.of(context).colorScheme.surfaceContainerHigh,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const UpdatesInfoAt()));
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Update Info",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }
}
