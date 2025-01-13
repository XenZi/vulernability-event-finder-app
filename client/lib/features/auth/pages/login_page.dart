import 'package:client/core/network/api_client.dart';
import 'package:client/core/theme/app_theme.dart';
import 'package:client/shared/components/button_component.dart';
import 'package:client/shared/components/textfield_component.dart';
import 'package:client/shared/utils/validators.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final apiClient = ApiClient();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  void _login(String email, String password) async {
    // Perform login action
    print("Logging in...");
    final response = await apiClient.post(
      '/login',
      {
        'email': email,
        'password': password,
      },
      null,
    );
    print(response.body);
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    // Request for notification permissions (important for iOS)
    messaging.requestPermission();

    // Get the FCM token when the app starts
    messaging.getToken().then((token) {
      print("FCM Token: $token");
      // Now you can send this token to your backend server for future use
    });

    // Handling foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Received a message: ${message.notification?.title}");
    });
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
                    print("Validation failed");
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
