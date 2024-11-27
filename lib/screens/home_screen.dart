import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/news_provider.dart';
import '../widgets/article_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> categories = [
    'Business',
    'Technology',
    'Sports',
    'Health',
    'Entertainment'
  ];
  String _selectedCategory = 'Business';

  @override
  void initState() {
    super.initState();
    final newsProvider = Provider.of<NewsProvider>(context, listen: false);
    newsProvider.fetchNews(_selectedCategory);
  }

  void _filterArticles(String query) {
    final newsProvider = Provider.of<NewsProvider>(context, listen: false);
    if (query.isEmpty) {
      setState(() {});
    } else {
      setState(() {
        newsProvider.articles.retainWhere(
          (article) =>
              article.title.toLowerCase().contains(query.toLowerCase()),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final newsProvider = Provider.of<NewsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('News App'),
        actions: [
          IconButton(
            icon: Icon(
                newsProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode),
            onPressed: newsProvider.toggleDarkMode,
          ),
        ],
      ),
      body: Column(
        children: [
          // Category Selector
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: categories.map((category) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategory = category;
                      newsProvider.fetchNews(category);
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: _selectedCategory == category
                          ? Colors.blue
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(category,
                        style: const TextStyle(color: Colors.white)),
                  ),
                );
              }).toList(),
            ),
          ),
          // Sort Dropdown
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: 'Date',
              items: ['Date', 'Title'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text('Sort by $value'),
                );
              }).toList(),
              onChanged: (value) {
                newsProvider.sortArticles(value!);
              },
            ),
          ),
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search news...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onChanged: _filterArticles,
            ),
          ),
          // Articles List
          Expanded(
            child: newsProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: newsProvider.articles.length,
                    itemBuilder: (context, index) {
                      return ArticleCard(article: newsProvider.articles[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
