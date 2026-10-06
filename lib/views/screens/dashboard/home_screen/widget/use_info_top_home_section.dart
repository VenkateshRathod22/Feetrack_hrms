import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:vlr/controllers/dashboard_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/date_formatters_and_converters.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/base/custom_image.dart';
import 'package:vlr/views/base/shimmer.dart';
import 'package:vlr/views/screens/account_screen/account_screen.dart';
import 'package:vlr/views/screens/edit_profile/profile_detail_screen.dart';

import '../../../../../controllers/auth_controller.dart';
import '../../../notification_screen/notification_screen.dart';

class UserInfoTopHome extends StatelessWidget {
  const UserInfoTopHome({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (authController) {
      return GetBuilder<DashBoardController>(builder: (dashController) {
        final dashData = dashController.dashboardModel;
        return CustomShimmer(
          isLoading: authController.isLoading || dashController.isLoading,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              left: 16.w,
              right: 12.w,
              bottom: 20.h,
              top: MediaQuery.of(context).padding.top + 8.h,
            ),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25.r),
                bottomRight: Radius.circular(25.r),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (authController.isLoading) return;
                        navigate(
                            context: context, page: const ProfileDetailScreen());
                      },
                      child: Row(
                        children: [
                          CustomImage(
                            path: (authController.userModel?.profileImage !=
                                        null ||
                                    (authController.userModel?.profileImage
                                            ?.isNotEmpty ??
                                        false))
                                ? (authController.userModel?.profileImage ??
                                    Assets.imagesNoProfile)
                                : Assets.imagesNoProfile,
                            height: 54.h,
                            width: 54.w,
                            isProfile: true,
                            radius: 999,
                            fit: BoxFit.cover,
                          ),
                          sizedBoxWidth(width: 12.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                "Hi, ${authController.userModel?.name ?? ""}",
                                style: Helper(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold,
                                      color: white,
                                    ),
                              ),
                              CustomText(
                                capitalize(
                                    authController.userModel?.role ?? ""),
                                style: Helper(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      fontSize: 12.sp,
                                      color: white.withOpacity(0.8),
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => navigate(
                              context: context,
                              page: const NotificationScreen()),
                          icon: Icon(Icons.notifications_none_outlined,
                              color: white, size: 24.sp),
                        ),
                        IconButton(
                          onPressed: () => navigate(
                              context: context, page: const AccountScreen()),
                          icon: Icon(Icons.settings_outlined,
                              color: white, size: 24.sp),
                        ),
                      ],
                    ),
                  ],
                ),
                sizedBoxHeight(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: CustomText(
                        "Business ID: ${authController.userModel?.email?.split('@').first ?? "N/A"}",
                        style: Helper(context).textTheme.bodySmall?.copyWith(
                              fontSize: 12.sp,
                              color: white,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.calendar_month, size: 22.sp, color: white),
                        sizedBoxWidth(width: 8.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              DateFormatters().dayFull.format(getDateTime()),
                              style: Helper(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                    fontSize: 12.sp,
                                    color: white,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            CustomText(
                              DateFormatters().dMy.format(getDateTime()),
                              style: Helper(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    fontSize: 10.sp,
                                    color: white.withOpacity(0.9),
                                  ),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
                sizedBoxHeight(height: 20.h),
                if (dashData?.myAttendanceToday != null)
                  Container(
                    margin: EdgeInsets.only(bottom: 20.h),
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    decoration: BoxDecoration(
                      color: white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              "Today's Attendance",
                              style: Helper(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: white.withOpacity(0.8),
                                    fontSize: 10.sp,
                                  ),
                            ),
                            sizedBoxHeight(height: 4.h),
                            CustomText(
                              capitalize(
                                  dashData?.myAttendanceToday?.status ??
                                      "N/A"),
                              style: Helper(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                    color: white,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            _buildAttendanceTime(
                                context,
                                "Check In",
                                dashData?.myAttendanceToday?.checkIn ?? "--:--",
                                Icons.login),
                            sizedBoxWidth(width: 20.w),
                            _buildAttendanceTime(
                                context,
                                "Check Out",
                                dashData?.myAttendanceToday?.checkOut ??
                                    "--:--",
                                Icons.logout),
                          ],
                        )
                      ],
                    ),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem(
                        context,
                        "${dashData?.myAttendanceThisMonth ?? 0}",
                        "Attendance",
                        Icons.calendar_month),
                    _buildStatItem(
                        context,
                        "${dashData?.myPendingLeaves ?? 0}",
                        "Leaves",
                        Icons.exit_to_app),
                    _buildStatItem(
                        context,
                        "${dashData?.totalLeads ?? 0}",
                        "Leads",
                        Icons.leaderboard),
                    _buildStatItem(
                        context,
                        "${dashData?.myPendingTasks ?? 0}",
                        "Tasks",
                        Icons.task_alt),
                  ],
                )
              ],
            ),
          ),
        );
      });
    });
  }

  Widget _buildAttendanceTime(
      BuildContext context, String label, String time, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: white.withOpacity(0.7), size: 12.sp),
            sizedBoxWidth(width: 4.w),
            CustomText(
              label,
              style: Helper(context).textTheme.bodySmall?.copyWith(
                    color: white.withOpacity(0.7),
                    fontSize: 9.sp,
                  ),
            ),
          ],
        ),
        CustomText(
          time,
          style: Helper(context).textTheme.bodySmall?.copyWith(
                color: white,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }

  Widget _buildStatItem(
      BuildContext context, String value, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: white.withOpacity(0.9), size: 20.sp),
        sizedBoxHeight(height: 4.h),
        CustomText(
          value,
          style: Helper(context).textTheme.titleMedium?.copyWith(
                color: white,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
        ),
        CustomText(
          label,
          style: Helper(context).textTheme.bodySmall?.copyWith(
                color: white.withOpacity(0.8),
                fontSize: 10.sp,
              ),
        ),
      ],
    );
  }
}
