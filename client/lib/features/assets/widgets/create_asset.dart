import 'package:flutter/material.dart';

class CreateAsset extends StatelessWidget {
  final TextEditingController controller;
  final String buttonText;
  final VoidCallback onPressed;
  final String hintText;

  const CreateAsset({
    super.key,
    required this.controller,
    required this.buttonText,
    required this.onPressed,
    this.hintText = 'Enter text',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: onPressed,
          child: Text(buttonText),
        ),
      ],
    );
  }
}
