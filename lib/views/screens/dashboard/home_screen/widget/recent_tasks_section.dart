import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/dashboard_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';

class RecentTasksSection extends StatelessWidget {
  const RecentTasksSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashBoardController>(builder: (dashController) {
      final tasks = dashController.dashboardModel?.recentTasks ?? [];
      if (tasks.isEmpty) return const SizedBox.shrink();

      return Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 4),
              blurRadius: 12,
              color: black.withOpacity(0.05),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  "Recent Tasks",
                  style: Helper(context).textTheme.titleMedium?.copyWith(
                        fontSize: 16.sp,
                      ),
                ),
                CustomText(
                  "View All",
                  style: Helper(context).textTheme.bodySmall?.copyWith(
                        color: tertiaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
            sizedBoxHeight(height: 12.h),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: tasks.length > 3 ? 3 : tasks.length,
              separatorBuilder: (context, index) => Divider(height: 24.h, color: grey.withOpacity(0.1)),
              itemBuilder: (context, index) {
                final task = tasks[index];
                return Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.w),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.task_alt, color: primaryColor, size: 20.sp),
                    ),
                    sizedBoxWidth(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            task.title ?? "Untitled Task",
                            style: Helper(context).textTheme.titleSmall?.copyWith(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          CustomText(
                            "Status: ${capitalize(task.status ?? "Pending")}",
                            style: Helper(context).textTheme.bodySmall?.copyWith(
                                  fontSize: 12.sp,
                                  color: grey,
                                ),
                          ),
                        ],
                      ),
                    ),
                    CustomText(
                      task.dueDate ?? task.startDate ?? "",
                      style: Helper(context).textTheme.bodySmall?.copyWith(
                            fontSize: 11.sp,
                            color: grey,
                          ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      );
    });
  }
}
