import 'package:flutter/material.dart';
import 'package:linexo_demo/pages/aufzeichen/scorings_tab.dart';
import '../../helpers/app_localizations.dart';
import 'aufzeichnen_tab.dart';

class AufzeichnenScreen extends StatelessWidget {
  const AufzeichnenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(localizations.translate('aufzeichnen_screen_title')),
          bottom: TabBar(
            indicatorColor: Colors.purple,
            tabs: [
              Tab(text: localizations.translate('aufzeichnen_tab_title')),
              Tab(text: localizations.translate('scorings_tab_title')),
              Tab(text: localizations.translate('touren_tab_title')),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            AufzeichnenTab(),
            ScoringsTab(),
            Center(child: Text('Touren Content')),
          ],
        ),
      ),
    );
  }
}
