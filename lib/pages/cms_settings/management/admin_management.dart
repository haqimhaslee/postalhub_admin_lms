import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminManagement extends StatefulWidget {
  const AdminManagement({super.key});
  @override
  State<AdminManagement> createState() => _AdminManagementState();
}

class _AdminManagementState extends State<AdminManagement> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _selectedCampusName;
  String? _branchCode; // Store the branch code
  List<String> _campusNames = []; // List to store campus names

  @override
  void initState() {
    super.initState();
    _fetchCampusNames();
  }

  Future<void> _fetchCampusNames() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('branchManagement').get();

      setState(() {
        _campusNames =
            snapshot.docs.map((doc) => doc['campusName'] as String).toList();
      });
    } catch (e) {
      print('Error fetching campus names: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching campus names: $e')),
      );
    }
  }

  Future<void> _createAdminAccount() async {
    try {
      // 1. Create User in Authentication
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text);

      // 2. Save Admin Data to Firestore
      await FirebaseFirestore.instance.collection('adminManagement').add({
        'campusAdminEmail': _emailController.text,
        'campusBranchName': _selectedCampusName, // Save selected campus name
        'campusBranchCode': _branchCode, // Save branch code
        'adminType': 2, // Default to Administration
        'uid': userCredential.user!.uid, // Store the UID
      });

      // ... (rest of your code for clearing fields and showing success message)
    } on FirebaseAuthException {
      // ... (error handling)
    } catch (e) {
      // ... (error handling)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Management"),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Create Admin Account"),
                content: SingleChildScrollView(
                  // Wrap with SingleChildScrollView
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                              labelText: 'Email (with @postalhub.web.app)'),
                        ),
                        // Password
                        TextField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration:
                              const InputDecoration(labelText: 'Password'),
                        ),
                        // Dropdown for Campus Name
                        DropdownButtonFormField<String>(
                          decoration:
                              const InputDecoration(labelText: 'Campus Name'),
                          value: _selectedCampusName,
                          items: _campusNames.map((campusName) {
                            return DropdownMenuItem<String>(
                              value: campusName,
                              child: Text(campusName),
                            );
                          }).toList(),
                          onChanged: (value) async {
                            _selectedCampusName = value;

                            // Fetch and update branch code based on selected campus
                            try {
                              QuerySnapshot snapshot = await FirebaseFirestore
                                  .instance
                                  .collection('branchManagement')
                                  .where('campusName', isEqualTo: value)
                                  .get();
                              if (snapshot.docs.isNotEmpty) {
                                setState(() {
                                  _branchCode = snapshot
                                      .docs.first['campusCode'] as String?;
                                });
                              }
                            } catch (e) {
                              print("Error fetching branch code: $e");
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content:
                                        Text('Error fetching branch code: $e')),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("Cancel")),
                  TextButton(
                    onPressed: _createAdminAccount,
                    child: const Text("Create"),
                  ),
                ],
              );
            },
          );
        },
        label: Text("Create Admin account"),
        icon: Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('adminManagement')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No admin found.'));
          }

          return Padding(
              padding: const EdgeInsets.only(
                top: 5,
                bottom: 15,
                left: 20,
                right: 20,
              ),
              child: ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot document = snapshot.data!.docs[index];
                  final data = document.data() as Map<String, dynamic>;

                  return Card(
                    child: ListTile(
                      title: Text(data['campusAdminEmail'] ??
                          'N/A'), // Handle null values
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              'Branch Name: ${data['campusBranchName'] ?? 'N/A'}'),
                          Text(
                              'Branch Code: ${data['campusBranchCode'] ?? 'N/A'}'),
                          Row(
                            children: [
                              Text("Admin Type: "),
                              data['adminType'] == 2
                                  ? Text("Operator")
                                  : Text("Administration")
                            ],
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {},
                      ),
                    ),
                  );
                },
              ));
        },
      ),
    );
  }
}
