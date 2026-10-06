import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';

class PunchInAndPunchOutIconWidget extends StatelessWidget {
  final String? time;
  final bool isCheckIn;
  const PunchInAndPunchOutIconWidget({
    super.key,
    required this.time,
    this.isCheckIn = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isCheckIn) {
      return Column(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: green2.withValues(alpha: 0.3)),
            child: const Icon(
              Icons.login,
              color: green2,
            ),
          ),
          sizedBoxHeight(height: 8.h),
          CustomText(
            "Punch In",
            style: Helper(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 10.sp,
                  color: greyLight5,
                ),
          ),
          CustomText(
            time ?? "-- : --",
            style: Helper(context).textTheme.titleMedium?.copyWith(
                  fontSize: 17.sp,
                  color: blackText4,
                ),
          ),
        ],
      );
    }
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
              shape: BoxShape.circle, color: red1.withValues(alpha: 0.2)),
          child: const Icon(
            Icons.logout,
            color: red1,
          ),
        ),
        sizedBoxHeight(height: 8.h),
        CustomText(
          "Punch Out",
          style: Helper(context).textTheme.bodyMedium?.copyWith(
                fontSize: 10.sp,
                color: greyLight5,
              ),
        ),
        CustomText(
          time ?? "-- : --",
          style: Helper(context).textTheme.titleMedium?.copyWith(
                fontSize: 17.sp,
                color: blackText4,
              ),
        ),
      ],
    );
  }
}
