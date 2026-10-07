import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/screens/attendance/attendance_history/widget/attendance_summary_section/attendance_summary_model.dart';

class AttendanceSummaryWidget extends StatelessWidget {
  final AttendanceSummaryModel attendanceSummaryModel;
  const AttendanceSummaryWidget({
    super.key,
    required this.attendanceSummaryModel,
  });

  @override
  Widget build(BuildContext context) {
    final color = attendanceSummaryModel.color;
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(10.r),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: SvgPicture.asset(
            attendanceSummaryModel.icon,
            height: 16.sp,
            width: 16.sp,
            colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
          ),
        ),
        sizedBoxHeight(height: 10.h),
        CustomText(
          attendanceSummaryModel.count ?? "0",
          style: TextStyle(
            fontSize: 18.sp, 
            fontWeight: FontWeight.w800, 
            color: blackText1,
            letterSpacing: -0.5,
          ),
        ),
        sizedBoxHeight(height: 2.h),
        CustomText(
          attendanceSummaryModel.title,
          maxLines: 1,
          style: TextStyle(
            fontSize: 10.sp, 
            color: greyDart2,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
