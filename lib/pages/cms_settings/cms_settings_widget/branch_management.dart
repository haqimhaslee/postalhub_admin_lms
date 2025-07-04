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
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.only(top: 15),
      ),
      Padding(
          padding: const EdgeInsets.only(left: 15, bottom: 2, right: 15),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25),
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
            child: Material(
              color: Theme.of(context).colorScheme.surfaceVariant,
              child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const BranchInfoSettings()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: ListTile(
                      title: const Text('Branch Info'),
                      subtitle: const Text('View and change branch info'),
                      leading: const Icon(
                        Icons.domain_rounded,
                        size: 25,
                      ),
                      trailing: const Icon(Icons.chevron_right_rounded),
                    ),
                  )),
            ),
          )),
    ]);
  }
}
