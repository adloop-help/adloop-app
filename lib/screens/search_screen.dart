// lib/screens/search_screen.dart
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

/// A simple search UI that replicates the Home search flow.
/// Users typically arrive here from Home; results are shown on ResultsScreen.
class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  String selectedCountry = 'India';

  final List<String> countries = const [
    'India','United States','United Kingdom','Canada','Australia','Germany','France','Spain','Italy','Brazil',
    'Mexico','Japan','China','South Korea','Indonesia','Turkey','Saudi Arabia','United Arab Emirates','Russia','South Africa',
    'Nigeria','Egypt','Netherlands','Sweden','Switzerland','Belgium','Austria','Poland','Portugal','Argentina',
    'Chile','Colombia','Peru','Philippines','Malaysia','Thailand','Vietnam','Singapore','New Zealand','Ireland',
    'Denmark','Norway','Finland','Greece','Czech Republic','Hungary','Romania','Israel','Bangladesh','Pakistan'
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _runSearch() {
    final q = _controller.text.trim();
    Navigator.pushNamed(context, '/results', arguments: {
      'query': q,
      'country': selectedCountry,
      'category': 'All',
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search ads'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0.5,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: _controller,
                textInputAction: TextInputAction.search,
                onSubmitted: (_) => _runSearch(),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: 'Search ads (e.g. guitar, shoes)',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedCountry,
                decoration: InputDecoration(
                  labelText: 'Country',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                items: countries.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (v) {
                  if (v == null) return;
                  setState(() => selectedCountry = v);
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _runSearch,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  child: Text('Show Results', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


