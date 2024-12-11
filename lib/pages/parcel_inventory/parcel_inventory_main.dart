// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:postalhub_admin_cms/pages/parcel_inventory/parcel_inventory.dart';

class ParcelInventoryMain extends StatefulWidget {
  const ParcelInventoryMain({super.key});

  @override
  State<ParcelInventoryMain> createState() => _ParcelInventoryMainState();
}

class _ParcelInventoryMainState extends State<ParcelInventoryMain>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TabBar(
        enableFeedback: true,
        splashBorderRadius: BorderRadius.circular(15),
        indicatorWeight: 4,
        isScrollable: true,
        dividerColor: const Color.fromARGB(0, 76, 175, 79),
        controller: _tabController,
        tabs: <Widget>[
          Tab(
            text: "All",
          ),
          Tab(
            text: "Arrived-Sorted",
          ),
          Tab(
            text: "On-Delivery",
          ),
          Tab(
            text: "Delivered",
          ),
        ],
      ),
      body: TabBarView(controller: _tabController, children: const <Widget>[
        ParcelInventory(),
        ParcelInventory(),
        Center(
          child: Text("Coming Soon"),
        ),
        ParcelInventory(),
      ]),
    );
  }
}
