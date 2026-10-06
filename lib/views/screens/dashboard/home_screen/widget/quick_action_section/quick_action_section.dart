import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/auth_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/base/custom_button.dart';
import 'package:vlr/views/screens/dashboard/home_screen/widget/quick_action_section/quick_action_widget.dart';

class QuickActionsSection extends StatelessWidget {
  const QuickActionsSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (authController) {
      final fullList = quickActionModelList(context: context).where((element) {
        if (element.requiredPermission == null) return true;
        return authController.hasPermission(element.requiredPermission!);
      }).toList();

      if (fullList.isEmpty) return const SizedBox.shrink();

      // Split the list for two rows
      final row1 = fullList.take(6).toList();
      final row2 = fullList.skip(6).toList();

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
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                "Quick Actions",
                style: Helper(context).textTheme.titleMedium?.copyWith(
                      fontSize: 16.sp,
                    ),
              ),
              CustomButton(
                onTap: () {},
                type: ButtonType.tertiary,
                child: CustomText(
                  "View All",
                  style: Helper(context).textTheme.titleMedium?.copyWith(
                        fontSize: 12.sp,
                        color: tertiaryColor,
                      ),
                ),
              ),
            ],
          ),
          sizedBoxHeight(height: 16.h),
          SizedBox(
            height: 125.h,
            child: ListView.separated(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final quickActionModel = row1[index];
                  return QuickActionWidget(quickActionModel: quickActionModel);
                },
                separatorBuilder: (_, __) => sizedBoxWidth(width: 26.w),
                itemCount: row1.length),
          ),
          if (row2.isNotEmpty) ...[
            sizedBoxHeight(height: 16.h),
            SizedBox(
              height: 125.h,
              child: ListView.separated(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    final quickActionModel = row2[index];
                    return QuickActionWidget(quickActionModel: quickActionModel);
                  },
                  separatorBuilder: (_, __) => sizedBoxWidth(width: 26.w),
                  itemCount: row2.length),
            ),
          ],
        ],
      ),
    );
    });
  }
}
