import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/payroll_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';

class PayrollReportsScreen extends StatefulWidget {
  const PayrollReportsScreen({super.key});

  @override
  State<PayrollReportsScreen> createState() => _PayrollReportsScreenState();
}

class _PayrollReportsScreenState extends State<PayrollReportsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<PayrollController>().getAdvanceReports();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text("Advance Reports"),
        backgroundColor: white,
        foregroundColor: black,
        elevation: 0,
        centerTitle: true,
      ),
      body: GetBuilder<PayrollController>(builder: (controller) {
        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            _buildSummaryHeader(controller.advanceReportsSummary),
            Expanded(
              child: controller.advanceReportsList.isEmpty
                  ? const Center(child: CustomText("No reports found"))
                  : ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                      itemCount: controller.advanceReportsList.length,
                      itemBuilder: (context, index) {
                        final item = controller.advanceReportsList[index];
                        final employee = item['employee'] ?? {};
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
                                children: [
                                  CircleAvatar(
                                    backgroundColor: primaryColor.withOpacity(0.1),
                                    child: Text(employee['name']?[0] ?? "E", style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
                                  ),
                                  sizedBoxWidth(width: 12.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        CustomText(employee['name'] ?? "Unknown", style: const TextStyle(fontWeight: FontWeight.bold)),
                                        CustomText(employee['email'] ?? "", style: TextStyle(color: grey, fontSize: 12.sp)),
                                      ],
                                    ),
                                  ),
                                  CustomText(
                                    PriceConverter.convertToNumberFormat(double.tryParse(item['amount'].toString()) ?? 0),
                                    style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor),
                                  ),
                                ],
                              ),
                              const Divider(height: 24),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      CustomText("Deduction Period", style: TextStyle(color: grey, fontSize: 11.sp)),
                                      CustomText("${controller.months[int.parse(item['deduction_month']) - 1]} ${item['deduction_year']}",
                                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.sp)),
                                    ],
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
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildSummaryHeader(Map<String, dynamic> summary) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              _buildSummaryItem("Total Requests", summary['total_count']?.toString() ?? "0", Icons.list_alt, Colors.blue),
              sizedBoxWidth(width: 16.w),
              _buildSummaryItem("Total Amount", PriceConverter.convertToNumberFormat(double.tryParse(summary['total_amount']?.toString() ?? "0") ?? 0),
                  Icons.account_balance_wallet, Colors.green),
            ],
          ),
          sizedBoxHeight(height: 16.h),
          Row(
            children: [
              _buildSummaryItem("Pending", summary['count_pending']?.toString() ?? "0", Icons.pending_actions, Colors.orange),
              sizedBoxWidth(width: 16.w),
              _buildSummaryItem("Deducted", summary['count_deducted']?.toString() ?? "0", Icons.check_circle, Colors.teal),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: color.withOpacity(0.1)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20.sp),
            sizedBoxWidth(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(label, style: TextStyle(color: grey, fontSize: 11.sp)),
                  CustomText(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.sp, color: black)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
