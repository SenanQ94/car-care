import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/videos_provider.dart';
import 'video_card.dart';

class VideoScreen extends StatefulWidget {
  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  String selectedCategory = '';

  @override
  Widget build(BuildContext context) {
    final videoProvider = Provider.of<VideoProvider>(context);

    if (videoProvider.isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Videos'),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    List<Map<String, String>> currentVideos = selectedCategory.isEmpty
        ? videoProvider.allVideos
        : videoProvider.getVideosByCategory(selectedCategory);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Videos'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: const Text('All'),
                      selected: selectedCategory.isEmpty,
                      onSelected: (bool selected) {
                        if (selected) {
                          setState(() {
                            selectedCategory = '';
                          });
                        }
                      },
                    ),
                  ),
                  ...videoProvider.categoryVideos.keys.map((category) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        label: Text(category),
                        selected: selectedCategory == category,
                        onSelected: (bool selected) {
                          if (selected) {
                            setState(() {
                              selectedCategory = category;
                            });
                          }
                        },
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: currentVideos.isNotEmpty
                  ? ListView.builder(
                      itemCount: currentVideos.length,
                      itemBuilder: (context, index) {
                        final video = currentVideos[index];
                        return VideoCard(
                          thumbnailUrl: video['thumbnail']!,
                          title: video['title']!,
                          videoUrl: video['url']!,
                        );
                      },
                    )
                  : const Center(
                      child: Text('No videos available'),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
