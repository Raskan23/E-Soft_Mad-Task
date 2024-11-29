import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/news_provider.dart';
import '../widgets/article_card.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> categories = [
    'Business',
    'Technology',
    'Sports',
    'Health',
    'Entertainment'
  ];
  String _selectedCategory = 'Business';
  String? _selectedDate;
  String _titleQuery = '';

  @override
  void initState() {
    super.initState();
    final newsProvider = Provider.of<NewsProvider>(context, listen: false);
    newsProvider.fetchNews(_selectedCategory);
  }

  // This function will be used to filter articles by title and date
  void _filterArticles() {
    final newsProvider = Provider.of<NewsProvider>(context, listen: false);
    newsProvider.filterArticles(_titleQuery, _selectedDate);
  }

  // Function to pick date from the date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null && pickedDate != DateTime.now()) {
      setState(() {
        _selectedDate = "${pickedDate.toLocal()}"
            .split(' ')[0]; // Get date in YYYY-MM-DD format
      });
      _filterArticles(); // Apply filter after selecting date
    }
  }

  @override
  Widget build(BuildContext context) {
    final newsProvider = Provider.of<NewsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('CategoryScreen'),
        actions: [],
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
          // Title Input Box
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search by Title',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  _titleQuery = value;
                });
              },
            ),
          ),
          // Submit Button to trigger search
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ElevatedButton(
              onPressed: _filterArticles,
              child: const Text('Submit'),
            ),
          ),
          // Date Picker for manual date entry
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(
                  _selectedDate != null
                      ? 'Selected Date: $_selectedDate'
                      : 'No Date Selected',
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context),
                ),
              ],
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
