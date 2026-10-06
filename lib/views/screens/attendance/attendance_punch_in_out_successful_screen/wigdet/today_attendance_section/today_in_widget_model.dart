import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vlr/controllers/attendance_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/date_formatters_and_converters.dart';
import 'package:vlr/services/theme.dart';

class TodayInWidgetModel {
  final IconData icon;
  final Color color;
  final String title;
  final Widget widget;

  TodayInWidgetModel(
      {required this.icon,
      required this.color,
      required this.title,
      required this.widget});
}

List<TodayInWidgetModel> todayInWidgetModelList(
        {required AttendanceController attendanceController,
        required BuildContext context}) =>
    [
      TodayInWidgetModel(
        icon: Icons.login,
        color: green2,
        title: "Punch In",
        widget: Column(
          children: [
            CustomText(
              attendanceController.attendanceModel?.checkInTimeFormat ?? "",
              style: Helper(context).textTheme.titleMedium?.copyWith(
                    fontSize: 10.sp,
                    color: green2,
                  ),
            ),
            sizedBoxHeight(height: 4.h),
            CustomText(
              DateFormatters().dMy.format(
                    attendanceController.attendanceModel?.date ?? getDateTime(),
                  ),
              style: Helper(context).textTheme.titleMedium?.copyWith(
                    fontSize: 10.sp,
                    color: greyDart2,
                  ),
            ),
          ],
        ),
      ),
      TodayInWidgetModel(
        icon: Icons.logout,
        color: red1,
        title: "Punch out",
        widget: Column(
          children: [
            CustomText(
              attendanceController.attendanceModel?.checkOutTimeFormat ?? "",
              style: Helper(context).textTheme.titleMedium?.copyWith(
                    fontSize: 10.sp,
                    color: red1,
                  ),
            ),
            sizedBoxHeight(height: 4.h),
            CustomText(
              DateFormatters().dMy.format(
                    attendanceController.attendanceModel?.date ?? getDateTime(),
                  ),
              style: Helper(context).textTheme.titleMedium?.copyWith(
                    fontSize: 10.sp,
                    color: greyDart2,
                  ),
            ),
          ],
        ),
      ),
      TodayInWidgetModel(
        icon: Icons.watch_later_outlined,
        color: primaryColor,
        title: "Working Hours",
        widget: Column(
          children: [
            CustomText(
              attendanceController.attendanceModel?.workingTimeFormat ?? "",
              style: Helper(context).textTheme.titleMedium?.copyWith(
                    fontSize: 10.sp,
                    color: primaryColor,
                  ),
            ),
          ],
        ),
      ),
      TodayInWidgetModel(
        icon: Icons.security_outlined,
        color: green2,
        title: "Status",
        widget: Column(
          children: [
            CustomText(
              attendanceController.attendanceModel?.statusName ?? "",
              style: Helper(context).textTheme.titleMedium?.copyWith(
                    fontSize: 10.sp,
                    color: attendanceController.attendanceModel?.statusColor,
                  ),
            ),
          ],
        ),
      ),
    ];
