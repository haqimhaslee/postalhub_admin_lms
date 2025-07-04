// ignore_for_file: deprecated_member_use, unused_local_variable
// ignore: unused_import
import 'package:image_network/image_network.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:syncfusion_flutter_barcodes/barcodes.dart';
import 'package:timelines_plus/timelines_plus.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DetailPage extends StatelessWidget {
  final Map<String, dynamic> data;
  final String docId;

  const DetailPage({super.key, required this.data, required this.docId});

  @override
  Widget build(BuildContext context) {
    final trackingID1 = data['trackingId1'];
    final remarks = data['remarks'] ?? 'No remarks';
    final status = data['status'] ?? 1;
    final trackingID2 = data['trackingId2'] ?? 'No Tracking ID';
    final trackingID3 = data['trackingId3'] ?? 'No Tracking ID';
    final trackingID4 = data['trackingId4'] ?? 'No Tracking ID';
    final warehouse = data['warehouse'] ?? 'No warehouse data';
    final ownerId = data['ownerId']?.toString() ?? '';
    final receiverId = data['receiverId'] ?? 'No receiver ID data';
    final receiverRemark =
        data['receiverRemarks'] ?? 'No receiver remarks data';
    final receiverImageUrl =
        data['receiverImageUrl'] ?? 'No receiver image data';
    final imageUrl = data['imageUrl'];
    final timestampArrived = data['timestamp_arrived_sorted'] != null
        ? (data['timestamp_arrived_sorted'] as Timestamp).toDate()
        : null;
    final timestampDelivered = data['timestamp_delivered'] != null
        ? (data['timestamp_delivered'] as Timestamp).toDate()
        : null;

    return Scaffold(
      appBar: AppBar(
        title: Text('$trackingID1'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Show a confirmation dialog before deleting
          bool confirmDelete = await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Confirm Delete"),
                    content: const Text(
                        "Are you sure you want to delete this item?"),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text("Cancel"),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.errorContainer,
                          foregroundColor:
                              Theme.of(context).colorScheme.onErrorContainer,
                        ),
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text("Delete"),
                      ),
                    ],
                  );
                },
              ) ??
              false;

          if (confirmDelete) {
            try {
              // Delete the document from Firestore
              await FirebaseFirestore.instance
                  .collection('parcelInventory')
                  .doc(docId)
                  .delete();

              // Delete the image from Firebase Storage if it exists
              if (imageUrl.isNotEmpty) {
                await FirebaseStorage.instance.refFromURL(imageUrl).delete();
              }

              // Delete the receiver image from Firebase Storage if it exists
              if (receiverImageUrl.isNotEmpty &&
                  receiverImageUrl != 'No receiver image data') {
                await FirebaseStorage.instance
                    .refFromURL(receiverImageUrl)
                    .delete();
              }

              // Show a success message or navigate back to the previous screen
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Item deleted successfully')),
              );
              Navigator.of(context).pop(); // Navigate back
            } catch (e) {
              // Show an error message if the deletion fails
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error deleting item: $e')),
              );
            }
          }
        },
        child: const Icon(Icons.delete),
      ),
      body: Padding(
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
              final statusList = ['Arrived/Sorted', 'On Delivery', 'Delivered'];
              final statusLabels = {
                'Arrived/Sorted': timestampArrived != null
                    ? '• Sorted at: ${DateFormat.yMMMd().add_jm().format(timestampArrived)}'
                    : '• Not sorted yet',
                'On Delivery': status == 'On Delivery'
                    ? '• Parcel is on the way'
                    : '• Not available',
                'Delivered': timestampDelivered != null
                    ? '• Delivered at: ${DateFormat.yMMMd().add_jm().format(timestampDelivered)}'
                    : '• Not delivered yet',
              };

              return Padding(
                  padding: const EdgeInsets.only(left: 12.0, bottom: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Container(
                      color: Theme.of(context).colorScheme.surfaceVariant,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: ImageNetwork(
                                        image: imageUrl,
                                        height: 250,
                                        width: 250,
                                        onLoading:
                                            const CircularProgressIndicator(
                                          year2023: false,
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
                                    if (trackingID2.isNotEmpty)
                                      Text('• Tracking ID 2: $trackingID2'),
                                    if (trackingID3.isNotEmpty)
                                      Text('• Tracking ID 3: $trackingID3'),
                                    if (trackingID4.isNotEmpty)
                                      Text('• Tracking ID 4: $trackingID4'),
                                    if (warehouse.isNotEmpty)
                                      Text('• Hub : $warehouse'),
                                    if (remarks.isNotEmpty)
                                      Padding(
                                          padding:
                                              const EdgeInsets.only(top: 12),
                                          child: Card(
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
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
                                                      CrossAxisAlignment.start,
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
                  ));
            },
            indicatorBuilder: (context, index) {
              bool isActive = false;
              if (index == 0 && timestampArrived != null) isActive = true;
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
      ),
    );
  }
}
