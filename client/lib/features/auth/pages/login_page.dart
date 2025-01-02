import 'package:client/shared/components/button_component.dart';
import 'package:client/shared/components/textfield_component.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Title
            Text(
              "Login",
              style: AppTheme.titleStyle.copyWith(fontSize: 32),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Email Input
            CustomTextField(
              labelText: "Email",
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),

            // Password Input
            CustomTextField(
              labelText: "Password",
              controller: passwordController,
              obscureText: true,
            ),
            const SizedBox(height: 24),

            // Login Button
            CustomButton(
              label: "Login",
              onPressed: () {
                print("Login with Email: ${emailController.text}");
              },
              styleType: ButtonStyleType.solid,
            ),
            const SizedBox(height: 16),

            // Register Link
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              child: Text(
                "Don't have an account? Register",
                style: AppTheme.bodyTextStyle.copyWith(
                  decoration: TextDecoration.underline,
                  color: AppTheme.titleColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
