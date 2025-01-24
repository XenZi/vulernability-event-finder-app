import 'dart:convert';
import 'dart:io';

import 'package:client/core/network/api_client.dart';
import 'package:client/core/security/secure_storage.dart';
import 'package:client/features/auth/providers/user.provider.dart';
import 'package:client/shared/components/buttons/button.widget.dart';
import 'package:client/shared/components/inputs/textfield_component.dart';
import 'package:client/shared/components/toast/toast.widget.dart';
import 'package:client/shared/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:client/core/theme/app_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends ConsumerState<LoginPage> {
  final apiClient = ApiClient();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final bool checkIfUserIsLogged = false;
  @override
  void initState() {
    redirectToAnotherPageIfUserIsAlreadyLogged();
    super.initState();
  }

  Future<void> redirectToAnotherPageIfUserIsAlreadyLogged() async {
    bool isTokenLoaded = await SecureStorage.loadToken() != null ? true : false;
    if (isTokenLoaded) {
      context.go("/");
    }
  }

  void _login(String email, String password) async {
    if (!mounted) return; // Ensure the widget is still mounted at the start.

    try {
      final response = await apiClient.post(
        '/login',
        {
          'email': email,
          'password': password,
        },
        null,
      );
      final responseData = json.decode(response.body);
      await SecureStorage.saveToken(responseData['token']);

      ref.read(userProvider.notifier).updateEmail(email);

      if (mounted) {
        context.go('/');
      }
    } on HttpException catch (e) {
      if (mounted) {
        // Check again before using context.
        ToastBar.show(
          context,
          e.message,
          style: ToastBarStyle.error,
        );
      }
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
                "Login",
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
                label: "Login",
                onPressed: () {
                  if (!formKey.currentState!.validate()) {
                    return;
                  }
                  _login(emailController.text, passwordController.text);
                },
                styleType: ButtonStyleType.solid,
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  context.go('/register');
                },
                child: RichText(
                  text: TextSpan(
                    text: "Don't have an account? ",
                    style: AppTheme.bodyTextStyle.copyWith(
                      color: AppTheme.textColor,
                    ),
                    children: [
                      TextSpan(
                        text: "Register",
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
