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

  Future<void> _updateOperatingTimesAndStatus(
      TimeOfDay? newOpenTime, TimeOfDay? newClosingTime) async {
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
        if (newClosingTime != null) {
          updates['closingTime'] = DateFormat('h:mm a').format(
              DateTime(2023, 1, 1, newClosingTime.hour, newClosingTime.minute));
        }

        await FirebaseFirestore.instance
            .collection('branchManagement')
            .doc(docId)
            .update(updates);

        setState(() {
          if (newOpenTime != null) {
            _openTime = updates['openTime'];
          }
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
            ? const Center(child: CircularProgressIndicator())
            : Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Padding(
                        padding: EdgeInsets.only(
                          top: 20,
                          bottom: 5,
                        ),
                        child: Text(
                          'BRANCH',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w800),
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
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
                                    color: Theme.of(context)
                                        .colorScheme
                                        .surfaceContainerHigh,
                                    child: InkWell(
                                      onTap: () {},
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            _campusName ?? "N/A",
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
                    const Padding(
                        padding: EdgeInsets.only(
                          top: 5,
                          bottom: 5,
                        ),
                        child: Text(
                          'STATUS',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w800),
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
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
                                    color: Theme.of(context)
                                        .colorScheme
                                        .surfaceContainerHigh,
                                    child: InkWell(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title:
                                                  const Text("Change Status"),
                                              content: const Text(
                                                  "Are you sure you want to change the open status?"),
                                              actions: <Widget>[
                                                TextButton(
                                                  child: const Text("Cancel"),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                                TextButton(
                                                  child: const Text("Change"),
                                                  onPressed: () {
                                                    _updateOpenStatus(
                                                        !(_openStatus ??
                                                            false));
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            _openStatus == true
                                                ? "Open"
                                                : "Closed",
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
                    const Padding(
                        padding: EdgeInsets.only(top: 5, bottom: 5, left: 20),
                        child: Text(
                          'OPERATING TIME',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w800),
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
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
                                    color: Theme.of(context)
                                        .colorScheme
                                        .surfaceContainerHigh,
                                    child: InkWell(
                                      onTap: () async {
                                        final TimeOfDay? newOpenTime =
                                            await showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now(),
                                        );
                                        final TimeOfDay? newClosingTime =
                                            await showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now(),
                                        );

                                        if (newOpenTime != null ||
                                            newClosingTime != null) {
                                          _updateOperatingTimesAndStatus(
                                              newOpenTime, newClosingTime);
                                        }
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            "Open Time : ${_openTime ?? "--"}",
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
                                    bottomLeft: Radius.circular(15),
                                    bottomRight: Radius.circular(15),
                                  ),
                                  child: Material(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .surfaceContainerHigh,
                                    child: InkWell(
                                      onTap: () async {
                                        final TimeOfDay? newOpenTime =
                                            await showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now(),
                                        );
                                        final TimeOfDay? newClosingTime =
                                            await showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now(),
                                        );

                                        if (newOpenTime != null ||
                                            newClosingTime != null) {
                                          _updateOperatingTimesAndStatus(
                                              newOpenTime, newClosingTime);
                                        }
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            "Closing Time : ${_closingTime ?? "--"}",
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
                ),
              ));
  }
}
