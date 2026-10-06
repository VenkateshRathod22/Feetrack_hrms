import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:vlr/controllers/lead_controller.dart';
import 'package:vlr/data/models/response/lead_recovery_model.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/base/custom_dropdown.dart';
import 'package:vlr/views/widget/button/appbar_back_button.dart';
import 'package:vlr/views/widget/text_box/app_text_box.dart';

class LeadOrderRecoveryPaynowScreen extends StatefulWidget {
  final LeadRecoveryItem recoveryItem;
  const LeadOrderRecoveryPaynowScreen({super.key, required this.recoveryItem});

  @override
  State<LeadOrderRecoveryPaynowScreen> createState() => _LeadOrderRecoveryPaynowScreenState();
}

class _LeadOrderRecoveryPaynowScreenState extends State<LeadOrderRecoveryPaynowScreen> {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController referenceController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  
  String selectedMethod = "cash";
  final List<String> paymentMethods = ["cash", "upi", "bank_transfer", "cheque"];

  @override
  void initState() {
    super.initState();
    dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    amountController.text = widget.recoveryItem.financials?.remainingBalance?.toString() ?? "0";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundLight,
      appBar: AppBar(
        title: CustomText(
          "Collect Payment",
          style: Helper(context).textTheme.titleMedium?.copyWith(fontSize: 18.sp),
        ),
        centerTitle: true,
        backgroundColor: white,
        elevation: 0,
        leading: const AppBarBackButton(),
      ),
      body: GetBuilder<LeadController>(builder: (controller) {
        return SingleChildScrollView(
          padding: EdgeInsets.all(20.r),
          child: Column(
            children: [
              _buildOrderSummaryCard(),
              sizedBoxHeight(height: 20),
              _buildPaymentForm(),
              sizedBoxHeight(height: 32),
              ElevatedButton(
                onPressed: () => _handlePayment(controller),
                style: ElevatedButton.styleFrom(
                  backgroundColor: green2,
                  minimumSize: Size(double.infinity, 54.h),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                  elevation: 0,
                ),
                child: controller.isLoading
                    ? SizedBox(width: 24.w, height: 24.w, child:  CircularProgressIndicator(color: white, strokeWidth: 2))
                    : CustomText("Confirm & Pay", style: TextStyle(color: white, fontWeight: FontWeight.bold, fontSize: 16.sp)),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildOrderSummaryCard() {
    final financials = widget.recoveryItem.financials;
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [BoxShadow(color: black.withValues(alpha: 0.05), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.receipt_long_rounded, color: primaryColor, size: 20.sp),
              sizedBoxWidth(width: 8),
              CustomText(widget.recoveryItem.orderNumber ?? "", style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: blackText1)),
            ],
          ),
          const Divider(height: 30),
          _summaryRow("Customer", widget.recoveryItem.customer?.name ?? "N/A"),
          _summaryRow("Total Amount", PriceConverter.convertToNumberFormat(financials?.finalAmount ?? 0)),
          _summaryRow("Amount Already Paid", PriceConverter.convertToNumberFormat(financials?.paidAmount ?? 0), valueColor: green2),
          sizedBoxHeight(height: 12),
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(color: red.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(12.r)),
            child: _summaryRow("Outstanding Balance", PriceConverter.convertToNumberFormat(financials?.remainingBalance ?? 0), isBold: true, valueColor: red),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentForm() {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [BoxShadow(color: black.withValues(alpha: 0.05), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText("PAYMENT DETAILS", style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w800, color: greyLight8, letterSpacing: 1.1)),
          sizedBoxHeight(height: 20),
          AppTextFieldWithHeading(
            heading: "AMOUNT TO COLLECT",
            isRequired: true,
            controller: amountController,
            keyboardType: TextInputType.number,
            preFixWidget: Padding(
              padding: EdgeInsets.all(12.r),
              child: CustomText("₹", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp, color: green2)),
            ), hindText: 'PAy',
          ),
          sizedBoxHeight(height: 20),
          CustomDropDownList<String>(
            heading: "PAYMENT METHOD",
            items: paymentMethods,
            value: selectedMethod,
            onChanged: (val) => setState(() => selectedMethod = val!),
          ),
          sizedBoxHeight(height: 20),
          AppTextFieldWithHeading(
            heading: "PAYMENT DATE",
            isRequired: true,
            controller: dateController,
            readOnly: true,
            suffix: Icon(Icons.calendar_today_rounded, size: 20.sp, color: primaryColor),
            onTap: () async {
              DateTime? picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2020),
                lastDate: DateTime.now(),
              );
              if (picked != null) {
                setState(() => dateController.text = DateFormat('yyyy-MM-dd').format(picked));
              }
            }, hindText: 'Pay',
          ),
          sizedBoxHeight(height: 20),
          AppTextFieldWithHeading(
            heading: "REFERENCE (Optional)",
            controller: referenceController,
            hindText: "UTR / Transaction ID",
          ),
          sizedBoxHeight(height: 20),
          AppTextFieldWithHeading(
            heading: "NOTES",
            controller: notesController,
            hindText: "Internal comments...",
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool isBold = false, Color? valueColor}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(label, style: TextStyle(fontSize: 12.sp, color: greyText, fontWeight: FontWeight.w500)),
          CustomText(value, style: TextStyle(fontSize: 13.sp, fontWeight: isBold ? FontWeight.w800 : FontWeight.bold, color: valueColor ?? blackText1)),
        ],
      ),
    );
  }

  void _handlePayment(LeadController controller) async {
    double amt = double.tryParse(amountController.text) ?? 0;
    if (amt <= 0) {
      showToast(message: "Please enter a valid amount", toastType: ToastType.warning);
      return;
    }

    final res = await controller.saveRecoveryPayment(
      orderId: widget.recoveryItem.orderId!,
      amount: amt,
      method: selectedMethod,
      date: dateController.text,
      reference: referenceController.text,
      notes: notesController.text,
    );

    if (res.isSuccess) {
      showToast(message: res.message, toastType: ToastType.success);
      Navigator.pop(context);
    } else {
      showToast(message: res.message, toastType: ToastType.error);
    }
  }
}
