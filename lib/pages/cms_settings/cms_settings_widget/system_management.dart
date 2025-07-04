// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:postalhub_admin_cms/pages/cms_settings/management/admin_management.dart';
import 'package:postalhub_admin_cms/pages/cms_settings/management/branch_management.dart';
import 'package:postalhub_admin_cms/pages/cms_settings/management/user_management.dart';

class SystemManagementWidgets extends StatefulWidget {
  const SystemManagementWidgets({super.key});

  @override
  State<SystemManagementWidgets> createState() =>
      SystemManagementWidgetsState();
}

class SystemManagementWidgetsState extends State<SystemManagementWidgets> {
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
                            builder: (context) => const BranchManagement()));
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
      ListTile(
        title: const Text('Admin Management'),
        subtitle: const Text('View and change admin'),
        leading: const Icon(Icons.color_lens_rounded),
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AdminManagement()));
        },
      ),
      ListTile(
        title: const Text('User Management'),
        subtitle: const Text('View and change user'),
        leading: const Icon(Icons.color_lens_rounded),
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const UserManagement()));
        },
      ),
    ]);
  }
}
