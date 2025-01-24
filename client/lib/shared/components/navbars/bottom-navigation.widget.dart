import 'package:client/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigationComponent extends StatelessWidget {
  const NavigationComponent({super.key});

  static const List<_NavItem> _navItems = [
    _NavItem(icon: Icons.home, label: 'Home', route: '/'),
    _NavItem(icon: Icons.devices, label: 'Assets', route: '/assets'),
    _NavItem(icon: Icons.exit_to_app, label: 'Logout', route: '/logout'),
  ];

  @override
  Widget build(BuildContext context) {
    final String currentPath =
        GoRouter.of(context).routeInformationProvider.value.uri.path;
    final int currentIndex =
        _navItems.indexWhere((item) => item.route == currentPath);
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: AppTheme.titleColor,
            width: 1.0,
          ),
        ),
      ),
      child: BottomNavigationBar(
        backgroundColor: AppTheme.backgroundColor,
        selectedItemColor: AppTheme.titleColor,
        unselectedItemColor: AppTheme.textColor,
        elevation: 0,
        iconSize: 28.0,
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex == -1 ? 0 : currentIndex,
        items: _navItems
            .map((navItem) => BottomNavigationBarItem(
                  icon: Icon(navItem.icon),
                  label: navItem.label,
                ))
            .toList(),
        onTap: (index) {
          if (_navItems[index].route != currentPath) {
            context.go(_navItems[index]
                .route); // Navigate only if the route is different
          }
        },
      ),
    );
  }
}

// Navigation item definition
class _NavItem {
  final IconData icon;
  final String label;
  final String route;

  const _NavItem(
      {required this.icon, required this.label, required this.route});
}
