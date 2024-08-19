import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../providers/articles_provider.dart';
import '../widgets/content_card.dart';
import '../../helpers/app_localizations.dart'; // Import the localization helper

class RatgeberScreen extends StatefulWidget {
  const RatgeberScreen({super.key});

  @override
  _RatgeberScreenState createState() => _RatgeberScreenState();
}

class _RatgeberScreenState extends State<RatgeberScreen> {
  String selectedCategory = '';

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final articlesProvider = Provider.of<ArticlesProvider>(context);

    if (articlesProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    List<Map<String, String>> currentArticles = selectedCategory.isEmpty
        ? articlesProvider.allArticles
        : articlesProvider.categoryArticles[selectedCategory] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.translate('articles_screen_title')),
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
                      label: Text(localizations.translate('all')),
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
                  ...articlesProvider.categoryArticles.keys.map((category) {
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
              child: currentArticles.isNotEmpty
                  ? MasonryGridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                itemCount: currentArticles.length,
                itemBuilder: (context, index) {
                  final article = currentArticles[index];
                  final imagePath = article['image'] ?? '';
                  final title = article['title'] ?? '';

                  return ContentCard(
                    grid: true,
                    imagePath: imagePath,
                    title: title,
                  );
                },
              )
                  : Center(
                child: Text(localizations.translate('no_articles_available')),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
