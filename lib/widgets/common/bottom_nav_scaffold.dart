import 'package:flutter/material.dart';
import '../../constants/ui_constants.dart';

class BottomNavItem {
  final String label;
  final IconData icon;
  final Widget screen;

  const BottomNavItem({
    required this.label,
    required this.icon,
    required this.screen,
  });
}

/// A scaffold with a bottom navigation bar for consistent navigation across the app
class BottomNavScaffold extends StatefulWidget {
  final List<BottomNavItem> items;
  final int initialIndex;
  final ValueChanged<int>? onIndexChanged;
  final Color? backgroundColor;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  const BottomNavScaffold({
    Key? key,
    required this.items,
    this.initialIndex = 0,
    this.onIndexChanged,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
  })  : assert(items.length >= 2, 'At least 2 items are required'),
        assert(initialIndex >= 0 && initialIndex < items.length,
            'Initial index out of range'),
        super(key: key);

  @override
  State<BottomNavScaffold> createState() => _BottomNavScaffoldState();
}

class _BottomNavScaffoldState extends State<BottomNavScaffold> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: widget.items.map((item) => item.screen).toList(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          if (widget.onIndexChanged != null) {
            widget.onIndexChanged!(index);
          }
        },
        backgroundColor:
            widget.backgroundColor ?? theme.scaffoldBackgroundColor,
        selectedItemColor:
            widget.selectedItemColor ?? theme.colorScheme.primary,
        unselectedItemColor:
            widget.unselectedItemColor ?? UIConstants.textSecondaryColor,
        selectedLabelStyle:
            const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
        type: BottomNavigationBarType.fixed,
        elevation: UIConstants.elevationMedium,
        items: widget.items
            .map((item) => BottomNavigationBarItem(
                  icon: Icon(item.icon),
                  label: item.label,
                ))
            .toList(),
      ),
      floatingActionButton: widget.floatingActionButton,
      floatingActionButtonLocation: widget.floatingActionButtonLocation,
    );
  }
}
