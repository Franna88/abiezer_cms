import 'package:flutter/material.dart';

class AdminSidenav extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const AdminSidenav({
    Key? key,
    required this.selectedIndex,
    required this.onItemSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      extended: MediaQuery.of(context).size.width >= 1200,
      selectedIndex: selectedIndex,
      onDestinationSelected: onItemSelected,
      labelType: NavigationRailLabelType.none,
      destinations: const [
        NavigationRailDestination(
          icon: Icon(Icons.dashboard),
          label: Text('Dashboard'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.folder),
          label: Text('Projects'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.list_alt),
          label: Text('BoM'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.shopping_cart),
          label: Text('Purchases'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.check_circle),
          label: Text('Approvals'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.bar_chart),
          label: Text('Reports'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.people),
          label: Text('Users'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.settings),
          label: Text('Settings'),
        ),
      ],
    );
  }
}
