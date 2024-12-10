// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AnalyticsGraph extends StatefulWidget {
  const AnalyticsGraph({super.key});

  @override
  State<AnalyticsGraph> createState() => AnalyticsGraphState();
}

class AnalyticsGraphState extends State<AnalyticsGraph> {
  int totalParcels = 0;
  int totalParcelsArrived = 0;
  int totalParcelsOnDelivery = 0;
  int totalParcelsDelivered = 0;
  int totalUserClient = 0;
  int totalUserAdmin = 0;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      // Fetch each collection separately
      final parcelInventorySnapshot =
          await FirebaseFirestore.instance.collection('parcelInventory').get();
      final clientUserSnapshot =
          await FirebaseFirestore.instance.collection('client_user').get();
      final adminUserSnapshot =
          await FirebaseFirestore.instance.collection('admin_user').get();

      setState(() {
        totalParcels = parcelInventorySnapshot.size;
        totalUserClient = clientUserSnapshot.size;
        totalUserAdmin = adminUserSnapshot.size;

        // Accessing 'status' as an integer
        totalParcelsArrived = parcelInventorySnapshot.docs
            .where((doc) => doc.data()['status'] == 1)
            .length;
        totalParcelsOnDelivery = parcelInventorySnapshot.docs
            .where((doc) => doc.data()['status'] == 2)
            .length;
        totalParcelsDelivered = parcelInventorySnapshot.docs
            .where((doc) => doc.data()['status'] == 3)
            .length;
      });
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 20),
        Text(
          "Analytics",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 20),
        Wrap(
          alignment: WrapAlignment.center,
          children: [
            _buildAnalyticsCard(
                context, totalParcels, "Total parcel (Inventory)"),
            _buildAnalyticsCard(
                context, totalParcelsArrived, "Arrived - Sorted"),
            _buildAnalyticsCard(context, totalParcelsOnDelivery, "On delivery"),
            _buildAnalyticsCard(context, totalParcelsDelivered, "Delivered"),
            _buildAnalyticsCard(context, totalUserClient, "User (Client)"),
            _buildAnalyticsCard(context, totalUserAdmin, "User (Admin)"),
          ],
        ),
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
            color: Theme.of(context).colorScheme.surfaceVariant,
            child: InkWell(
              onTap: () {},
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Removed fixed width constraint
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
      ),
    );
  }
}
