import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:typed_data';

class CarouselAdder extends StatefulWidget {
  const CarouselAdder({super.key});

  @override
  State<CarouselAdder> createState() => _CarouselAdderState();
}

class _CarouselAdderState extends State<CarouselAdder> {
  final TextEditingController _titleController = TextEditingController();
  Uint8List? _selectedImage;
  bool _isUploading = false;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final imageData = await pickedFile.readAsBytes();
      setState(() {
        _selectedImage = imageData;
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_selectedImage == null || _titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please select an image and enter a title.')),
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      // Upload image to Firebase Storage
      final storageRef = FirebaseStorage.instance.ref().child(
          'carouselServices_images/${DateTime.now().millisecondsSinceEpoch}');
      final uploadTask = storageRef.putData(_selectedImage!);
      final snapshot = await uploadTask;
      final imageUrl = await snapshot.ref.getDownloadURL();

      // Save image URL and title to Firestore
      await FirebaseFirestore.instance.collection('carouselServices').add({
        'image_url': imageUrl,
        'title': _titleController.text,
        'created_at': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image uploaded successfully!')),
      );

      // Clear the fields
      setState(() {
        _selectedImage = null;
        _titleController.clear();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading image: $e')),
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Carousel Adder"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
                "• To upload a carousel banner, you need to enter a Title and pick an image"),
            Text(
                "• Image uploaded must be in 16:9 Ratio to avoid image size issue and be cropped out by system"),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            _selectedImage != null
                ? Image.memory(
                    _selectedImage!,
                    height: 200,
                    fit: BoxFit.cover,
                  )
                : Placeholder(
                    color: Theme.of(context).colorScheme.surfaceContainerHigh,
                    child: Center(
                      child: Text("Please pick an image"),
                    ),
                    fallbackHeight: 200,
                    fallbackWidth: double.infinity,
                  ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _pickImage,
                  child: const Text('Pick Image'),
                ),
                ElevatedButton(
                  onPressed: _isUploading ? null : _uploadImage,
                  child: _isUploading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Upload'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
