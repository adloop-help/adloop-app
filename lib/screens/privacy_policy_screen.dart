import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  static const Color primaryGreen = Color(0xFF00C853);
  static const Color tileGreen = Color(0xFFB9F6CA);
  static const Color darkGreen = Color(0xFF1B5E20);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Privacy Policy",
          style: TextStyle(
            color: primaryGreen,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: tileGreen,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                children: [
                  Icon(Icons.privacy_tip, color: darkGreen),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Your privacy matters to us",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: darkGreen,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Last updated: 2026",
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 16),

            const Text(
              "AdLoop respects your privacy.",
              style: TextStyle(fontSize: 14),
            ),

            const SizedBox(height: 20),

            sectionTitle("1. Information We Collect"),
            sectionContent([
              "Name",
              "Email address",
              "Submitted website details",
            ]),

            sectionTitle("2. How We Use Information"),
            sectionContent([
              "Review submitted websites",
              "Improve our platform",
              "Respond to your enquiries",
            ]),

            sectionTitle("3. Ads"),
            const Text(
              "Our app uses third-party advertising (Google AdMob). Ads may be personalized based on user behavior.",
              style: TextStyle(height: 1.6),
            ),

            const SizedBox(height: 16),

            sectionTitle("4. Data Sharing"),
            const Text(
              "We do NOT sell or share your personal data with third parties.",
              style: TextStyle(height: 1.6),
            ),

            const SizedBox(height: 16),

            sectionTitle("5. Security"),
            const Text(
              "We take reasonable steps to protect your information.",
              style: TextStyle(height: 1.6),
            ),

            const SizedBox(height: 16),

            sectionTitle("6. Contact"),
            const Text(
              "If you have any questions, contact us via the Contact Us section in the app.",
              style: TextStyle(height: 1.6),
            ),

            const SizedBox(height: 20),

            const Text(
              "By using AdLoop, you agree to this policy.",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  static Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, top: 10),
      child: Text(
        title,
        style: const TextStyle(
          color: darkGreen,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  static Widget sectionContent(List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.map((e) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Text(
            "• $e",
            style: const TextStyle(height: 1.6),
          ),
        );
      }).toList(),
    );
  }
}
