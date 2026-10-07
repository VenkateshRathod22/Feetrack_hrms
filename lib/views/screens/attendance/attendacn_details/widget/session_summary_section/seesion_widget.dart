import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';

class SessionWidget extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final Color? subtitleColor;
  const SessionWidget({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    this.subtitleColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          color: iconColor,
          size: 16.sp,
        ),
        sizedBoxHeight(height: 7.h),
        CustomText(
          title,
          style: Helper(context).textTheme.bodySmall?.copyWith(
                fontSize: 12.sp,
                color: greyLight5,
              ),
        ),
        sizedBoxHeight(height: 4.h),
        CustomText(
          subtitle,
          maxLines: 2,
          textAlign: TextAlign.center,
          style: Helper(context).textTheme.titleMedium?.copyWith(
                fontSize: 12.sp,
                color: subtitleColor ?? blackText2,
              ),
        ),
      ],
    );
  }
}
