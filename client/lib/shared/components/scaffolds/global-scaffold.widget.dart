import 'package:client/core/theme/app_theme.dart';
import 'package:client/shared/components/navbars/bottom-navigation.widget.dart';
import 'package:client/shared/components/navbars/top-navigation-bar.widget.dart';
import 'package:flutter/material.dart';

class GlobalScaffold extends StatelessWidget {
  final Widget child;
  final Widget? floatingActionButton; // Optional parameter for FAB

  const GlobalScaffold({
    super.key,
    required this.child,
    this.floatingActionButton, // Initialize optional parameter
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: TopNavigationBar(),
      body: child,
      bottomNavigationBar: const NavigationComponent(),
      floatingActionButton: floatingActionButton, // Add FAB here
    );
  }
}
