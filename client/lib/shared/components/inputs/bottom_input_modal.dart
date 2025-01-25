import 'package:client/core/theme/app.theme.dart';
import 'package:client/shared/components/buttons/button.widget.dart';
import 'package:client/shared/components/inputs/textfield_component.dart';
import 'package:flutter/material.dart';

class BottomInputModal extends StatefulWidget {
  final String title;
  final TextEditingController textController;
  final String hintText;
  final void Function(String) onSubmit;
  final List<String? Function(String?)>? validators;

  const BottomInputModal({
    required this.title,
    required this.textController,
    required this.hintText,
    required this.onSubmit,
    this.validators,
    super.key,
  });

  @override
  BottomInputModalState createState() => BottomInputModalState();
}

class BottomInputModalState extends State<BottomInputModal> {
  String? validationError;

  void _handleSubmit() {
    final input = widget.textController.text;
    String? error;

    if (widget.validators != null) {
      for (var validator in widget.validators!) {
        error = validator(input);
        if (error != null) {
          break;
        }
      }
    }

    setState(() {
      validationError = error;
    });

    if (error == null) {
      widget.onSubmit(input);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.backgroundColor.withOpacity(0.9),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 10,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.titleColor,
            ),
          ),
          const SizedBox(height: 10),
          CustomTextField(
            labelText: widget.title,
            controller: widget.textController,
            hintText: widget.hintText,
            validators: widget.validators,
          ),
          if (validationError != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                validationError!,
                style: const TextStyle(color: Colors.red, fontSize: 14),
              ),
            ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerRight,
            child: CustomButton(
              label: 'Submit',
              onPressed: _handleSubmit,
              styleType: ButtonStyleType.solid,
            ),
          ),
        ],
      ),
    );
  }
}
