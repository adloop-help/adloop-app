import 'package:flutter/material.dart';
import 'discover_screen.dart';
import 'home_screen.dart';
import 'explore_feed_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void goToDiscover() {
    setState(() {
      _selectedIndex = 0;
    });
  }

  late final List<Widget> _screens = [
    const DiscoverScreen(),
    HomeScreen(onDiscoverTap: goToDiscover),
    const ExploreFeedScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color(0xFF00C853),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,

        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/feed_icons/discover.png',
              height: 28,
              color: _selectedIndex == 0
                  ? const Color(0xFF00C853)
                  : Colors.grey,
            ),
            label: "Discover",
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/feed_icons/categories.png',
              height: 28,
              color: _selectedIndex == 1
                  ? const Color(0xFF00C853)
                  : Colors.grey,
            ),
            label: "Categories",
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/feed_icons/explore_feed.png',
              height: 28,
              color: _selectedIndex == 2
                  ? const Color(0xFF00C853)
                  : Colors.grey,
            ),
            label: "Explore Feed",
          ),
        ],
      ),
    );
  }
}