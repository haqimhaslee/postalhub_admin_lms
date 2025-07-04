// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BranchInfoSettings extends StatefulWidget {
  const BranchInfoSettings({super.key});
  @override
  State<BranchInfoSettings> createState() => _BranchInfoSettingsState();
}

class _BranchInfoSettingsState extends State<BranchInfoSettings> {
  String? _campusName;
  String? _openTime;
  String? _closingTime;
  bool? _openStatus;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchBranchData();
  }

  Future<void> _updateOpenOperatingTimes(
    TimeOfDay? newOpenTime,
  ) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return;
      }

      final querySnapshot = await FirebaseFirestore.instance
          .collection('branchManagement')
          .where('operatorEmail', isEqualTo: user.email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final docId = querySnapshot.docs.first.id;

        final updates = <String, dynamic>{};

        if (newOpenTime != null) {
          updates['openTime'] = DateFormat('h:mm a').format(
              DateTime(2023, 1, 1, newOpenTime.hour, newOpenTime.minute));
        }

        await FirebaseFirestore.instance
            .collection('branchManagement')
            .doc(docId)
            .update(updates);

        setState(() {
          if (newOpenTime != null) {
            _openTime = updates['openTime'];
          }
        });
      }
    } catch (e) {
      print("Error updating operating times: $e");
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating times: $e.toString()')));
    }
  }

  Future<void> _updateCloseOperatingTimes(TimeOfDay? newClosingTime) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return;
      }

      final querySnapshot = await FirebaseFirestore.instance
          .collection('branchManagement')
          .where('operatorEmail', isEqualTo: user.email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final docId = querySnapshot.docs.first.id;

        final updates = <String, dynamic>{};

        if (newClosingTime != null) {
          updates['closingTime'] = DateFormat('h:mm a').format(
              DateTime(2023, 1, 1, newClosingTime.hour, newClosingTime.minute));
        }

        await FirebaseFirestore.instance
            .collection('branchManagement')
            .doc(docId)
            .update(updates);

        setState(() {
          if (newClosingTime != null) {
            _closingTime = updates['closingTime'];
          }
        });
      }
    } catch (e) {
      print("Error updating operating times: $e");
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating times: $e.toString()')));
    }
  }

  Future<void> _updateOpenStatus(bool newStatus) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        // Handle user not signed in
        return;
      }

      final querySnapshot = await FirebaseFirestore.instance
          .collection('branchManagement')
          .where('operatorEmail', isEqualTo: user.email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final docId = querySnapshot.docs.first.id;
        await FirebaseFirestore.instance
            .collection('branchManagement')
            .doc(docId)
            .update({'openStatus': newStatus});

        setState(() {
          _openStatus = newStatus;
        });
      }
    } catch (e) {
      // Handle errors
      print('Error updating open status: $e');
      // Optionally show an error message to the user.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating status: $e.toString()')),
      );
    }
  }

  Future<void> _fetchBranchData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        // Handle the case where the user is not signed in
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final snapshot = await FirebaseFirestore.instance
          .collection('branchManagement')
          .where('operatorEmail', isEqualTo: user.email)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final branchData = snapshot.docs.first.data();
        setState(() {
          _campusName = branchData['campusName'] as String?;
          _openTime = branchData['openTime'] as String?;
          _closingTime = branchData['closingTime'] as String?;
          _openStatus = branchData['openStatus'] as bool?;
          _isLoading = false;
        });
      } else {
        // Handle the case where no branch data is found for the user
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      // Handle errors
      print('Error fetching branch data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Branch Info Settings"),
      ),
      body: _isLoading // Conditionally render based on loading state
          ? const Center(
              child: CircularProgressIndicator(
              year2023: false,
            ))
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                        bottomLeft: Radius.circular(25),
                        bottomRight: Radius.circular(25),
                      ),
                      child: Material(
                        color: Theme.of(context).colorScheme.surfaceVariant,
                        child: InkWell(
                            child: Padding(
                          padding: const EdgeInsets.all(6),
                          child: ListTile(
                            title: Text(
                              _campusName ?? "N/A",
                            ),
                            leading: const Icon(
                              Icons.domain_rounded,
                              size: 25,
                            ),
                            subtitle: Text(
                              _openStatus == true ? "Open" : "Closed",
                              style: TextStyle(
                                  color: _openStatus == true
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context).colorScheme.error),
                            ),
                            trailing: Switch(
                              value: _openStatus ?? false,
                              onChanged: (bool value) {
                                _updateOpenStatus(!(_openStatus ?? false));
                              },
                            ),
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
                            onTap: () async {
                              final TimeOfDay? newOpenTime =
                                  await showTimePicker(
                                helpText: "Select new opening time",
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );

                              if (newOpenTime != null) {
                                _updateOpenOperatingTimes(
                                  newOpenTime,
                                );
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(6),
                              child: ListTile(
                                title: Text(
                                  "Opening Time : ${_openTime ?? "--"}",
                                ),
                                subtitle: Text("Click to change opening time"),
                                leading: const Icon(Icons.schedule_rounded),
                                trailing:
                                    const Icon(Icons.chevron_right_rounded),
                              ),
                            )),
                      ),
                    )),
                Padding(
                    padding:
                        const EdgeInsets.only(left: 15, bottom: 2, right: 15),
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(25),
                        bottomLeft: Radius.circular(25),
                      ),
                      child: Material(
                        color: Theme.of(context).colorScheme.surfaceVariant,
                        child: InkWell(
                            onTap: () async {
                              final TimeOfDay? newClosingTime =
                                  await showTimePicker(
                                helpText: "Select new closing time",
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );

                              if (newClosingTime != null) {
                                _updateCloseOperatingTimes(newClosingTime);
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(6),
                              child: ListTile(
                                title: Text(
                                  "Closing Time : ${_closingTime ?? "--"}",
                                ),
                                subtitle: Text("Click to change closing time"),
                                leading: const Icon(Icons.schedule_rounded),
                                trailing:
                                    const Icon(Icons.chevron_right_rounded),
                              ),
                            )),
                      ),
                    )),
              ],
            ),
    );
  }
}
