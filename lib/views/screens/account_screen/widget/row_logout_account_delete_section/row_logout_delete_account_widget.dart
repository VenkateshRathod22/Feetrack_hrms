import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';

class RowOfLogOutAndDeleteAccountWIdget extends StatelessWidget {
  final IconData icon;
  final String title;
  final Function()? onTap;
  const RowOfLogOutAndDeleteAccountWIdget({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            width: 1,
            color: greyLight4,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: redDark,
            ),
            sizedBoxHeight(height: 8.h),
            CustomText(
              title,
              style: Helper(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 14,
                    color: redDark,
                  ),
            )
          ],
        ),
      ),
    );
  }
}
