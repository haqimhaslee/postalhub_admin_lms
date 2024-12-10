// ignore_for_file: deprecated_member_use
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:postalhub_admin_cms/login_services/auth_page.dart';
import 'package:postalhub_admin_cms/pages/cms_settings/cms_settings_widget/branch_management.dart';
import 'package:postalhub_admin_cms/pages/cms_settings/cms_settings_widget/current_user_info.dart';
import 'package:postalhub_admin_cms/pages/cms_settings/cms_settings_widget/help_support.dart';
import 'package:postalhub_admin_cms/pages/cms_settings/cms_settings_widget/others.dart';
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
        // Handle error, e.g., show a SnackBar
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
        ? const Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.all(10),
            child: ListView(
              children: [
                Container(
                    color: const Color.fromARGB(0, 255, 255, 255),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(children: [
                            CurrentUserInfoWidgets(),
                            //Branch Management || Only for operator level
                            if (adminType != 1)
                              BranchManagementWidgets()
                            else
                              Container(),
                            //System Management || Only for Admin/IT level
                            if (adminType != 2)
                              SystemManagementWidgets()
                            else
                              Container(),
                            HelpSupportWidgets(),
                            CmsOthersWidgets(),
                            Padding(
                                padding: const EdgeInsets.only(
                                  top: 5,
                                  bottom: 15,
                                  left: 15,
                                  right: 15,
                                ),
                                child: Card(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .errorContainer,
                                  elevation: 0,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                  ),
                                  child: SizedBox.fromSize(
                                    size: const Size(400, 55),
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        bottomRight: Radius.circular(15),
                                        bottomLeft: Radius.circular(15),
                                        topLeft: Radius.circular(15),
                                        topRight: Radius.circular(15),
                                      ),
                                      child: Material(
                                        color: const Color.fromARGB(
                                            0, 255, 193, 7),
                                        child: InkWell(
                                          //splashColor:Color.fromARGB(255, 191, 217, 255),
                                          onTap: logout,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                "Sign Out",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w900,
                                                  fontSize: 13,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onErrorContainer,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )),
                            const Text(
                              " ",
                              style: TextStyle(
                                  fontSize: 10, fontWeight: FontWeight.w300),
                            )
                          ]),
                        ]))
              ],
            ),
          );
  }
}
