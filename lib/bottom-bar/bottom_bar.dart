import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utils/constant/app_color.dart';
import '../../utils/constant/app_image.dart';
import '../home  Screen/home_screen.dart';
import '../profile/user_profile.dart';
import '../user_history/user_history.dart';
import '../all_category/all_category.dart';
import '../taxi/taxi_screen.dart'; // Import your Taxi screen here

class BottomBar extends StatefulWidget {
  const BottomBar({Key? key}) : super(key: key);

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  late PageController _pageController;

  List<Widget> screenList = [
    const HomeScreen(),
    AllCategory(),
    TaxiHome(), // Add the Taxi screen here
    BookingHistory(),
    Profile(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void onItemTapped(int index) {
    _pageController.jumpToPage(index);
    setState(() {
      AppImages.currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              AppImages.currentIndex = index;
            });
          },
          children: screenList,
        ),
        bottomNavigationBar: bottomNavigationBars(),
      ),
    );
  }

  Widget bottomNavigationBars() {
    return Container(
      color: AppColor.appColor,
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(AppImages.bHome, 'Home', 0),
          _buildNavItem(AppImages.bDiscover, 'Discover', 1),
          _buildNavItem(AppImages.bTaxi, 'Taxi', 2), // Taxi icon and label
          _buildNavItem(AppImages.bHistory, 'Bookings', 3),
          _buildNavItem(AppImages.bProfile, 'Profile', 4),
        ],
      ),
    );
  }

  Widget _buildNavItem(String iconPath, String label, int index) {
    final isSelected = AppImages.currentIndex == index;

    return GestureDetector(
      onTap: () => onItemTapped(index),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: isSelected
            ? BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            const BoxShadow(
              color: Colors.black26,
              offset: Offset(2, 2),
              blurRadius: 6,
              spreadRadius: 1,
            ),
            BoxShadow(
              color: AppColor.appBannerColor.withOpacity(0.3),
              offset: const Offset(-2, -2),
              blurRadius: 4,
            ),
          ],
        )
            : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ImageIcon(AssetImage(iconPath)),
            SizedBox(height: 4.h),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColor.appBannerColor : Colors.black54,
                fontSize: 12.sp,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
