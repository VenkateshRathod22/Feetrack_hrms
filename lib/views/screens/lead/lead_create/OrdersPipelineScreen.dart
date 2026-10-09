import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/lead_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/data/models/response/lead_order_comment_model.dart';
import 'package:vlr/data/models/response/lead_order_model.dart';
import 'package:vlr/views/screens/lead/lead_create/lead_create_order_screen.dart';
import 'package:vlr/views/widget/button/appbar_back_button.dart';
import 'package:vlr/views/widget/text_box/app_text_box.dart';
import 'package:intl/intl.dart';

import '../../../../data/models/response/response_model.dart';

class Orderspipelinescreen extends StatefulWidget {
  const Orderspipelinescreen({super.key});

  @override
  State<Orderspipelinescreen> createState() => _OrderspipelinescreenState();
}

class _OrderspipelinescreenState extends State<Orderspipelinescreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<LeadController>().getLeadOrderTabs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LeadController>(builder: (controller) {
      return Scaffold(
        backgroundColor: backgroundLight,
        appBar: AppBar(
          title: CustomText(
            "Orders Pipeline",
            style: Helper(context).textTheme.titleMedium?.copyWith(fontSize: 18.sp),
          ),
          centerTitle: true,
          backgroundColor: white,
          elevation: 0,
          leading: const AppBarBackButton(),
          actions: [
            IconButton(
              onPressed: () => navigate(context: context, page: const LeadCreateOrderScreen()),
              icon:  Icon(Icons.add_circle_outline, color: primaryColor),
              tooltip: "Create Order",
            ),
          ],
          bottom: controller.leadOrderTabs.isEmpty
              ? null
              : PreferredSize(
                  preferredSize: Size.fromHeight(50.h),
                  child: Container(
                    height: 50.h,
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    decoration: BoxDecoration(
                      color: white,
                      border: Border(bottom: BorderSide(color: greyLight4, width: 1)),
                    ),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      itemCount: controller.leadOrderTabs.length,
                      itemBuilder: (context, index) {
                        final tab = controller.leadOrderTabs[index];
                        final isSelected = controller.selectedOrderTabIndex == index;
                        return GestureDetector(
                          onTap: () => controller.updateSelectedOrderTab(index),
                          child: Container(
                            margin: EdgeInsets.only(right: 12.w),
                            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                            decoration: BoxDecoration(
                              color: isSelected ? primaryColor : greyLight4,
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Row(
                              children: [
                                CustomText(
                                  tab.label ?? "",
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                    color: isSelected ? white : greyText,
                                  ),
                                ),
                                if (tab.count != null && tab.count! > 0) ...[
                                  sizedBoxWidth(width: 6),
                                  Container(
                                    padding: EdgeInsets.all(4.r),
                                    decoration: BoxDecoration(
                                      color: isSelected ? white.withValues(alpha: 0.2) : primaryColor.withValues(alpha: 0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: CustomText(
                                      tab.count.toString(),
                                      style: TextStyle(
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.bold,
                                        color: isSelected ? white : primaryColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
        ),
        body: controller.isLoading && controller.leadOrders.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : controller.leadOrders.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inventory_2_outlined, size: 64.sp, color: greyLight2),
                        sizedBoxHeight(height: 16),
                        CustomText(
                          "No orders found in '${controller.leadOrderTabs[controller.selectedOrderTabIndex].label}'",
                          style: TextStyle(color: greyText, fontSize: 14.sp),
                        ),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: () => controller.getLeadOrders(controller.leadOrderTabs[controller.selectedOrderTabIndex].key ?? "all"),
                    child: ListView.separated(
                      padding: EdgeInsets.all(16.r),
                      itemCount: controller.leadOrders.length,
                      separatorBuilder: (_, __) => sizedBoxHeight(height: 16.h),
                      itemBuilder: (context, index) {
                        final order = controller.leadOrders[index];
                        return _OrderPipelineCard(order: order);
                      },
                    ),
                  ),
      );
    });
  }
}

class _OrderPipelineCard extends StatelessWidget {
  final LeadOrderModel order;
  const _OrderPipelineCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      order.orderNumber ?? "#ORDER",
                      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: primaryColor),
                    ),
                    _buildStatusBadge(order.approvalStatus),
                  ],
                ),
                sizedBoxHeight(height: 12),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20.r,
                      backgroundColor: secondaryColor.withValues(alpha: 0.1),
                      child: Icon(Icons.person_outline, color: secondaryColor, size: 20.sp),
                    ),
                    sizedBoxWidth(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            order.lead?.customerName ?? "Unknown Lead",
                            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: blackText1),
                          ),
                          CustomText(
                            order.lead?.customerMobile ?? "",
                            style: TextStyle(fontSize: 11.sp, color: greyText),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        CustomText(
                          PriceConverter.convertToNumberFormat(order.finalAmount ?? 0),
                          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: blackText2),
                        ),
                        CustomText(
                          "Final Amount",
                          style: TextStyle(fontSize: 10.sp, color: greyText),
                        ),
                      ],
                    ),
                  ],
                ),
                if (order.currentStage != null) ...[
                  sizedBoxHeight(height: 16),
                  Container(
                    padding: EdgeInsets.all(12.r),
                    decoration: BoxDecoration(
                      color: backgroundLight,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.account_tree_outlined, size: 16.sp, color: primaryColor),
                        sizedBoxWidth(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                "Current Stage: ${capitalize(order.currentStage?.name)}",
                                style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.bold, color: blackText3),
                              ),
                              CustomText(
                                "Assigned: ${order.currentStage?.assignedUser ?? 'N/A'} (${order.currentStage?.department ?? ''})",
                                style: TextStyle(fontSize: 10.sp, color: greyDart2),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: greyLight4.withValues(alpha: 0.5),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(16.r)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    _infoItem("Paid", PriceConverter.convertToNumberFormat(order.paidAmount ?? 0), green2),
                    sizedBoxWidth(width: 12),
                    _infoItem("Bal", PriceConverter.convertToNumberFormat(order.remainingBalance ?? 0), red),
                  ],
                ),
                Row(
                  children: [
                    _actionButton(
                      context,
                      icon: Icons.comment_outlined,
                      color: primaryColor,
                      onTap: () => _showCommentsBottomSheet(context, order.id!),
                    ),
                    if (order.approvalStatus?.toLowerCase() == 'pending') ...[
                      sizedBoxWidth(width: 8),
                      _actionButton(
                        context,
                        icon: Icons.check_circle_outline,
                        color: green2,
                        onTap: () => _confirmAction(context, "Approve", () => Get.find<LeadController>().approveOrder(order.id!)),
                      ),
                      sizedBoxWidth(width: 8),
                      _actionButton(
                        context,
                        icon: Icons.cancel_outlined,
                        color: red,
                        onTap: () => _confirmAction(context, "Reject", () => Get.find<LeadController>().rejectOrder(order.id!)),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 10.h),
            child: Row(
              children: [
                Icon(Icons.calendar_today_rounded, size: 12.sp, color: greyText),
                sizedBoxWidth(width: 4),
                CustomText(
                  "Created: ${order.createdAt ?? ""}",
                  style: TextStyle(fontSize: 10.sp, color: greyText),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButton(BuildContext context, {required IconData icon, required Color color, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        padding: EdgeInsets.all(6.r),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Icon(icon, color: color, size: 18.sp),
      ),
    );
  }

  void _showCommentsBottomSheet(BuildContext context, String orderId) {
    final commentController = TextEditingController();
    Get.find<LeadController>().getOrderComments(orderId);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(builder: (context, setModalState) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          ),
          padding: EdgeInsets.all(20.r),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText("Order Comments", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
                  IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.close)),
                ],
              ),
              const Divider(),
              Expanded(
                child: GetBuilder<LeadController>(builder: (controller) {
                  if (controller.isCalcLoading) return const Center(child: CircularProgressIndicator());
                  if (controller.orderComments.isEmpty) return  Center(child: CustomText("No comments yet", style: TextStyle(color: greyText)));
                  
                  return ListView.separated(
                    itemCount: controller.orderComments.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (context, index) {
                      final comment = controller.orderComments[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 14.r,
                                backgroundColor: primaryColor.withValues(alpha: 0.1),
                                child: CustomText(comment.user?.name?[0].toUpperCase() ?? "U", style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.bold)),
                              ),
                              sizedBoxWidth(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(comment.user?.name ?? "Unknown", style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold)),
                                    CustomText(comment.stage?.name ?? "", style: TextStyle(fontSize: 10.sp, color: greyText)),
                                  ],
                                ),
                              ),
                              CustomText(comment.createdAt != null ? DateFormat('dd MMM, hh:mm a').format(DateTime.parse(comment.createdAt!)) : "", style: TextStyle(fontSize: 9.sp, color: grey)),
                            ],
                          ),
                          sizedBoxHeight(height: 8),
                          CustomText(comment.comment ?? "", style: TextStyle(fontSize: 12.sp, color: blackText2)),
                        ],
                      );
                    },
                  );
                }),
              ),
              sizedBoxHeight(height: 16),
              Row(
                children: [
                  Expanded(
                    child: AppTextFieldWithHeading(
                      controller: commentController,
                      hindText: "Write a comment...",
                    ),
                  ),
                  sizedBoxWidth(width: 12),
                  IconButton(
                    onPressed: () {
                      if (commentController.text.isNotEmpty) {
                        Get.find<LeadController>().addOrderComment(orderId, commentController.text).then((res) {
                          if (res?.isSuccess ?? false) {
                            commentController.clear();
                            showToast(message: res?.message ?? "Comment added", toastType: ToastType.success);
                          } else {
                            showToast(message: res?.message ?? "Failed to add comment", toastType: ToastType.error);
                          }
                        });
                      }
                    },
                    icon:  Icon(Icons.send_rounded, color: primaryColor),
                  ),
                ],
              ),
              sizedBoxHeight(height: MediaQuery.of(context).viewInsets.bottom),
            ],
          ),
        );
      }),
    );
  }

  void _confirmAction(BuildContext context, String action, Future<ResponseModel> Function() onConfirm) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("$action Order"),
        content: Text("Are you sure you want to $action this order?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirm().then((res) {
                if (res?.isSuccess ?? false) {
                  showToast(message: res?.message ?? "Action successful", toastType: ToastType.success);
                } else {
                  showToast(message: res?.message ?? "Action failed", toastType: ToastType.error);
                }
              });
            },
            child: Text(action, style: TextStyle(color: action == "Approve" ? green2 : red)),
          ),
        ],
      ),
    );
  }

  Widget _infoItem(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        CustomText(label, style: TextStyle(fontSize: 9.sp, color: greyText)),
        CustomText(value, style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }

  Widget _buildStatusBadge(String? status) {
    Color color = Colors.grey;
    if (status?.toLowerCase() == 'approved') color = Colors.green;
    if (status?.toLowerCase() == 'pending') color = Colors.orange;
    if (status?.toLowerCase() == 'rejected') color = Colors.red;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: CustomText(
        capitalize(status),
        style: TextStyle(fontSize: 10.sp, color: color, fontWeight: FontWeight.bold),
      ),
    );
  }
}
