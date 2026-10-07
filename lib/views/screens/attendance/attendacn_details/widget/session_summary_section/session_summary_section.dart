import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:vlr/controllers/attendance_controller.dart';
import 'package:vlr/generated/assets.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/date_formatters_and_converters.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/base/shimmer.dart';
import 'package:vlr/views/screens/attendance/attendacn_details/widget/session_summary_section/seesion_widget.dart';

class SessionSummarySection extends StatelessWidget {
  const SessionSummarySection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AttendanceController>(builder: (attendanceController) {
      return Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            color: white,
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 1),
                blurRadius: 2,
                spreadRadius: 0,
                color: black.withValues(alpha: 0.05),
              )
            ]),
        child: Column(
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  Assets.svgsSession,
                ),
                sizedBoxWidth(width: 8.w),
                Expanded(
                  child: CustomText(
                    "Session Summary",
                    style: Helper(context).textTheme.titleMedium?.copyWith(
                          fontSize: 14.sp,
                          color: blackText4,
                        ),
                  ),
                )
              ],
            ),
            sizedBoxHeight(height: 16.h),
            CustomShimmer(
              isLoading: attendanceController.isLoading,
              child: Row(
                children: [
                  Expanded(
                    child: SessionWidget(
                      icon: Icons.watch_later_outlined,
                      iconColor: blueLight3,
                      title: 'Working Hr',
                      subtitle: formatMinutesToHours(attendanceController
                              .attendanceModel?.workingMinutes ??
                          0),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 4.w),
                    width: 1,
                    height: 60.h,
                    color: greyLight6,
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: SessionWidget(
                        icon: Icons.watch_later_outlined,
                        iconColor: organ,
                        title: 'Late Hr',
                        subtitle: formatMinutesToHours(int.tryParse(
                            attendanceController.attendanceModel?.lateMinutes ??
                                "")),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 4.w),
                    width: 1,
                    height: 60.h,
                    color: greyLight6,
                  ),
                  Expanded(
                    child: SessionWidget(
                      icon: Icons.calendar_month_sharp,
                      title: 'Check In Date',
                      iconColor: purple,
                      subtitle: DateFormat('MMM dd, yyyy').format(
                          attendanceController.attendanceModel?.date ??
                              getDateTime()),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 4.w),
                    width: 1,
                    height: 60.h,
                    color: greyLight6,
                  ),
                  Expanded(
                    child: SessionWidget(
                      icon: Icons.work_outline_outlined,
                      iconColor: greenLight,
                      title: 'Status',
                      subtitle: capitalize(
                          attendanceController.attendanceModel?.statusName ??
                              ""),
                      subtitleColor:
                          attendanceController.attendanceModel?.statusColor,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      );
    });
  }
}
