// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:postalhub_admin_cms/pages/cms_settings/management/branch/branch_info_settings.dart';

class BranchManagementWidgets extends StatefulWidget {
  const BranchManagementWidgets({super.key});

  @override
  State<BranchManagementWidgets> createState() =>
      BranchManagementWidgetsState();
}

class BranchManagementWidgetsState extends State<BranchManagementWidgets> {
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
              'BRANCH MANAGEMENT',
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
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15),
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
                                        const BranchInfoSettings()));
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Branch Info Settings",
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
