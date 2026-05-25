class WebSearchService {

  static String buildCommercialSearch(String query) {

    query = query.trim().replaceAll(" ", "+");

    // Add commercial keywords automatically
    return "https://www.google.com/search?q=$query+buy+deals+offers+shop";

  }

}