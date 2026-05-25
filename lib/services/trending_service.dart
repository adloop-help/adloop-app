import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/trending_article.dart';

class TrendingService {
  final String apiKey = "99cd336da19b3874441451ffa54c1ea8"; // 🔥 replace this

  Future<List<TrendingArticle>> fetchTrending(String keyword) async {
    final url =
        "https://gnews.io/api/v4/search?q=$keyword&lang=en&max=10&apikey=$apiKey";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      List articles = data['articles'];

      return articles
          .map((e) => TrendingArticle.fromJson(e))
          .toList();
    } else {
      throw Exception("Failed to load trends");
    }
  }
}