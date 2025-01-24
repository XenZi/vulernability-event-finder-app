import 'package:client/core/theme/app_theme.dart';
import 'package:client/shared/models/menu-option.model.dart';
import 'package:flutter/material.dart';

class DynamicSelectionMenu {
  static void show({
    required BuildContext context,
    required List<MenuOption> options,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          color: AppTheme.backgroundColor,
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: options.map((option) {
              return ListTile(
                leading: Icon(option.icon, color: option.iconColor),
                title: Text(
                  option.text,
                  style: const TextStyle(color: AppTheme.textColor),
                ),
                onTap: () {
                  Navigator.pop(context); // Close the menu
                  option.onTap(); // Call the provided function
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
