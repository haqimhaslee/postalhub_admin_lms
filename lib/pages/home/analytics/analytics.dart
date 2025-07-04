// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:postalhub_admin_cms/pages/home/analytics/analytics_graph.dart';
//import 'package:postalhub_admin_cms/pages/home/analytics/analytics_graph.dart';
import 'package:postalhub_admin_cms/pages/home/analytics/analytics_parcel.dart';

class HomeAnalytics extends StatefulWidget {
  const HomeAnalytics({super.key});

  @override
  State<HomeAnalytics> createState() => HomeAnalyticsState();
}

class HomeAnalyticsState extends State<HomeAnalytics> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsetsGeometry.fromLTRB(10, 0, 10, 0),
          child: AnalyticsGraph(),
        ),
        AnalyticsParcel(),
      ],
    );
  }
}
