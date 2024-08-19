import 'package:flutter/material.dart';

class ContentCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final bool grid;

  const ContentCard({
    super.key,
    required this.imagePath,
    required this.title,
    this.grid = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 4,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: grid ? StackFit.loose : StackFit.expand,
          children: [
            Image.network(
              imagePath,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) {
                if (progress == null) {
                  return child;
                } else {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(theme.primaryColor),
                    ),
                  );
                }
              },
              errorBuilder: (context, error, stackTrace) {
                return Center(
                  child: Icon(Icons.error, color: theme.colorScheme.error),
                );
              },
            ),
            // Overlay for the title
            Positioned(
              bottom: 8,
              left: 8,
              child: Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontSize: 12,
                  shadows: [
                    Shadow(
                      offset: Offset(0, 1),
                      blurRadius: 2,
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
