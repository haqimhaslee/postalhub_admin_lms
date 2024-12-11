import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:postalhub_admin_cms/pages/home/home_control_panel/function/carousel/carousel_viewer.dart';

class CarouselViewer extends StatefulWidget {
  const CarouselViewer({super.key});
  @override
  State<CarouselViewer> createState() => _CarouselViewerState();
}

class _CarouselViewerState extends State<CarouselViewer> {
  Future<void> _deleteItem(DocumentSnapshot item) async {
    try {
      // Delete the image from Firebase Storage
      final imageUrl = item['image_url'];
      if (imageUrl != null && imageUrl.isNotEmpty) {
        final storageRef = FirebaseStorage.instance.refFromURL(imageUrl);
        await storageRef.delete();
      }

      // Delete the item from Firestore
      await FirebaseFirestore.instance
          .collection('carouselServices')
          .doc(item.id)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Item deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting item: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Row(children: [
          const Text('Carousel List'),
        ]),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
              ),
              child: SizedBox(
                width: 700,
                child: CarouselAds(),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('carouselServices')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No items found'));
                }

                final items = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final title = item['title'] ?? 'No Title';
                    final imageUrl = item['image_url'] ?? '';

                    return ListTile(
                      onTap: () {},
                      leading: imageUrl.isNotEmpty
                          ? Image.network(imageUrl,
                              width: 80, height: 80, fit: BoxFit.cover)
                          : const Icon(Icons.image_not_supported),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(title),
                        ],
                      ),
                      trailing: IconButton(
                        tooltip: 'Delete',
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deleteItem(item),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
