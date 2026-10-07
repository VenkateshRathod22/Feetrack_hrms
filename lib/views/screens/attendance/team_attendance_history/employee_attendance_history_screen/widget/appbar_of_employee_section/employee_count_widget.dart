import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';

class EmployeeCountWidget extends StatelessWidget {
  final String? title;
  final String subtitle;
  final Color color;
  const EmployeeCountWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomText(
          title ?? "",
          style: Helper(context).textTheme.titleLarge?.copyWith(
                fontSize: 24.sp,
                color: color,
              ),
        ),
        sizedBoxHeight(height: 8.h),
        CustomText(
          subtitle,
          style: Helper(context).textTheme.bodyMedium?.copyWith(
                fontSize: 10.sp,
                color: greyDart3,
              ),
        ),
      ],
    );
  }
}
