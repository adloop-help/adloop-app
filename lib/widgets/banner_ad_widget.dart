// lib/widgets/banner_ad_widget.dart
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdWidget extends StatefulWidget {
  // Optionally allow custom size via constructor
  final AdSize adSize;
  const BannerAdWidget({Key? key, this.adSize = AdSize.banner}) : super(key: key);

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;
  String? _loadError;

  @override
  void initState() {
    super.initState();
    _createAndLoadBanner();
  }

  void _createAndLoadBanner() {
    // Use the official test ad unit id for banners while developing:
    final adUnitId = "ca-app-pub-4436630342078093/6037074740";

    // Dispose old ad if any
    _bannerAd?.dispose();
    _isLoaded = false;
    _loadError = null;

    _bannerAd = BannerAd(
      adUnitId: adUnitId,
      size: widget.adSize,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (!mounted) return;
          setState(() {
            _isLoaded = true;
            _loadError = null;
          });
        },
        onAdFailedToLoad: (ad, error) {
          // Important: dispose the ad here.
          ad.dispose();
          if (!mounted) return;
          setState(() {
            _bannerAd = null;
            _isLoaded = false;
            _loadError = 'Failed to load ads: ${error.message}';
          });
          // Optional: print to console for debugging
          debugPrint('BannerAd failedToLoad: ${error.code} ${error.message}');
        },
        onAdOpened: (ad) => debugPrint('BannerAd opened'),
        onAdClosed: (ad) => debugPrint('BannerAd closed'),
        onAdImpression: (ad) => debugPrint('BannerAd impression'),
      ),
    );

    // Start loading
    _bannerAd!.load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Use a fixed container height matching the ad size to avoid layout jumps
    final containerHeight = widget.adSize.height.toDouble();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_isLoaded && _bannerAd != null)
          SizedBox(
            width: _bannerAd!.size.width.toDouble(),
            height: containerHeight,
            child: AdWidget(ad: _bannerAd!),
          )
        else if (_loadError != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: Column(
              children: [
                Text(
                  _loadError ?? 'Failed to load ads',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    // Retry load
                    _createAndLoadBanner();
                  },
                  child: const Text('Retry'),
                )
              ],
            ),
          )
        else
          // Loading placeholder (small height to reserve space)
          SizedBox(
            height: containerHeight,
            child: const Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }
}


