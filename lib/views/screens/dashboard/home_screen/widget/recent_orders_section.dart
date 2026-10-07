import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/dashboard_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';

class RecentOrdersSection extends StatelessWidget {
  const RecentOrdersSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashBoardController>(builder: (dashController) {
      final orders = dashController.dashboardModel?.recentOrders ?? [];
      if (orders.isEmpty) return const SizedBox.shrink();

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
                  "Recent Orders",
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
              itemCount: orders.length > 3 ? 3 : orders.length,
              separatorBuilder: (context, index) => Divider(height: 24.h, color: grey.withOpacity(0.1)),
              itemBuilder: (context, index) {
                final order = orders[index];
                return Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.w),
                      decoration: BoxDecoration(
                        color: secondaryColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.shopping_bag_outlined, color: secondaryColor, size: 20.sp),
                    ),
                    sizedBoxWidth(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            order.lead?.customerName ?? "Order #${order.id?.substring(0, 8)}",
                            style: Helper(context).textTheme.titleSmall?.copyWith(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          CustomText(
                            "Amt: ₹${order.finalAmount ?? order.totalAmount ?? 0}",
                            style: Helper(context).textTheme.bodySmall?.copyWith(
                                  fontSize: 12.sp,
                                  color: grey,
                                ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        CustomText(
                          capitalize(order.paymentStatus ?? "Pending"),
                          style: Helper(context).textTheme.bodySmall?.copyWith(
                                fontSize: 11.sp,
                                color: order.paymentStatus == 'paid' ? Colors.green : Colors.orange,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        CustomText(
                          capitalize(order.approvalStatus ?? ""),
                          style: Helper(context).textTheme.bodySmall?.copyWith(
                                fontSize: 10.sp,
                                color: grey,
                              ),
                        ),
                      ],
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
