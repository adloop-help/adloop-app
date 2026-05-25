

import 'package:flutter/material.dart';
import '../services/location_service.dart';
import 'home_screen.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {

  String selectedCountry = "India";

 final List<String> _countries = const [

  'India',
  'United States',
  'United Kingdom',
  'United Arab Emirates',
  'Canada',
  'Australia',

  'Germany',
  'France',
  'Italy',
  'Spain',
  'Netherlands',
  'Switzerland',
  'Poland',
  'Portugal',
  'Sweden',
  'Norway',
  'Denmark',
  'Finland',

  'Brazil',
  'Mexico',

  'Japan',
  'South Korea',
  'Singapore',
  'Malaysia',
  'Thailand',
  'Vietnam',
  'Indonesia',
  'Philippines',

  'Saudi Arabia',
  'Turkey',
  'South Africa',

                              ];

  void saveLocation() async {

    await LocationService.saveCountry(selectedCountry);

    if(!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Select Your Country"),
      ),

      body: Padding(

        padding: const EdgeInsets.all(20),

        child: Column(

          children: [

            const SizedBox(height:40),

            const Text(
              "Choose your location for better search results",
              style: TextStyle(fontSize:18),
            ),

            const SizedBox(height:30),

            DropdownButton<String>(
              value: selectedCountry,
              isExpanded: true,
              items: _countries.map((country) {

                return DropdownMenuItem(
                  value: country,
                  child: Text(country),
                );

              }).toList(),
              onChanged: (value){

                setState(() {

                  selectedCountry = value!;

                });

              },
            ),

            const SizedBox(height:40),

            ElevatedButton(
              onPressed: saveLocation,
              child: const Text("Continue"),
            )

          ],

        ),

      ),

    );

  }

}