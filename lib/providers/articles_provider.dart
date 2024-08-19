import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ArticlesProvider with ChangeNotifier {
  bool isLoading = true;
  Map<String, List<Map<String, String>>> categoryArticles = {};

  ArticlesProvider() {
    fetchArticles();
  }

  Future<void> fetchArticles() async {
    try {
      final categoriesSnapshot = await FirebaseFirestore.instance.collection('categories').get();

      final Map<String, List<Map<String, String>>> fetchedArticles = {};

      for (var categoryDoc in categoriesSnapshot.docs) {
        final String categoryName = categoryDoc.id;

        final articlesSnapshot = await categoryDoc.reference.collection(categoryName).get();

        final List<Map<String, String>> articlesList = articlesSnapshot.docs.map((doc) {
          final data = doc.data();
          return {
            'title': data['title']?.toString() ?? 'No title',
            'image': data['image']?.toString() ?? '',
          };
        }).toList();

        fetchedArticles[categoryName] = articlesList;

      }

      categoryArticles = fetchedArticles;
    } catch (e) {
      print(e);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  List<Map<String, String>> get allArticles {
    final allArticlesList = categoryArticles.values.expand((list) => list).toList();
    allArticlesList.shuffle();
    return allArticlesList;
  }
}
