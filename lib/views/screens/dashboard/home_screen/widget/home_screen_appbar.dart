import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/state_manager.dart';
import 'package:vlr/controllers/auth_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/base/custom_image.dart';
import 'package:vlr/views/screens/edit_profile/profile_detail_screen.dart';
import 'package:vlr/views/screens/notification_screen/notification_screen.dart';

class HomeScreenAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeScreenAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (authController) {
      return AppBar(
        elevation: 2,
        scrolledUnderElevation: 0, // Prevents tinting on scroll in Material 3
        backgroundColor: Get.isDarkMode ? white : primaryColor,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomText(
              "FEETRACK",
              style: Helper(context).textTheme.titleLarge?.copyWith(
                    fontSize: 22.sp,
                    color: Get.isDarkMode ? black : white,
                    letterSpacing: 1,
                  ),
            ),
            sizedBoxWidth(width: 6),
            CustomText(
              "HRMS",
              style: Helper(context).textTheme.titleSmall?.copyWith(
                    fontSize: 14.sp,
                    color: Get.isDarkMode ? black : white,
                  ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              navigate(context: context, page: const NotificationScreen());
            },
            icon: Badge(
              isLabelVisible: true,
              child: Icon(
                Icons.notifications_outlined,
                color: Get.isDarkMode ? black : white,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              if (authController.isLoading) return;
              navigate(context: context, page: const ProfileDetailScreen());
            },
            child: Padding(
              padding: EdgeInsets.only(right: 16.0.w, left: 8.0.w),
              child: CustomImage(
                path: (authController.userModel?.profileImage != null ||
                        (authController.userModel?.profileImage?.isNotEmpty ??
                            false))
                    ? (authController.userModel?.profileImage ??
                        Assets.imagesNoProfile)
                    : Assets.imagesNoProfile,
                height: 40.h,
                width: 40.w,
                isProfile: true,
                radius: 999,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      );
    });
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
