import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/payroll_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';

class AdvancePaymentsScreen extends StatefulWidget {
  const AdvancePaymentsScreen({super.key});

  @override
  State<AdvancePaymentsScreen> createState() => _AdvancePaymentsScreenState();
}

class _AdvancePaymentsScreenState extends State<AdvancePaymentsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<PayrollController>().getAdvancePayments();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text("Advance Payments"),
        backgroundColor: white,
        foregroundColor: black,
        elevation: 0,
        centerTitle: true,
      ),
      body: GetBuilder<PayrollController>(builder: (controller) {
        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.advancePaymentsList.isEmpty) {
          return const Center(child: CustomText("No advance payments found"));
        }

        return ListView.builder(
          padding: EdgeInsets.all(20.w),
          itemCount: controller.advancePaymentsList.length,
          itemBuilder: (context, index) {
            final item = controller.advancePaymentsList[index];
            final status = item['status']?.toString() ?? 'pending';
            final color = status == 'approved' ? Colors.green : (status == 'pending' ? Colors.orange : Colors.red);

            return Container(
              margin: EdgeInsets.only(bottom: 16.h),
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        PriceConverter.convertToNumberFormat(double.tryParse(item['amount'].toString()) ?? 0),
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: CustomText(
                          status.capitalizeFirst!,
                          style: TextStyle(color: color, fontSize: 12.sp, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  sizedBoxHeight(height: 12.h),
                  Row(
                    children: [
                      Icon(Icons.notes, size: 16.sp, color: grey),
                      sizedBoxWidth(width: 8.w),
                      Expanded(
                        child: CustomText(
                          item['reason'] ?? "No reason provided",
                          style: TextStyle(fontSize: 14.sp, color: black.withOpacity(0.7)),
                        ),
                      ),
                    ],
                  ),
                  sizedBoxHeight(height: 8.h),
                  Row(
                    children: [
                      Icon(Icons.calendar_month, size: 16.sp, color: grey),
                      sizedBoxWidth(width: 8.w),
                      CustomText(
                        "Deduction: ${controller.months[int.parse(item['deduction_month']) - 1]} ${item['deduction_year']}",
                        style: TextStyle(fontSize: 13.sp, color: grey),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        item['created_at']?.toString().split('T')[0] ?? "",
                        style: TextStyle(fontSize: 12.sp, color: grey),
                      ),
                      if (item['is_deducted'] == 1)
                        Row(
                          children: [
                            Icon(Icons.check_circle, color: Colors.green, size: 16.sp),
                            sizedBoxWidth(width: 4.w),
                            CustomText("Deducted", style: TextStyle(color: Colors.green, fontSize: 12.sp, fontWeight: FontWeight.bold)),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}
