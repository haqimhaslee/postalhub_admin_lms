// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchUser extends StatefulWidget {
  const SearchUser({super.key});

  @override
  State<SearchUser> createState() => _SearchUserState();
}

final searchInput = TextEditingController();

class _SearchUserState extends State<SearchUser> {
  final _firestore = FirebaseFirestore.instance;
  String _searchTerm = '';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: TextField(
              controller: searchInput,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      searchInput.clear();
                    });
                  },
                  icon: const Icon(Icons.cancel),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                labelText: 'UID/Email/No Tel/Campus Email*',
              ),
            ),
          ),
          const Divider(),
          Expanded(
            child: _buildSearchResults(_searchTerm),
          ),
          FilledButton(
            onPressed: () => setState(() => _searchTerm = searchInput.text),
            child: const Center(
              child: Text(
                "Search User",
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(String searchTerm) {
    if (searchTerm.isEmpty) {
      return Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [const Text('Search user'), const Text('*Case sensitive')],
        ),
      );
    }

    return FutureBuilder<List<DocumentSnapshot<Map<String, dynamic>>>>(
      future: _performSearch(searchTerm),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final documents = snapshot.data ?? [];
        if (documents.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/gif/not_found.gif",
                ),
                const Text('No user found for that keyword.')
              ],
            ),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          itemCount: documents.length,
          itemBuilder: (context, index) {
            final data = documents[index].data()!;

            final firstName = data['firstName']?.toString() ?? '';
            final lastName = data['lastName']?.toString() ?? '';
            final email = data['email']?.toString() ?? '';
            final companyAddress = data['company_address']?.toString() ?? '';
            final companyEmail = data['company_email']?.toString() ?? '';
            final phoneNo = data['phone']?.toString() ?? '';

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20,
                ),
                const SizedBox(
                  height: 10,
                ),
                Card(
                  elevation: 0,
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 30, 30, 30),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'UID : ${data['unique_id']}',
                            ),
                            if (firstName.isNotEmpty && lastName.isNotEmpty)
                              Text(
                                'Username : $firstName $lastName',
                              ),
                            if (email.isNotEmpty)
                              Text(
                                'Email : $email',
                              ),
                            if (companyEmail.isNotEmpty)
                              Text(
                                'Campus Email : $companyEmail',
                              ),
                            if (companyAddress.isNotEmpty)
                              Text(
                                'Campus Table/Office/Room Address : $companyAddress',
                              ),
                            if (phoneNo.isNotEmpty)
                              Text(
                                'Phone. No : $phoneNo',
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 1, 20, 1),
                ),
                Card(
                  elevation: 0,
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      const SizedBox(
                        height: 6,
                      )
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<List<DocumentSnapshot<Map<String, dynamic>>>> _performSearch(
      String searchTerm) async {
    final results1 = await _firestore
        .collection('client_user')
        .where('unique_id', isEqualTo: searchTerm)
        .get();

    final results2 = await _firestore
        .collection('client_user')
        .where('email', isEqualTo: searchTerm)
        .get();

    final results3 = await _firestore
        .collection('client_user')
        .where('company_id', isEqualTo: searchTerm)
        .get();

    final results4 = await _firestore
        .collection('client_user')
        .where('company_email', isEqualTo: searchTerm)
        .get();
    final results5 = await _firestore
        .collection('client_user')
        .where('phone', isEqualTo: searchTerm)
        .get();

    final allResults = [
      ...results1.docs,
      ...results2.docs,
      ...results3.docs,
      ...results4.docs,
      ...results5.docs,
    ];

    // Remove duplicates by tracking document IDs
    final uniqueResults =
        {for (var doc in allResults) doc.id: doc}.values.toList();

    return uniqueResults;
  }
}
