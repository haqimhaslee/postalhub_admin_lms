// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:postalhub_admin_cms/pages/notification_tester/notification_tester.dart';

class CmsOthersWidgets extends StatefulWidget {
  const CmsOthersWidgets({super.key});

  @override
  State<CmsOthersWidgets> createState() => CmsOthersWidgetsState();
}

class CmsOthersWidgetsState extends State<CmsOthersWidgets> {
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
              'OTHERS',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
            )),
        Padding(
            padding: const EdgeInsets.only(
              top: 5,
              bottom: 15,
              left: 15,
              right: 15,
            ),
            child: Card(
                elevation: 0,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: Column(children: [
                  SizedBox.fromSize(
                    size: const Size(400, 55),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
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
                                        const notificationTester()));
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Developers Options",
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
                          onTap: () => showLicensePage(
                            context: context,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Licenses",
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
                          onTap: () {},
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "GitHub Resources",
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
                ]))),
      ],
    );
  }
}
