import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/common_header.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  int currentIndex = 0;

  BannerAd? _bannerAd;
  bool _isAdLoaded = false;

  final List<bool> isLiked = [];
  final List<int> likeCounts = [];
  final List<int> viewCounts = [];

  late PageController _pageController;

  List<Map<String, String>> discoverData = [];
  bool isLoadingVideos = true;

  /// 🔥 META NATIVE AD EVERY 7 VIDEOS
  bool isAdIndex(int index) {
    return index != 0 && index % 8 == 7;
  }

  int getRealVideoIndex(int index) {
    return index - (index ~/ 8);
  }

  @override
  void initState() {
    super.initState();

    _pageController = PageController();

    fetchVideos();

    _bannerAd = BannerAd(
      adUnitId: "ca-app-pub-4436630342078093/6037074740",
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    )..load();
  }

  Future<void> fetchVideos() async {
    try {
      final response = await http.get(Uri.parse(
          "https://dmt844tuay62m.cloudfront.net/adfeed/adloop_videos_adfeed.json"));

      final List<dynamic> data = jsonDecode(response.body);

      final prefs = await SharedPreferences.getInstance();
      final lastVideo = prefs.getString("last_video");

      int startIndex = 0;

      discoverData = data.map<Map<String, String>>((item) {
        return {
          "video": item["video"]?.toString() ?? "",
          "url": item["website"]?.toString() ?? ""
        };
      }).toList();

      isLiked.clear();
      likeCounts.clear();
      viewCounts.clear();

      for (int i = 0; i < discoverData.length; i++) {
        isLiked.add(false);
        likeCounts.add(0);
        viewCounts.add(0);
      }

      /// ✅ RESUME LAST WATCHED VIDEO
      if (lastVideo != null) {
        final foundIndex = discoverData.indexWhere(
          (item) => item["video"] == lastVideo,
        );

        if (foundIndex != -1) {
          startIndex = foundIndex;
        }
      }

      /// ✅ CREATE CONTROLLER WITH SAVED POSITION
      _pageController = PageController(initialPage: startIndex);

      setState(() {
        currentIndex = startIndex;
        isLoadingVideos = false;
      });
    } catch (e) {
      print("JSON ERROR: $e");

      setState(() {
        isLoadingVideos = false;
      });
    }
  }

  Future<void> openLink(String url) async {
    final uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  void shareLink(String url) {
    Share.share(url);
  }

  /// 🔥 META AD UI
  Widget buildMetaAd() {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 25,
        ),
        height: MediaQuery.of(context).size.height * 0.72,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(20),
          image: const DecorationImage(
            image: NetworkImage(
              "https://images.unsplash.com/photo-1520607162513-77705c0f0d4a?q=80&w=1200&auto=format&fit=crop",
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.black.withOpacity(0.45),
              ),
            ),

            const Positioned(
              top: 20,
              left: 20,
              child: Text(
                "Sponsored",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  "Discover Trending Brands & Deals",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            Positioned(
              bottom: 35,
              left: 25,
              right: 25,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                onPressed: () async {
                  final uri = Uri.parse(
                    "https://www.facebook.com",
                  );

                  await launchUrl(
                    uri,
                    mode: LaunchMode.externalApplication,
                  );
                },
                child: const Text(
                  "Learn More",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoadingVideos) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (discoverData.isEmpty) {
      return const Scaffold(
        body: Center(child: Text("No data received")),
      );
    }

    final totalItems =
        discoverData.length + (discoverData.length ~/ 7);

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: const CommonHeader(),
      ),

      body: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(),
        itemCount: totalItems,

        onPageChanged: (index) async {
          if (isAdIndex(index)) return;

          final realIndex = getRealVideoIndex(index);

          setState(() {
            currentIndex = realIndex;
            viewCounts[realIndex]++;
          });

          final prefs = await SharedPreferences.getInstance();

          prefs.setString(
            "last_video",
            discoverData[realIndex]["video"]!,
          );
        },

        itemBuilder: (context, index) {
          /// 🔥 SHOW AD EVERY 7 VIDEOS
          if (isAdIndex(index)) {
            return buildMetaAd();
          }

          final realIndex = getRealVideoIndex(index);

          final item = discoverData[realIndex];

          return Stack(
            children: [
              VideoPlayerItem(
                videoPath: item["video"]!,
                isActive: realIndex == currentIndex,
              ),

              Positioned(
                bottom: 25,
                left: 20,
                child: GestureDetector(
                  onTap: () => openLink(item["url"]!),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Text(
                      "Visit Website",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),

              Positioned(
                bottom: 25,
                right: 20,
                child: GestureDetector(
                  onTap: () => shareLink(item["url"]!),
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.share,
                      color: Colors.black,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class VideoPlayerItem extends StatefulWidget {
  final String videoPath;
  final bool isActive;

  const VideoPlayerItem({
    super.key,
    required this.videoPath,
    required this.isActive,
  });

  @override
  State<VideoPlayerItem> createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  late VideoPlayerController _controller;
  bool isPlaying = true;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.network(widget.videoPath)
      ..initialize().then((_) {
        setState(() {});

        if (widget.isActive) {
          _controller.play();
        }
      });
  }

  @override
  void didUpdateWidget(covariant VideoPlayerItem oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isActive) {
      _controller.play();
      isPlaying = true;
    } else {
      _controller.pause();
    }
  }

  void togglePlay() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
        isPlaying = false;
      } else {
        _controller.play();
        isPlaying = true;
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: togglePlay,
      child: Center(
        child: Container(
          margin:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          height: MediaQuery.of(context).size.height * 0.72,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(20),
          ),
          clipBehavior: Clip.hardEdge,
          child: Stack(
            children: [
              _controller.value.isInitialized
                  ? SizedBox.expand(
                      child: VideoPlayer(_controller),
                    )
                  : Container(
                      color: Colors.black,
                    ),

              if (!_controller.value.isPlaying)
                const Center(
                  child: Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: 60,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
    