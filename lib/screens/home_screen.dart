import 'package:flutter/material.dart';
import 'category_offers_screen.dart';
import 'register_screen.dart';
import 'contact_screen.dart';
import 'privacy_policy_screen.dart';
import '../widgets/banner_ad_widget.dart';
import '../services/category_keywords.dart';
import '../services/trending_service.dart';
import 'discover_screen.dart';
import '../widgets/common_header.dart'; // ✅ ADDED

class HomeScreen extends StatefulWidget {

  final VoidCallback? onDiscoverTap;

  const HomeScreen({super.key, this.onDiscoverTap});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const Color primaryGreen = Color(0xFF00C853);
  static const Color tileGreen = Color(0xFFB9F6CA);
  static const Color darkGreen = Color(0xFF1B5E20);

  String _selectedCountry = "ALL";

  @override
  void initState() {
    super.initState();

    final keywords =
        CategoryKeywords.getKeywords("Clothing, Shoes & Jewellery");

    final keyword = keywords[0];

    TrendingService().fetchTrending(keyword).then((articles) {
      for (var article in articles) {
        print(article.title);
        print(article.url);
      }
    }).catchError((e) {
      print("❌ ERROR: $e");
    });
  }

  final List<String> _countries = const [
    'ALL','India','United States','United Kingdom','United Arab Emirates',
    'Canada','Australia','Germany','France','Italy','Spain','Netherlands',
    'Brazil','Mexico','Japan','South Korea','Singapore','South Africa',
    'Turkey','Indonesia','Philippines','Thailand','Vietnam','Malaysia',
    'Saudi Arabia','Sweden','Norway','Denmark','Finland','Portugal',
    'Armenia','Poland','Switzerland',
  ];

  String getFlag(String country) {
    switch (country) {
      case "ALL": return "🌍";
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
      default: return "🌍";
    }
  }

  final List<Map<String, String>> _categories = const [
    {"icon":"🏷️","name":"Coupons & Promo Codes"},
    {"icon":"👗","name":"Clothing, Shoes & Jewellery"},
    {"icon":"💄","name":"Healthcare & Beauty"},
    {"icon":"🏀","name":"Sports & Outdoors"},
    {"icon":"💻","name":"Electronics & Software"},
    {"icon":"🧸","name":"Toys & Games"},
    {"icon":"📚","name":"Books & Ebooks"},
    {"icon":"🏡","name":"Home & Kitchen"},
    {"icon":"🛒","name":"Grocery & Gourmet Food"},
    {"icon":"💼","name":"Finance & Marketing"},
    {"icon":"🏢","name":"Real Estate & Property"},
    {"icon":"🎓","name":"Education & Training"},
    {"icon":"🧑‍💼","name":"Professional Services"},
    {"icon":"🐶","name":"Pet Supplies"},
    {"icon":"🌿","name":"Patio, Lawn & Garden"},
    {"icon":"🎨","name":"Arts, Crafts & Sewing"},
    {"icon":"🚗","name":"Automotive Parts"},
    {"icon":"🎸","name":"Musical Instruments"},
    {"icon":"🧳","name":"Luggage & Travel Gear"},
    {"icon":"🪑","name":"Tools & Furniture"},
    {"icon":"🚚","name":"Logistics & Transport"},
    {"icon":"📦","name":"Office Products"},
    {"icon":"🌾","name":"Agricultural Products"},
    {"icon":"🏗️","name":"Construction Parts"}
  ];

  void openCategory(String category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CategoryOffersScreen(
          category: category,
          country: _selectedCountry,
        ),
      ),
    );
  }

  void showCountryPicker() async {
    final picked = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 14),
              const Text("Choose your country",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const Divider(),
              Expanded(
                child: ListView.builder(
                  itemCount: _countries.length,
                  itemBuilder: (context, index) {
                    final c = _countries[index];
                    return ListTile(
                      leading: Text(getFlag(c), style: const TextStyle(fontSize: 20)),
                      title: Text(c),
                      trailing: _selectedCountry == c
                          ? const Icon(Icons.check, color: primaryGreen)
                          : null,
                      onTap: () => Navigator.pop(context, c),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedCountry = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      /// ✅ HEADER FIXED HERE
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: CommonHeader(
          rightWidget: Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                elevation: 0,
                side: const BorderSide(color: Colors.black12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const RegisterScreen(),
                  ),
                );
              },
              child: const Text(
                "Register",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

           GestureDetector(
              onTap: showCountryPicker,
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Text(getFlag(_selectedCountry), style: const TextStyle(fontSize: 20)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _selectedCountry,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                    const Icon(Icons.arrow_drop_down)
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Categories",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),

                
              ],
            ),

            const SizedBox(height: 12),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.8,
              ),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index]["name"]!;
                final icon = _categories[index]["icon"]!;

                return GestureDetector(
                  onTap: () => openCategory(category),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: tileGreen,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Text(icon, style: const TextStyle(fontSize: 22)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            category,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              color: darkGreen,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 30),

            BannerAdWidget(),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ContactScreen(),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    decoration: BoxDecoration(
                      border: Border.all(color: primaryGreen),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "Contact Us",
                      style: TextStyle(
                        color: primaryGreen,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PrivacyPolicyScreen(),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    decoration: BoxDecoration(
                      border: Border.all(color: primaryGreen),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "Privacy Policy",
                      style: TextStyle(
                        color: primaryGreen,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

/// ✅ BUTTON (UNCHANGED)
class AnimatedTrendingButton extends StatelessWidget {
  final VoidCallback onTap;

  const AnimatedTrendingButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(25),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Color(0xFF16A34A),
          borderRadius: BorderRadius.circular(25),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.play_circle_fill, color: Colors.white, size: 18),
            SizedBox(width: 6),
            Text(
              "Discover",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
