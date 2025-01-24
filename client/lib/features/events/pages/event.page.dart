import 'package:client/core/theme/app_theme.dart';
import 'package:client/shared/components/navbars/navigation_component.dart';
import 'package:client/shared/components/navbars/top_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EventPage extends StatelessWidget {
  final GoRouterState? goRouterState;

  const EventPage({super.key, this.goRouterState});

  @override
  Widget build(BuildContext context) {
    final id = goRouterState?.pathParameters['id'];

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: TopNavigationBar(),
      body: Center(
        child: Text(
          'Event ID For Events Retrieval: $id',
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