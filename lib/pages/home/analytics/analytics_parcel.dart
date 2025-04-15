// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AnalyticsParcel extends StatefulWidget {
  const AnalyticsParcel({super.key});

  @override
  State<AnalyticsParcel> createState() => AnalyticsParcelState();
}

class AnalyticsParcelState extends State<AnalyticsParcel> {
  int totalParcels = 0;
  int totalParcelDelivered = 0;
  int totalParcelOnDelivery = 0;
  int totalParcelSorted = 0;

  @override
  void initState() {
    super.initState();
    fetchParcelCount();
  }

  Future<void> fetchParcelCount() async {
    try {
      //all
      final queryAll = FirebaseFirestore.instance.collection('parcelInventory');
      final aggregateQueryAll = await queryAll.count().get();
      //delivered
      final queryDelivered = FirebaseFirestore.instance
          .collection('parcelInventory')
          .where('status', isEqualTo: 3);
      final aggregateQueryDelivered = await queryDelivered.count().get();
      //sorted
      final querySorted = FirebaseFirestore.instance
          .collection('parcelInventory')
          .where('status', isEqualTo: 1);
      final aggregateQuerySorted = await querySorted.count().get();
      //ondelivery
      final queryOnDelivery = FirebaseFirestore.instance
          .collection('parcelInventory')
          .where('status', isEqualTo: 2);
      final aggregateQueryOnDelivery = await queryOnDelivery.count().get();
      setState(() {
        totalParcels = aggregateQueryAll.count!;
        totalParcelDelivered = aggregateQueryDelivered.count!;
        totalParcelSorted = aggregateQuerySorted.count!;
        totalParcelOnDelivery = aggregateQueryOnDelivery.count!;
      });
    } catch (e) {
      print('Error getting document count: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 20),
        Text(
          "All branches",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            //fontWeight: FontWeight.w900,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 5),
        Wrap(
          alignment: WrapAlignment.center,
          children: [
            _buildAnalyticsCard(
              context,
              totalParcels,
              "All parcel",
            ),
            _buildAnalyticsCard(
                context, totalParcelSorted, "All parcel-Sorted"),
            _buildAnalyticsCard(
                context, totalParcelOnDelivery, "All parcel-On Delivery"),
            _buildAnalyticsCard(
                context, totalParcelDelivered, "All parcel-Delivered"),
          ],
        ),
        Text(
          "This branch",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            //fontWeight: FontWeight.w900,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        Wrap(
          alignment: WrapAlignment.center,
          children: [
            _buildAnalyticsCard(
              context,
              totalParcelOnDelivery,
              "All parcel",
            ),
            _buildAnalyticsCard(
                context, totalParcelOnDelivery, "All parcel-Sorted"),
            _buildAnalyticsCard(
                context, totalParcelOnDelivery, "All parcel-On Delivery"),
            _buildAnalyticsCard(
                context, totalParcelOnDelivery, "All parcel-Delivered"),
          ],
        ),
        const SizedBox(height: 20),
        Divider(),
      ],
    );
  }

  Widget _buildAnalyticsCard(BuildContext context, int value, String label) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: SizedBox(
        width: 150,
        height: 100,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Material(
            color: Theme.of(context).colorScheme.surfaceContainerHigh,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "$value",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
