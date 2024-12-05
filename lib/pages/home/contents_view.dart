import 'package:flutter/material.dart';
import 'package:linexo_demo/pages/sharedUI/ratgeber_screen.dart';
import 'package:provider/provider.dart';
import 'package:linexo_demo/providers/articles_provider.dart';
import 'package:shimmer/shimmer.dart';
import '../widgets/content_card.dart';
import '../../helpers/app_localizations.dart';

class ContentView extends StatefulWidget {
  const ContentView({super.key});

  @override
  _ContentViewState createState() => _ContentViewState();
}

class _ContentViewState extends State<ContentView> {
  String selectedCategory = 'Ausstattung & Zubehör';
  bool showFilters = false;

  @override
  Widget build(BuildContext context) {
    final articlesProvider = Provider.of<ArticlesProvider>(context);
    final localizations = AppLocalizations.of(context);

    if (articlesProvider.isLoading) {
      return Container(
        constraints: const BoxConstraints(maxHeight: 400),
        padding: const EdgeInsets.all(4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  localizations.translate('content_view_title'),
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.filter_alt_outlined,
                    color: Color(0xFF543B85),
                    size: 32,
                  ),
                  onPressed: () {
                    setState(() {
                      showFilters = !showFilters;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 2),
            if (showFilters)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: articlesProvider.categoryArticles.keys.map((category) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        label: Text(category),
                        selected: selectedCategory == category,
                        onSelected: (bool selected) {
                          setState(() {
                            selectedCategory = category;
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
            const SizedBox(height: 6),
            Expanded(
              child: Column(
                children: [
                  Flexible(
                    flex: 6,
                    child: ShimmerLoading(),
                  ),
                  const SizedBox(height: 8),
                  Flexible(
                    flex: 5,
                    child: Row(
                      children: [
                        Expanded(
                          child: ShimmerLoading(),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            children: [
                              Expanded(
                                child: ShimmerLoading(),
                              ),
                              const SizedBox(height: 4),
                              SizedBox(
                                height: 40,
                                child: ShimmerLoading(
                                  height: 40,
                                  width: double.infinity,
                                ),
                              ),
                            ],
                          ),
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

    List<Map<String, String>> currentArticles = articlesProvider.categoryArticles[selectedCategory] ?? [];

    return Container(
      constraints: const BoxConstraints(maxHeight: 400),
      padding: const EdgeInsets.all(4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                localizations.translate('content_view_title'),
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(
                  Icons.filter_alt_outlined,
                  color: Color(0xFF543B85),
                  size: 32,
                ),
                onPressed: () {
                  setState(() {
                    showFilters = !showFilters;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 2),
          if (showFilters)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: articlesProvider.categoryArticles.keys.map((category) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(category),
                      selected: selectedCategory == category,
                      onSelected: (bool selected) {
                        setState(() {
                          selectedCategory = category;
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          const SizedBox(height: 6),
          Expanded(
            child: Column(
              children: [
                Flexible(
                  flex: 6,
                  child: currentArticles.isNotEmpty
                      ? ContentCard(
                    imagePath: currentArticles[0]['image']!,
                    title: currentArticles[0]['title']!,
                  )
                      : Center(child: Text(localizations.translate('no_articles_available'))),
                ),
                const SizedBox(height: 8),
                Flexible(
                  flex: 5,
                  child: currentArticles.length > 1
                      ? Row(
                    children: [
                      Expanded(
                        child: ContentCard(
                          imagePath: currentArticles[1]['image']!,
                          title: currentArticles[1]['title']!,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          children: [
                            Expanded(
                              child: ContentCard(
                                imagePath: currentArticles[2]['image']!,
                                title: currentArticles[2]['title']!,
                              ),
                            ),
                            const SizedBox(height: 4),
                            SizedBox(
                              height: 40,
                              child: ChoiceChip(
                                label: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.arrow_forward, size: 16),
                                    const SizedBox(width: 4),
                                    Text(localizations.translate('more_posts')),
                                  ],
                                ),
                                selected: false,
                                onSelected: (_) {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => const RatgeberScreen(),
                                    ),
                                  );
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                backgroundColor: Colors.white,
                                selectedColor: const Color(0xFF543B85),
                                labelStyle: const TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}


class ShimmerLoading extends StatelessWidget {
  final double width;
  final double height;

  const ShimmerLoading({
    Key? key,
    this.width = double.infinity,
    this.height = 200,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}