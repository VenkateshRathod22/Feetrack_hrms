import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/advance_payment_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/screens/advance_payment/add_advance_payment_screen.dart';

class AdvancePaymentScreen extends StatefulWidget {
  const AdvancePaymentScreen({super.key});

  @override
  State<AdvancePaymentScreen> createState() => _AdvancePaymentScreenState();
}

class _AdvancePaymentScreenState extends State<AdvancePaymentScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<AdvancePaymentController>().fetchAdvancePayments();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: CustomText(
          "Advance Payments",
          style: Helper(context).textTheme.titleMedium?.copyWith(
                fontSize: 18.sp,
                color: white,
              ),
        ),
        backgroundColor: primaryColor,
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: white),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: primaryColor,
        onPressed: () {
          navigate(context: context, page: const AddAdvancePaymentScreen());
        },
        label: CustomText("Request Advance", style: TextStyle(color: white, fontWeight: FontWeight.bold)),
        icon: Icon(Icons.add, color: white),
      ),
      body: GetBuilder<AdvancePaymentController>(builder: (controller) {
        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.advancePaymentsList.isEmpty) {
          return Center(
            child: CustomText(
              "No advance payment records found",
              style: TextStyle(color: greyDart2, fontSize: 16.sp),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            await controller.fetchAdvancePayments();
          },
          child: ListView.builder(
            padding: EdgeInsets.all(16.r),
            itemCount: controller.advancePaymentsList.length,
            itemBuilder: (context, index) {
              final payment = controller.advancePaymentsList[index];

              Color statusColor = Colors.orange;
              if (payment.status == "approved") {
                statusColor = Colors.green;
              } else if (payment.status == "rejected") {
                statusColor = Colors.red;
              }

              return Container(
                margin: EdgeInsets.only(bottom: 12.h),
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: black.withValues(alpha: 0.04),
                      blurRadius: 8,
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
                          PriceConverter.convertToNumberFormat(double.tryParse(payment.amount ?? "0") ?? 0),
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: CustomText(
                            capitalize(payment.status),
                            style: TextStyle(
                              color: statusColor,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(),
                    sizedBoxHeight(height: 4),
                    _buildRowItem("Reason:", payment.reason ?? "N/A"),
                    sizedBoxHeight(height: 6),
                    _buildRowItem("Deduction Month:", "${payment.deductionMonth ?? "N/A"} / ${payment.deductionYear ?? "N/A"}"),
                    sizedBoxHeight(height: 6),
                    _buildRowItem("Is Deducted:", payment.isDeducted == 1 ? "Yes" : "No"),
                    if (payment.remarks != null && payment.remarks!.isNotEmpty) ...[
                      sizedBoxHeight(height: 6),
                      _buildRowItem("Remarks:", payment.remarks!),
                    ]
                  ],
                ),
              );
            },
          ),
        );
      }),
    );
  }

  Widget _buildRowItem(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13.sp,
            color: greyDart2,
          ),
        ),
        sizedBoxWidth(width: 8),
        Expanded(
          child: CustomText(
            value,
            style: TextStyle(
              fontSize: 13.sp,
              color: blackText1,
            ),
          ),
        ),
      ],
    );
  }
}
