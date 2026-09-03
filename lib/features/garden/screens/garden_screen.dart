import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'package:succucare_app/features/garden/widgets/widgets.dart';

enum GardenDestination { garden, scan, alerts }

extension GardenDestinationLabel on GardenDestination {
  String get label => switch (this) {
    GardenDestination.garden => 'Garden',
    GardenDestination.scan => 'Scan',
    GardenDestination.alerts => 'Alerts',
  };

  IconData get icon => switch (this) {
    GardenDestination.garden => Symbols.potted_plant,
    GardenDestination.scan => Symbols.frame_inspect,
    GardenDestination.alerts => Symbols.notifications,
  };
}

class GardenScreen extends StatelessWidget {
  const GardenScreen({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  void _onTabTapped(int indexSelected) {
    // Switch to the selected tab, resetting to initial location if already selected
    navigationShell.goBranch(
      indexSelected,
      initialLocation: indexSelected == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GardenAppBar(),
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (indexSelected) => _onTabTapped(indexSelected),
        destinations:
            GardenDestination.values
                .map(
                  (destination) => NavigationDestination(
                    icon: Icon(destination.icon),
                    label: destination.label,
                  ),
                )
                .toList(),
      ),
    );
  }
}
