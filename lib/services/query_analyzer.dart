class QueryAnalyzer {

  static bool isProductSearch(String query) {

    final q = query.toLowerCase();

    List<String> productWords = [
      "buy",
      "price",
      "shop",
      "deal",
      "discount",
      "sale",
      "offer",
      "product",
      "order",
      "cheap",
      "best",
      "online"
    ];

    for (var word in productWords) {
      if (q.contains(word)) {
        return true;
      }
    }

    return false;

  }

}

