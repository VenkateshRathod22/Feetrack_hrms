import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/attendance_controller.dart';
import 'package:vlr/controllers/auth_controller.dart';
import 'package:vlr/controllers/notice_controller.dart';
import 'package:vlr/controllers/dashboard_controller.dart';
import 'package:vlr/controllers/permission_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/date_formatters_and_converters.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/screens/dashboard/home_screen/widget/attendance_section/attendance_section.dart';
import 'package:vlr/views/screens/dashboard/home_screen/widget/home_screen_appbar.dart';
import 'package:vlr/views/screens/dashboard/home_screen/widget/notice_board_section/notice_board_section.dart';
import 'package:vlr/views/screens/dashboard/home_screen/widget/notification_section/notification_section.dart';
import 'package:vlr/views/screens/dashboard/home_screen/widget/quick_action_section/quick_action_section.dart';
import 'package:vlr/views/screens/dashboard/home_screen/widget/quick_action_section/management_section.dart';
import 'package:vlr/views/screens/dashboard/home_screen/widget/quick_action_section/quick_action_widget.dart';
import 'package:vlr/views/screens/dashboard/home_screen/widget/this_month_target_section/this_month_target_section.dart';
import 'package:vlr/views/screens/dashboard/home_screen/widget/top_achievers_section/top_achievers_section.dart';
import 'package:vlr/views/screens/dashboard/home_screen/widget/recent_tasks_section.dart';
import 'package:vlr/views/screens/dashboard/home_screen/widget/recent_leads_section.dart';
import 'package:vlr/views/screens/dashboard/home_screen/widget/recent_orders_section.dart';

class HomeScreen extends StatefulWidget {
  final bool? isComingForSplashScreen;
  const HomeScreen({super.key, this.isComingForSplashScreen = false});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    final noticeController = Get.find<NoticeController>();
    final dashBoardController = Get.find<DashBoardController>();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      dashBoardController.getDashboardData();
      if (widget.isComingForSplashScreen == true) {
        noticeController.fetchNoticeBoard().then((value) {
          if (value.isSuccess && noticeController.noticeModelList.isNotEmpty) {
            showNoticeBoard();
          }
        });
      } else {
        Get.find<AuthController>().fetchProfile();
      }

      final PermissionController permissionController =
          Get.find<PermissionController>();
      permissionController.clearSelfie();
      permissionController.clearLocation();

      await permissionController.requestLocationPermissionAndFetch(context);

      Get.find<AttendanceController>().fetchCheckListPoint();
            Get.find<AttendanceController>().fetchTodayAttendance();

      log("Attendance status : - ${Get.find<AttendanceController>().attendanceModel?.status ?? ""}");
      log("Attendance status : - ${Get.find<AttendanceController>().attendanceModel?.status ?? ""}");

    });
  }

  void showNoticeBoard() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: const NoticeBoardWidget(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeScreenAppBar(),
      body: GetBuilder<AuthController>(builder: (authController) {
        return GetBuilder<DashBoardController>(builder: (dashController) {
          return RefreshIndicator(
            onRefresh: () async {
              await authController.fetchProfile();
              await dashController.getDashboardData();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // const UserInfoTopHome(),
                  sizedBoxHeight(height: 16.h),
                  userNameAndDate(authController: authController),
                  sizedBoxHeight(height: 20.h),
                  const Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: AppConstants.horizontalPadding),
                    child: AttendanceSection(),
                  ),
                  // sizedBoxHeight(height: 16.h),

                  // const Padding(
                  //   padding: EdgeInsets.symmetric(
                  //       horizontal: AppConstants.horizontalPadding),
                  //   child: DailyAttendanceSection(),
                  // ),
                  sizedBoxHeight(height: 16.h),
                  const TopAchieversSection(),
                  const RecentTasksSection(),
                  const RecentLeadsSection(),
                  const RecentOrdersSection(),
                  sizedBoxHeight(height: 16.h),
                  const QuickActionsSection(),
                  ManagementSection(
                    title: "Performance & Assets",
                    actions: managementActions1(context: context),
                  ),
                  ManagementSection(
                    title: "Recruitment & Compliance",
                    actions: managementActions2(context: context),
                  ),
                  const ThisMonthTargetSection(),
                  sizedBoxHeight(height: 16.h),
                  const NotificationSection(),
                  sizedBoxHeight(height: 40.h),
                ],
              ),
            ),
          );
        });
      }),
    );
  }

  Widget userNameAndDate({required AuthController authController}) => Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.horizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              "Hi, ${authController.userModel?.name ?? ""}",
              style: Helper(context).textTheme.titleMedium?.copyWith(
                    fontSize: 24.sp,
                  ),
            ),
            sizedBoxHeight(height: 2),
            CustomText(
              DateFormatters().dayDM.format(getDateTime()),
              style: Helper(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(fontSize: 12.sp, color: greyLight5),
            ),
          ],
        ),
      );
}
