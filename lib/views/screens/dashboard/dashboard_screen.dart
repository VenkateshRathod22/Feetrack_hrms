import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/dashboard_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/screens/account_screen/account_screen.dart';
import 'package:vlr/views/screens/bottom_navigation_bar/option_screen.dart';
import 'package:vlr/views/screens/dashboard/home_screen/home_screen.dart';
import 'package:vlr/views/screens/reports/reports_section_screen.dart';

import '../../../generated/assets.dart';

class DashboardScreen extends StatefulWidget {
  final bool isComingForSplashScreen;
  const DashboardScreen({super.key, this.isComingForSplashScreen = false});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(isComingForSplashScreen: widget.isComingForSplashScreen),
      const OptionScreen(),
      const ReportsSectionScreen(),
      const AccountScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashBoardController>(
      builder: (controller) {
        return Scaffold(
          body: IndexedStack(
            index: controller.dashPage,
            children: _screens,
          ),
          bottomNavigationBar: SafeArea(
            child: Container(
              height: 70.h,
              margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: white,
                boxShadow: [
                  BoxShadow(
                    color: black.withOpacity(0.1),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
                borderRadius: BorderRadius.circular(35.r),
                border: Border.all(color: greyLight2.withOpacity(0.5)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(35.r),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _bottomNavItem(
                      index: 0,
                      label: "Home",
                      icon: Icons.home_rounded,
                      controller: controller,
                    ),
                    _bottomNavItem(
                      index: 1,
                      label: "Options",
                      icon: Icons.grid_view_rounded,
                      controller: controller,
                    ),
                    _bottomNavItem(
                      index: 2,
                      label: "Reports",
                      iconPath: Assets.svgsGraph,
                      controller: controller,
                    ),
                    _bottomNavItem(
                      index: 3,
                      label: "Account",
                      iconPath: Assets.svgsPerson,
                      controller: controller,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _bottomNavItem({
    required int index,
    required String label,
    IconData? icon,
    String? iconPath,
    required DashBoardController controller,
  }) {
    bool isActive = controller.dashPage == index;
    return GestureDetector(
      onTap: () => controller.dashPage = index,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(horizontal: isActive ? 20.w : 12.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isActive ? primaryColor.withOpacity(0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Row(
          children: [
            if (icon != null)
              Icon(
                icon,
                color: isActive ? primaryColor : greyDart,
                size: 24.sp,
              )
            else if (iconPath != null)
              SvgPicture.asset(
                iconPath,
                colorFilter: ColorFilter.mode(
                  isActive ? primaryColor : greyDart,
                  BlendMode.srcIn,
                ),
                height: 22.h,
                width: 22.w,
              ),
            if (isActive) ...[
              sizedBoxWidth(width: 8.w),
              Text(
                label,
                style: Helper(context).textTheme.bodySmall?.copyWith(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 13.sp,
                    ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
