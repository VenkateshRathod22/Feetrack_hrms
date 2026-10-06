import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/attendance_controller.dart';
import 'package:vlr/generated/assets.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/lanch_helper.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/screens/attendance/attendacn_details/widget/location_attendance_section/location_attendance_widget.dart';

class LocationAttendanceSection extends StatelessWidget {
  const LocationAttendanceSection({super.key});

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
                  Assets.svgsLocationOutline,
                  height: 20.h,
                  width: 20.w,
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(blueLight3, BlendMode.srcIn),
                ),
                sizedBoxWidth(width: 8.w),
                Expanded(
                  child: CustomText(
                    "Location",
                    style: Helper(context).textTheme.titleMedium?.copyWith(
                          fontSize: 14.sp,
                          color: blackText4,
                        ),
                  ),
                )
              ],
            ),
            sizedBoxHeight(height: 16.h),
            Row(
              children: [
                Expanded(
                  child: LocationAttendanceWidget(
                      title: "CHECK IN LOCATION",
                      location:
                          "${attendanceController.attendanceModel?.checkInLat ?? "--"}, ${attendanceController.attendanceModel?.checkInLng ?? "--"}",
                      color: green2,
                      onTap: () {
                        LaunchHelper.openGoogleMap(
                            lat: attendanceController
                                    .attendanceModel?.checkInLat ??
                                "",
                            lng: attendanceController
                                    .attendanceModel?.checkInLng ??
                                "");
                      }),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16.w),
                  width: 1,
                  height: 80.h,
                  color: greyLight6,
                ),
                Expanded(
                  child: LocationAttendanceWidget(
                      title: "CHECK OUT LOCATION",
                      location:
                          "${attendanceController.attendanceModel?.checkOutLat ?? "--"}, ${attendanceController.attendanceModel?.checkOutLng ?? "--"}",
                      color: red1,
                      onTap: () {
                        LaunchHelper.openGoogleMap(
                            lat: attendanceController
                                    .attendanceModel?.checkOutLat ??
                                "",
                            lng: attendanceController
                                    .attendanceModel?.checkOutLng ??
                                "");
                      }),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
