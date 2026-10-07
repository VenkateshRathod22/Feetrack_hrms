import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/lead_controller.dart';
import 'package:vlr/data/models/response/lead_model.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/base/custom_button.dart';
import 'package:vlr/views/base/custom_dropdown.dart';
import 'package:vlr/views/widget/text_box/app_text_box.dart';

import '../../../../data/models/user_model.dart';

class LeadCreateScreen extends StatefulWidget {
  final LeadModel? lead;
  final bool isTab;
  const LeadCreateScreen({super.key, this.lead, this.isTab = false});

  @override
  State<LeadCreateScreen> createState() => _LeadCreateScreenState();
}

class _LeadCreateScreenState extends State<LeadCreateScreen> {
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final leadController = Get.find<LeadController>();
      leadController.fetchEmployees().then((_) {
        if (widget.lead != null) {
          leadController.setLead(widget.lead!);
        } else {
          if (!widget.isTab) {
            leadController.clearControllers();
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = GetBuilder<LeadController>(builder: (leadController) {
      return Form(
        key: formKey,
        child: Column(
          children: [
            AppTextFieldWithHeading(
              headingWidget: Row(
                children: [
                  CustomText(
                    "Name",
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
              controller: leadController.nameLeadController,
              hindText: "Enter lead name",
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Enter a name for lead";
                }
                return null;
              },
            ),
            sizedBoxHeight(height: 24.h),
            AppTextFieldWithHeading(
              headingWidget: Row(
                children: [
                  CustomText(
                    "Business Name",
                    style: Helper(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 14.sp,
                        ),
                  ),
                ],
              ),
              controller: leadController.businessNameController,
              hindText: "Enter business Name",
            ),
            sizedBoxHeight(height: 24.h),
            AppTextFieldWithHeading(
              headingWidget: Row(
                children: [
                  CustomText(
                    "Email",
                    style: Helper(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 14.sp,
                        ),
                  ),
                ],
              ),
              controller: leadController.emailController,
              hindText: "Enter email",
              keyboardType: TextInputType.emailAddress,
            ),
            sizedBoxHeight(height: 24.h),
            AppTextFieldWithHeading(
              headingWidget: Row(
                children: [
                  CustomText(
                    "Phone number",
                    style: Helper(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 14.sp,
                        ),
                  ),
                ],
              ),
              inputFormatters: [
                LengthLimitingTextInputFormatter(10),
                FilteringTextInputFormatter.digitsOnly
              ],
              keyboardType: TextInputType.number,
              controller: leadController.phoneController,
              hindText: "Enter business phone no.",
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Enter phone number";
                } else if (value.length < 10) {
                  return "Enter a valid 10-digit phone number";
                }
                return null;
              },
            ),
            sizedBoxHeight(height: 24.h),
            CustomDropDownList(
              headingWidget: Row(
                children: [
                  CustomText(
                    "Product Interest",
                    style: Helper(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 14.sp,
                        ),
                  ),
                ],
              ),
              value: leadController.productInterest,
              items: leadController.productInterestList,
              hintText: "Select Product Interest",
              onChanged: (value) {
                leadController.productInterest = value;
                leadController.update();
              },
            ),
            sizedBoxHeight(height: 24.h),
            AppTextFieldWithHeading(
              headingWidget: Row(
                children: [
                  CustomText(
                    "Business Amount",
                    style: Helper(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 14.sp,
                        ),
                  ),
                ],
              ),
              controller: leadController.businessAmountController,
              hindText: "Enter business amount",
            ),
            sizedBoxHeight(height: 24.h),
            CustomDropDownList<String>(
              headingWidget: Row(
                children: [
                  CustomText(
                    "Status",
                    style: Helper(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 14.sp,
                        ),
                  ),
                ],
              ),
              value: leadController.status,
              items: leadController.statusList,
              hintText: "Select status",
              onChanged: (value) {
                leadController.status = value;
                leadController.update();
              },
            ),
            sizedBoxHeight(height: 24.h),
            CustomDropDownList<UserModel>(
              headingWidget: Row(
                children: [
                  CustomText(
                    "Assign To",
                    style: Helper(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 14.sp,
                        ),
                  ),
                ],
              ),
              value: leadController.assignTo,
              items: leadController.assignToList,
              hintText: "Select assign to",
              onChanged: (value) {
                leadController.assignTo = value;
                leadController.update();
              },
            ),
            sizedBoxHeight(height: 24.h),
            AppTextFieldWithHeading(
              headingWidget: Row(
                children: [
                  CustomText(
                    "Requirements",
                    style: Helper(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 14.sp,
                        ),
                  ),
                ],
              ),
              maxLines: 5,
              controller: leadController.requirementController,
              hindText: "Enter your Requirements..",
            ),
            sizedBoxHeight(height: 24.h),
            if (widget.isTab)
              CustomButton(
                height: 50,
                isLoading: leadController.isLoading,
                onTap: () {
                  if (formKey.currentState?.validate() ?? false) {
                    if (leadController.selectedLead != null) {
                      leadController.updateLead();
                    } else {
                      leadController.addLead();
                    }
                  }
                },
                child: CustomText(
                  leadController.selectedLead != null ? "Update Lead" : "Save Lead",
                  style: Helper(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(fontSize: 16.sp, color: white),
                ),
              ),
            if (widget.isTab) sizedBoxHeight(height: 24.h),
          ],
        ),
      );
    });

    if (widget.isTab) {
      return SingleChildScrollView(
        padding: AppConstants.screenPadding,
        child: content,
      );
    }

    return Scaffold(
      bottomNavigationBar: Padding(
        padding: AppConstants.screenPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GetBuilder<LeadController>(builder: (leadController) {
              return CustomButton(
                height: 50,
                isLoading: leadController.isLoading,
                onTap: () {
                  if (formKey.currentState?.validate() ?? false) {
                    if (leadController.selectedLead != null) {
                      leadController.updateLead();
                    } else {
                      leadController.addLead();
                    }
                  }
                },
                child: CustomText(
                  leadController.selectedLead != null ? "Update Lead" : "Save Lead",
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
        title: GetBuilder<LeadController>(builder: (leadController) {
          return CustomText(
            leadController.selectedLead != null ? "Update Lead" : "New Lead",
            style: Helper(context).textTheme.titleMedium?.copyWith(
                  fontSize: 16.sp,
                ),
          );
        }),
      ),
      body: SingleChildScrollView(
        padding: AppConstants.screenPadding,
        child: content,
      ),
    );
  }
}
