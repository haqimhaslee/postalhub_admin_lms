// ignore_for_file: deprecated_member_use
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_network/image_network.dart';
import 'package:shimmer/shimmer.dart';
import 'package:syncfusion_flutter_barcodes/barcodes.dart';
import 'package:timelines_plus/timelines_plus.dart';

class SearchInventory extends StatefulWidget {
  const SearchInventory({super.key});

  @override
  State<SearchInventory> createState() => _SearchInventoryState();
}

final searchInput = TextEditingController();

class _SearchInventoryState extends State<SearchInventory> {
  final _firestore = FirebaseFirestore.instance;
  String _searchTerm = '';
  bool _hasError = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Align(
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 600,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 10, left: 20, right: 20, bottom: 0),
                    child: TextField(
                      controller: searchInput,
                      decoration: InputDecoration(
                          labelText: 'Tracking Number*',
                          suffixIcon: Padding(
                            padding: const EdgeInsets.only(
                                bottom: 5, top: 5, right: 5),
                            child: IconButton(
                              icon: const Icon(Icons.search_rounded),
                              onPressed: () => setState(() {
                                _hasError = false;
                                _searchTerm = searchInput.text;
                              }),
                            ),
                          )),
                    ),
                  ),
                ),
                Expanded(
                  child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: 700,
                      ),
                      child: _buildSearchResults(_searchTerm)),
                )
              ],
            )));
  }

  Widget _buildSearchResults(String searchTerm) {
    if (searchTerm.isEmpty) {
      return Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '*Case sensitive',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
      future: _performSearch(searchTerm),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Shimmer.fromColors(
              direction: ShimmerDirection.ltr,
              period: const Duration(milliseconds: 1000),
              baseColor: Theme.of(context).colorScheme.surfaceContainerLowest,
              highlightColor:
                  Theme.of(context).colorScheme.surfaceContainerHighest,
              child: ListView(
                children: const [
                  Card(
                      elevation: 0,
                      child: SizedBox(
                        child: AspectRatio(
                          aspectRatio: 16 / 5,
                        ),
                      )),
                  Card(
                      elevation: 0,
                      child: SizedBox(
                        child: AspectRatio(
                          aspectRatio: 16 / 5,
                        ),
                      )),
                  Card(
                      elevation: 0,
                      child: SizedBox(
                        child: AspectRatio(
                          aspectRatio: 16 / 5,
                        ),
                      )),
                ],
              ));
        }

        final documents = snapshot.data?.docs ?? [];
        if (documents.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/components/parcel_not_found.png",
                  scale: 3,
                ),
                Text(
                  'Sorry...',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                Text(
                  '\nNo items found for that tracking number or\nyour parcel might not be sorted yet.\nPlease check again later.',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.onSurface),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          itemCount: documents.length,
          itemBuilder: (context, index) {
            final data = documents[index].data();
            final imageUrl = data['imageUrl'];
            final trackingId2 = data['trackingId2']?.toString() ?? '';
            final trackingId3 = data['trackingId3']?.toString() ?? '';
            final trackingId4 = data['trackingId4']?.toString() ?? '';
            final remarks = data['remarks']?.toString() ?? '';
            final status = data['status'];
            final timestampSorted = data['timestamp_arrived_sorted'] != null
                ? (data['timestamp_arrived_sorted'] as Timestamp).toDate()
                : null;
            final timestampDelivered = data['timestamp_delivered'] != null
                ? (data['timestamp_delivered'] as Timestamp).toDate()
                : null;
            final warehouseCode = data['warehouse']?.toString() ?? '';

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              child: FixedTimeline.tileBuilder(
                theme: TimelineThemeData(
                  nodePosition: 0,
                  indicatorPosition: 0.3,
                  color: Colors.grey,
                ),
                builder: TimelineTileBuilder.connected(
                  connectionDirection: ConnectionDirection.before,
                  itemCount: 3,
                  contentsBuilder: (context, index) {
                    final statusList = [
                      'Arrived/Sorted',
                      'On Delivery',
                      'Delivered'
                    ];
                    final statusLabels = {
                      'Arrived/Sorted': timestampSorted != null
                          ? '• Sorted at: ${DateFormat.yMMMd().add_jm().format(timestampSorted)}'
                          : '• Not sorted yet',
                      'On Delivery': status == 'On Delivery'
                          ? '• Parcel is on the way'
                          : '• Not available',
                      'Delivered': timestampDelivered != null
                          ? '• Delivered at: ${DateFormat.yMMMd().add_jm().format(timestampDelivered)}'
                          : '• Not delivered yet',
                    };

                    return Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                statusList[index],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                statusLabels[statusList[index]] ?? '',
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                ),
                              ),
                              if (index == 0)
                                Padding(
                                  padding: const EdgeInsets.only(top: 12),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (_hasError != true)
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: ImageNetwork(
                                            image: imageUrl,
                                            height: 250,
                                            width: 250,
                                            onLoading:
                                                const CircularProgressIndicator(
                                              year2023: false,
                                            ),
                                            onError: Builder(
                                              builder: (context) {
                                                WidgetsBinding.instance
                                                    .addPostFrameCallback((_) {
                                                  if (mounted) {
                                                    setState(() {
                                                      _hasError = true;
                                                    });
                                                  }
                                                });
                                                return const SizedBox.shrink();
                                              },
                                            ),
                                          ),
                                        ),
                                      const SizedBox(height: 12),
                                      SizedBox(
                                        height: 55,
                                        child: SfBarcodeGenerator(
                                          value: '${data['trackingId1']}',
                                          showValue: true,
                                          barColor: Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      if (trackingId2.isNotEmpty)
                                        Text('• Tracking ID 2: $trackingId2'),
                                      if (trackingId3.isNotEmpty)
                                        Text('• Tracking ID 3: $trackingId3'),
                                      if (trackingId4.isNotEmpty)
                                        Text('• Tracking ID 4: $trackingId4'),
                                      if (warehouseCode.isNotEmpty)
                                        Text('• Hub : $warehouseCode'),
                                      if (remarks.isNotEmpty)
                                        Padding(
                                            padding:
                                                const EdgeInsets.only(top: 12),
                                            child: Card(
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(8)),
                                                  side: BorderSide(
                                                      width: 1,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .tertiaryContainer)),
                                              child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Icon(
                                                              Icons
                                                                  .info_outline_rounded,
                                                              size: 20,
                                                              color: Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .tertiary),
                                                          SizedBox(
                                                            width: 5,
                                                          ),
                                                          Text(
                                                            "Remarks",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .tertiary),
                                                          )
                                                        ],
                                                      ),
                                                      SizedBox(height: 8),
                                                      Text(
                                                        remarks,
                                                      ),
                                                    ],
                                                  )),
                                            )),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  indicatorBuilder: (context, index) {
                    bool isActive = false;
                    if (index == 0 && timestampSorted != null) isActive = true;
                    if (index == 1 && status == '• On Delivery') {
                      isActive = true;
                    }
                    if (index == 2 && timestampDelivered != null) {
                      isActive = true;
                    }

                    return DotIndicator(
                      size: 20,
                      color: isActive
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).disabledColor,
                    );
                  },
                  connectorBuilder: (context, index, _) => SolidLineConnector(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<QuerySnapshot<Map<String, dynamic>>> _performSearch(
      String searchTerm) async {
    return _firestore
        .collection('parcelInventory')
        .where('trackingId1', isEqualTo: searchTerm)
        .get()
        .then((result1) {
      if (result1.docs.isNotEmpty) {
        return result1; // Return if found in trackingId1
      }

      // If not found in trackingId1, check trackingId2
      return _firestore
          .collection('parcelInventory')
          .where('trackingId2', isEqualTo: searchTerm)
          .get()
          .then((result2) {
        if (result2.docs.isNotEmpty) {
          return result2; // Return if found in trackingId2
        }

        // If not found in trackingId2, check trackingId3
        return _firestore
            .collection('parcelInventory')
            .where('trackingId3', isEqualTo: searchTerm)
            .get()
            .then((result3) {
          if (result3.docs.isNotEmpty) {
            return result3; // Return if found in trackingId3
          }

          // Finally, check trackingId4
          return _firestore
              .collection('parcelInventory')
              .where('trackingId4', isEqualTo: searchTerm)
              .get();
        });
      });
    });
  }
}
