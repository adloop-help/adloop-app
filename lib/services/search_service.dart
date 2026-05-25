class SearchService {

  static Future<List<Map<String, String>>> searchWeb(String query) async {

    final searchQuery =
        "$query deals offers discount buy online";

    final q = Uri.encodeComponent(searchQuery);

    return [

      {
        "name": "Amazon",
        "desc": "$query deals on Amazon",
        "url": "https://www.amazon.in/s?k=$q"
      },

      {
        "name": "Flipkart",
        "desc": "$query offers on Flipkart",
        "url": "https://www.flipkart.com/search?q=$q"
      },

      {
        "name": "Google Shopping",
        "desc": "$query discounts and deals",
        "url": "https://www.google.com/search?q=$q"
      },

      {
        "name": "BestBuy",
        "desc": "$query products and offers",
        "url":
            "https://www.bestbuy.com/site/searchpage.jsp?st=${Uri.encodeComponent(query)}"
      },

      {
        "name": "eBay",
        "desc": "$query items and auctions",
        "url":
            "https://www.ebay.com/sch/i.html?_nkw=${Uri.encodeComponent(query)}"
      }

    ];

  }

}