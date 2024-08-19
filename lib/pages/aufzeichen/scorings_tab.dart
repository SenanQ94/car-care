import 'package:flutter/material.dart';
import '../../helpers/app_localizations.dart'; // Update the import to match the location of AppLocalizations

class ScoringsTab extends StatelessWidget {
  const ScoringsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                buildScoringCard(
                  context,
                  icon: Icons.fitness_center_outlined,
                  title: localizations.translate('scorings_tab_activity_title'),
                  subtitle: localizations.translate('scorings_tab_activity_subtitle'),
                  expandedContent: [
                    buildExpandedText(localizations.translate('scorings_tab_today'), '0,00 km'),
                    buildExpandedText(localizations.translate('scorings_tab_this_week'), '0,00 km'),
                    buildExpandedText(localizations.translate('scorings_tab_this_month'), '0,00 km'),
                    buildExpandedText(localizations.translate('scorings_tab_this_year'), '0,00 km'),
                  ],
                ),
                buildScoringCard(
                  context,
                  icon: Icons.route_outlined,
                  title: localizations.translate('scorings_tab_total_distance_title'),
                  subtitle: localizations.translate('scorings_tab_total_distance_subtitle'),
                ),
                buildScoringCard(
                  context,
                  icon: Icons.access_time,
                  title: localizations.translate('scorings_tab_total_duration_title'),
                  subtitle: localizations.translate('scorings_tab_total_duration_subtitle'),
                ),
                buildScoringCard(
                  context,
                  icon: Icons.timer_outlined,
                  title: localizations.translate('scorings_tab_average_title'),
                  subtitle: localizations.translate('scorings_tab_average_subtitle'),
                ),
                buildScoringCard(
                  context,
                  icon: Icons.location_on_outlined,
                  title: localizations.translate('scorings_tab_longest_tour_title'),
                  subtitle: localizations.translate('scorings_tab_longest_tour_subtitle'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildScoringCard(BuildContext context,
      {required IconData icon,
        required String title,
        required String subtitle,
        List<Widget>? expandedContent}) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: ExpansionTile(
        shape: const Border(),
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF2E0061),
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(title, style: const TextStyle(fontSize: 16)),
        subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey)),
        children: expandedContent ?? [],
      ),
    );
  }

  Widget buildExpandedText(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(color: Colors.black)),
        ],
      ),
    );
  }
}
