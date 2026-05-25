import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:easy_audience_network/easy_audience_network.dart';

import 'screens/main_screen.dart';
import 'thankyou_screen.dart';
import 'screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔥 SIMPLE FIREBASE INIT (NO firebase_options.dart)
  await Firebase.initializeApp();

  // 🔥 ADMOB INIT
  await MobileAds.instance.initialize();

  // 🔥 META AUDIENCE NETWORK INIT
  EasyAudienceNetwork.init(
  testMode: true,
   );

  runApp(const AdLoopApp());
}

class AdLoopApp extends StatelessWidget {
  const AdLoopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AdLoop',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF00C853),
      ),

      routes: {
        "/thankyou": (context) => const ThankYouScreen(),
      },

      home: const MainScreen(),
    );
  }
}