import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/payroll_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';

import 'package:vlr/views/screens/payroll/payroll_adjustment_screen.dart';

class PayrollDraftsScreen extends StatefulWidget {
  const PayrollDraftsScreen({super.key});

  @override
  State<PayrollDraftsScreen> createState() => _PayrollDraftsScreenState();
}

class _PayrollDraftsScreenState extends State<PayrollDraftsScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<PayrollController>().getPayrollDrafts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        title: Text("Payroll Drafts"),
        backgroundColor: white,
        foregroundColor: black,
        elevation: 0,
      ),
      body: GetBuilder<PayrollController>(builder: (controller) {
        return Column(
          children: [
            Padding(
              padding: AppConstants.screenPadding.copyWith(bottom: 0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Search employee...",
                  prefixIcon: Icon(Icons.search),
                  filled: true,
                  fillColor: grey.withValues(alpha: 0.1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (val) {
                  controller.getPayrollDrafts(search: val);
                },
              ),
            ),
            Expanded(
              child: controller.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : controller.payrollDraftsList.isEmpty
                      ? const Center(child: CustomText("No payroll drafts found"))
                      : ListView.builder(
                          padding: AppConstants.screenPadding,
                          itemCount: controller.payrollDraftsList.length,
                          itemBuilder: (context, index) {
                            final draft = controller.payrollDraftsList[index];
                            final employee = draft['employee'];
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
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: primaryColor.withValues(alpha: 0.1),
                                        child: Text(
                                          employee['name']?[0] ?? "E",
                                          style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      sizedBoxWidth(width: 12.w),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            CustomText(
                                              employee['name'] ?? "Unknown",
                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
                                            ),
                                            CustomText(
                                              "Code: ${employee['employee_code'] ?? 'N/A'}",
                                              style: TextStyle(color: grey, fontSize: 12.sp),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                                        decoration: BoxDecoration(
                                          color: Colors.orange.withValues(alpha: 0.1),
                                          borderRadius: BorderRadius.circular(4.r),
                                        ),
                                        child: CustomText(
                                          draft['status']?.toString().capitalizeFirst ?? "Pending",
                                          style: TextStyle(
                                            color: Colors.orange,
                                            fontSize: 10.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Divider(height: 24.h, color: grey.withValues(alpha: 0.1)),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      _buildInfoColumn("Basic", draft['basic_salary'].toString()),
                                      _buildInfoColumn("Gross", draft['gross_pay'].toString()),
                                      _buildInfoColumn("Net Pay", draft['net_pay'].toString(), isBold: true),
                                    ],
                                  ),
                                  sizedBoxHeight(height: 12.h),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      CustomText(
                                        "Period: ${controller.months[int.parse(draft['month']) - 1]} ${draft['year']}",
                                        style: TextStyle(color: grey, fontSize: 11.sp),
                                      ),
                                      TextButton.icon(
                                        onPressed: () {
                                          controller.setAdjustmentData(draft);
                                          navigate(
                                            context: context,
                                            page: PayrollAdjustmentScreen(payrollId: draft['id']),
                                          );
                                        },
                                        icon: Icon(Icons.edit_note, size: 18),
                                        label: Text("Adjustment"),
                                        style: TextButton.styleFrom(
                                          foregroundColor: primaryColor,
                                          padding: EdgeInsets.zero,
                                          minimumSize: Size.zero,
                                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
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

  Widget _buildInfoColumn(String label, String value, {bool isBold = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(label, style: TextStyle(color: grey, fontSize: 11.sp)),
        sizedBoxHeight(height: 2.h),
        CustomText(
          PriceConverter.convertToNumberFormat(double.tryParse(value) ?? 0),
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            fontSize: 13.sp,
            color: isBold ? primaryColor : black,
          ),
        ),
      ],
    );
  }
}
