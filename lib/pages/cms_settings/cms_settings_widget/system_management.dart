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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15, bottom: 0, top: 20),
          child: Text(
            "System Management",
            style: TextStyle(
              fontSize: 15,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        ListTile(
          title: const Text('Branch Management'),
          subtitle: const Text('View and change branch info'),
          leading: const Icon(Icons.color_lens_rounded),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const BranchManagement()));
          },
        ),
        ListTile(
          title: const Text('Admin Management'),
          subtitle: const Text('View and change admin'),
          leading: const Icon(Icons.color_lens_rounded),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AdminManagement()));
          },
        ),
        ListTile(
          title: const Text('User Management'),
          subtitle: const Text('View and change user'),
          leading: const Icon(Icons.color_lens_rounded),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const UserManagement()));
          },
        ),
      ],
    );
  }
}
