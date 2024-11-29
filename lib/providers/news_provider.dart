import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/article_model.dart';

class NewsProvider with ChangeNotifier {
  List<Article> _articles = [];
  List<Article> _favorites = []; // Initialize as an empty list.
  bool _isLoading = false;
  bool _isDarkMode = false;
  List<Article> _filteredArticles = []; // Store filtered articles

  List<Article> get articles =>
      _filteredArticles.isNotEmpty ? _filteredArticles : _articles;
  List<Article> get favorites => _favorites;
  bool get isLoading => _isLoading;
  bool get isDarkMode => _isDarkMode;

  // Fetch news articles based on category
  Future<void> fetchNews(String category) async {
    final url =
        'https://newsapi.org/v2/top-headlines?category=$category&apiKey=1ef0234e36794fc796fb20e2d6589f80';
    _isLoading = true;
    notifyListeners();
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body)['articles'] as List;
        _articles = data.map((json) => Article.fromJson(json)).toList();
        _filteredArticles =
            List.from(_articles); // Start with all articles unfiltered
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Toggle dark mode on or off
  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  // Sort articles based on criteria (Date or Title)
  void sortArticles(String criteria) {
    if (criteria == 'Date') {
      _filteredArticles.sort((a, b) => b.publishedAt.compareTo(a.publishedAt));
    } else if (criteria == 'Title') {
      _filteredArticles.sort((a, b) => a.title.compareTo(b.title));
    }
    notifyListeners();
  }

  // Filter articles based on title and date
  void filterArticles(String titleQuery, String? date) {
    List<Article> filteredList = _articles;

    // Filter by title query
    if (titleQuery.isNotEmpty) {
      filteredList = filteredList
          .where((article) =>
              article.title.toLowerCase().contains(titleQuery.toLowerCase()))
          .toList();
    }

    // Filter by date if a date is selected
    if (date != null && date.isNotEmpty) {
      filteredList = filteredList
          .where((article) =>
              article.publishedAt.substring(0, 10) ==
              date) // Assuming date format is YYYY-MM-DD
          .toList();
    }

    // Update filtered articles list
    _filteredArticles = filteredList;

    // Notify listeners so UI can update
    notifyListeners();
  }

  // Toggle favorite status for an article
  void toggleFavorite(Article article) {
    if (_favorites.contains(article)) {
      _favorites.remove(article);
    } else {
      _favorites.add(article);
    }
    notifyListeners();
  }

  // Check if an article is marked as favorite
  bool isFavorite(Article article) {
    return _favorites.contains(article);
  }
}
