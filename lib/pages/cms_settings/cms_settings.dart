// ignore_for_file: deprecated_member_use
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:postalhub_admin_cms/login_services/auth_page.dart';
import 'package:postalhub_admin_cms/pages/cms_settings/cms_settings_widget/appearance/appearance_main.dart';
import 'package:postalhub_admin_cms/pages/cms_settings/cms_settings_widget/branch_management.dart';
import 'package:postalhub_admin_cms/pages/cms_settings/cms_settings_widget/current_user_info.dart';
import 'package:postalhub_admin_cms/pages/cms_settings/cms_settings_widget/language/language_main.dart';
import 'package:postalhub_admin_cms/pages/cms_settings/cms_settings_widget/system_management.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class MyProfile extends StatefulWidget {
  const MyProfile({Key? key}) : super(key: key);

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  int? adminType;
  bool _isLoading = true;
  Future<void> logout() async {
    try {
      await AuthService.logout();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logged out')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  Future<void> _fetchAdminType() async {
    final user = auth.currentUser;
    if (user != null) {
      try {
        final snapshot = await _firestore
            .collection('adminManagement')
            .where('campusAdminEmail', isEqualTo: user.email)
            .get();

        if (snapshot.docs.isNotEmpty) {
          setState(() {
            adminType = snapshot.docs.first.get('adminType') as int;
          });
        }
      } catch (e) {
        print('Error fetching admin type: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${e.toString()}")),
        );
      } finally {
        setState(() {
          _isLoading = false; // Set loading to false after fetching or error
        });
      }
    } else {
      setState(() {
        _isLoading = false; // Handle the case where the user isn't logged in
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchAdminType();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading // Conditionally render based on loading state
        ? const Center(
            child: CircularProgressIndicator(
            year2023: false,
          ))
        : Material(
            // Add this
            child: ListView(
            children: [
              CurrentUserInfoWidgets(),
              //Branch Management || Only for operator level
              if (adminType != 1) BranchManagementWidgets() else Container(),
              //System Management || Only for Admin/IT level
              if (adminType != 2) SystemManagementWidgets() else Container(),

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
                      child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const AppearanceMain()));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(6),
                            child: ListTile(
                              title: const Text('Appearance'),
                              subtitle:
                                  const Text('Customize the app appearance'),
                              leading: const Icon(
                                Icons.color_lens_rounded,
                                size: 25,
                              ),
                              trailing: const Icon(Icons.chevron_right_rounded),
                            ),
                          )),
                    ),
                  )),
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
                      child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const LanguageMain()));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(6),
                            child: ListTile(
                              title: const Text('Language'),
                              subtitle:
                                  const Text('Customize the app language'),
                              leading: const Icon(
                                Icons.translate_rounded,
                                size: 25,
                              ),
                              trailing: const Icon(Icons.chevron_right_rounded),
                            ),
                          )),
                    ),
                  )),

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
                      child: InkWell(
                          onTap: () {},
                          child: Padding(
                            padding: const EdgeInsets.all(6),
                            child: ListTile(
                              title: const Text('Policies'),
                              subtitle:
                                  const Text('View Terms and Privacy Policy'),
                              leading: const Icon(
                                Icons.developer_board_rounded,
                                size: 25,
                              ),
                              trailing: const Icon(Icons.chevron_right_rounded),
                            ),
                          )),
                    ),
                  )),
              Padding(
                  padding:
                      const EdgeInsets.only(left: 15, bottom: 2, right: 15),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(),
                    child: Material(
                      color: Theme.of(context).colorScheme.surfaceVariant,
                      child: InkWell(
                          onTap: () => showLicensePage(
                                context: context,
                                applicationName: 'Postal Hub LMS',
                              ),
                          child: Padding(
                            padding: const EdgeInsets.all(6),
                            child: ListTile(
                              title: const Text('Licences'),
                              subtitle: const Text('View open source licences'),
                              leading: const Icon(
                                Icons.description_outlined,
                                size: 25,
                              ),
                              trailing: const Icon(Icons.chevron_right_rounded),
                            ),
                          )),
                    ),
                  )),
              Padding(
                  padding:
                      const EdgeInsets.only(left: 15, bottom: 2, right: 15),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(),
                    child: Material(
                      color: Theme.of(context).colorScheme.surfaceVariant,
                      child: InkWell(
                          onTap: () {},
                          child: Padding(
                            padding: const EdgeInsets.all(6),
                            child: ListTile(
                              title: const Text('Release Updates'),
                              subtitle: const Text('View release updates'),
                              leading: const Icon(
                                Icons.update_rounded,
                                size: 25,
                              ),
                              trailing: const Icon(Icons.chevron_right_rounded),
                            ),
                          )),
                    ),
                  )),
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
                      child: InkWell(
                          onTap: () {},
                          child: Padding(
                            padding: const EdgeInsets.all(6),
                            child: ListTile(
                              title: const Text('About'),
                              subtitle:
                                  const Text('Learn more about Postal Hub'),
                              leading: const Icon(
                                Icons.info_rounded,
                                size: 25,
                              ),
                              trailing: const Icon(Icons.chevron_right_rounded),
                            ),
                          )),
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.only(top: 15),
              ),
              Padding(
                  padding:
                      const EdgeInsets.only(left: 15, bottom: 2, right: 15),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25),
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                    child: Material(
                      color: Theme.of(context).colorScheme.errorContainer,
                      child: InkWell(
                          onTap: logout,
                          child: Padding(
                            padding: const EdgeInsets.all(6),
                            child: ListTile(
                              title: Text(
                                'Sign Out',
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onErrorContainer,
                                ),
                              ),
                              leading: Icon(
                                Icons.logout_rounded,
                                size: 25,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onErrorContainer,
                              ),
                            ),
                          )),
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.only(top: 15),
              ),
            ],
          ));
  }
}
