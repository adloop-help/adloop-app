import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/product_service.dart';
import '../services/category_keywords.dart';

class TrendingScreen extends StatefulWidget {
  final String category;

  const TrendingScreen({super.key, required this.category});

  @override
  State<TrendingScreen> createState() => _TrendingScreenState();
}

class _TrendingScreenState extends State<TrendingScreen> {
  static const Color primaryGreen = Color(0xFF00C853);

  late String selectedCategory;

  final List<String> categories = [
    "Clothing, Shoes & Jewellery",
    "Healthcare & Beauty",
    "Sports & Outdoors",
    "Electronics & Software",
    "Toys & Games",
    "Books & Ebooks",
    "Home & Kitchen",
    "Grocery & Gourmet Food",
    "Finance & Marketing",
    "Real Estate & Property",
    "Education & Training",
    "Professional Services",
    "Pet Supplies",
    "Patio, Lawn & Garden",
    "Arts, Crafts & Sewing",
    "Automotive Parts",
    "Musical Instruments",
    "Luggage & Travel Gear",
    "Tools & Furniture",
    "Logistics & Transport",
    "Office Products",
    "Agricultural Products",
    "Construction Parts"
  ];

  @override
  void initState() {
    super.initState();
    selectedCategory = widget.category;
  }

  /// 🔗 OPEN LINK
  Future<void> openLink(String url, String title) async {
    final finalUrl = url.isNotEmpty
        ? url
        : "https://www.google.com/search?q=${Uri.encodeComponent(title)}";

    final uri = Uri.tryParse(finalUrl);

    if (uri != null) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
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
        title: const Text(
          "Trending Products",
          style: TextStyle(
            color: primaryGreen,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Column(
        children: [

          /// 🔥 DROPDOWN
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
                border: Border.all(color: Colors.black12),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedCategory,
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                  items: categories.map((c) {
                    return DropdownMenuItem(
                      value: c,
                      child: Text(c),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedCategory = value;
                      });
                    }
                  },
                ),
              ),
            ),
          ),

          /// 🔥 PRODUCTS
          Expanded(
            child: RefreshIndicator(
              color: primaryGreen,
              onRefresh: () async {
                setState(() {});
                await Future.delayed(const Duration(milliseconds: 500));
              },
              child: StreamBuilder(
                // 🔥 FIX: USE collectionGroup INSTEAD
                stream: FirebaseFirestore.instance
                    .collectionGroup('product')
                    .snapshots(),
                builder: (context, snapshot) {

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final docs = snapshot.data?.docs ?? [];

                  if (docs.isEmpty) {
                    return const Center(
                      child: Text("No products found 😕"),
                    );
                  }

                  return ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(12),
                    itemCount: docs.length,
                    itemBuilder: (context, index) {

                      final data = docs[index];

                      final title = data['title'] ?? '';
                      final image = data['image'] ?? '';
                      final url = data['url'] ?? '';
                      final price = data['price'] ?? '';

                      return GestureDetector(
                        onTap: () => openLink(url, title),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              if (image.isNotEmpty)
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(18),
                                  ),
                                  child: Image.network(
                                    image,
                                    height: 180,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              else
                                Container(
                                  height: 180,
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.image_not_supported),
                                ),

                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    Text(
                                      title,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),

                                    const SizedBox(height: 6),

                                    if (price.isNotEmpty)
                                      Text(
                                        price,
                                        style: const TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
