import 'package:client/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigationComponent extends StatelessWidget {
  const NavigationComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: AppTheme.titleColor, // Replace with your desired color
            width: 1.0, // 1px border
          ),
        ),
      ),
      child: BottomNavigationBar(
        backgroundColor: AppTheme.backgroundColor,
        selectedItemColor: AppTheme.titleColor,
        unselectedItemColor: AppTheme.textColor,
        elevation: 0, // Elevation can be set to 0 for a flat design
        iconSize: 28.0,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              context.go('/home');
              break;
            case 1:
              context.go('/settings');
              break;
          }
        },
      ),
    );
  }
}
