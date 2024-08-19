import 'package:flutter/material.dart';
import '../../helpers/app_localizations.dart'; // Update the import to match the location of AppLocalizations

class AufzeichnenTab extends StatelessWidget {
  const AufzeichnenTab({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);

    return Column(
      children: [
        Row(
          children: [
            // The first two cards side by side
            Expanded(child: AufzeichnenCard(
                title: localizations.translate('aufzeichnen_tab_distance_title'),
                value: '0,0'
            )),
            Expanded(child: AufzeichnenCard(
                title: localizations.translate('aufzeichnen_tab_average_speed_title'),
                value: '0,0'
            )),
          ],
        ),
        SizedBox(
          width: double.infinity,
          child: AufzeichnenCard(
              title: localizations.translate('aufzeichnen_tab_speed_title'),
              value: '0,0'
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: AufzeichnenCard(
              title: localizations.translate('aufzeichnen_tab_time_title'),
              value: '00:00:00'
          ),
        ),
      ],
    );
  }
}

class AufzeichnenCard extends StatelessWidget {
  final String title;
  final String value;

  const AufzeichnenCard({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        height: 150,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(value, style: const TextStyle(fontSize: 32)),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontSize: 14, color: Colors.black87)),
          ],
        ),
      ),
    );
  }
}
