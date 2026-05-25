// lib/screens/ad_detail_screen.dart
import 'package:flutter/material.dart';

class AdDetailScreen extends StatelessWidget {
  final dynamic ad; // accepts _MockAd or other ad object with fields used below
  const AdDetailScreen({Key? key, required this.ad}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final title = ad.title ?? 'Ad';
    final desc = ad.description ?? '';
    final imageUrl = ad.imageUrl ?? '';
    final url = ad.url ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ad Details'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0.5,
      ),
      body: ListView(
        children: [
          if (imageUrl != null && imageUrl.isNotEmpty)
            AspectRatio(
              aspectRatio: 16 / 10,
              child: Image.network(imageUrl, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const SizedBox()),
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Text(desc, style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 18),
                ElevatedButton.icon(
                  onPressed: () {
                    // For now open the url externally is left out to avoid extra packages.
                    // You can later use url_launcher to actually open the target.
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Would open ad URL (mock)')));
                  },
                  icon: const Icon(Icons.open_in_new),
                  label: const Text('Open Ad'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


