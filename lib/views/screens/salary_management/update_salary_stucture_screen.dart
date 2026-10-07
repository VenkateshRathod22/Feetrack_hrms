import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/commission_level_controller.dart';
import 'package:vlr/controllers/salary_controller.dart';
import 'package:vlr/data/models/commission_level_model.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/base/custom_button.dart';
import 'package:vlr/views/widget/text_box/app_text_box.dart';

class UpdateSalaryStuctureScreen extends StatefulWidget {
  final String employeeId;
  const UpdateSalaryStuctureScreen({super.key, required this.employeeId});

  @override
  State<UpdateSalaryStuctureScreen> createState() => _UpdateSalaryStuctureScreenState();
}

class _UpdateSalaryStuctureScreenState extends State<UpdateSalaryStuctureScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<CommissionLevelController>().getCommissionLevelList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text("Update Salary Structure"),
        backgroundColor: white,
        foregroundColor: black,
        elevation: 0,
      ),
      body: GetBuilder<SalaryController>(builder: (salaryController) {
        return SingleChildScrollView(
          padding: AppConstants.screenPadding,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle("General"),
                _buildDropdown(
                  "Salary Type",
                  salaryController.selectedSalaryType,
                  salaryController.salaryTypes,
                  (val) => setState(() => salaryController.selectedSalaryType = val),
                ),
                sizedBoxHeight(height: 16.h),
                if (salaryController.selectedSalaryType != 'base_only') ...[
                  GetBuilder<CommissionLevelController>(builder: (commController) {
                    return _buildCommissionLevelDropdown(
                      "Commission Level",
                      salaryController.selectedCommissionLevelId,
                      commController.commissionLevelList,
                      (val) => setState(() => salaryController.selectedCommissionLevelId = val),
                    );
                  }),
                  sizedBoxHeight(height: 16.h),
                ],
                AppTextFieldWithHeading(
                  heading: "Basic Salary",
                  hindText: "0",
                  controller: salaryController.basicSalaryController,
                  keyboardType: TextInputType.number,
                ),
                sizedBoxHeight(height: 16.h),
                AppTextFieldWithHeading(
                  heading: "Monthly Target",
                  hindText: "0",
                  controller: salaryController.monthlyTargetController,
                  keyboardType: TextInputType.number,
                ),
                sizedBoxHeight(height: 16.h),
                AppTextFieldWithHeading(
                  heading: "Merchant Target",
                  hindText: "0",
                  controller: salaryController.merchantTargetController,
                  keyboardType: TextInputType.number,
                ),
                sizedBoxHeight(height: 16.h),
                AppTextFieldWithHeading(
                  heading: "Commission Percent",
                  hindText: "0",
                  controller: salaryController.commissionPercentController,
                  keyboardType: TextInputType.number,
                ),
                sizedBoxHeight(height: 16.h),
                AppTextFieldWithHeading(
                  heading: "Recovery Percent",
                  hindText: "0",
                  controller: salaryController.recoveryPercentController,
                  keyboardType: TextInputType.number,
                ),
                sizedBoxHeight(height: 24.h),
                
                _buildSectionTitle("Allowances"),
                _buildGridFields([
                  _field("HRA", salaryController.hraController),
                  _field("DA", salaryController.daController),
                  _field("Conveyance", salaryController.conveyanceController),
                  _field("Medical", salaryController.medicalController),
                  _field("Special", salaryController.specialController),
                  _field("Travel", salaryController.travelController),
                  _field("Internet", salaryController.internetController),
                  _field("Food", salaryController.foodController),
                  _field("Perf. Incentive", salaryController.performanceIncentiveController),
                  _field("Sales Incentive", salaryController.salesIncentiveController),
                  _field("Bonus", salaryController.bonusController),
                  _field("Overtime", salaryController.overtimeController),
                  _field("Shift", salaryController.shiftController),
                  _field("Other", salaryController.otherAllowanceController),
                ]),

                sizedBoxHeight(height: 24.h),
                _buildSectionTitle("Deductions"),
                _buildGridFields([
                  _field("PF", salaryController.pfController),
                  _field("ESI", salaryController.esiController),
                  _field("PT", salaryController.ptController),
                  _field("TDS", salaryController.tdsController),
                  _field("LWF", salaryController.lwfController),
                  _field("Notice Period", salaryController.noticePeriodController),
                  _field("Other", salaryController.otherDeductionController),
                ]),

                sizedBoxHeight(height: 32.h),
                CustomButton(
                  title: "Update Structure",
                  isLoading: salaryController.isLoading,
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      salaryController.updateSalaryStructure(widget.employeeId).then((response) {
                        if (response.isSuccess) {
                          showToast(message: response.message, toastType: ToastType.success);
                          pop(context);
                        } else {
                          showToast(message: response.message, toastType: ToastType.error);
                        }
                      });
                    }
                  },
                ),
                sizedBoxHeight(height: 40.h),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: CustomText(
        title,
        style: Helper(context).textTheme.titleMedium?.copyWith(color: primaryColor, fontSize: 18.sp),
      ),
    );
  }

  Widget _buildGridFields(List<Widget> fields) {
    List<Widget> rows = [];
    for (int i = 0; i < fields.length; i += 2) {
      rows.add(
        Padding(
          padding: EdgeInsets.only(bottom: 16.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: fields[i]),
              sizedBoxWidth(width: 16),
              if (i + 1 < fields.length)
                Expanded(child: fields[i + 1])
              else
                const Expanded(child: SizedBox()),
            ],
          ),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: rows,
    );
  }

  Widget _field(String label, TextEditingController controller) {
    return AppTextFieldWithHeading(
      heading: label,
      hindText: "0",
      controller: controller,
      keyboardType: TextInputType.number,
    );
  }

  Widget _buildDropdown(String hint, String? value, List<String> items, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          hint,
          style: Helper(context).textTheme.bodyMedium?.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w600),
        ),
        sizedBoxHeight(height: 7.h),
        DropdownButtonFormField<String>(
          value: value,
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
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(capitalize(e.replaceAll('_', ' '))))).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildCommissionLevelDropdown(String hint, int? value, List<CommissionLevelModel> items, Function(int?) onChanged) {
    // Ensure value is present in items or null
    int? effectiveValue = items.any((e) => e.id == value) ? value : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          hint,
          style: Helper(context).textTheme.bodyMedium?.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w600),
        ),
        sizedBoxHeight(height: 7.h),
        DropdownButtonFormField<int>(
          value: effectiveValue,
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
          items: items
              .map((e) => DropdownMenuItem(
                    value: e.id,
                    child: Text(e.levelName ?? ""),
                  ))
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
