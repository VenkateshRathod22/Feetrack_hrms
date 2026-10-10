import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/attendance_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';

class CheckInAndOutTImeRowSection extends StatelessWidget {
  const CheckInAndOutTImeRowSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AttendanceController>(builder: (attendanceController) {
      return Column(
        children: [

          sizedBoxHeight(height: 12.h),
          Row(
            children: [
              Expanded(
                child: checkWidget(
                  context: context,
                  title: 'Check-in',
                  subTitle:
                      attendanceController.attendanceModel?.checkInTimeFormat ??
                          "-- : --",
                ),
              ), 
               Container(
                height: 50.h,
                width: 1, color: dividerColor1,
               ), 
              Expanded(
                child: checkWidget(
                  context: context,
                  title: 'Check-out',
                  subTitle:
                      attendanceController.attendanceModel?.checkOutTimeFormat ??
                          "-- : --",
                ),
              ), 
                             Container(
                height: 50.h,
                width: 1, color: dividerColor1,
               ), 
              Expanded(
                child: checkWidget(
                  context: context,
                  title: 'Shift',
                  subTitle:
                          "-- : --",
                ),
              ), 
            ],
          )
        ],
      );
    });
  }

  Column checkWidget({
    required BuildContext context,
    required String title,
    required String subTitle,
  }) {
    return Column(
      children: [
        CustomText(
          title,
          style: Helper(context).textTheme.bodyMedium?.copyWith(
                fontSize: 12.sp,
                color: greyLight5,
              ),
        ),
        sizedBoxHeight(height: 2), 
        CustomText(
          subTitle,
          style: Helper(context).textTheme.titleMedium?.copyWith(
                fontSize: 12.sp,
                color: black,
              ),
        ),
      ],
    );
  }
}
