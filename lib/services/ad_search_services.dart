import '../data/category_data.dart';

class AdSearchService {

  static List<Map<String, String>> searchCategoryLinks(String query) {

    query = query.toLowerCase();

    List<Map<String, String>> results = [];

    categoryOffers.forEach((category, offers) {

      for (var offer in offers) {

        final name = offer["name"]!.toLowerCase();
        final desc = offer["desc"]!.toLowerCase();

        if (name.contains(query) || desc.contains(query)) {
          results.add(offer);
        }

      }

    });

    return results;
  }

}