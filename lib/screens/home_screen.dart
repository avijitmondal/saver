import 'package:flutter/material.dart';
import '../widgets/common/bottom_nav_scaffold.dart';
import '../constants/ui_constants.dart';
import '../constants/app_constants.dart';
import 'overview_screen.dart';
import 'investments_screen.dart';
import 'notifications_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Define navigation items
    final List<BottomNavItem> navItems = [
      const BottomNavItem(
        label: 'Overview',
        icon: Icons.dashboard_outlined,
        screen: OverviewScreen(),
      ),
      const BottomNavItem(
        label: 'Investments',
        icon: Icons.trending_up,
        screen: InvestmentsScreen(),
      ),
      // Notifications item only when enabled
      if (AppConstants.featureFlags['notifications'] ?? false)
        const BottomNavItem(
          label: 'Notifications',
          icon: Icons.notifications_outlined,
          screen: NotificationsScreen(),
        ),
      const BottomNavItem(
        label: 'Profile',
        icon: Icons.person_outline,
        screen: ProfileScreen(),
      ),
    ];

    // Adjust selected index if notifications disabled and previously selected its slot
    if (!(AppConstants.featureFlags['notifications'] ?? false) && _selectedIndex >= navItems.length) {
      _selectedIndex = 0;
    }

    return BottomNavScaffold(
      items: navItems,
      initialIndex: _selectedIndex,
      onIndexChanged: (index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      selectedItemColor: UIConstants.primaryColor,
    );
  }
}
