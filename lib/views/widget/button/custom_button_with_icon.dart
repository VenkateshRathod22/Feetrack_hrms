import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vlr/services/constants.dart';

class CustomButtonWithIcon extends StatelessWidget {
  final String title;
  final String icon;
  final Color bgColor;
  final Color titleColor;
  final ColorFilter iconColor;
  final Function()? onTap;
  const CustomButtonWithIcon({
    super.key,
    required this.title,
    required this.icon,
    this.onTap,
    required this.bgColor,
    required this.titleColor,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:  EdgeInsets.symmetric(vertical: 13.h),
        decoration: BoxDecoration(
            color: bgColor, borderRadius: BorderRadius.circular(8.r)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              icon,
              colorFilter: iconColor,
            ),
            SizedBox(
              width: 9.w,
            ),
            Text(
              title,
              style: Helper(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 12.sp, fontWeight: FontWeight.bold, color: titleColor),
            )
          ],
        ),
      ),
    );
  }
}
