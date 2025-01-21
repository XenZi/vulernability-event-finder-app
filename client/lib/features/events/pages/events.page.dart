import 'package:client/core/theme/app_theme.dart';
import 'package:client/shared/components/navbars/navigation_component.dart';
import 'package:client/shared/components/navbars/top_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EventsPage extends StatelessWidget {
  final GoRouterState? goRouterState;

  const EventsPage({super.key, this.goRouterState});

  @override
  Widget build(BuildContext context) {
    final id = goRouterState?.pathParameters['id'];

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: TopNavigationBar(),
      body: Center(
        child: Text(
          'Asset ID For Events Retrieval: $id',
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
