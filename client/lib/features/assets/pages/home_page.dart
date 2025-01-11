import 'package:client/shared/components/bottom_input_modal.dart';
import 'package:client/shared/components/button_component.dart';
import 'package:client/shared/components/navigation_component.dart';
import 'package:client/shared/components/top_navigation_bar.dart';
import 'package:client/shared/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:client/core/theme/app_theme.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: TopNavigationBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Home Page',
              style: TextStyle(
                color: AppTheme.titleColor,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 20),
            CustomButton(
              label: 'Open Input Form',
              onPressed: () => _showInputModal(context),
              styleType: ButtonStyleType.solid,
            ),
            CustomButton(
              label: 'Go Towards Another Page',
              onPressed: () => context.go('/assets'),
              styleType: ButtonStyleType.solid,
            ),
          ],
        ),
      ),
      bottomNavigationBar: const NavigationComponent(),
    );
  }

  void _showInputModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {
        return BottomInputModal(
          title: 'Enter Asset Address',
          textController: TextEditingController(),
          hintText: 'Type something...',
          validators: [validateRequiredField, validateIPAddress],
          onSubmit: (input) {
            if (input.isNotEmpty) {
              print('User Input: $input');
              Navigator.pop(context);
            } else {
              print('Input is required.');
            }
          },
        );
      },
    );
  }
}
