import 'package:flutter/material.dart';

/// A simple BottomNavigationBar widget that navigates to
/// Settings, Shopping List and Navigation Menu pages.
class BottomNavigationBarWidget extends StatelessWidget {
  const BottomNavigationBarWidget({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      onTap: onTap,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.navigation),
          label: 'Icon Nav 1',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.map_outlined),
          label: 'Map Nav 1',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.navigation),
          label: 'Icon Nav 2',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.map_outlined),
          label: 'Map Nav 2',
        ),
      ],
    );
  }
}
