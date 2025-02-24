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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15, bottom: 0, top: 20),
          child: Text(
            "Branch Management",
            style: TextStyle(
              fontSize: 15,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        ListTile(
          title: const Text('Branch Info'),
          subtitle: const Text('View and change branch info'),
          leading: const Icon(Icons.domain_rounded),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const BranchInfoSettings()));
          },
        ),
      ],
    );
  }
}
