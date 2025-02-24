// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';

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
        SizedBox(
          height: 5,
        ),
        Text(
          "Temporary Unavailable",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 17,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
