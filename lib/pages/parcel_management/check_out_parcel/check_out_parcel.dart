import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:barcode_scan2/barcode_scan2.dart';

class CheckOutParcel extends StatefulWidget {
  const CheckOutParcel({super.key});

  @override
  State<CheckOutParcel> createState() => _CheckOutParcelState();
}

final TextEditingController receiverIdTextField = TextEditingController();

class _CheckOutParcelState extends State<CheckOutParcel> {
  File? file;
  String? webImagePath;
  ImagePicker imagePicker = ImagePicker();
  FirebaseStorage storage = FirebaseStorage.instance;
  final TextEditingController trackingIdController = TextEditingController();

  final List<Map<String, dynamic>> parcels = [];
  final List<Map<String, dynamic>> cart = [];
  final Map<String, TextEditingController> remarksControllers = {};

  Future<String> uploadImage(File imageFile) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference reference =
        storage.ref().child('parcel_receiver_images/$fileName');
    UploadTask uploadTask = reference.putFile(imageFile);
    TaskSnapshot snapshot = await uploadTask.whenComplete(() => null);
    String imageUrl = await snapshot.ref.getDownloadURL();
    return imageUrl;
  }

  Future<String> uploadWebImage(XFile imageFile) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference reference =
        storage.ref().child('parcel_receiver_images/$fileName');
    UploadTask uploadTask = reference.putData(await imageFile.readAsBytes());
    TaskSnapshot snapshot = await uploadTask.whenComplete(() => null);
    String imageUrl = await snapshot.ref.getDownloadURL();
    return imageUrl;
  }

  Future<void> scanQRCode(TextEditingController controller) async {
    var result = await BarcodeScanner.scan();
    setState(() {
      controller.text = result.rawContent;
    });
  }

  Future<void> getImage() async {
    final pickedFile = await imagePicker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        if (kIsWeb) {
          webImagePath = pickedFile.path;
        } else {
          file = File(pickedFile.path);
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    trackingIdController.text = "";
  }

  Future<void> readAndAddToCart(String trackingId) async {
    try {
      final docRef = FirebaseFirestore.instance
          .collection('parcelInventory')
          .where('trackingId1', isEqualTo: trackingId)
          .get();
      final querySnapshot = await docRef;

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        final docData = {
          ...doc.data(),
          'id': doc.id,
        };
        setState(() {
          if (!cart.any((parcel) => parcel['id'] == doc.id)) {
            parcels.add(docData);
            cart.add(docData);
            remarksControllers[doc.id] = TextEditingController();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Parcel already in checkout cart!'),
                duration: Duration(seconds: 2),
              ),
            );
          }
        });
        // Clear the tracking ID TextField after adding to cart
        trackingIdController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Parcel not found!'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error reading data: $error'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> updateData() async {
    if ((file == null && webImagePath == null) ||
        receiverIdTextField.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please provide a receiver ID and take a photo!'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    final userQuery = await FirebaseFirestore.instance
        .collection('client_user')
        .where('unique_id', isEqualTo: receiverIdTextField.text)
        .get();

    if (userQuery.docs.isNotEmpty) {
      final userDoc = userQuery.docs.first;
      int currentPoints = userDoc['membership_points'] ?? 0;
      int pointsToAdd = cart.length * 2;

      await userDoc.reference.update({
        'membership_points': currentPoints + pointsToAdd,
      });
    }

    // Check if remarks are required for parcels with parcelCategory 2 or 3
    for (var parcel in cart) {
      int parcelCategory = parcel['parcelCategory'] ?? 0;
      String docId = parcel['id'];
      String receiverRemarks = remarksControllers[docId]?.text ?? '';

      if ((parcelCategory == 2 || parcelCategory == 3) &&
          receiverRemarks.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('Remarks are required for COD & Self-Collect parcels!'),
            duration: Duration(seconds: 7),
          ),
        );
        return; // Stop the checkout process
      }
    }

    try {
      String imageUrl;
      if (kIsWeb) {
        imageUrl = await uploadWebImage(XFile(webImagePath!));
      } else {
        imageUrl = await uploadImage(file!);
      }
      String receiverId = receiverIdTextField.text;
      DateTime currentTime = DateTime.now();

      for (var parcel in cart) {
        String docId = parcel['id'];
        String receiverRemarks = remarksControllers[docId]?.text ?? '';
        await FirebaseFirestore.instance
            .collection('parcelInventory')
            .doc(docId)
            .update({
          'status': 3,
          'receiverImageUrl': imageUrl,
          'receiverId': receiverId,
          'receiverRemarks': receiverRemarks,
          'timestamp_delivered': currentTime,
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Parcel checked out successfully!'),
          duration: Duration(seconds: 2),
        ),
      );

      setState(() {
        cart.clear();
        file = null;
        webImagePath = null;
        receiverIdTextField.clear();
        remarksControllers.clear();
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating data: $error'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void removeFromCart(String docId) {
    setState(() {
      cart.removeWhere((parcel) => parcel['id'] == docId);
      remarksControllers.remove(docId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(children: [
        const SizedBox(height: 10),
        TextField(
          controller: trackingIdController,
          decoration: InputDecoration(
            suffixIcon: IconButton(
              onPressed: () {
                scanQRCode(trackingIdController);
              },
              icon: const Icon(Icons.barcode_reader),
            ),
            labelText: 'Tracking ID',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        const SizedBox(height: 10),
        FilledButton(
          onPressed: () => readAndAddToCart(trackingIdController.text),
          child: const Text('Add to Checkout'),
        ),
        const SizedBox(height: 20),
        const SizedBox(height: 20),
        cart.isNotEmpty
            ? Column(
                children: [
                  const Text(
                    'Cart',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  ...cart.map((parcel) {
                    String docId = parcel['id'];
                    int parcelCategory = parcel['parcelCategory'] ?? 0;
                    String categoryText = '';
                    if (parcelCategory == 2) {
                      categoryText = '  [SELF-COLLECT]';
                    } else if (parcelCategory == 3) {
                      categoryText = '  [COD]';
                    }
                    return Card(
                      elevation: 3,
                      child: ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(parcel['trackingId1'] ?? ''),
                                const SizedBox(width: 8),
                                Text(
                                  categoryText,
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: remarksControllers[docId],
                              decoration: const InputDecoration(
                                labelText: 'Remarks',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.remove_circle),
                          onPressed: () => removeFromCart(docId),
                        ),
                      ),
                    );
                  }).toList(),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10))),
                    child: webImagePath == null && file == null
                        ? MaterialButton(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 40,
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                ),
                                const Icon(
                                  Icons.camera,
                                  size: 40,
                                ),
                                const Text("Camera* (Required)"),
                                const SizedBox(
                                  height: 40,
                                ),
                              ],
                            ),
                            onPressed: () {
                              getImage();
                            },
                          )
                        : MaterialButton(
                            child: kIsWeb
                                ? Image.network(
                                    webImagePath!,
                                    height: 300,
                                    fit: BoxFit.fill,
                                  )
                                : Image.file(
                                    height: 300,
                                    file!,
                                    fit: BoxFit.fill,
                                  ),
                            onPressed: () {
                              getImage();
                            },
                          ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextField(
                    controller: receiverIdTextField,
                    style: const TextStyle(fontSize: 12),
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: () {
                            scanQRCode(receiverIdTextField);
                          },
                          icon: const Icon(Icons.barcode_reader),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        labelText: 'Receiver ID/UID*'),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  FilledButton(
                    onPressed: updateData,
                    child: const Text('Checkout'),
                  ),
                ],
              )
            : const Text('Checkout system is empty'),
      ]),
    );
  }
}
