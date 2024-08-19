import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../helpers/app_localizations.dart';
import '../../providers/auth_service.dart';
import '../home_page.dart';
import 'confirmation_screen.dart';

class LoginAsGuestPage extends StatefulWidget {
  const LoginAsGuestPage({super.key});

  @override
  _LoginAsGuestPageState createState() => _LoginAsGuestPageState();
}

class _LoginAsGuestPageState extends State<LoginAsGuestPage> {
  final TextEditingController emailController = TextEditingController();
  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    emailController.addListener(() {
      setState(() {
        isButtonEnabled = emailController.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  bool isValidEmail(String email) {
    final RegExp emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return emailRegex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(localizations.translate('login_guest_title'))),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localizations.translate('login_guest_title'),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: localizations.translate('enter_email_label'),
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isButtonEnabled
                    ? () async {
                  final String email = emailController.text;
                  if (isValidEmail(email)) {
                    final authService = Provider.of<AuthService>(context, listen: false);
                    try {
                      await authService.sendGuestLoginEmail(email);
                      final isVerified = await Navigator.push<bool>(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ConfirmationPage(email: email),
                        ),
                      );
                      if (isVerified ?? false) {
                        // Redirect to the homepage if verified
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomePage(),
                          ),
                        );
                      } else {
                        // Show a message or stay on the same page
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(localizations.translate('email_not_verified'))),
                        );
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(e.toString())),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(localizations.translate('email_invalid'))),
                    );
                  }
                }
                    : null,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: Text(localizations.translate('confirm_button')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


