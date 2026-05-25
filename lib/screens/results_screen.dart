import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/offer_model.dart';
import '../widgets/native_ad_widget.dart';

class ResultsScreen extends StatefulWidget {
final String query;
final String category;
final String country;

const ResultsScreen({
Key? key,
required this.query,
required this.category,
required this.country,
}) : super(key: key);

@override
State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {

static const Color primaryGreen = Color(0xFF00C853);

late List<OfferModel> offers;

@override
void initState() {
super.initState();
offers = generateDynamicResults(widget.query);
}

/// Generate dynamic search results
List<OfferModel> generateDynamicResults(String query) {

final q = query.replaceAll(" ", "+");

return [

  OfferModel(
    title: "Amazon $query",
    description: "Buy $query on Amazon",
    url: "https://www.amazon.in/s?k=$q",
  ),

  OfferModel(
    title: "Flipkart $query",
    description: "Shop $query on Flipkart",
    url: "https://www.flipkart.com/search?q=$q",
  ),

  OfferModel(
    title: "Chewy $query",
    description: "Pet supplies marketplace",
    url: "https://www.chewy.com/s?query=$q",
  ),

  OfferModel(
    title: "Petco $query",
    description: "Pet products store",
    url: "https://www.petco.com/shop/en/petcostore/search?query=$q",
  ),

  OfferModel(
    title: "PetSmart $query",
    description: "Pet supplies & services",
    url: "https://www.petsmart.com/search/?q=$q",
  ),

  OfferModel(
    title: "DogFoodAdvisor",
    description: "Independent dog food reviews",
    url: "https://www.dogfoodadvisor.com",
  ),

  OfferModel(
    title: "PetMD $query",
    description: "Pet health information",
    url: "https://www.petmd.com/search?q=$q",
  ),

  OfferModel(
    title: "AKC Dog Care",
    description: "American Kennel Club dog advice",
    url: "https://www.akc.org/?s=$q",
  ),
];

}

/// Extract domain from URL
String getDomain(String url) {
try {
final uri = Uri.parse(url);
return uri.host.replaceFirst("www.", "");
} catch (e) {
return "";
}
}

/// Generate logo using favicon
String getLogo(String url) {
final domain = getDomain(url);
return "https://www.google.com/s2/favicons?domain=$domain&sz=128";
}

@override
Widget build(BuildContext context) {

return Scaffold(
  backgroundColor: Colors.white,

  appBar: AppBar(
    backgroundColor: Colors.white,
    elevation: 0,
    iconTheme: const IconThemeData(color: primaryGreen),

    title: Text(
      "${widget.query} • ${widget.country}",
      style: const TextStyle(
        color: primaryGreen,
        fontWeight: FontWeight.w700,
        fontSize: 20,
      ),
    ),
  ),

  body: ListView.builder(
    padding: const EdgeInsets.all(16),

    /// Ads after every 2 links
    itemCount: offers.length + (offers.length ~/ 2),

    itemBuilder: (context, index) {

      if (index > 0 && index % 3 == 2) {
        return const Padding(
          padding: EdgeInsets.only(bottom: 20),
          child: NativeAdWidget(),
        );
      }

      final actualIndex = index - (index ~/ 3);
      final offer = offers[actualIndex];

      return _buildOfferCard(offer);
    },
  ),
);

}

Widget _buildOfferCard(OfferModel offer) {

final logoUrl = getLogo(offer.url);

return GestureDetector(
  onTap: () => _openUrl(offer.url),

  child: Container(
    margin: const EdgeInsets.only(bottom: 18),
    padding: const EdgeInsets.all(16),

    decoration: BoxDecoration(
      color: const Color(0xFFE8F5E9),
      borderRadius: BorderRadius.circular(20),
    ),

    child: Row(
      children: [

        ClipRRect(
          borderRadius: BorderRadius.circular(8),

          child: Image.network(
            logoUrl,
            width: 48,
            height: 48,
            fit: BoxFit.contain,

            errorBuilder: (context, error, stackTrace) {
              return const Icon(
                Icons.public,
                size: 40,
                color: Colors.grey,
              );
            },
          ),
        ),

        const SizedBox(width: 14),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text(
                offer.title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                offer.description,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),

              const SizedBox(height: 10),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),

                child: Text(
                  widget.country,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: primaryGreen,
                  ),
                ),
              ),
            ],
          ),
        ),

        const Icon(
          Icons.open_in_new,
          size: 18,
          color: Colors.black45,
        )
      ],
    ),
  ),
);

}

Future<void> _openUrl(String url) async {

final Uri uri = Uri.parse(url);

if (!await launchUrl(
  uri,
  mode: LaunchMode.externalApplication,
)) {
  debugPrint("Could not launch $url");
}

}
}