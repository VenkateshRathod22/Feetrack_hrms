import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/commission_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/base/custom_button.dart';

class GenerateProcessCommionsScreen extends StatefulWidget {
  const GenerateProcessCommionsScreen({super.key});

  @override
  State<GenerateProcessCommionsScreen> createState() => _GenerateProcessCommionsScreenState();
}

class _GenerateProcessCommionsScreenState extends State<GenerateProcessCommionsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        title: Text("Process Commissions"),
        backgroundColor: white,
        foregroundColor: black,
        elevation: 0,
      ),
      body: GetBuilder<CommissionController>(builder: (controller) {
        return Padding(
          padding: AppConstants.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                "Select period to process commissions",
                style: Helper(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              sizedBoxHeight(height: 24.h),
              
              CustomText("Month", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16.sp)),
              sizedBoxHeight(height: 8.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                decoration: BoxDecoration(
                  color: grey.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    value: controller.selectedMonth,
                    isExpanded: true,
                    items: List.generate(12, (index) {
                      return DropdownMenuItem(
                        value: index + 1,
                        child: Text(controller.months[index]),
                      );
                    }),
                    onChanged: (val) {
                      if (val != null) controller.setMonth(val);
                    },
                  ),
                ),
              ),
              
              sizedBoxHeight(height: 20.h),
              
              CustomText("Year", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16.sp)),
              sizedBoxHeight(height: 8.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                decoration: BoxDecoration(
                  color: grey.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    value: controller.selectedYear,
                    isExpanded: true,
                    items: List.generate(5, (index) {
                      int year = DateTime.now().year - 2 + index;
                      return DropdownMenuItem(
                        value: year,
                        child: Text(year.toString()),
                      );
                    }),
                    onChanged: (val) {
                      if (val != null) controller.setYear(val);
                    },
                  ),
                ),
              ),
              
              const Spacer(),
              
              CustomButton(
                title: "Generate Commissions",
                isLoading: controller.isLoading,
                onTap: () {
                  controller.processCommission().then((res) {
                    showToast(
                      message: res.message,
                      typeCheck: res.isSuccess,
                    );
                    if (res.isSuccess) {
                      pop(context);
                    }
                  });
                },
              ),
              sizedBoxHeight(height: 20.h),
            ],
          ),
        );
      }),
    );
  }
}
