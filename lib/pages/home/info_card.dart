import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback? onTap;

  const InfoCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          elevation: 4,
          surfaceTintColor: Colors.white,
          child: ListTile(
            trailing: Icon(icon, color: theme.colorScheme.primary, size: 38),
            title: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: theme.textTheme.headline6?.color,
              ),
            ),
            subtitle: Text(
              description,
              style: TextStyle(
                fontSize: 12,
                color: theme.textTheme.subtitle1?.color,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
