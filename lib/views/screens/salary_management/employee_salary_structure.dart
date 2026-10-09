import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/salary_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/services/permission_helper.dart';
import 'package:vlr/views/screens/salary_management/update_salary_stucture_screen.dart';

class EmployeeSalaryStructure extends StatefulWidget {
  final String staffId;
  final String staffName;

  const EmployeeSalaryStructure({
    super.key,
    required this.staffId,
    required this.staffName,
  });

  @override
  State<EmployeeSalaryStructure> createState() => _EmployeeSalaryStructureState();
}

class _EmployeeSalaryStructureState extends State<EmployeeSalaryStructure> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<SalaryController>().getSalaryStructure(widget.staffId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundLight,
      appBar: AppBar(
        title: Text("Salary Structure"),
        backgroundColor: white,
        foregroundColor: black,
        elevation: 0,
      ),
      body: GetBuilder<SalaryController>(
        builder: (salaryController) {
          if (salaryController.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final structure = salaryController.salaryStructure;

          if (structure == null) {
            return const Center(
              child: Text("No salary structure found"),
            );
          }

          return SingleChildScrollView(
            padding: AppConstants.screenPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Employee Name
                CustomText(
                  widget.staffName,
                  style: Helper(context).textTheme.titleLarge?.copyWith(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                      ),
                ),

                sizedBoxHeight(height: 16.h),

                // General Section
                _buildSection(
                  context,
                  "General",
                  [
                    _buildInfoRow(
                      context,
                      "Salary Type",
                      capitalize(
                        structure.salaryType?.replaceAll('_', ' ') ?? "",
                      ),
                    ),
                    _buildInfoRow(
                      context,
                      "Basic Salary",
                      PriceConverter.convertToNumberFormat(
                        structure.basicSalary ?? 0,
                      ),
                    ),
                    _buildInfoRow(
                      context,
                      "Monthly Target",
                      PriceConverter.convertToNumberFormat(
                        structure.monthlyTarget ?? 0,
                      ),
                    ),
                    _buildInfoRow(
                      context,
                      "Merchant Target",
                      PriceConverter.convertToNumberFormat(
                        structure.merchantTarget ?? 0,
                      ),
                    ),
                    _buildInfoRow(
                      context,
                      "Commission (%)",
                      "${structure.commissionPercent}%",
                    ),
                    _buildInfoRow(
                      context,
                      "Recovery (%)",
                      "${structure.recoveryPercent}%",
                    ),
                  ],
                ),

                sizedBoxHeight(height: 16.h),

                // Incentives Section
                if ((structure.performanceIncentive ?? 0) > 0 || (structure.salesIncentive ?? 0) > 0)
                  _buildSection(
                    context,
                    "Incentives",
                    [
                      if ((structure.performanceIncentive ?? 0) > 0)
                        _buildInfoRow(
                          context,
                          "Performance Incentive",
                          PriceConverter.convertToNumberFormat(
                            structure.performanceIncentive ?? 0,
                          ),
                          color: green2,
                        ),
                      if ((structure.salesIncentive ?? 0) > 0)
                        _buildInfoRow(
                          context,
                          "Sales Incentive",
                          PriceConverter.convertToNumberFormat(
                            structure.salesIncentive ?? 0,
                          ),
                          color: green2,
                        ),
                      if (structure.incentiveText != null && structure.incentiveText!.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.only(top: 8.h),
                          child: CustomText(
                            structure.incentiveText!,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: greyDart2,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                    ],
                  ),

                if ((structure.performanceIncentive ?? 0) > 0 || (structure.salesIncentive ?? 0) > 0)
                  sizedBoxHeight(height: 16.h),

                // Allowances Section
                if (structure.allowances != null)
                  _buildSection(
                    context,
                    "Allowances",
                    [
                      _buildInfoRow(
                        context,
                        "HRA",
                        PriceConverter.convertToNumberFormat(
                          structure.allowances!.hra ?? 0,
                        ),
                      ),
                      _buildInfoRow(
                        context,
                        "DA",
                        PriceConverter.convertToNumberFormat(
                          structure.allowances!.da ?? 0,
                        ),
                      ),
                      _buildInfoRow(
                        context,
                        "Conveyance",
                        PriceConverter.convertToNumberFormat(
                          structure.allowances!.conveyance ?? 0,
                        ),
                      ),
                      _buildInfoRow(
                        context,
                        "Medical",
                        PriceConverter.convertToNumberFormat(
                          structure.allowances!.medical ?? 0,
                        ),
                      ),
                      _buildInfoRow(
                        context,
                        "Special",
                        PriceConverter.convertToNumberFormat(
                          structure.allowances!.special ?? 0,
                        ),
                      ),
                      _buildInfoRow(
                        context,
                        "Travel",
                        PriceConverter.convertToNumberFormat(
                          structure.allowances!.travel ?? 0,
                        ),
                      ),
                      _buildInfoRow(
                        context,
                        "Internet",
                        PriceConverter.convertToNumberFormat(
                          structure.allowances!.internet ?? 0,
                        ),
                      ),
                      _buildInfoRow(
                        context,
                        "Food",
                        PriceConverter.convertToNumberFormat(
                          structure.allowances!.food ?? 0,
                        ),
                      ),
                      _buildInfoRow(
                        context,
                        "Performance Incentive",
                        PriceConverter.convertToNumberFormat(
                          structure.allowances!.performanceIncentive ?? 0,
                        ),
                      ),
                      _buildInfoRow(
                        context,
                        "Sales Incentive",
                        PriceConverter.convertToNumberFormat(
                          structure.allowances!.salesIncentive ?? 0,
                        ),
                      ),
                      _buildInfoRow(
                        context,
                        "Bonus",
                        PriceConverter.convertToNumberFormat(
                          structure.allowances!.bonus ?? 0,
                        ),
                      ),
                      _buildInfoRow(
                        context,
                        "Total Allowances",
                        PriceConverter.convertToNumberFormat(
                          structure.totalAllowances ?? 0,
                        ),
                        isBold: true,
                      ),
                    ],
                  ),

                sizedBoxHeight(height: 16.h),

                // Deductions Section
                if (structure.deductions != null)
                  _buildSection(
                    context,
                    "Deductions",
                    [
                      _buildInfoRow(
                        context,
                        "PF",
                        PriceConverter.convertToNumberFormat(
                          structure.deductions!.pf ?? 0,
                        ),
                      ),
                      _buildInfoRow(
                        context,
                        "ESI",
                        PriceConverter.convertToNumberFormat(
                          structure.deductions!.esi ?? 0,
                        ),
                      ),
                      _buildInfoRow(
                        context,
                        "PT",
                        PriceConverter.convertToNumberFormat(
                          structure.deductions!.pt ?? 0,
                        ),
                      ),
                      _buildInfoRow(
                        context,
                        "TDS",
                        PriceConverter.convertToNumberFormat(
                          structure.deductions!.tds ?? 0,
                        ),
                      ),
                      _buildInfoRow(
                        context,
                        "LWF",
                        PriceConverter.convertToNumberFormat(
                          structure.deductions!.lwf ?? 0,
                        ),
                      ),
                    ],
                  ),

                sizedBoxHeight(height: 16.h),

                // Summary Section
                _buildSection(
                  context,
                  "Summary",
                  [
                    _buildInfoRow(
                      context,
                      "Gross Salary",
                      PriceConverter.convertToNumberFormat(
                        structure.grossSalary ?? 0,
                      ),
                      isBold: true,
                    ),
                    _buildInfoRow(
                      context,
                      "Net Salary",
                      PriceConverter.convertToNumberFormat(
                        structure.netSalary ?? 0,
                      ),
                      isBold: true,
                      color: green2,
                    ),
                  ],
                ),

                sizedBoxHeight(height: 24.h),

                // Buttons
                PermissionWrapper(
                  permission: 'salary_viewany',
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            salaryController.setUpdateData(structure);

                            navigate(
                              context: context,
                              page: UpdateSalaryStuctureScreen(
                                employeeId: widget.staffId,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: white,
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          child: const CustomText(
                            "Manage Structure",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                sizedBoxHeight(height: 40.h),
              ],
            ),
          );
        },
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Section Widget
  // ---------------------------------------------------------------------------

  Widget _buildSection(
    BuildContext context,
    String title,
    List<Widget> children,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            title,
            style: Helper(context).textTheme.titleMedium?.copyWith(
                  color: primaryColor,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const Divider(),
          ...children,
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Info Row Widget
  // ---------------------------------------------------------------------------

  Widget _buildInfoRow(
    BuildContext context,
    String label,
    String value, {
    bool isBold = false,
    Color? color,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: CustomText(
              label,
              style: Helper(context).textTheme.bodyMedium?.copyWith(
                    color: greyDart2,
                  ),
            ),
          ),
          SizedBox(width: 12.w),
          Flexible(
            child: CustomText(
              value,
              textAlign: TextAlign.end,
              style: Helper(context).textTheme.titleSmall?.copyWith(
                    fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
                    color: color ?? blackText3,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
