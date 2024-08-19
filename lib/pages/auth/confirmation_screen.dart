import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../helpers/app_localizations.dart';
import '../../providers/auth_service.dart';

class ConfirmationPage extends StatefulWidget {
  final String email;
  const ConfirmationPage({super.key, required this.email});

  @override
  _ConfirmationPageState createState() => _ConfirmationPageState();
}

class _ConfirmationPageState extends State<ConfirmationPage> {
  final TextEditingController codeController = TextEditingController();
  bool isCheckboxChecked = false;
  bool isResendButtonDisabled = false;
  int resendCooldown = 15;
  late Timer _timer;

  @override
  void dispose() {
    codeController.dispose();
    if (_timer.isActive) _timer.cancel();
    super.dispose();
  }

  Future<void> verifyEmail() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    try {
      final result = await authService.isEmailVerified(widget.email);
      if (!mounted) return;
      if (result) {
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).translate('email_not_verified'))),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error verifying email: $e')),
        );
      }
    }
  }


  Future<void> resendVerificationEmail() async {
    final authService = Provider.of<AuthService>(context, listen: false);

    final isEmailVerified = await authService.isEmailVerified(widget.email);
    if (isEmailVerified) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).translate('email_already_verified'))),
      );
      return;
    }

    if (isResendButtonDisabled) return;

    try {
      setState(() {
        isResendButtonDisabled = true;
      });
      await authService.resendVerificationEmail(widget.email);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).translate('email_sent'))),
      );

      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          resendCooldown--;
        });

        if (resendCooldown <= 0) {
          timer.cancel();
          setState(() {
            isResendButtonDisabled = false;
            resendCooldown = 15;
          });
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
      setState(() {
        isResendButtonDisabled = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(localizations.translate('email_verification_title'))),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localizations.translate('email_verification_title'),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              localizations.translate('verification_message', {'email': widget.email}),
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Text(
                localizations.translate('change_email'),
                style: const TextStyle(
                  color: Colors.blue,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 20),
            CheckboxListTile(
              value: isCheckboxChecked,
              onChanged: (bool? value) {
                setState(() {
                  isCheckboxChecked = value ?? false;
                });
              },
              title: Text(localizations.translate('email_verified_checkbox')),
            ),
            const SizedBox(height: 20),
            Text(
              localizations.translate('email_not_received_message'),
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: isResendButtonDisabled ? null : resendVerificationEmail,
              child: Text(
                isResendButtonDisabled
                    ? localizations.translate('resend_email_cooldown', {'seconds': resendCooldown.toString()})
                    : localizations.translate('resend_email'),
                style: TextStyle(
                  color: isResendButtonDisabled ? Colors.grey : Colors.blue,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isCheckboxChecked ? () async {
                  await verifyEmail();
                } : null,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: Text(localizations.translate('confirm_button_label')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}