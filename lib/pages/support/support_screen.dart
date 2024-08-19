import 'package:flutter/material.dart';
import 'package:linexo_demo/pages/support/contact_form_screen.dart';
import 'package:linexo_demo/pages/support/faq_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:linexo_demo/helpers/app_localizations.dart';
import '../widgets/my_card.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  void _callDeveloper(BuildContext context) {
    const phoneNumber = '+491776461077';
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                AppLocalizations.of(context).translate('call_phone_number', {'phoneNumber': phoneNumber}),
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                onPressed: () async {
                  const url = 'tel:$phoneNumber';
                  if (!await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication)) {
                    throw 'Could not launch $url';
                  }
                },
                child: Text(AppLocalizations.of(context).translate('call')),
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  side: BorderSide(color: Theme.of(context).colorScheme.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(AppLocalizations.of(context).translate('cancel')),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('support')),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            MyCard(
              icon: Icons.help_outline,
              text: AppLocalizations.of(context).translate('frequently_asked_questions'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const FAQScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            MyCard(
              icon: Icons.alternate_email,
              text: AppLocalizations.of(context).translate('contact_form'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ContactFormScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            MyCard(
              icon: Icons.chat_bubble_outline,
              text: AppLocalizations.of(context).translate('live_chat'),
              subtext: AppLocalizations.of(context).translate('live_chat_hours'),
              onTap: () {
                // Navigate to Live Chat page
              },
            ),
            const SizedBox(height: 16),
            MyCard(
              icon: Icons.phone_outlined,
              text: AppLocalizations.of(context).translate('customer_service'),
              subtext: AppLocalizations.of(context).translate('customer_service_hours'),
              onTap: () {
                _callDeveloper(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
