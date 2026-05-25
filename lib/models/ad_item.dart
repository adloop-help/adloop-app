// lib/models/ad_item.dart
class AdItem {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String category;
  final String country;
  final String targetUrl;
  final DateTime createdAt;

  AdItem({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.category,
    required this.country,
    required this.targetUrl,
    required this.createdAt,
  });

  factory AdItem.fromJson(Map<String, dynamic> json) {
    return AdItem(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      imageUrl: json['imageUrl']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      country: json['country']?.toString() ?? '',
      targetUrl: json['targetUrl']?.toString() ?? '',
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'category': category,
      'country': country,
      'targetUrl': targetUrl,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}


