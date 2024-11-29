import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/fav_screen.dart';
import '../screens/Settings-Screen.dart';
import '../screens/Category-screen.dart';
import '../screens/DetailsScreen.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({Key? key}) : super(key: key);

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  late PageController _pageController;

  // List of pages
  final List<Widget> _screenList = [
    const HomeScreen(),
    const DetailsScreen(),
    const DarkModeToggle(),
    const CategoryScreen(),
    const FavoritesScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0); // Start from HomeScreen
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void onItemTapped(int index) {
    // Update the current page in the PageController
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: PageView(
          controller: _pageController,
          physics:
              const NeverScrollableScrollPhysics(), // Disable swipe navigation
          onPageChanged: (index) {
            setState(() {
              // Sync the selected index when the page changes
            });
          },
          children: _screenList,
        ),
        bottomNavigationBar: _bottomNavigationBars(),
      ),
    );
  }

  Widget _bottomNavigationBars() {
    return BottomNavigationBar(
      showSelectedLabels: true,
      showUnselectedLabels: true,
      backgroundColor: Colors.blue, // Adjust to your desired background color
      unselectedItemColor: const Color(0xFF707070),
      selectedItemColor: Colors.blueAccent, // Color for selected item
      selectedFontSize: 14, // Font size for selected text
      unselectedFontSize: 12, // Font size for unselected text
      onTap: (index) {
        onItemTapped(index); // Update page on tap
      },
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.category),
          label: 'Categories',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          label: 'Favorites',
        ),
      ],
    );
  }
}
