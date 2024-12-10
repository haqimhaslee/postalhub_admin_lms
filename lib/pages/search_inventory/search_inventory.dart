// ignore_for_file: deprecated_member_use
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:another_stepper/another_stepper.dart';
import 'package:image_network/image_network.dart';

class SearchInventory extends StatefulWidget {
  const SearchInventory({super.key});

  @override
  State<SearchInventory> createState() => _SearchInventoryState();
}

final searchInput = TextEditingController();

class _SearchInventoryState extends State<SearchInventory> {
  final _firestore = FirebaseFirestore.instance;
  String _searchTerm = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(0, 158, 158, 158),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => setState(() => _searchTerm = searchInput.text),
          label: const Text("Search"),
          icon: const Icon(Icons.search),
        ),
        body: Padding(
            padding: const EdgeInsets.only(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.width > 590 ? 30 : 20,
                    left: MediaQuery.of(context).size.width > 590 ? 30 : 20,
                    right: MediaQuery.of(context).size.width > 590 ? 28 : 20,
                    bottom: MediaQuery.of(context).size.width > 590 ? 28 : 10,
                  ),
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
                      labelText: 'Tracking Number*',
                    ),
                  ),
                ),
                //const Divider(),
                Expanded(
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        10,
                        0,
                        10,
                        0,
                      ),
                      child: _buildSearchResults(_searchTerm)),
                ),
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
            Image.asset(
              "assets/gif/search.gif",
              scale: 2,
            ),
            const Text('Enter a tracking number to search.'),
            const Text('*Tracking numbers are case sensitive')
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
          return const Center(child: CircularProgressIndicator());
        }

        final documents = snapshot.data?.docs ?? [];
        if (documents.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/gif/not_found.gif",
                ),
                const Text('Sorry...'),
                const Padding(
                  padding: EdgeInsets.only(
                    left: 30,
                    right: 30,
                  ),
                  child: Text(
                    'No items found for that tracking number or your parcel might not be sorted yet.',
                    textAlign: TextAlign.center,
                  ),
                ),
                const Text('Please check again later.'),
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
            final receiverRemarks = data['receiverRemarks']?.toString() ?? '';
            final remarks = data['remarks']?.toString() ?? '';
            final status = data['status'];
            final receiverImageUrl = data['receiverImageUrl'];
            final timestampSorted = data['timestamp_arrived_sorted'] != null
                ? (data['timestamp_arrived_sorted'] as Timestamp).toDate()
                : null;
            final timestampDelivered = data['timestamp_delivered'] != null
                ? (data['timestamp_delivered'] as Timestamp).toDate()
                : null;
            final warehouseCode = data['warehouse']?.toString() ?? '';

            List<StepperData> stepperDataDelivered = [
              StepperData(
                  title: StepperText(
                    "Ready to take",
                    textStyle: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  subtitle: StepperText("Arriving/Sorting"),
                  iconWidget: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    child: const Icon(Icons.inventory, color: Colors.white),
                  )),
              StepperData(
                  title: StepperText(
                    "On delivery",
                    textStyle: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  subtitle: StepperText("On delivery"),
                  iconWidget: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    child:
                        const Icon(Icons.delivery_dining, color: Colors.white),
                  )),
              StepperData(
                  title: StepperText("Delivered",
                      textStyle: const TextStyle(
                        color: Colors.grey,
                      )),
                  subtitle: StepperText("Delivery"),
                  iconWidget: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    child: const Icon(Icons.check_rounded, color: Colors.white),
                  ))
            ];

            List<StepperData> stepperDataSorted = [
              StepperData(
                  title: StepperText(
                    "Ready to take",
                    textStyle: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  subtitle: StepperText("Arriving/Sorting"),
                  iconWidget: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    child: const Icon(Icons.inventory, color: Colors.white),
                  )),
              StepperData(
                  title: StepperText(
                    "On delivery",
                    textStyle: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  subtitle: StepperText("On delivery"),
                  iconWidget: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    child:
                        const Icon(Icons.delivery_dining, color: Colors.white),
                  )),
              StepperData(
                  title: StepperText("Delivered",
                      textStyle: const TextStyle(
                        color: Colors.grey,
                      )),
                  subtitle: StepperText("Delivery"),
                  iconWidget: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    child: const Icon(Icons.check_rounded, color: Colors.white),
                  ))
            ];

            List<StepperData> stepperDataOnDelivery = [
              StepperData(
                  title: StepperText(
                    "Ready to take",
                    textStyle: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  subtitle: StepperText("Arriving/Sorting"),
                  iconWidget: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    child: const Icon(Icons.inventory, color: Colors.white),
                  )),
              StepperData(
                  title: StepperText(
                    "On delivery",
                    textStyle: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  subtitle: StepperText("On delivery"),
                  iconWidget: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    child:
                        const Icon(Icons.delivery_dining, color: Colors.white),
                  )),
              StepperData(
                  title: StepperText("Not delivered",
                      textStyle: const TextStyle(
                        color: Colors.grey,
                      )),
                  subtitle: StepperText("Delivery"),
                  iconWidget: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    child: const Icon(Icons.check_rounded, color: Colors.white),
                  ))
            ];

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Card(
                      color:
                          Theme.of(context).colorScheme.surfaceContainerHighest,
                      elevation: 0,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 15,
                          left: 25,
                          right: 25,
                          bottom: 15,
                        ),
                        child: switch (status) {
                          1 => AnotherStepper(
                              stepperList: stepperDataSorted,
                              stepperDirection: Axis.horizontal,
                              iconWidth: 40,
                              iconHeight: 40,
                              activeBarColor: Colors.green,
                              inActiveBarColor: Colors.grey,
                              inverted: true,
                              verticalGap: 20,
                              activeIndex: 0,
                              barThickness: 8,
                            ),
                          2 => AnotherStepper(
                              stepperList: stepperDataOnDelivery,
                              stepperDirection: Axis.horizontal,
                              iconWidth: 40,
                              iconHeight: 40,
                              activeBarColor: Colors.green,
                              inActiveBarColor: Colors.grey,
                              inverted: true,
                              verticalGap: 20,
                              activeIndex: 1,
                              barThickness: 8,
                            ),
                          3 => AnotherStepper(
                              stepperList: stepperDataDelivered,
                              stepperDirection: Axis.horizontal,
                              iconWidth: 40,
                              iconHeight: 40,
                              activeBarColor: Colors.green,
                              inActiveBarColor: Colors.grey,
                              inverted: true,
                              verticalGap: 20,
                              activeIndex: 2,
                              barThickness: 8,
                            ),
                          _ => Container(), // Handle default case if needed
                        },
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Card(
                  elevation: 0,
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                          padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: ImageNetwork(
                                    image: imageUrl,
                                    height: 350,
                                    width: 300,
                                    onLoading: const CircularProgressIndicator(
                                      color: Colors.indigoAccent,
                                    ),
                                    onError: const Icon(
                                      Icons.error,
                                      color: Colors.red,
                                    ),
                                  )),
                            ],
                          )),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 0, 0, 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.qr_code_scanner_rounded,
                                  size: 15,
                                ),
                                Text(
                                  '   Tracking ID 1 :  ${data['trackingId1']}',
                                ),
                              ],
                            ),
                            if (trackingId2.isNotEmpty)
                              Row(
                                children: [
                                  const Icon(
                                    Icons.qr_code_scanner_rounded,
                                    size: 15,
                                  ),
                                  Text(
                                    '   Tracking ID 2 :  ${data['trackingId2']}',
                                  ),
                                ],
                              ),
                            if (trackingId3.isNotEmpty)
                              Row(
                                children: [
                                  const Icon(
                                    Icons.qr_code_scanner_rounded,
                                    size: 15,
                                  ),
                                  Text(
                                    '   Tracking ID 3 :  ${data['trackingId3']}',
                                  ),
                                ],
                              ),
                            if (trackingId4.isNotEmpty)
                              Row(
                                children: [
                                  const Icon(
                                    Icons.qr_code_scanner_rounded,
                                    size: 15,
                                  ),
                                  Text(
                                    '   Tracking ID 4 :  ${data['trackingId4']}',
                                  ),
                                ],
                              ),
                            if (remarks.isNotEmpty)
                              Row(
                                children: [
                                  const Icon(
                                    Icons.description_rounded,
                                    size: 15,
                                  ),
                                  Text(
                                    '    Remarks :  $remarks',
                                  ),
                                ],
                              ),
                            if (timestampSorted != null)
                              Row(
                                children: [
                                  const Icon(
                                    Icons.schedule_rounded,
                                    size: 15,
                                  ),
                                  Text(
                                    '   Sorted at :  ${DateFormat.yMMMd().add_jm().format(timestampSorted)}',
                                  ),
                                ],
                              ),
                            if (warehouseCode.isNotEmpty)
                              Row(
                                children: [
                                  const Icon(
                                    Icons.warehouse_rounded,
                                    size: 15,
                                  ),
                                  Text(
                                    '   Warehouse/Branch :  $warehouseCode',
                                  ),
                                ],
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
                  child: Divider(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                Card(
                  elevation: 0,
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (status == 3)
                              Padding(
                                padding: const EdgeInsets.fromLTRB(30, 5, 5, 1),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (timestampDelivered != null)
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.schedule_rounded,
                                            size: 15,
                                          ),
                                          Text(
                                            '   Delivered at :  ${DateFormat.yMMMd().add_jm().format(timestampDelivered)}',
                                          ),
                                        ],
                                      ),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.badge_rounded,
                                          size: 15,
                                        ),
                                        Text(
                                          '   Receiver :  ${data['receiverId']}',
                                        ),
                                      ],
                                    ),
                                    if (receiverRemarks.isNotEmpty)
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.description_rounded,
                                            size: 15,
                                          ),
                                          Text(
                                              '   Remarks :  ${data['receiverRemarks']}'),
                                        ],
                                      ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: Image.network(
                                            receiverImageUrl,
                                            width: 300.0,
                                            height: 300.0,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              String errorMessage;
                                              if (error
                                                  is NetworkImageLoadException) {
                                                errorMessage =
                                                    'Network error: $error';
                                              } else {
                                                errorMessage =
                                                    'Failed to load image: $error';
                                              }
                                              return Column(
                                                children: [
                                                  const Icon(Icons
                                                      .image_not_supported_outlined),
                                                  Text(errorMessage),
                                                ],
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                              )
                            else
                              const Column(),
                          ],
                        ),
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
