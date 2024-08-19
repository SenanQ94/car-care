import 'package:flutter/material.dart';

class MyCard extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color? iconColor;
  final String? subtext;
  final VoidCallback? onTap;

  const MyCard({
    super.key,
    required this.icon,
    required this.text,
    this.iconColor,
    this.subtext,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      surfaceTintColor: theme.cardColor,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: Row(
            children: [
              Icon(
                icon,
                color: iconColor ?? theme.iconTheme.color,
                size: 22,
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.textTheme.bodyLarge?.color,
                      fontWeight: FontWeight.w500,
                      fontSize: 14
                    ),
                  ),
                  if (subtext != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        subtext!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.textTheme.bodySmall?.color,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
