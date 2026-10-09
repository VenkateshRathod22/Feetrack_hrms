import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/advance_payment_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/base/custom_button.dart';
import 'package:vlr/views/widget/text_box/app_text_box.dart';

class AddAdvancePaymentScreen extends StatefulWidget {
  const AddAdvancePaymentScreen({super.key});

  @override
  State<AddAdvancePaymentScreen> createState() => _AddAdvancePaymentScreenState();
}

class _AddAdvancePaymentScreenState extends State<AddAdvancePaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _reasonController = TextEditingController();

  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _amountController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: CustomText(
          "Request Advance",
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
      body: GetBuilder<AdvancePaymentController>(builder: (controller) {
        return SingleChildScrollView(
          padding: EdgeInsets.all(16.r),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextFieldWithHeading(
                  headingWidget: CustomText(
                    "Amount (₹)",
                    style: Helper(context).textTheme.labelMedium?.copyWith(fontSize: 14.sp, color: blueDark2),
                  ),
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  hindText: "Enter amount",
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter amount";
                    }
                    if (double.tryParse(value) == null) {
                      return "Please enter a valid number";
                    }
                    return null;
                  },
                ),
                sizedBoxHeight(height: 16),
                CustomText(
                  "Deduction Month & Year",
                  style: Helper(context).textTheme.labelMedium?.copyWith(fontSize: 14.sp, color: blueDark2),
                ),
                sizedBoxHeight(height: 8),
                InkWell(
                  onTap: () async {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Select Year & Month"),
                          content: SizedBox(
                            width: 300,
                            height: 300,
                            child: YearPicker(
                              firstDate: DateTime(DateTime.now().year - 1),
                              lastDate: DateTime(DateTime.now().year + 5),
                              selectedDate: _selectedDate,
                              onChanged: (DateTime dateTime) {
                                Navigator.pop(context);
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return SizedBox(
                                      height: 250,
                                      child: ListView.builder(
                                        itemCount: 12,
                                        itemBuilder: (context, index) {
                                          return ListTile(
                                            title: Text(
                                              "${index + 1} - ${[
                                                'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                                                'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
                                              ][index]}",
                                            ),
                                            onTap: () {
                                              setState(() {
                                                _selectedDate = DateTime(dateTime.year, index + 1);
                                              });
                                              Navigator.pop(context);
                                            },
                                          );
                                        },
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
                    decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: greyLight2),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          "${_selectedDate.month.toString().padLeft(2, '0')} / ${_selectedDate.year}",
                          style: Helper(context).textTheme.bodyMedium?.copyWith(fontSize: 14.sp),
                        ),
                        Icon(Icons.calendar_month, color: primaryColor),
                      ],
                    ),
                  ),
                ),
                sizedBoxHeight(height: 16),
                AppTextFieldWithHeading(
                  headingWidget: CustomText(
                    "Reason",
                    style: Helper(context).textTheme.labelMedium?.copyWith(fontSize: 14.sp, color: blueDark2),
                  ),
                  controller: _reasonController,
                  maxLines: 4,
                  hindText: "Enter the reason for advance payment request",
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter a reason";
                    }
                    return null;
                  },
                ),
                sizedBoxHeight(height: 32),
                CustomButton(
                  isLoading: controller.isLoading,
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      controller
                          .createAdvancePayment(
                        amount: double.parse(_amountController.text.trim()),
                        month: _selectedDate.month,
                        year: _selectedDate.year,
                        reason: _reasonController.text.trim(),
                      )
                          .then((value) {
                        showToast(message: value.message, typeCheck: value.isSuccess);
                        if (value.isSuccess) {
                          Navigator.pop(context);
                        }
                      });
                    }
                  },
                  child: CustomText(
                    "Submit Request",
                    style: Helper(context).textTheme.labelSmall?.copyWith(fontSize: 16.sp, color: white),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
