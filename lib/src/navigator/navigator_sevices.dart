import 'package:flutter/material.dart';

import 'package:animations/animations.dart';
import 'package:postalhub_admin_cms/pages/parcel_inventory/parcel_inventory_main.dart';
import 'package:postalhub_admin_cms/pages/parcel_management/check_in_parcel.dart';
import 'package:postalhub_admin_cms/pages/parcel_management/check_out_parcel.dart';
import 'package:postalhub_admin_cms/pages/home/home.dart';
import 'package:postalhub_admin_cms/pages/loyalty_prog/loyalty_prog.dart';
import 'package:postalhub_admin_cms/pages/out_for_delivery/out_for_delivery.dart';
import 'package:postalhub_admin_cms/pages/cms_settings/cms_settings.dart';
import 'package:postalhub_admin_cms/pages/search_inventory/search_inventory.dart';
import 'package:postalhub_admin_cms/pages/search_user/search_user.dart';

class NavigatorServices extends StatefulWidget {
  const NavigatorServices({super.key});
  @override
  State<NavigatorServices> createState() => _NavigatorServicesState();
}

class _NavigatorServicesState extends State<NavigatorServices> {
  var _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    const Home(),
    const ParcelInventoryMain(),
    const SearchInventory(),
    const SearchUser(),
    const CheckInParcel(),
    const CheckOutParcel(),
    const OutForDelivery(),
    const LoyaltyProg(),
    const MyProfile(),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWideScreen = constraints.maxWidth > 680;

        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
            elevation: 0,
            scrolledUnderElevation: 0,
            title: Row(
              children: [
                Image.asset(
                  'assets/images/postalhub_logo.jpg',
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
                const Text('  Postal Hub CMS'),
              ],
            ),
            leading: isWideScreen
                ? null
                : Builder(
                    builder: (context) => IconButton(
                      icon: const Icon(Icons.menu_rounded),
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                    ),
                  ),
          ),
          drawer: isWideScreen
              ? null
              : SizedBox(
                  child: NavigationDrawer(
                    backgroundColor:
                        Theme.of(context).colorScheme.surfaceContainerLow,
                    onDestinationSelected: (i) =>
                        setState(() => _selectedIndex = i),
                    selectedIndex: _selectedIndex,
                    children: _buildDrawerDestinations(),
                  ),
                ),
          body: Row(
            children: [
              if (isWideScreen)
                SizedBox(
                  child: NavigationDrawer(
                    backgroundColor:
                        Theme.of(context).colorScheme.surfaceContainerLow,
                    onDestinationSelected: (i) =>
                        setState(() => _selectedIndex = i),
                    selectedIndex: _selectedIndex,
                    children: _buildDrawerDestinations(),
                  ),
                ),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft:
                        Radius.circular(constraints.maxWidth > 590 ? 40 : 25),
                    topRight:
                        Radius.circular(constraints.maxWidth > 590 ? 0 : 25),
                  ),
                  child: PageTransitionSwitcher(
                    transitionBuilder: (child, animation, secondaryAnimation) =>
                        SharedAxisTransition(
                      fillColor: Theme.of(context).colorScheme.surface,
                      transitionType: SharedAxisTransitionType.vertical,
                      animation: animation,
                      secondaryAnimation: secondaryAnimation,
                      child: child,
                    ),
                    child: _widgetOptions.elementAt(_selectedIndex),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildDrawerDestinations() {
    return <Widget>[
      const Padding(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
      ),
      const NavigationDrawerDestination(
        label: Text("Home"),
        icon: Icon(Icons.home_outlined),
        selectedIcon: Icon(Icons.home_rounded),
      ),
      const NavigationDrawerDestination(
        label: Text("Parcel Inventory"),
        icon: Icon(Icons.inventory_2_outlined),
        selectedIcon: Icon(Icons.inventory_2_rounded),
      ),
      const NavigationDrawerDestination(
        label: Text("Search Parcel"),
        icon: Icon(Icons.search_outlined),
        selectedIcon: Icon(Icons.search_rounded),
      ),
      const NavigationDrawerDestination(
        label: Text("Search User"),
        icon: Icon(Icons.person_search_outlined),
        selectedIcon: Icon(Icons.person_search_rounded),
      ),
      const Padding(
        padding: EdgeInsets.fromLTRB(28, 5, 28, 5),
        child: Divider(),
      ),
      const NavigationDrawerDestination(
        label: Text("Parcel Key-In"),
        icon: Icon(Icons.barcode_reader),
        selectedIcon: Icon(Icons.barcode_reader),
      ),
      const NavigationDrawerDestination(
        label: Text("Parcel Key-Out"),
        icon: Icon(Icons.barcode_reader),
        selectedIcon: Icon(Icons.barcode_reader),
      ),
      const Padding(
        padding: EdgeInsets.fromLTRB(28, 5, 28, 5),
        child: Divider(),
      ),
      const NavigationDrawerDestination(
        label: Text("Delivery"),
        icon: Icon(Icons.delivery_dining_outlined),
        selectedIcon: Icon(Icons.delivery_dining),
      ),
      const NavigationDrawerDestination(
        label: Text("Reward Point"),
        icon: Icon(Icons.card_membership_outlined),
        selectedIcon: Icon(Icons.card_membership_rounded),
      ),
      const Padding(
        padding: EdgeInsets.fromLTRB(28, 5, 28, 5),
        child: Divider(),
      ),
      const NavigationDrawerDestination(
        label: Text("CMS & Settings"),
        icon: Icon(Icons.settings_outlined),
        selectedIcon: Icon(Icons.settings_rounded),
      ),
    ];
  }
}
