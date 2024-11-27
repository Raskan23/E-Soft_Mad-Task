import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/article_model.dart';

class NewsProvider with ChangeNotifier {
  List<Article> _articles = [];
  List<Article> _favorites = []; // Initialize as an empty list.
  bool _isLoading = false;
  bool _isDarkMode = false;

  List<Article> get articles => _articles;
  List<Article> get favorites =>
      _favorites; // Add getter for favorites if needed.
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
      _articles.sort((a, b) => b.publishedAt.compareTo(a.publishedAt));
    } else if (criteria == 'Title') {
      _articles.sort((a, b) => a.title.compareTo(b.title));
    }
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
    return _favorites.contains(article); // Ensure it returns a bool.
  }
}
