import 'package:flutter/material.dart';
import '../../helpers/app_localizations.dart';

class GuestUIPage extends StatelessWidget {
  const GuestUIPage({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.translate('guest_page_title')),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Image.asset(
              'assets/images/logo.png',
              width: 100,
              height: 100,
            ),
            const SizedBox(height: 20),

            Text(
              localizations.translate('guest_message'),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.black54),
            ),
            const SizedBox(height: 20),
            Text(
              localizations.translate('guest_suggestion'),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
}
