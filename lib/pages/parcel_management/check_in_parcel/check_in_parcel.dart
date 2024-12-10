import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CheckInParcel extends StatefulWidget {
  const CheckInParcel({super.key});

  @override
  State<CheckInParcel> createState() => _CheckInParcelState();
}

final TextEditingController trackingId1 = TextEditingController();
final TextEditingController trackingId2 = TextEditingController();
final TextEditingController trackingId3 = TextEditingController();
final TextEditingController trackingId4 = TextEditingController();
final TextEditingController ownerId = TextEditingController();
final TextEditingController remarks = TextEditingController();

class _CheckInParcelState extends State<CheckInParcel> {
  File? file;
  XFile? webFile;
  String? webImagePath;
  ImagePicker imagePicker = ImagePicker();
  FirebaseStorage storage = FirebaseStorage.instance;

  int parcelCategory = 1; // Default parcel category

  // ignore: unused_field
  bool _isLoading = false; // Add loading state variable
  String? warehouse;

  Future<void> addToFirebase(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    // Get values from text fields
    String trackingid_1 = trackingId1.text;
    String trackingid_2 = trackingId2.text;
    String trackingid_3 = trackingId3.text;
    String trackingid_4 = trackingId4.text;
    String owner_id = ownerId.text;
    String remarks_ = remarks.text;
    String imageUrl;

    imageUrl = await uploadImage(file!);

    DateTime currentTime = DateTime.now();

    // Create a Map to hold data
    Map<String, dynamic> data = {
      'trackingId1': trackingid_1,
      'trackingId2': trackingid_2,
      'trackingId3': trackingid_3,
      'trackingId4': trackingid_4,
      'ownerId': owner_id,
      'remarks': remarks_,
      'status': 1,
      'warehouse': warehouse,
      'imageUrl': imageUrl,
      'timestamp_arrived_sorted': currentTime,
      'parcelCategory': parcelCategory, // Add parcel category to data
    };

    // Add data to Firestore
    try {
      await FirebaseFirestore.instance.collection('parcelInventory').add(data);

      // Clear text fields (optional)
      trackingId1.text = '';
      trackingId2.text = '';
      trackingId3.text = '';
      trackingId4.text = '';
      ownerId.text = '';
      remarks.text = '';

      // Clear selected image and reset parcel category
      setState(() {
        file = null;
        webFile = null;
        webImagePath = null;
        parcelCategory = 1; // Reset to default category
        _isLoading = false;
      });

      // Show success Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Parcel added successfully!'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (error) {
      // Show error Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error adding parcel: $error'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<String> uploadImage(File imageFile) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference reference = storage.ref().child('parcel_images/$fileName');
    UploadTask uploadTask = reference.putFile(imageFile);
    TaskSnapshot snapshot = await uploadTask.whenComplete(() => null);
    String imageUrl = await snapshot.ref.getDownloadURL();
    return imageUrl;
  }

  Future<void> getImage() async {
    if (!kIsWeb) {
      // Check if not running on web
      var status = await Permission.camera.status;
      if (status.isDenied) {
        // Request camera permission if denied
        status = await Permission.camera.request();
        if (status.isDenied) {
          // Handle permission denied (e.g., show a message)
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Camera permission is required.'),
              duration: Duration(seconds: 2),
            ),
          );
          return; // Exit if permission is still denied
        }
      }
    }

    try {
      final pickedFile =
          await imagePicker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        setState(() {
          if (kIsWeb) {
            webFile = pickedFile;
            webImagePath = pickedFile.path;
          } else {
            file = File(pickedFile.path);
          }
        });
      }
    } catch (e) {
      // Handle any errors that might occur during image capture
      print("Error capturing image: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred while capturing the image.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> scanQRCode(TextEditingController controller) async {
    var result = await BarcodeScanner.scan();
    setState(() {
      controller.text = result.rawContent;
    });
  }

  Future<void> _getWarehouse() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String userEmail = user.email!;

        QuerySnapshot adminSnapshot = await FirebaseFirestore.instance
            .collection('adminManagement')
            .where('campusAdminEmail', isEqualTo: userEmail)
            .get();

        if (adminSnapshot.docs.isNotEmpty) {
          String campusCode = adminSnapshot.docs[0]['campusCode'];

          setState(() {
            warehouse = campusCode;
          });
          print('Campus code sucess');
        } else {
          // Handle case where no matching admin is found
          print('No admin found with the current user\'s email.');
          // You might want to show an error message or navigate to a different screen
        }
      } else {
        // Handle case where user is not logged in
        print('User is not logged in.');
      }
    } catch (e) {
      print('Error retrieving warehouse: $e');
      // Handle error appropriately (e.g., show an error message)
    }
  }

  @override
  void initState() {
    super.initState();
    _getWarehouse(); // Fetch warehouse code when the widget initializes
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: ListView(
        children: [
          Container(
            decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.secondary,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            child: webImagePath == null && file == null
                ? MaterialButton(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 40,
                          width: MediaQuery.of(context).size.width * 0.6,
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
            height: 10,
          ),
          TextField(
            controller: trackingId1,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                onPressed: () {
                  scanQRCode(trackingId1);
                },
                icon: const Icon(Icons.barcode_reader),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              labelText: 'Tracking ID* (Required)',
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            controller: trackingId2,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                onPressed: () {
                  scanQRCode(trackingId2);
                },
                icon: const Icon(Icons.barcode_reader),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              labelText: 'Tracking ID 2 (Optional)',
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            controller: trackingId3,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                onPressed: () {
                  scanQRCode(trackingId3);
                },
                icon: const Icon(Icons.barcode_reader),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              labelText: 'Tracking ID 3 (Optional)',
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            controller: trackingId4,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                onPressed: () {
                  scanQRCode(trackingId4);
                },
                icon: const Icon(Icons.barcode_reader),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              labelText: 'Tracking ID 4 (Optional)',
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Column(
            children: [
              const Text("Parcel Category"),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Radio<int>(
                  value: 1,
                  groupValue: parcelCategory,
                  onChanged: (value) {
                    setState(() {
                      parcelCategory = value!;
                    });
                  },
                ),
                const Text("Normal"),
                Radio<int>(
                  value: 2,
                  groupValue: parcelCategory,
                  onChanged: (value) {
                    setState(() {
                      parcelCategory = value!;
                    });
                  },
                ),
                const Text("Self-Collect"),
                Radio<int>(
                  value: 3,
                  groupValue: parcelCategory,
                  onChanged: (value) {
                    setState(() {
                      parcelCategory = value!;
                    });
                  },
                ),
                const Text("COD"),
              ]),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          TextField(
            controller: ownerId,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                onPressed: () {
                  scanQRCode(ownerId);
                },
                icon: const Icon(Icons.barcode_reader),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              labelText: "User Unique ID (UID)* (Recommeded)",
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            controller: remarks,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              labelText: 'Remarks (Optional)',
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          FilledButton(
            onPressed: _isLoading // Disable button while loading
                ? null
                : () {
                    if (trackingId1.text.isEmpty ||
                        (file == null && webFile == null)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Uh-oh 😯. Missing parcel details'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    } else {
                      addToFirebase(context);
                    }
                  },
            child: Center(
              child: _isLoading // Conditionally render button or loading icon
                  ? const CircularProgressIndicator() // Show loading icon
                  : const Text("Add parcel"), // Show button text
            ),
          ),
        ],
      ),
    );
  }
}
