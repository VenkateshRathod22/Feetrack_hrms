import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';

class PunchInAndPunchOutWidget extends StatelessWidget {
  final String title;
  final String? subTitle;
  const PunchInAndPunchOutWidget({
    super.key,
    required this.title,
    this.subTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomText(
          title,
          style: Helper(context).textTheme.bodyMedium?.copyWith(
                fontSize: 16.sp,
                color: greyText2,
              ),
        ),
        sizedBoxHeight(height: 4.h),
        CustomText(
          subTitle ?? "-- : --",
          style: Helper(context).textTheme.titleMedium?.copyWith(
                fontSize: 20.sp,
                color: green,
              ),
        )
      ],
    );
  }
}
