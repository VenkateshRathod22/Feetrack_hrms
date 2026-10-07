import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/dashboard_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';

class RecentLeadsSection extends StatelessWidget {
  const RecentLeadsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashBoardController>(builder: (dashController) {
      final leads = dashController.dashboardModel?.recentLeads ?? [];
      if (leads.isEmpty) return const SizedBox.shrink();

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
                  "Recent Leads",
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
              itemCount: leads.length > 3 ? 3 : leads.length,
              separatorBuilder: (context, index) => Divider(height: 24.h, color: grey.withOpacity(0.1)),
              itemBuilder: (context, index) {
                final lead = leads[index];
                return Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.w),
                      decoration: BoxDecoration(
                        color: tertiaryColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.person_outline, color: tertiaryColor, size: 20.sp),
                    ),
                    sizedBoxWidth(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            lead.customerName ?? "Unknown Customer",
                            style: Helper(context).textTheme.titleSmall?.copyWith(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          CustomText(
                            lead.businessName ?? lead.email ?? "",
                            style: Helper(context).textTheme.bodySmall?.copyWith(
                                  fontSize: 12.sp,
                                  color: grey,
                                ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: (lead.status == 'won' ? Colors.green : Colors.orange).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: CustomText(
                        capitalize(lead.status ?? "Pending"),
                        style: Helper(context).textTheme.bodySmall?.copyWith(
                              fontSize: 10.sp,
                              color: lead.status == 'won' ? Colors.green : Colors.orange,
                              fontWeight: FontWeight.bold,
                            ),
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
