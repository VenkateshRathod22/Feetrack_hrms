import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/state_manager.dart';
import 'package:vlr/controllers/leave_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/base/custom_button.dart';
import 'package:vlr/views/base/custom_dropdown.dart';
import 'package:vlr/views/screens/leave/leave_history.dart';
import 'package:vlr/views/widget/text_box/app_text_box.dart';
import 'package:vlr/data/models/leave_category_model.dart';

class ApplyLeaveScreen extends StatefulWidget {
  const ApplyLeaveScreen({super.key});

  @override
  State<ApplyLeaveScreen> createState() => _ApplyLeaveScreenState();
}

class _ApplyLeaveScreenState extends State<ApplyLeaveScreen> {
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<LeaveController>().fetchLeaveCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: AppConstants.screenPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GetBuilder<LeaveController>(builder: (leaveController) {
              return CustomButton(
                height: 50,
                isLoading: leaveController.isLoading,
                onTap: () {
                  if (formKey.currentState?.validate() ?? false) {
                    if (leaveController.selectedLeaveCategory == null) {
                      showToast(message: "Select leave category");
                    } else {
                      leaveController.applyLeave();
                    }
                  }
                },
                child: CustomText(
                  "Submit Application",
                  style: Helper(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(fontSize: 16.sp, color: white),
                ),
              );
            })
          ],
        ),
      ),
      appBar: AppBar(
        elevation: 2,
        centerTitle: true,
        backgroundColor: white,
        title: CustomText(
          "Apply for Leave",
          style: Helper(context).textTheme.titleMedium?.copyWith(
                fontSize: 16.sp,
              ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              navigate(context: context, page: const LeaveHistoryScreen());
            },
            icon: const Icon(Icons.history),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: AppConstants.screenPadding,
        child: GetBuilder<LeaveController>(builder: (leaveController) {
          return Form(
            key: formKey,
            child: Column(
              children: [
                AppTextFieldWithHeading(
                  headingWidget: Row(
                    children: [
                      CustomText(
                        "Start Date",
                        style: Helper(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 14.sp,
                            ),
                      ),
                      CustomText(
                        " *",
                        style: Helper(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontSize: 18.sp, color: redDark),
                      ),
                    ],
                  ),
                  controller: leaveController.startDateController,
                  hindText: "dd-mm-yyyy",
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );

                    if (pickedDate != null) {
                      leaveController.startDateController.text =
                          "${pickedDate.day.toString().padLeft(2, '0')}-"
                          "${pickedDate.month.toString().padLeft(2, '0')}-"
                          "${pickedDate.year}";
                    }
                  },
                  suffix: const Icon(Icons.calendar_month),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Select end date";
                    }
                    return null;
                  },
                ),
                sizedBoxHeight(height: 24.h),
                AppTextFieldWithHeading(
                  headingWidget: Row(
                    children: [
                      CustomText(
                        "End Date",
                        style: Helper(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 14.sp,
                            ),
                      ),
                      CustomText(
                        " *",
                        style: Helper(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontSize: 18.sp, color: redDark),
                      ),
                    ],
                  ),
                  controller: leaveController.endDateController,
                  hindText: "dd-mm-yyyy",
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );

                    if (pickedDate != null) {
                      leaveController.endDateController.text =
                          "${pickedDate.day.toString().padLeft(2, '0')}-"
                          "${pickedDate.month.toString().padLeft(2, '0')}-"
                          "${pickedDate.year}";
                    }
                  },
                  suffix: const Icon(Icons.calendar_month),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Select end date";
                    }
                    return null;
                  },
                ),
                sizedBoxHeight(height: 24.h),
                CustomDropDownList<LeaveCategoryModel>(
                  headingWidget: Row(
                    children: [
                      CustomText(
                        "Leave Category",
                        style: Helper(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 14.sp,
                            ),
                      ),
                      CustomText(
                        " *",
                        style: Helper(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontSize: 18.sp, color: redDark),
                      ),
                    ],
                  ),
                  value: leaveController.selectedLeaveCategory,
                  items: leaveController.leaveCategoryList,
                  hintText: "Select Category",
                  onChanged: (value) {
                    leaveController.selectedLeaveCategory = value;
                    leaveController.update();
                  },
                  validator: (value) {
                    if (value == null) {
                      return "Select leave category";
                    }
                    return null;
                  },
                ),
                sizedBoxHeight(height: 24.h),
                AppTextFieldWithHeading(
                  headingWidget: Row(
                    children: [
                      CustomText(
                        "Reason for Leave",
                        style: Helper(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 14.sp,
                            ),
                      ),
                    ],
                  ),
                  controller: leaveController.reasonForLeaveController,
                  hindText: "Enter reason for leave...",
                  maxLines: 5,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter reason for leave";
                    }
                    return null;
                  },
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
