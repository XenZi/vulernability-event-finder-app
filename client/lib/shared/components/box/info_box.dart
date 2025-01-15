import 'package:client/core/theme/app_theme.dart';
import 'package:client/shared/components/circle_icon.dart';
import 'package:flutter/material.dart';

class InfoBox extends StatelessWidget {
  final String title;
  final IconData icon;
  final String text;

  const InfoBox({
    super.key,
    required this.title,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppTheme.darkerBackgroundColor,
        borderRadius: BorderRadius.circular(12.0),
      ),
      // width: 150,
      child: Column(
        children: [
          CircleIconButton(icon: icon, color: AppTheme.titleColor),
          const SizedBox(height: 8.0),
          Text(
            title,
            style: TextStyle(
              color: AppTheme.titleColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            text,
            style: TextStyle(
              color: AppTheme.textColor,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
