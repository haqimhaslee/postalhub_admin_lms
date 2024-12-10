// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CurrentUserInfoWidgets extends StatefulWidget {
  const CurrentUserInfoWidgets({super.key});

  @override
  State<CurrentUserInfoWidgets> createState() => CurrentUserInfoWidgetsState();
}

class CurrentUserInfoWidgetsState extends State<CurrentUserInfoWidgets> {
  String? _userEmail;
  String? _campusBranchName;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _userEmail = user.email;
      });

      try {
        final snapshot = await FirebaseFirestore.instance
            .collection('adminManagement')
            .where('campusAdminEmail', isEqualTo: _userEmail)
            .limit(1)
            .get();

        if (snapshot.docs.isNotEmpty) {
          setState(() {
            _campusBranchName = snapshot.docs.first.get('campusBranchName');
          });
        } else {
          // Handle case where no matching document is found
          print('No matching document found for email: $_userEmail');
          // You might want to set a default value or show an error message.
          setState(() {
            _campusBranchName = 'Not Found';
          });
        }
      } catch (e) {
        print('Error fetching user data: $e');
        setState(() {
          _campusBranchName = 'Error';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
            padding: const EdgeInsets.only(
              top: 15,
              left: 10,
              right: 10,
              bottom: 7.5,
            ),
            child: Card(
              elevation: 0,
              child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Padding(
                        padding: const EdgeInsets.only(
                          top: 15,
                          left: 15,
                          right: 10,
                          bottom: 15,
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Padding(
                                    padding: const EdgeInsets.only(
                                      top: 0,
                                      left: 10,
                                      right: 10,
                                      bottom: 0,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Logged in as :-",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 13,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSecondaryContainer,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.email_rounded,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSecondaryContainer,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              "${_userEmail ?? 'Loading...'}",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSecondaryContainer,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.apartment_rounded,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSecondaryContainer,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              "${_campusBranchName ?? 'Loading...'}",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSecondaryContainer,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ))
                              ],
                            ),
                          ],
                        )),
                  )),
            )),
      ],
    );
  }
}
