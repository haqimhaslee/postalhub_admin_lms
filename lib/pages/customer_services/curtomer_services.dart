// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class CustomerServices extends StatefulWidget {
  const CustomerServices({super.key});
  @override
  State<CustomerServices> createState() => _CustomerServicesState();
}

class _CustomerServicesState extends State<CustomerServices> {
  @override
  Widget build(BuildContext context) {
    // ... other widget code

    return Padding(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: ListView(
          children: [
            SizedBox(
              height: 20,
            ),
            Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Customer Services system (Coming Soon)",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ],
        ));
  }
}
