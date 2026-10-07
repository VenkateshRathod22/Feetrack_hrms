import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/auth_controller.dart';
import 'package:vlr/controllers/staff_contoller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/base/shimmer.dart';
import 'package:vlr/views/screens/attendance/team_attendance_history/team_attendaance_history_screen/widget/appbar_and_searchbar.dart';
import 'package:vlr/views/screens/staff/widget/staff_widget.dart';
import 'package:vlr/views/screens/staff/create_staff_screen.dart';

class StaffScreen extends StatefulWidget {
  const StaffScreen({super.key});

  @override
  State<StaffScreen> createState() => _StaffScreenState();
}

class _StaffScreenState extends State<StaffScreen> {
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<StaffController>().getStaffList(status: 'all');
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (authController) {
      return Scaffold(
        backgroundColor: backgroundLight,
        floatingActionButton: authController.hasPermission("staff_create")
            ? FloatingActionButton.extended(
                onPressed: () {
                  Get.find<StaffController>().clearControllers();
                  navigate(context: context, page: const CreateStaffScreen());
                },
                backgroundColor: primaryColor,
                icon: Icon(Icons.person_add_rounded, color: white),
                label: CustomText(
                  "Add Staff",
                  style: TextStyle(
                    color: white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
                ),
              )
            : null,
        body: GetBuilder<StaffController>(builder: (staffController) {
          return Column(
            children: [
              AppBarAndSearchBar(
                title: "Staff Management",
                onChanged: (value) {
                  _debounce?.cancel();
                  _debounce = Timer(const Duration(milliseconds: 500), () {
                    staffController.getStaffList(
                      status: staffController
                          .statusTabs[staffController.selectedTabIndex],
                      search: value.trim(),
                    );
                  });
                },
              ),
              sizedBoxHeight(height: 12.h),
              
              // Status Tabs
              Container(
                height: 45.h,
                margin: EdgeInsets.only(bottom: 12.h),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  itemCount: staffController.statusTabs.length,
                  itemBuilder: (context, index) {
                    bool isSelected = staffController.selectedTabIndex == index;
                    String status = staffController.statusTabs[index];
                    return GestureDetector(
                      onTap: () => staffController.updateTabIndex(index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: EdgeInsets.only(right: 10.w),
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isSelected ? primaryColor : white,
                          borderRadius: BorderRadius.circular(25.r),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: primaryColor.withValues(alpha: 0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  )
                                ]
                              : [],
                          border: Border.all(
                            color: isSelected ? primaryColor : greyLight2,
                            width: 1,
                          ),
                        ),
                        child: CustomText(
                          capitalize(status),
                          style: Helper(context).textTheme.bodyMedium?.copyWith(
                                color: isSelected ? white : greyDart3,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                                fontSize: 13.sp,
                              ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              Expanded(
                child: staffController.isLoading
                    ? ListView.separated(
                        padding: AppConstants.screenPadding,
                        itemBuilder: (context, index) => CustomShimmer(
                          isLoading: true,
                          child: Container(
                            height: 160.h,
                            decoration: BoxDecoration(
                              color: white,
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                          ),
                        ),
                        separatorBuilder: (_, __) =>
                            sizedBoxHeight(height: 16.h),
                        itemCount: 5,
                      )
                    : staffController.staffList.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.people_outline_rounded,
                                    size: 64.sp, color: greyLight2),
                                sizedBoxHeight(height: 16.h),
                                CustomText(
                                  "No staff found",
                                  style: Helper(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(color: greyLight5),
                                ),
                              ],
                            ),
                          )
                        : ListView.separated(
                            padding: AppConstants.screenPadding,
                            itemBuilder: (context, index) => StaffWidget(
                              staff: staffController.staffList[index],
                            ),
                            separatorBuilder: (_, __) =>
                                sizedBoxHeight(height: 16.h),
                            itemCount: staffController.staffList.length,
                          ),
              ),
            ],
          );
        }),
      );
    });
  }

}
