class AffiliateSearchService {

  static List<Map<String, String>> generateSearchLinks(String query) {

    query = query.toLowerCase().replaceAll(" ", "+");

    return [

      {
        "name": "Amazon",
        "desc": "Shop deals on Amazon",
        "url": "https://www.amazon.in/s?k=$query"
      },

      {
        "name": "Flipkart",
        "desc": "Browse products on Flipkart",
        "url": "https://www.flipkart.com/search?q=$query"
      },

      {
        "name": "IndiaMart",
        "desc": "Industrial products marketplace",
        "url": "https://dir.indiamart.com/search.mp?ss=$query"
      },

      {
        "name": "Alibaba",
        "desc": "Global wholesale marketplace",
        "url": "https://www.alibaba.com/trade/search?SearchText=$query"
      },

      {
        "name": "eBay",
        "desc": "International marketplace",
        "url": "https://www.ebay.com/sch/i.html?_nkw=$query"
      },

      {
        "name": "Walmart",
        "desc": "Online retail store",
        "url": "https://www.walmart.com/search?q=$query"
      },

      {
        "name": "BestBuy",
        "desc": "Electronics store",
        "url": "https://www.bestbuy.com/site/searchpage.jsp?st=$query"
      },

      {
        "name": "AliExpress",
        "desc": "Affordable online products",
        "url": "https://www.aliexpress.com/wholesale?SearchText=$query"
      },

    ];

  }

}
