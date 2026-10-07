import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vlr/generated/assets.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';

class NoticeContainer extends StatelessWidget {
  const NoticeContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: greyLight1,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          width: 1,
          color: greyLight6,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(Assets.svgsInfo),
          sizedBoxWidth(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  "Note",
                  style: Helper(context).textTheme.titleMedium?.copyWith(
                        fontSize: 12.sp,
                        color: primaryColor,
                      ),
                ),
                sizedBoxHeight(height: 4.h),
                CustomText(
                  "Attendance data is captured automatically at the time of punch in and punch out.",
                  maxLines: 3,
                  style: Helper(context).textTheme.bodySmall?.copyWith(
                        fontSize: 10.sp,
                        color: greyDart3,
                      ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
