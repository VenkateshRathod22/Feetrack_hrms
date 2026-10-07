import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/payroll_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';

class MyPayrollScreen extends StatefulWidget {
  const MyPayrollScreen({super.key});

  @override
  State<MyPayrollScreen> createState() => _MyPayrollScreenState();
}

class _MyPayrollScreenState extends State<MyPayrollScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<PayrollController>().getMyPayroll();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        title: const Text("My Payroll"),
        backgroundColor: white,
        foregroundColor: black,
        elevation: 0,
      ),
      body: GetBuilder<PayrollController>(builder: (controller) {
        return controller.isLoading
            ? const Center(child: CircularProgressIndicator())
            : controller.myPayrollList.isEmpty
                ? const Center(child: CustomText("No payroll history found"))
                : ListView.builder(
                    padding: AppConstants.screenPadding,
                    itemCount: controller.myPayrollList.length,
                    itemBuilder: (context, index) {
                      final payroll = controller.myPayrollList[index];
                      return Container(
                        margin: EdgeInsets.only(bottom: 16.h),
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: white,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(color: grey.withValues(alpha: 0.2)),
                          boxShadow: [
                            BoxShadow(
                              color: black.withValues(alpha: 0.05),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
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
                                  "${controller.months[int.parse(payroll['month']) - 1]} ${payroll['year']}",
                                  style: Helper(context).textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                                  decoration: BoxDecoration(
                                    color: Colors.green.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(4.r),
                                  ),
                                  child: CustomText(
                                    payroll['status']?.toString().capitalizeFirst ?? "Paid",
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            sizedBoxHeight(height: 12.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildPayInfo("Gross Pay", payroll['gross_pay'].toString()),
                                _buildPayInfo("Net Pay", payroll['net_pay'].toString(), isPrimary: true),
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

  Widget _buildPayInfo(String label, String amount, {bool isPrimary = false}) {
    return Column(
      crossAxisAlignment: isPrimary ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        CustomText(label, style: TextStyle(color: grey, fontSize: 12.sp)),
        sizedBoxHeight(height: 4.h),
        CustomText(
          PriceConverter.convertToNumberFormat(double.tryParse(amount) ?? 0),
          style: TextStyle(
            color: isPrimary ? primaryColor : black,
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
