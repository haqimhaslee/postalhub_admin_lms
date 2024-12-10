import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
        body: Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
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
                  return const Center(child: Text('No images found'));
                }

                final items = snapshot.data!.docs;

                return CarouselSlider(
                  options: CarouselOptions(
                    //height: 177,
                    enlargeCenterPage: true,
                    autoPlay: true,
                    aspectRatio: 16 / 9,
                    autoPlayCurve: Curves.easeInOut,
                    enableInfiniteScroll: true,
                    autoPlayAnimationDuration:
                        const Duration(milliseconds: 1100),
                    autoPlayInterval: const Duration(seconds: 7),
                    viewportFraction: 1,
                  ),
                  items: items.map((item) {
                    final imageUrl = item['image_url'] ?? '';
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.symmetric(horizontal: 0.0),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                          ),
                          child: imageUrl.isNotEmpty
                              ? CachedNetworkImage(
                                  imageUrl: imageUrl,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator()),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                )
                              : const Center(
                                  child: Icon(Icons.image_not_supported,
                                      size: 50)),
                        );
                      },
                    );
                  }).toList(),
                );
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('carouselServices')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No items found'));
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
                          : Icon(Icons.image_not_supported),
                      title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(title),
                          ]),
                      trailing: IconButton(
                        tooltip: 'Delete',
                        icon: Icon(Icons.delete),
                        onPressed: () => _deleteItem(item),
                      ),
                    );
                  },
                );
              },
            ),
          )
        ]));
  }
}
