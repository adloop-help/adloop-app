import 'dart:convert';
import 'package:http/http.dart' as http;

class ProductService {
  final String apiKey = "5b5fe7fbe4mshe307391b8a84d05p1e7a52jsn96a3e19fbf93";

  Future<List<dynamic>> fetchProducts(String keyword) async {
    final url = Uri.parse(
      "https://real-time-product-search.p.rapidapi.com/search-v2?q=$keyword&country=US&language=en"
    );

    try {
      final response = await http
          .get(
            url,
            headers: {
              "X-RapidAPI-Key": apiKey,
              "X-RapidAPI-Host": "real-time-product-search.p.rapidapi.com",
            },
          )
          .timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        return data['data']?['products'] ??
               data['products'] ??
               data['results'] ??
               [];
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  /// ✅ MULTI KEYWORD SUPPORT (ADDED)
  Future<List<dynamic>> fetchMultipleProducts(List<String> keywords) async {
    List<dynamic> allProducts = [];

    for (String keyword in keywords) {
      final products = await fetchProducts(keyword);
      allProducts.addAll(products);

      await Future.delayed(const Duration(milliseconds: 300));
    }

    return allProducts;
  }
}
