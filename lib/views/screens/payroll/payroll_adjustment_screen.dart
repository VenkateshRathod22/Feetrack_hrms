import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/payroll_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';

class PayrollAdjustmentScreen extends StatelessWidget {
  final int payrollId;
  const PayrollAdjustmentScreen({super.key, required this.payrollId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text("Adjust Payroll"),
        backgroundColor: white,
        foregroundColor: black,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => pop(context),
          icon: Icon(Icons.arrow_back_ios_new, size: 20),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 20.h),
        decoration: BoxDecoration(
          color: white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: GetBuilder<PayrollController>(builder: (controller) {
          return Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText("Net Payable", style: TextStyle(color: grey, fontSize: 12.sp)),
                  CustomText(
                    PriceConverter.convertToNumberFormat(controller.netPay),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.sp,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
              sizedBoxWidth(width: 24.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: controller.isLoading
                      ? null
                      : () {
                          controller.adjustPayroll(payrollId).then((res) {
                            showToast(message: res.message, typeCheck: res.isSuccess);
                            if (res.isSuccess) pop(context);
                          });
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: white,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                    elevation: 0,
                  ),
                  child: controller.isLoading
                      ?  SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: white, strokeWidth: 2))
                      : Text("Confirm & Save", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          );
        }),
      ),
      body: GetBuilder<PayrollController>(builder: (controller) {
        return SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Period & Status Header
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(10.w),
                          decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.calendar_month, color: primaryColor, size: 24.sp),
                        ),
                        sizedBoxWidth(width: 12.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText("Payroll Period", style: TextStyle(color: grey, fontSize: 12.sp)),
                            CustomText(
                              "${controller.months[int.parse(controller.selectedMonth.toString()) - 1]} ${controller.selectedYear}",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: CustomText(
                        "Pending",
                        style: TextStyle(color: Colors.orange[800], fontSize: 12.sp, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
              sizedBoxHeight(height: 20.h),

              // Earnings Section
              _buildSectionCard(
                title: "Earnings (Added to Salary)",
                icon: Icons.add_circle_outline,
                iconColor: Colors.green[700]!,
                children: [
                  _buildInputField("Basic Salary", controller.basicSalaryController, prefix: "₹"),
                  sizedBoxHeight(height: 16.h),
                  _buildMonthSalarySection(controller),
                  sizedBoxHeight(height: 20.h),
                  const _SectionSubtitle("Allowances"),
                  if (controller.allowanceControllers.isEmpty)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: CustomText("No allowances configured.", style: TextStyle(color: grey, fontSize: 13.sp, fontStyle: FontStyle.italic)),
                    )
                  else
                    ...controller.allowanceControllers.entries.map((e) => Padding(
                          padding: EdgeInsets.only(bottom: 12.h),
                          child: _buildInputField(e.key, e.value, prefix: "₹"),
                        )),
                  const Divider(height: 32),
                  _buildSummaryRow("Total Allowances", PriceConverter.convertToNumberFormat(controller.totalAllowances), isBold: true),
                  sizedBoxHeight(height: 12.h),
                  _buildInputField("Bonuses", controller.bonusController, prefix: "+"),
                  sizedBoxHeight(height: 20.h),
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: _buildSummaryRow("Total Earnings", PriceConverter.convertToNumberFormat(controller.totalSalary), color: Colors.green[800]!, isBold: true),
                  ),
                ],
              ),

              sizedBoxHeight(height: 20.h),

              // Deductions Section
              _buildSectionCard(
                title: "Deductions",
                icon: Icons.remove_circle_outline,
                iconColor: Colors.red[700]!,
                children: [
                  _buildInputField("Salary Advance", controller.advancePayController, prefix: "-"),
                  sizedBoxHeight(height: 20.h),
                  const _SectionSubtitle("Itemized Deductions"),
                  if (controller.deductionControllers.isEmpty)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: CustomText("No additional deductions.", style: TextStyle(color: grey, fontSize: 13.sp, fontStyle: FontStyle.italic)),
                    )
                  else
                    ...controller.deductionControllers.entries.map((e) => Padding(
                          padding: EdgeInsets.only(bottom: 12.h),
                          child: _buildInputField(e.key, e.value, prefix: "₹"),
                        )),
                  const Divider(height: 32),
                  _buildSummaryRow("Total Deductions", "- ${PriceConverter.convertToNumberFormat(controller.totalDeductions)}", color: Colors.red[700]!, isBold: true),
                ],
              ),

              sizedBoxHeight(height: 20.h),

              // Final Summary Card
              Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [primaryColor, primaryColor.withOpacity(0.8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildSummaryRow("Gross Pay", PriceConverter.convertToNumberFormat(controller.grossPay), color: white.withOpacity(0.9)),
                    sizedBoxHeight(height: 12.h),
                     Divider(color: white, thickness: 0.5),
                    sizedBoxHeight(height: 8.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText("Net Pay", style: TextStyle(color: white, fontSize: 18.sp, fontWeight: FontWeight.bold)),
                        CustomText(
                          PriceConverter.convertToNumberFormat(controller.netPay),
                          style: TextStyle(color: white, fontSize: 22.sp, fontWeight: FontWeight.w900),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              sizedBoxHeight(height: 30.h),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSectionCard({required String title, required IconData icon, required Color iconColor, required List<Widget> children}) {
    return Container(
      width: double.infinity,
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
              Icon(icon, color: iconColor, size: 22.sp),
              sizedBoxWidth(width: 8.w),
              CustomText(title, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: black)),
            ],
          ),
          const Divider(height: 24),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller, {String? prefix}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(label, style: TextStyle(fontSize: 13.sp, color: black.withOpacity(0.7), fontWeight: FontWeight.w500)),
        sizedBoxHeight(height: 8.h),
        TextFormField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          textAlign: TextAlign.start,
          style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
          decoration: InputDecoration(
            prefixIcon: prefix != null
                ? Container(
                    width: 40.w,
                    alignment: Alignment.center,
                    child: Text(prefix, style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
                  )
                : null,
            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            filled: true,
            fillColor: const Color(0xFFF9FAFB),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(color: grey.withOpacity(0.2)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(color: grey.withOpacity(0.2)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(color: primaryColor.withOpacity(0.5)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMonthSalarySection(PayrollController controller) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.green.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText("Attendance Earnings", style: TextStyle(color: Colors.green[900], fontWeight: FontWeight.bold, fontSize: 13.sp)),
              CustomText(
                PriceConverter.convertToNumberFormat(controller.thisMonthSalary),
                style: TextStyle(color: Colors.green[900], fontWeight: FontWeight.w800, fontSize: 15.sp),
              ),
            ],
          ),
          sizedBoxHeight(height: 16.h),
          GridView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10.w,
              mainAxisSpacing: 10.h,
              childAspectRatio: 2.2,
            ),
            children: [
              _buildCounterItem("Present", controller.presentDaysController, Colors.green),
              _buildCounterItem("Half Day", controller.halfDaysController, Colors.orange),
              _buildCounterItem("Paid Leave", controller.paidLeaveController, Colors.blue),
              _buildCounterItem("Unpaid Leave", controller.unpaidLeaveController, Colors.red),
            ],
          ),
          sizedBoxHeight(height: 12.h),
          _buildCounterItem("Absent", controller.absentDaysController, Colors.red[900]!),
        ],
      ),
    );
  }
  Widget _buildCounterItem(
      String label,
      TextEditingController controller,
      Color color,
      ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 10.w,
        vertical: 6.h,
      ),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: color.withOpacity(0.1),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomText(
            label,
            style: TextStyle(
              color: color,
              fontSize: 10.sp,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 4.h),

          TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              border: InputBorder.none,
              isDense: true,
              hintText: "0",
              hintStyle: TextStyle(
                fontSize: 14.sp,
                color: grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
Widget _buildSummaryRow(String label, String value, {Color? color, bool isBold = false}) {
  // Fall back to your 'black' getter if no color is passed
  final textColor = color ?? black; 

  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      CustomText(
        label, 
        style: TextStyle(
          color: textColor, 
          fontSize: 14.sp, 
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      CustomText(
        value, 
        style: TextStyle(
          color: textColor, 
          fontSize: 14.sp, 
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  );
}
}

class _SectionSubtitle extends StatelessWidget {
  final String title;
  const _SectionSubtitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: CustomText(
        title.toUpperCase(),
        style: TextStyle(
          color: grey,
          fontSize: 11.sp,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.0,
        ),
      ),
    );
  }
}
