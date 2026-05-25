import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/category_data.dart';
import '../services/search_service.dart';
import '../services/metadata_service.dart';

class SearchResultsScreen extends StatefulWidget {

  final String query;
  final String country;

  const SearchResultsScreen({
    super.key,
    required this.query,
    required this.country,
  });

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();

}

class _SearchResultsScreenState extends State<SearchResultsScreen> {

  List<Map<String, String>> results = [];

  bool loading = true;

  /// image cache
  Map<String, String?> imageCache = {};

  @override
  void initState() {
    super.initState();
    runSearch();
  }

  /// FLAG FUNCTION
  String getFlag(String country) {

    switch (country) {

      case "India": return "🇮🇳";
      case "United States": return "🇺🇸";
      case "United Kingdom": return "🇬🇧";
      case "United Arab Emirates": return "🇦🇪";
      case "Canada": return "🇨🇦";
      case "Australia": return "🇦🇺";
      case "Germany": return "🇩🇪";
      case "France": return "🇫🇷";
      case "Italy": return "🇮🇹";
      case "Spain": return "🇪🇸";
      case "Netherlands": return "🇳🇱";
      case "Brazil": return "🇧🇷";
      case "Mexico": return "🇲🇽";
      case "Japan": return "🇯🇵";
      case "South Korea": return "🇰🇷";
      case "Singapore": return "🇸🇬";
      case "South Africa": return "🇿🇦";
      case "Turkey": return "🇹🇷";
      case "Indonesia": return "🇮🇩";
      case "Philippines": return "🇵🇭";
      case "Thailand": return "🇹🇭";
      case "Vietnam": return "🇻🇳";
      case "Malaysia": return "🇲🇾";
      case "Saudi Arabia": return "🇸🇦";
      case "Sweden": return "🇸🇪";
      case "Norway": return "🇳🇴";
      case "Denmark": return "🇩🇰";
      case "Finland": return "🇫🇮";
      case "Portugal": return "🇵🇹";
      case "Armenia": return "🇦🇲";
      case "Poland": return "🇵🇱";
      case "Switzerland": return "🇨🇭";

      default:
        return "🌍";

    }

  }

  /// COUNTRY FILTER FUNCTION
  bool matchesCountry(String url, String country) {

    if (country == "India" && url.contains(".in")) return true;
    if (country == "Germany" && url.contains(".de")) return true;
    if (country == "United Kingdom" && url.contains(".co.uk")) return true;
    if (country == "United States" && url.contains(".com")) return true;
    if (country == "France" && url.contains(".fr")) return true;
    if (country == "Italy" && url.contains(".it")) return true;
    if (country == "Spain" && url.contains(".es")) return true;
    if (country == "Netherlands" && url.contains(".nl")) return true;
    if (country == "Japan" && url.contains(".jp")) return true;
    if (country == "Canada" && url.contains(".ca")) return true;
    if (country == "Australia" && url.contains(".au")) return true;

    /// GLOBAL websites allowed everywhere
    if (
        url.contains("aliexpress") ||
        url.contains("ebay") ||
        url.contains("alibaba") ||
        url.contains("rakuten")
    ) {
      return true;
    }

    return false;

  }

