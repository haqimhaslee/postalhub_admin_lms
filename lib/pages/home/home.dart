// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:postalhub_admin_cms/pages/home/analytics/analytics.dart';
//import 'package:postalhub_admin_cms/pages/home/analytics/analytics_parcel.dart';
import 'package:postalhub_admin_cms/pages/home/home_control_panel/home_control_panel.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    // ... other widget code

    return Padding(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: ListView(
          children: [
            Column(
              children: [
                HomeAnalytics(),
                SizedBox(
                  height: 20,
                ),
                HomeControlPanel(),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ],
        ));
  }
}
