import 'package:client/core/theme/app_theme.dart';
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
      margin: const EdgeInsets.only(bottom: 5.0, left: 16.0, right: 16.0),
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 2.0),
      decoration: BoxDecoration(
        color: AppTheme.darkerBackgroundColor,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 28,
              color: AppTheme.titleColor,
            ),
          ),
          const SizedBox(height: 12.0),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.titleColor,
                ),
          ),
          const SizedBox(height: 8.0),
          Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textColor,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
