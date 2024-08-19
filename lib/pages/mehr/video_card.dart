import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class VideoCard extends StatelessWidget {
  final String thumbnailUrl;
  final String title;
  final String videoUrl;

  const VideoCard({
    Key? key,
    required this.thumbnailUrl,
    required this.title,
    required this.videoUrl,
  }) : super(key: key);

  void _launchURL(String url) async {
    if (!await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => _launchURL(videoUrl),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.network(
                    thumbnailUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 150,
                  ),
                  const Icon(Icons.play_circle_outline, color: Colors.white, size: 50),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => _launchURL(videoUrl),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: GestureDetector(
                          onTap: () => _launchURL(videoUrl),
                          child: Row(
                            children: [
                              Icon(Icons.arrow_forward, color: theme.primaryColor),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  title,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    color: theme.textTheme.bodyLarge?.color,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.share, color: theme.primaryColor),
                        onPressed: () => Share.share(videoUrl),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
