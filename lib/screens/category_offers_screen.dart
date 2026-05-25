import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;

class CategoryOffersScreen extends StatefulWidget {
  final String category;
  final String country;

  const CategoryOffersScreen({
    super.key,
    required this.category,
    required this.country,
  });

  @override
  State<CategoryOffersScreen> createState() =>
      _CategoryOffersScreenState();
}

class _CategoryOffersScreenState extends State<CategoryOffersScreen> {
  List<Map<String, String>> allOffers = [];
  List<Map<String, String>> filteredOffers = [];

  bool isLoading = true;

  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    fetchCategoryData();
  }

  Future<void> fetchCategoryData() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://adloop-categories-data.s3.ap-south-1.amazonaws.com/categories.json',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        List<Map<String, String>> loadedOffers =
            List<Map<String, dynamic>>.from(
          data[widget.category] ?? [],
        ).map((item) {
          return {
            "name": item["name"]?.toString() ?? "",
            "desc": item["desc"]?.toString() ?? "",
            "url": item["url"]?.toString() ?? "",
            "country": item["country"]?.toString() ?? "Global",
          };
        }).toList();

        if (widget.country != "ALL") {
          loadedOffers.sort((a, b) {
            final aCountry = a["country"] ?? "";
            final bCountry = b["country"] ?? "";

            if (aCountry == widget.country &&
                bCountry != widget.country) {
              return -1;
            }

            if (aCountry != widget.country &&
                bCountry == widget.country) {
              return 1;
            }

            return 0;
          });
        }

        setState(() {
          allOffers = loadedOffers;
          filteredOffers = loadedOffers;
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("S3 Fetch Error: $e");

      setState(() {
        isLoading = false;
      });
    }
  }

  /// 🔥 AD WIDGET
  Widget buildAd() {
    BannerAd banner = BannerAd(
      adUnitId: 'ca-app-pub-4436630342078093/6037074740',
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(),
    )..load();

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      alignment: Alignment.center,
      child: SizedBox(
        width: banner.size.width.toDouble(),
        height: banner.size.height.toDouble(),
        child: AdWidget(ad: banner),
      ),
    );
  }

  /// 🔥 CARD UI
  Widget buildCard(Map<String, String> offer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFE6F3EA),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          /// ICON
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                "https://www.google.com/s2/favicons?sz=128&domain=${offer["url"]!.replaceAll("https://", "").replaceAll("http://", "").split("/")[0]}",
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.public, color: Colors.grey);
                },
              ),
            ),
          ),

          const SizedBox(width: 12),

          /// TEXT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  offer["name"]!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  offer["desc"]!,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 6),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    offer["country"] ?? "Global",
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.green,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Icon(Icons.open_in_new, color: Colors.grey),
        ],
      ),
    );
  }

  /// 🔍 SEARCH FILTER
  void filterSearch(String query) {
    setState(() {
      searchQuery = query.toLowerCase();

      filteredOffers = allOffers.where((offer) {
        final name = offer["name"]!.toLowerCase();
        final desc = offer["desc"]!.toLowerCase();

        return name.contains(searchQuery) ||
            desc.contains(searchQuery);
      }).toList();
    });
  }

  /// 🌐 OPEN URL
  Future<void> openUrl(String url) async {
    final Uri uri = Uri.parse(url);

    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception("Could not launch $url");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),

        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.category,
              style: const TextStyle(
                color: Color(0xFF00C853),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            Text(
              widget.country,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),

      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF00C853),
              ),
            )
          : Column(
              children: [
                /// SEARCH BAR
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    onChanged: filterSearch,
                    decoration: InputDecoration(
                      hintText: "Search websites...",
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: const Color(0xFFF1F1F1),

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),

                /// CONTENT
                Expanded(
                  child: filteredOffers.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment:
                                MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.search_off,
                                size: 60,
                                color: Colors.grey,
                              ),

                              SizedBox(height: 12),

                              Text(
                                "No results found",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                              SizedBox(height: 6),

                              Text(
                                "Try a different keyword",
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                          ),

                          /// 🔥 LOGIC
                          itemCount: searchQuery.isNotEmpty
                              ? filteredOffers.length + 1
                              : filteredOffers.length +
                                  (filteredOffers.length ~/ 4),

                          itemBuilder: (context, index) {
                            /// 🔍 SEARCH MODE
                            if (searchQuery.isNotEmpty) {
                              if (index < filteredOffers.length) {
                                final offer =
                                    filteredOffers[index];

                                return GestureDetector(
                                  onTap: () =>
                                      openUrl(offer["url"]!),
                                  child: buildCard(offer),
                                );
                              }

                              /// 🔥 ONE AD AT BOTTOM
                              return buildAd();
                            }

                            /// 🏠 NORMAL MODE
                            if ((index + 1) % 5 == 0) {
                              return buildAd();
                            }

                            int adCount = index ~/ 5;
                            int realIndex = index - adCount;

                            final offer =
                                filteredOffers[realIndex];

                            return GestureDetector(
                              onTap: () =>
                                  openUrl(offer["url"]!),
                              child: buildCard(offer),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
