import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/department_controller.dart';
import 'package:vlr/controllers/pipeline_stage_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/base/custom_button.dart';
import 'package:vlr/views/widget/text_box/app_text_box.dart';

class AddPiplineConfigScreem extends StatefulWidget {
  final bool isEdit;
  final String? pipelineId;
  const AddPiplineConfigScreem({super.key, this.isEdit = false, this.pipelineId});

  @override
  State<AddPiplineConfigScreem> createState() => _AddPiplineConfigScreemState();
}

class _AddPiplineConfigScreemState extends State<AddPiplineConfigScreem> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<DepartmentController>().getDepartmentList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        title: Text(widget.isEdit ? "Edit Stage" : "Add New Stage"),
        backgroundColor: white,
        foregroundColor: black,
        elevation: 0,
      ),
      body: GetBuilder<PipelineStageController>(builder: (pipelineController) {
        return GetBuilder<DepartmentController>(builder: (deptController) {
          return SingleChildScrollView(
            padding: AppConstants.screenPadding,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppTextFieldWithHeading(
                    heading: "STAGE NAME",
                    hindText: "e.g. Finance Approval",
                    controller: pipelineController.nameController,
                    isRequired: true,
                    validator: (val) => val == null || val.isEmpty ? "Required" : null,
                  ),
                  sizedBoxHeight(height: 24.h),
                  _buildDropdown(
                    "RESPONSIBLE DEPARTMENT",
                    pipelineController.selectedDepartmentId,
                    deptController.departmentList
                        .map((e) => DropdownMenuItem(value: e.id.toString(), child: Text(e.name ?? "")))
                        .toList(),
                    (val) => setState(() => pipelineController.selectedDepartmentId = val),
                  ),
                  sizedBoxHeight(height: 8.h),
                  CustomText(
                    "Users in this department will be able to approve this stage.",
                    style: Helper(context).textTheme.bodySmall?.copyWith(color: grey),
                  ),
                  sizedBoxHeight(height: 24.h),
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: grey.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: grey.withValues(alpha: 0.1)),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Switch(
                              value: pipelineController.countsTowardsTarget,
                              onChanged: (val) {
                                setState(() => pipelineController.countsTowardsTarget = val);
                              },
                              activeColor: primaryColor,
                            ),
                            sizedBoxWidth(width: 8.w),
                            Expanded(
                              child: CustomText(
                                "Counts Towards Employee Target / Business",
                                style: Helper(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        sizedBoxHeight(height: 8.h),
                        CustomText(
                          "When an order is approved at this stage, the order's Amount Paid Now (\$) will be added to the employee's business target.",
                          style: Helper(context).textTheme.bodySmall?.copyWith(color: grey),
                        ),
                      ],
                    ),
                  ),
                  sizedBoxHeight(height: 32.h),
                  CustomButton(
                    title: widget.isEdit ? "Update Stage" : "Add Stage",
                    isLoading: pipelineController.isLoading,
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        if (widget.isEdit) {
                          pipelineController.updatePipelineStage(widget.pipelineId!).then((res) {
                            showToast(message: res.message, typeCheck: res.isSuccess);
                            if (res.isSuccess) pop(context);
                          });
                        } else {
                          pipelineController.addPipelineStage().then((res) {
                            showToast(message: res.message, typeCheck: res.isSuccess);
                            if (res.isSuccess) pop(context);
                          });
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        });
      }),
    );
  }

  Widget _buildDropdown(String hint, String? value, List<DropdownMenuItem<String>> items, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          hint,
          style: Helper(context).textTheme.bodyMedium?.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w600),
        ),
        sizedBoxHeight(height: 7.h),
        DropdownButtonFormField<String>(
          isExpanded: true,
          dropdownColor: white,
          value: (value != null && items.any((item) => item.value == value)) ? value : null,
          decoration: InputDecoration(
            filled: true,
            fillColor: grey.withValues(alpha: 0.1),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: grey.withValues(alpha: 0.5), width: 0.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: grey.withValues(alpha: 0.5), width: 0.5),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
          ),
          items: items,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
