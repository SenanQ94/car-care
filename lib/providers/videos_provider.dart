import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VideoProvider with ChangeNotifier {
  bool isLoading = true;
  Map<String, List<Map<String, String>>> categoryVideos = {};

  VideoProvider() {
    fetchVideos();
  }

  Future<void> fetchVideos() async {
    try {
      // Fetch all category documents
      final categoriesSnapshot = await FirebaseFirestore.instance.collection('youtubeVideos').get();

      final Map<String, List<Map<String, String>>> fetchedVideos = {};

      for (var categoryDoc in categoriesSnapshot.docs) {
        final String categoryName = categoryDoc.id;

        // Fetch videos within this category
        final videosList = (categoryDoc.data()['videos'] as List<dynamic>?)
            ?.map((video) {
          final videoData = video as Map<String, dynamic>;
          return {
            'title': videoData['title']?.toString() ?? 'No title',
            'url': videoData['url']?.toString() ?? '',
            'thumbnail': videoData['thumbnail']?.toString() ?? '',
          };
        })
            .toList() ?? [];

        fetchedVideos[categoryName] = videosList;
      }

      categoryVideos = fetchedVideos;
    } catch (e) {
      print('Error fetching videos: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  List<Map<String, String>> get allVideos {
    // Combine videos from all categories and shuffle
    final allVideosList = categoryVideos.values.expand((list) => list).toList();
    allVideosList.shuffle();
    return allVideosList;
  }

  List<Map<String, String>> getVideosByCategory(String category) {
    return categoryVideos[category] ?? [];
  }
}
