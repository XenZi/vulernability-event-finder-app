import 'package:client/shared/components/navigation_component.dart';
import 'package:client/shared/components/top_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:client/core/theme/app_theme.dart';

class EventPage extends StatelessWidget {
  const EventPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: TopNavigationBar(),
      body: Center(
        child: Text(
          'Home Page',
          style: TextStyle(
            color: AppTheme.titleColor,
            fontSize: 24,
          ),
        ),
      ),
      bottomNavigationBar: const NavigationComponent(),
    );
  }
}
