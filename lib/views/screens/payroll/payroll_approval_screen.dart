import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/payroll_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';

class PayrollApprovalScreen extends StatefulWidget {
  const PayrollApprovalScreen({super.key});

  @override
  State<PayrollApprovalScreen> createState() => _PayrollApprovalScreenState();
}

class _PayrollApprovalScreenState extends State<PayrollApprovalScreen> {
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
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text("Payroll Approval"),
        backgroundColor: white,
        foregroundColor: black,
        elevation: 0,
        centerTitle: true,
      ),
      body: GetBuilder<PayrollController>(builder: (controller) {
        return Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Search employee...",
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
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
                      ? const Center(child: CustomText("No payroll pending for approval"))
                      : ListView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          itemCount: controller.payrollDraftsList.length,
                          itemBuilder: (context, index) {
                            final draft = controller.payrollDraftsList[index];
                            final employee = draft['employee'] ?? {};
                            
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
                                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                                        decoration: BoxDecoration(
                                          color: Colors.orange.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(20.r),
                                        ),
                                        child: CustomText(
                                          draft['status']?.toString().capitalizeFirst ?? "Pending",
                                          style: TextStyle(
                                            color: Colors.orange,
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Divider(height: 24),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      _buildInfoColumn("Basic", draft['basic_salary'].toString()),
                                      _buildInfoColumn("Gross", draft['gross_pay'].toString()),
                                      _buildInfoColumn("Net Pay", draft['net_pay'].toString(), isBold: true),
                                    ],
                                  ),
                                  sizedBoxHeight(height: 16.h),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      CustomText(
                                        "Period: ${controller.months[int.parse(draft['month']) - 1]} ${draft['year']}",
                                        style: TextStyle(color: grey, fontSize: 12.sp),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          _showApprovalDialog(context, controller, draft['id'], employee['name'] ?? "this employee");
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green,
                                          foregroundColor: white,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                                          elevation: 0,
                                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                                          minimumSize: Size.zero,
                                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                        ),
                                        child: const Text("Mark as Paid"),
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

  Widget _buildInfoColumn(String label, String value, {bool isBold = false, Color? color}) {
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
            color: color ?? (isBold ? primaryColor : black),
          ),
        ),
      ],
    );
  }

  void _showApprovalDialog(BuildContext context, PayrollController controller, int id, String name) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Approve Payroll"),
        content: Text("Are you sure you want to approve and mark the payroll as paid for $name?"),
        actions: [
          TextButton(
            onPressed: () => pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              pop(context);
              controller.approvePayroll(id).then((res) {
                showToast(message: res.message, typeCheck: res.isSuccess);
                if (res.isSuccess) {
                  controller.getPayrollApprovals(); // Refresh list
                }
              });
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: white),
            child: const Text("Approve"),
          ),
        ],
      ),
    );
  }
}
