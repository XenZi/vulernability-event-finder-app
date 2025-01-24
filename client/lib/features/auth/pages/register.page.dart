import 'dart:io';

import 'package:client/core/network/api_client.dart';
import 'package:client/shared/components/buttons/button.widget.dart';
import 'package:client/shared/components/inputs/textfield_component.dart';
import 'package:client/shared/components/toast/toast.widget.dart';
import 'package:client/shared/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:client/core/theme/app_theme.dart';
import 'package:go_router/go_router.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final apiClient = ApiClient();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _register(String email, String password) async {
    try {
      await apiClient.post(
        '/register',
        {
          'email': email,
          'password': password,
        },
        null,
      );
      context.go('/login');
    } on HttpException catch (e) {
      ToastBar.show(
        context,
        e.message,
        style: ToastBarStyle.error,
      );
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Register",
                style: AppTheme.titleStyle.copyWith(fontSize: 32),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              CustomTextField(
                labelText: "Email",
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                validators: [validateRequiredField, validateEmail],
              ),
              const SizedBox(height: 16),
              CustomTextField(
                labelText: "Password",
                controller: passwordController,
                obscureText: true,
                validators: [validateRequiredField, validatePassword],
              ),
              const SizedBox(height: 24),
              CustomButton(
                label: "Register",
                onPressed: () {
                  if (!formKey.currentState!.validate()) {
                    return;
                  }
                  _register(emailController.text, passwordController.text);
                },
                styleType: ButtonStyleType.solid,
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  context.go('/login');
                },
                child: RichText(
                  text: TextSpan(
                    text: "Already have an account? ",
                    style: AppTheme.bodyTextStyle.copyWith(
                      color: AppTheme.textColor,
                    ),
                    children: [
                      TextSpan(
                        text: "Login",
                        style: AppTheme.bodyTextStyle.copyWith(
                          color: AppTheme.titleColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
