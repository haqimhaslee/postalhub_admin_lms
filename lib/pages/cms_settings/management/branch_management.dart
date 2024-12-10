import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BranchManagement extends StatefulWidget {
  const BranchManagement({super.key});
  @override
  State<BranchManagement> createState() => _BranchManagementState();
}

class _BranchManagementState extends State<BranchManagement> {
  final _formKey = GlobalKey<FormState>();
  final _campusCodeController = TextEditingController();
  final _campusNameController = TextEditingController();
  final _campusDomainController = TextEditingController();
  TimeOfDay? _selectedOpenTime;
  TimeOfDay? _selectedCloseTime;
  bool _isOpen = false; // Initial open status

  void _showAddBranchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Branch'),
          content: StatefulBuilder(
            // Use StatefulBuilder to manage internal state
            builder: (context, setState) {
              return SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    // Wrap with SingleChildScrollView
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        TextFormField(
                          controller: _campusNameController,
                          decoration:
                              const InputDecoration(labelText: 'Campus Name'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter campus name';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _campusCodeController,
                          decoration:
                              const InputDecoration(labelText: 'Campus Code'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter campus code';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _campusDomainController,
                          decoration:
                              const InputDecoration(labelText: 'Campus Domain'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter campus domain';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        CheckboxListTile(
                          title: const Text("Open status"),
                          value: _isOpen,
                          onChanged: (value) {
                            setState(() {
                              _isOpen = value!;
                            });
                          },
                        ),
                        // Open Time Picker
                        ListTile(
                          title: const Text("Open Time"),
                          trailing: _selectedOpenTime == null
                              ? null
                              : Text(_selectedOpenTime!.format(context)),
                          onTap: () async {
                            final TimeOfDay? picked = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            if (picked != null) {
                              setState(() => _selectedOpenTime = picked);
                            }
                          },
                        ),
                        // Close Time Picker
                        ListTile(
                          title: const Text("Closing Time"),
                          trailing: _selectedCloseTime == null
                              ? null
                              : Text(_selectedCloseTime!.format(context)),
                          onTap: () async {
                            final TimeOfDay? picked = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            if (picked != null) {
                              setState(() => _selectedCloseTime = picked);
                            }
                          },
                        ),

                        const SizedBox(height: 20),
                        const Text("Instruction 1"),
                        const Text("Instruction 2"),
                        const Text("Instruction 3"),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
                _clearTextControllers();
                _resetTimeAndStatus(); // Reset time and status
              },
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  FirebaseFirestore.instance
                      .collection('branchManagement')
                      .add({
                    'campusCode': _campusCodeController.text,
                    'campusName': _campusNameController.text,
                    'campusDomain': _campusDomainController.text,
                    'openStatus': _isOpen, // Add open status
                    'openTime':
                        _selectedOpenTime?.format(context), // Add open time
                    'closingTime':
                        _selectedCloseTime?.format(context), // Add close time
                  });

                  Navigator.of(context).pop();
                  _clearTextControllers();
                  _resetTimeAndStatus(); // Reset time and status after adding
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Branch added successfully')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _clearTextControllers() {
    _campusCodeController.clear();
    _campusNameController.clear();
    _campusDomainController.clear();
  }

  void _resetTimeAndStatus() {
    _selectedOpenTime = null;
    _selectedCloseTime = null;
    _isOpen = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Branch Management"),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddBranchDialog(context),
        label: Text("Add branch"),
        icon: Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('branchManagement')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No branches found.'));
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
                      title: Text(
                          data['campusName'] ?? 'N/A'), // Handle null values
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Campus Code: ${data['campusCode'] ?? 'N/A'}'),
                          Text(
                              'Campus Domain: ${data['campusDomain'] ?? 'N/A'}'),
                          Text(
                              'Operating time: ${data['openTime'] ?? 'N/A'} to ${data['closingTime'] ?? 'N/A'}'),
                          Row(
                            children: [
                              Text("Status: "),
                              data['openStatus'] == true
                                  ? Text("OPEN")
                                  : Text("CLOSE")
                            ],
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Confirm Delete"),
                                content: const Text(
                                    "Are you sure you want to delete this branch?"),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text("Cancel"),
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(); // Dismiss dialog
                                    },
                                  ),
                                  TextButton(
                                    child: const Text("Delete"),
                                    onPressed: () async {
                                      try {
                                        await document.reference.delete();
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  'Branch deleted successfully')),
                                        );
                                        Navigator.of(context)
                                            .pop(); // Dismiss dialog
                                      } catch (e) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              content: Text(
                                                  'Error deleting branch: $e')),
                                        );
                                        Navigator.of(context)
                                            .pop(); // Dismiss dialog even if error
                                      }
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
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
