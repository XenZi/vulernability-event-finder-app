import 'package:client/core/theme/app.theme.dart';
import 'package:flutter/material.dart';

class BoxWithTitle extends StatelessWidget {
  final Widget child;
  final String title;
  const BoxWithTitle({super.key, required this.child, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color:
            AppTheme.darkerBackgroundColor, // Background color from the theme
        borderRadius: BorderRadius.circular(12.0), // Rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2), // Subtle shadow
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title, // Title of the child container
            style: TextStyle(
                fontSize: 16,
                color: AppTheme.titleColor,
                fontWeight:
                    FontWeight.bold), // Use the title style from the theme
          ),
          const SizedBox(height: 8), // Spacing between title and child
          Flexible(
            child: child, // Embed the graph widget passed as a parameter
          ),
        ],
      ),
    );
  }
}
