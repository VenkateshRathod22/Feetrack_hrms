import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/auth_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/screens/dashboard/home_screen/widget/quick_action_section/quick_action_widget.dart';

class ManagementSection extends StatelessWidget {
  final String title;
  final List<QuickActionModel> actions;

  const ManagementSection({
    super.key,
    required this.title,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (authController) {
      final filteredActions = actions.where((action) {
        if (action.requiredPermission == null) return true;
        return authController.hasPermission(action.requiredPermission!);
      }).toList();

      if (filteredActions.isEmpty) return const SizedBox.shrink();

      return Container(
        margin: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.h),
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 4),
              blurRadius: 12,
              spreadRadius: 0,
              color: black.withValues(alpha: 0.05),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              title,
              style: Helper(context).textTheme.titleMedium?.copyWith(
                    fontSize: 16.sp,
                  ),
            ),
            sizedBoxHeight(height: 16.h),
            SizedBox(
              height: 125.h,
              child: ListView.separated(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return QuickActionWidget(quickActionModel: filteredActions[index]);
                },
                separatorBuilder: (_, __) => sizedBoxWidth(width: 20.w),
                itemCount: filteredActions.length,
              ),
            ),
          ],
        ),
      );
    });
  }
}