  Future<void> runSearch() async {

    final q = widget.query.toLowerCase();

    List<Map<String, String>> searchMatches = [];
    List<Map<String, String>> categoryRemainder = [];
    List<Map<String, String>> webMatches = [];

    String? matchedCategory;

    /// STEP 1: FIND SEARCH MATCHES
    categoryOffers.forEach((category, offers) {

      for (var offer in offers) {

        final name = offer["name"]!.toLowerCase();
        final desc = offer["desc"]!.toLowerCase();

        if (name.contains(q) || desc.contains(q)) {

          searchMatches.add(offer);
          matchedCategory = category;

        }

      }

    });

    /// STEP 2: GET REMAINING WEBSITES FROM SAME CATEGORY
    if (matchedCategory != null) {

      for (var offer in categoryOffers[matchedCategory]!) {

        if (!searchMatches.contains(offer)) {

          categoryRemainder.add(offer);

        }

      }

    }

    /// STEP 3: WEB SEARCH
    final webResults = await SearchService.searchWeb(widget.query);
    webMatches.addAll(webResults);

    /// STEP 4: MERGE RESULTS
    List<Map<String, String>> finalResults = [];

    finalResults.addAll(searchMatches);
    finalResults.addAll(webMatches);
    finalResults.addAll(categoryRemainder);

    /// STEP 5: PRIORITIZE USER COUNTRY
    List<Map<String, String>> preferred = [];
    List<Map<String, String>> others = [];

    for (var item in finalResults) {

      final url = item["url"]!;

      if (matchesCountry(url, widget.country)) {

        preferred.add(item);

      } else {

        others.add(item);

      }

    }

    List<Map<String, String>> sortedResults = [];

    sortedResults.addAll(preferred);
    sortedResults.addAll(others);

    /// STEP 6: LOAD IMAGES
    for (var item in sortedResults) {

      final url = item["url"]!;

      try {

        final image = await MetadataService.fetchImage(url);

        if (image != null && image.startsWith("http")) {

          imageCache[url] = image;

        }

      } catch (e) {

        imageCache[url] = null;

      }

    }

    setState(() {

      results = sortedResults;
      loading = false;

    });

  }

  void openUrl(String url) async {

    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {

      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

    }

  }

  /// AD WIDGET
  Widget adWidget() {

    return Container(

      height: 120,

      margin: const EdgeInsets.symmetric(vertical: 16),

      decoration: BoxDecoration(

        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(15),

      ),

      child: const Center(

        child: Text(
          "Ad Space",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),

      ),

    );

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: Text('Results for "${widget.query}"'),
      ),

      body: loading

          ? const Center(child: CircularProgressIndicator())

          : results.isEmpty

          ? ListView(

        padding: const EdgeInsets.all(20),

        children: [

          const SizedBox(height: 40),

          const Center(
            child: Text(
              "No results found",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 40),

          adWidget(),
          adWidget(),
          adWidget(),
          adWidget(),

        ],

      )

          : ListView.builder(

        padding: const EdgeInsets.all(16),

        itemCount: results.length + (results.length ~/ 4),

        itemBuilder: (context, index) {

          if (index % 5 == 4) {
            return adWidget();
          }

          final realIndex = index - (index ~/ 5);

          if (realIndex >= results.length) {
            return const SizedBox();
          }

          final offer = results[realIndex];

          final imageUrl = imageCache[offer["url"]];

          return GestureDetector(

            onTap: () {
              openUrl(offer["url"]!);
            },

            child: Container(

              margin: const EdgeInsets.only(bottom: 18),

              decoration: BoxDecoration(
                color: const Color(0xFFE6F3EA),
                borderRadius: BorderRadius.circular(20),
              ),

              child: Column(

                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  ClipRRect(

                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),

                    child: Container(

                      height: 160,
                      width: double.infinity,
                      color: Colors.white,

                      child: imageUrl != null

                          ? Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.shopping_bag,
                            size: 50,
                            color: Colors.grey,
                          );
                        },
                      )

                          : const Icon(
                        Icons.shopping_bag,
                        size: 50,
                        color: Colors.grey,
                      ),

                    ),

                  ),

                  Padding(

                    padding: const EdgeInsets.all(14),

                    child: Row(

                      children: [

                        Expanded(

                          child: Column(

                            crossAxisAlignment:
                            CrossAxisAlignment.start,

                            children: [

                              Text(
                                offer["name"] ?? "",
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 6),

                              Text(
                                offer["desc"] ?? "",
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey,
                                ),
                              ),

                              const SizedBox(height: 8),

                              Container(

                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4),

                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                  BorderRadius.circular(20),
                                ),

                                child: Text(

                                  "${getFlag(offer["country"] ?? "")} ${offer["country"] ?? "Global"}",

                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.green,
                                  ),

                                ),

                              ),

                            ],

                          ),

                        ),

                        const Icon(
                          Icons.open_in_new,
                          color: Colors.grey,
                        ),

                      ],

                    ),

                  ),

                ],

              ),

            ),

          );

        },

      ),

    );

  }

}
