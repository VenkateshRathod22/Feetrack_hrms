import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';

class TodayTeamAttendanceSummaryWidget extends StatelessWidget {
  final String title;
  final String subTitle;
  final String icon;
  final Color color;
  final Function()? onTap;
  const TodayTeamAttendanceSummaryWidget({
    super.key,
    required this.title,
    required this.subTitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(14.w),
            height: 48.h,
            width: 48.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withValues(alpha: 0.30),
            ),
            child: SvgPicture.asset(
              icon,
              colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
            ),
          ),
          sizedBoxHeight(height: 8.h),
          CustomText(
            title,
            style: Helper(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 12.sp,
                  color: greyLight6,
                ),
          ),
          sizedBoxHeight(height: 4.h),
          CustomText(
            subTitle,
            style: Helper(context).textTheme.titleSmall?.copyWith(
                  fontSize: 26.sp,
                  color: color,
                ),
          ),
        ],
      ),
    );
  }
}
