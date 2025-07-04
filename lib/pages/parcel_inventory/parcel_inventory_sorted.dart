// ignore_for_file: deprecated_member_use
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:postalhub_admin_cms/pages/parcel_inventory/parcel_inventory_detail.dart';
import 'package:visibility_detector/visibility_detector.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class ParcelInventorySorted extends StatefulWidget {
  const ParcelInventorySorted({super.key});
  @override
  State<ParcelInventorySorted> createState() => _ParcelInventorySortedState();
}

class _ParcelInventorySortedState extends State<ParcelInventorySorted> {
  DocumentSnapshot? _lastDocument;
  bool _hasMore = true;
  final int _limit = 9;
  List<DocumentSnapshot> _documents = [];
  late ScrollController _scrollController;
  String? campusCode;

  Future<void> _fetchCampusCode() async {
    final user = auth.currentUser;
    if (user != null) {
      try {
        final snapshot = await _firestore
            .collection('adminManagement')
            .where('campusAdminEmail', isEqualTo: user.email)
            .get();

        if (snapshot.docs.isNotEmpty) {
          setState(() {
            campusCode = snapshot.docs.first.get('campusCode') as String;
            _fetchMoreData(); // Fetch data after campusCode is retrieved
          });
        }
      } catch (e) {
        print('Error fetching admin type: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${e.toString()}")),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchCampusCode();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        _hasMore &&
        campusCode != null) {
      // Check if campusCode is available
      _fetchMoreData();
    }
  }

  Future<void> _fetchMoreData() async {
    if (!_hasMore || campusCode == null)
      return; // Exit if no more data or campusCode is null

    Query query = FirebaseFirestore.instance
        .collection('parcelInventory')
        .where('warehouse', isEqualTo: campusCode) // Filter by warehouse
        .where('status', isEqualTo: 1) // Filter by status
        .orderBy('timestamp_arrived_sorted', descending: true)
        .limit(_limit);

    if (_lastDocument != null) {
      query = query.startAfterDocument(_lastDocument!);
    }

    try {
      final snapshot = await query.get();
      setState(() {
        _documents.addAll(snapshot.docs);
        _lastDocument = snapshot.docs.isNotEmpty ? snapshot.docs.last : null;
        _hasMore = snapshot.docs.length == _limit;
      });
    } catch (e) {
      print('Error fetching data: $e');
      // Handle error (e.g., show a snackbar)
    }
  }

  @override
  Widget build(BuildContext context) {
    return campusCode ==
            null // Show loading indicator while fetching campusCode
        ? const Center(
            child: CircularProgressIndicator(
            year2023: false,
          ))
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _documents.isEmpty // Show message if no parcels found
                    ? const Center(child: Text("No parcels found."))
                    : ListView.builder(
                        controller: _scrollController,
                        itemCount: _documents.length,
                        itemBuilder: (context, index) {
                          final data = _documents[index].data();
                          if (data is Map<String, dynamic>) {
                            return MyListItemWidget(
                                data: data, docId: _documents[index].id);
                          } else {
                            return const SizedBox();
                          }
                        },
                      ),
              )
            ],
          );
  }
}

// ... (MyListItemWidget remains unchanged)

class MyListItemWidget extends StatefulWidget {
  final Map<String, dynamic> data;
  final String docId;

  const MyListItemWidget({super.key, required this.data, required this.docId});

  @override
  State<MyListItemWidget> createState() => _MyListItemWidgetState();
}

class _MyListItemWidgetState extends State<MyListItemWidget> {
  bool _mounted = false;

  @override
  void initState() {
    super.initState();
    _mounted = true;
  }

  @override
  void dispose() {
    _mounted = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final trackingID1 = widget.data['trackingId1'];

    final remarks = widget.data['remarks'] ?? 'No remarks';
    final status = widget.data['status'];
    final parcelCategory = widget.data['parcelCategory'] ?? 1;

    return VisibilityDetector(
      key: Key(widget.data['trackingId1']),
      onVisibilityChanged: (visibilityInfo) {
        if (_mounted) {
          setState(() {});
        }
      },
      child: Column(
        children: [
          Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: Card(
                elevation: 0,
                color: Theme.of(context).colorScheme.surfaceVariant,
                child: Column(
                  children: [
                    SizedBox(
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        child: Material(
                          color: const Color.fromARGB(0, 96, 125, 139),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailPage(
                                      data: widget.data, docId: widget.docId),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                              child: Row(
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                    child: Container(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('Track No 1: $trackingID1'),
                                          Text('Remarks: $remarks'),
                                          Row(
                                            children: [
                                              _buildStatusWidget(
                                                  context, status),
                                              _buildCategoryWidget(
                                                  context, parcelCategory),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ))
        ],
      ),
    );
  }

  Widget _buildStatusWidget(BuildContext context, int status) {
    switch (status) {
      case 2:
        return _statusContainer(
            context, 'On-Delivery', Colors.blue); // On-Delivery in orange
      case 3:
        return _statusContainer(
            context, 'Delivered', Colors.green); // Delivered in green blue
      default:
        return _statusContainer(context, 'Arrived-Sorted', Colors.orange);
    }
  }

  Widget _statusContainer(
      BuildContext context, String statusText, Color color) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 5, 5, 1),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(5, 1, 5, 1),
              child: Text(
                statusText,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildCategoryWidget(BuildContext context, int parcelCategory) {
    switch (parcelCategory) {
      case 2:
        return _categoryContainer(context, 'SELF-COLLECT');
      case 3:
        return _categoryContainer(context, 'COD');
      default:
        return Container();
    }
  }

  Widget _categoryContainer(BuildContext context, String categoryText) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 5, 5, 1),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(0, 167, 196, 0),
              border: Border.all(
                color: Theme.of(context).colorScheme.onSurface,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(5, 1, 5, 1),
              child: Text(
                categoryText,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
