import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:vlr/controllers/attrition_controller.dart';
import 'package:vlr/controllers/staff_contoller.dart';
import 'package:vlr/controllers/exit_reason_controller.dart';
import 'package:vlr/data/models/reports/attrition_report_model.dart';
import 'package:vlr/data/models/response/response_model.dart';
import 'package:vlr/data/repositories/reports_repo.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/base/custom_button.dart';
import 'package:vlr/views/widget/text_box/app_text_box.dart';

class RecordExitScreen extends StatefulWidget {
  final AttritionReportModel? attritionModel;
  const RecordExitScreen({super.key, this.attritionModel});

  @override
  State<RecordExitScreen> createState() => _RecordExitScreenState();
}

class _RecordExitScreenState extends State<RecordExitScreen> {
  final _formKey = GlobalKey<FormState>();
  String? selectedEmployeeId;
  String? selectedExitType;
  String? selectedExitReason;
  final TextEditingController resignationDateController = TextEditingController();
  final TextEditingController exitDateController = TextEditingController();
  final TextEditingController lastWorkingDateController = TextEditingController();
  final TextEditingController noticePeriodController = TextEditingController();
  final TextEditingController remarksController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.attritionModel != null) {
      selectedEmployeeId = widget.attritionModel!.employeeId;
      selectedExitType = widget.attritionModel!.exitType;
      selectedExitReason = widget.attritionModel!.exitReason;
      
      // Handle Date formats
      if (widget.attritionModel!.resignationDate != null) {
         resignationDateController.text = _formatInputDate(widget.attritionModel!.resignationDate!);
      }
      if (widget.attritionModel!.exitDate != null) {
         exitDateController.text = _formatInputDate(widget.attritionModel!.exitDate!);
      }
      if (widget.attritionModel!.lastWorkingDate != null) {
         lastWorkingDateController.text = _formatInputDate(widget.attritionModel!.lastWorkingDate!);
      }
      
      noticePeriodController.text = widget.attritionModel!.noticePeriodDays?.toString() ?? "";
      remarksController.text = widget.attritionModel!.remarks ?? "";
    }
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<StaffController>().getEmployeesListing();
      Get.find<ExitReasonController>().getExitReasonsReport();
    });
  }

  String _formatInputDate(String dateStr) {
    try {
      DateTime dt = DateTime.parse(dateStr);
      return DateFormat('yyyy-MM-dd').format(dt);
    } catch (e) {
      return dateStr.split("T")[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: CustomText(widget.attritionModel != null ? "Edit Exit Record" : "Record Employee Exit", style: Helper(context).textTheme.titleMedium?.copyWith(fontSize: 18.sp)),
        centerTitle: true,
        backgroundColor: white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: GetBuilder<AttritionController>(builder: (attritionController) {
        return SingleChildScrollView(
          padding: EdgeInsets.all(16.r),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle("Employee Information"),
                GetBuilder<StaffController>(builder: (staffController) {
                  return _buildDropdown(
                    "Select Employee",
                    selectedEmployeeId,
                    staffController.employeeListing.map((e) => DropdownMenuItem(value: e.id.toString(), child: Text(e.name ?? ""))).toList(),
                    (val) => setState(() => selectedEmployeeId = val),
                  );
                }),
                sizedBoxHeight(height: 16),
                _buildSectionTitle("Exit Details"),
                Row(
                  children: [
                    Expanded(
                      child: _buildDropdown(
                        "Exit Type",
                        selectedExitType,
                        ['voluntary', 'involuntary'].map((e) => DropdownMenuItem(value: e, child: Text(capitalize(e)))).toList(),
                        (val) => setState(() => selectedExitType = val),
                      ),
                    ),
                    sizedBoxWidth(width: 12),
                    Expanded(
                      child: GetBuilder<ExitReasonController>(builder: (reasonController) {
                        return _buildDropdown(
                          "Exit Reason",
                          selectedExitReason,
                          reasonController.exitReasonReportList.map((e) => DropdownMenuItem(value: e.name, child: Text(e.name ?? ""))).toList(),
                          (val) => setState(() => selectedExitReason = val),
                        );
                      }),
                    ),
                  ],
                ),
                sizedBoxHeight(height: 16),
                AppTextFieldWithHeading(
                  heading: "Resignation Date",
                  hindText: "YYYY-MM-DD",
                  controller: resignationDateController,
                  readOnly: true,
                  onTap: () => _selectDate(context, resignationDateController),
                  isRequired: true,
                  validator: (value) => value == null || value.isEmpty ? "Required" : null,
                ),
                sizedBoxHeight(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: AppTextFieldWithHeading(
                        heading: "Exit Date",
                        hindText: "YYYY-MM-DD",
                        controller: exitDateController,
                        readOnly: true,
                        onTap: () => _selectDate(context, exitDateController),
                        isRequired: true,
                        validator: (value) => value == null || value.isEmpty ? "Required" : null,
                      ),
                    ),
                    sizedBoxWidth(width: 12),
                    Expanded(
                      child: AppTextFieldWithHeading(
                        heading: "Last Working Date",
                        hindText: "YYYY-MM-DD",
                        controller: lastWorkingDateController,
                        readOnly: true,
                        onTap: () => _selectDate(context, lastWorkingDateController),
                        isRequired: true,
                        validator: (value) => value == null || value.isEmpty ? "Required" : null,
                      ),
                    ),
                  ],
                ),
                sizedBoxHeight(height: 16),
                AppTextFieldWithHeading(
                  heading: "Notice Period (Days)",
                  hindText: "e.g. 30",
                  controller: noticePeriodController,
                  keyboardType: TextInputType.number,
                  isRequired: true,
                  validator: (value) => value == null || value.isEmpty ? "Required" : null,
                ),
                sizedBoxHeight(height: 16),
                AppTextFieldWithHeading(
                  heading: "Remarks",
                  hindText: "Enter any additional notes...",
                  controller: remarksController,
                  maxLines: 3,
                ),
                sizedBoxHeight(height: 32),
                CustomButton(
                  title: widget.attritionModel != null ? "Update Exit Record" : "Submit Exit Record",
                  isLoading: attritionController.isLoading,
                  onTap: _submitRecord,
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        controller.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _submitRecord() {
    if (_formKey.currentState!.validate()) {
      if (selectedEmployeeId == null || selectedExitType == null || selectedExitReason == null) {
        showToast(message: "Please fill all required fields", toastType: ToastType.error);
        return;
      }
      
      Map<String, dynamic> body = {
        "employee_id": selectedEmployeeId,
        "exit_date": exitDateController.text,
        "last_working_date": lastWorkingDateController.text,
        "resignation_date": resignationDateController.text,
        "exit_type": selectedExitType,
        "exit_reason": selectedExitReason,
        "notice_period_days": int.tryParse(noticePeriodController.text) ?? 0,
        "remarks": remarksController.text,
        "status": "completed",
      };

      if (widget.attritionModel != null) {
        Get.find<AttritionController>().updateAttritionRecord(widget.attritionModel!.id!, body).then((response) {
          if (response.isSuccess) {
            showToast(message: response.message, toastType: ToastType.success);
            pop(context);
          } else {
            showToast(message: response.message, toastType: ToastType.error);
          }
        });
      } else {
        Get.find<AttritionController>().createAttritionRecord(body).then((response) {
          if (response.isSuccess) {
            showToast(message: response.message, toastType: ToastType.success);
            pop(context);
          } else {
            showToast(message: response.message, toastType: ToastType.error);
          }
        });
      }
    }
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: CustomText(title, style: Helper(context).textTheme.titleSmall?.copyWith(color: primaryColor)),
    );
  }

  Widget _buildDropdown(String hint, String? value, List<DropdownMenuItem<String>> items, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(hint, style: Helper(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold)),
        sizedBoxHeight(height: 4),
        DropdownButtonFormField<String>(
          isExpanded: true,
          value: value,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r), borderSide: BorderSide(color: greyLight1)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r), borderSide: BorderSide(color: greyLight1)),
          ),
          items: items,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
