import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdatesInfoAt extends StatefulWidget {
  const UpdatesInfoAt({super.key});

  @override
  State<UpdatesInfoAt> createState() => _UpdatesInfoAtState();
}

class _UpdatesInfoAtState extends State<UpdatesInfoAt> {
  // Stream to listen to Firestore collection updates, ordered by date
  final Stream<QuerySnapshot> _updatesStream = FirebaseFirestore.instance
      .collection('version_update_info')
      .orderBy('ver_date',
          descending: true) // Order by 'ver_date' in descending order
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Release updates'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(0.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: _updatesStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;

                // Convert Timestamp to DateTime and format as a string
                Timestamp timestamp = data['ver_date'];
                DateTime dateTime = timestamp.toDate();
                String formattedDate =
                    DateFormat('dd-MM-yyyy').format(dateTime);

                return Padding(
                  padding: const EdgeInsets.only(
                    top: 0,
                    left: 25,
                    right: 25,
                    bottom: 0,
                  ),
                  child: Card(
                    color:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                    elevation: 0,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 0,
                        left: 25,
                        right: 25,
                        bottom: 20,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 20,
                              left: 5,
                              right: 5,
                              bottom: 20,
                            ),
                            child: Text(
                              formattedDate,
                              style: const TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 5,
                              right: 5,
                            ),
                            child: MarkdownBody(
                              onTapLink: (text, href, title) {
                                if (href != null) {
                                  launchUrl(Uri.parse(href));
                                }
                              },
                              data: data['ver_info']?.replaceAll(r'\n', '\n') ??
                                  'No Content',
                              styleSheet: MarkdownStyleSheet.fromTheme(
                                Theme.of(context),
                              ),
                              softLineBreak:
                                  true, // Ensures soft line breaks are handled
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}
