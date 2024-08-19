import 'package:flutter/material.dart';
import '../../helpers/app_localizations.dart';

class UserUIPage extends StatelessWidget {
  const UserUIPage({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.translate('user_page_title')),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Logo Image
            Image.asset(
              'assets/images/logo.png',
              width: 100,
              height: 100,
            ),
            const SizedBox(height: 20),
            // Message
            Text(
              localizations.translate('user_message'), // Use localization
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
