// lib/services/ad_api.dart
import 'dart:async';
import '../models/ad_item.dart';

class AdApiService {
  // pretend this is your backend dataset
  static final List<AdItem> _mockAds = [
    AdItem(
      id: 'a1',
      title: 'Siyalta Oversized Tee — New Drop',
      description: 'Streetwear oversized T-shirts. Free shipping above ₹999.',
      imageUrl: 'https://images.unsplash.com/photo-1531297484001-80022131f5a1?w=1200&q=80&auto=format&fit=crop',
      url: 'https://example.com/siyalta',
      category: 'Clothing, Shoes & Jewellery',
      countryTag: 'India',
    ),
    AdItem(
      id: 'a2',
      title: 'Smartphone Deal — 40% Off',
      description: 'Flagship-level performance at midrange prices.',
      imageUrl: 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=1200&q=80&auto=format&fit=crop',
      url: 'https://example.com/phone',
      category: 'Electronics & Software',
      countryTag: 'United States',
    ),
    AdItem(
      id: 'a3',
      title: 'Home Decor Flash Sale',
      description: 'Redefine your living room — minimal lamps & cushions.',
      imageUrl: 'https://images.unsplash.com/photo-1505691723518-36a987b7d6b1?w=1200&q=80&auto=format&fit=crop',
      url: 'https://example.com/home-decor',
      category: 'Home & Kitchen',
      countryTag: 'France',
    ),
    AdItem(
      id: 'a4',
      title: 'Gourmet Coffee Beans',
      description: 'Single-origin roasts delivered worldwide.',
      imageUrl: 'https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=1200&q=80&auto=format&fit=crop',
      url: 'https://example.com/coffee',
      category: 'Grocery & Gourmet Food',
      countryTag: 'Brazil',
    ),
    AdItem(
      id: 'a5',
      title: 'Budget Tours — Sri Lanka & Thailand',
      description: 'Group packages starting from ₹12,999 per person.',
      imageUrl: 'https://images.unsplash.com/photo-1502920917128-1aa500764b0f?w=1200&q=80&auto=format&fit=crop',
      url: 'https://example.com/travel',
      category: 'Luggage & Travel Gear',
      countryTag: 'India',
    ),
    AdItem(
      id: 'a6',
      title: 'Fitness Protein Combo Pack',
      description: 'Whey protein and shaker — combo discount active now.',
      imageUrl: 'https://images.unsplash.com/photo-1606813902817-59b9b1a0a8e4?w=1200&q=80&auto=format&fit=crop',
      url: 'https://example.com/fitness',
      category: 'Healthcare & Beauty',
      countryTag: 'United Kingdom',
    ),
  ];

  // simulate backend pagination
  static Future<List<AdItem>> fetchAds({
    required String category,
    required String country,
    required String query,
    required int page,
    required int pageSize,
  }) async {
    await Future.delayed(const Duration(milliseconds: 700)); // simulate latency

    final lowerCat = category.toLowerCase();
    final lowerCountry = country.toLowerCase();
    final lowerQuery = query.trim().toLowerCase();

    final filtered = _mockAds.where((ad) {
      final matchCountry = lowerCountry == 'all' || ad.countryTag.toLowerCase() == lowerCountry;
      final matchCat = lowerCat == 'all' || ad.category.toLowerCase().contains(lowerCat);
      final matchQuery = lowerQuery.isEmpty ||
          ad.title.toLowerCase().contains(lowerQuery) ||
          ad.description.toLowerCase().contains(lowerQuery);
      return matchCountry && matchCat && matchQuery;
    }).toList();

    final start = page * pageSize;
    if (start >= filtered.length) return [];
    final end = (start + pageSize > filtered.length) ? filtered.length : start + pageSize;
    return filtered.sublist(start, end);
  }
}


