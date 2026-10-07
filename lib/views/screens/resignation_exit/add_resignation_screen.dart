import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:vlr/controllers/resignation_exit_controller.dart';
import 'package:vlr/controllers/staff_contoller.dart';
import 'package:vlr/data/models/exit_model.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/input_decoration.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/base/custom_button.dart';
import 'package:vlr/views/widget/text_box/app_text_box.dart';

class AddResignationScreen extends StatefulWidget {
  final ExitModel? exitModel;
  const AddResignationScreen({super.key, this.exitModel});

  @override
  State<AddResignationScreen> createState() => _AddResignationScreenState();
}

class _AddResignationScreenState extends State<AddResignationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController resignationDateController = TextEditingController();
  final TextEditingController noticePeriodController = TextEditingController();
  final TextEditingController lastWorkingDateController = TextEditingController();
  final TextEditingController exitReasonController = TextEditingController();
  final TextEditingController fnfAmountController = TextEditingController();
  final TextEditingController settlementDateController = TextEditingController();
  final TextEditingController feedbackController = TextEditingController();
  final TextEditingController remarksController = TextEditingController();

  String? selectedEmployeeId;
  String selectedStatus = 'resigned';
  String selectedClearance = 'pending_clearance';
  String selectedFnFStatus = 'pending_settlement';

  final List<Map<String, String>> _exitStatuses = [
    {'value': 'resigned', 'label': 'Resigned'},
    {'value': 'serving_notice_period', 'label': 'Serving Notice Period'},
    {'value': 'clearance_completed', 'label': 'Clearance Completed'},
    {'value': 'fully_exited', 'label': 'Fully Exited'},
    {'value': 'cancelled', 'label': 'Cancelled'},
  ];

  final List<Map<String, String>> _clearanceStatuses = [
    {'value': 'pending_clearance', 'label': 'Pending Clearance'},
    {'value': 'in_progress', 'label': 'In Progress'},
    {'value': 'partially_cleared', 'label': 'Partially Cleared'},
    {'value': 'fully_cleared', 'label': 'Fully Cleared'},
  ];

  final List<Map<String, String>> _fnfStatuses = [
    {'value': 'pending_settlement', 'label': 'Pending Settlement'},
    {'value': 'in_progress', 'label': 'In Progress'},
    {'value': 'settled_completed', 'label': 'Settled / Completed'},
    {'value': 'on_hold', 'label': 'On Hold'},
  ];

  @override
  void initState() {
    super.initState();
    if (widget.exitModel != null) {
      resignationDateController.text = _formatInputDate(widget.exitModel!.resignationDate ?? "");
      noticePeriodController.text = widget.exitModel!.noticePeriodDays?.toString() ?? "";
      lastWorkingDateController.text = _formatInputDate(widget.exitModel!.lastWorkingDate ?? "");
      exitReasonController.text = widget.exitModel!.exitReason ?? "";
      fnfAmountController.text = widget.exitModel!.fnfAmount ?? "";
      settlementDateController.text = _formatInputDate(widget.exitModel!.fnfSettlementDate ?? "");
      remarksController.text = widget.exitModel!.remarks ?? "";
      selectedEmployeeId = widget.exitModel!.employeeId;
      selectedStatus = widget.exitModel!.status ?? 'resigned';
      selectedClearance = widget.exitModel!.clearanceStatus ?? 'pending_clearance';
      selectedFnFStatus = widget.exitModel!.fnfStatus ?? 'pending_settlement';
    }
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<StaffController>().getEmployeesListing();
    });
  }

  String _formatInputDate(String dateStr) {
    if (dateStr.isEmpty) return "";
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
      backgroundColor: backgroundLight,
      appBar: AppBar(
        title: CustomText(widget.exitModel != null ? "Edit Exit Record" : "Record Resignation / Exit", 
          style: Helper(context).textTheme.titleMedium?.copyWith(fontSize: 18.sp)),
        centerTitle: true,
        backgroundColor: white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => pop(context),
            icon:          Icon(Icons.close, color: greyText),
          )
        ],
      ),
      body: GetBuilder<ResignationExitController>(builder: (controller) {
        return SingleChildScrollView(
          padding: EdgeInsets.all(20.r),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GetBuilder<StaffController>(builder: (staff) {
                  return _buildDropdown(
                    "Resigning Employee",
                    selectedEmployeeId,
                    staff.employeeListing.map((e) => DropdownMenuItem(value: e.id, child: Text(e.name ?? ""))).toList(),
                    (v) => setState(() => selectedEmployeeId = v),
                    isRequired: true,
                    hintText: "Select Employee...",
                    enabled: widget.exitModel == null,
                  );
                }),
                sizedBoxHeight(height: 20),
                _buildDropdown(
                  "Exit Status",
                  selectedStatus,
                  _exitStatuses.map((e) => DropdownMenuItem(value: e['value']!, child: Text(e['label']!))).toList(),
                  (v) => setState(() => selectedStatus = v!),
                  isRequired: true,
                ),
                sizedBoxHeight(height: 20),
                AppTextFieldWithHeading(
                  heading: "Resignation Date",
                  hindText: "YYYY-MM-DD",
                  controller: resignationDateController,
                  readOnly: true,
                  onTap: () => _selectDate(context, resignationDateController),
                  isRequired: true,
                  suffix: const Icon(Icons.calendar_today_outlined, size: 18),
                ),
                sizedBoxHeight(height: 20),
                AppTextFieldWithHeading(
                  heading: "Notice Period (Days)",
                  hindText: "e.g. 30",
                  controller: noticePeriodController,
                  keyboardType: TextInputType.number,
                  isRequired: true,
                ),
                sizedBoxHeight(height: 20),
                AppTextFieldWithHeading(
                  heading: "Last Working Date",
                  hindText: "YYYY-MM-DD",
                  controller: lastWorkingDateController,
                  readOnly: true,
                  onTap: () => _selectDate(context, lastWorkingDateController),
                  suffix: const Icon(Icons.calendar_today_outlined, size: 18),
                ),
                sizedBoxHeight(height: 20),
                AppTextFieldWithHeading(
                  heading: "Exit Reason",
                  hindText: "Describe the reason for resignation / exit...",
                  controller: exitReasonController,
                  isRequired: true,
                  maxLines: 3,
                  validator: (v) => v!.isEmpty ? "Required" : null,
                ),
                sizedBoxHeight(height: 20),
                _buildDropdown(
                  "Departmental Clearance Status",
                  selectedClearance,
                  _clearanceStatuses.map((e) => DropdownMenuItem(value: e['value']!, child: Text(e['label']!))).toList(),
                  (v) => setState(() => selectedClearance = v!),
                  isRequired: true,
                ),
                sizedBoxHeight(height: 20),
                _buildDropdown(
                  "F&F Settlement Status",
                  selectedFnFStatus,
                  _fnfStatuses.map((e) => DropdownMenuItem(value: e['value']!, child: Text(e['label']!))).toList(),
                  (v) => setState(() => selectedFnFStatus = v!),
                  isRequired: true,
                ),
                sizedBoxHeight(height: 20),
                AppTextFieldWithHeading(
                  heading: "F&F Settlement Amount (₹)",
                  hindText: "0",
                  controller: fnfAmountController,
                  keyboardType: TextInputType.number,
                  isRequired: true,
                ),
                sizedBoxHeight(height: 20),
                AppTextFieldWithHeading(
                  heading: "F&F Settlement Date",
                  hindText: "YYYY-MM-DD",
                  controller: settlementDateController,
                  readOnly: true,
                  onTap: () => _selectDate(context, settlementDateController),
                  suffix: const Icon(Icons.calendar_today_outlined, size: 18),
                ),
                sizedBoxHeight(height: 20),
                AppTextFieldWithHeading(
                  heading: "Exit Interview Feedback & Notes",
                  hindText: "Feedback provided during exit interview, handovers, asset return notes...",
                  controller: feedbackController,
                  maxLines: 4,
                ),
                sizedBoxHeight(height: 20),
                AppTextFieldWithHeading(
                  heading: "Internal HR Remarks",
                  hindText: "Enter notes...",
                  controller: remarksController,
                  maxLines: 3,
                ),
                sizedBoxHeight(height: 40),
                CustomButton(
                  onTap: _submitForm,
                  isLoading: controller.isActionLoading,
                  radius: 8,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.check_rounded, color: Colors.white, size: 20),
                      sizedBoxWidth(width: 8),
                      CustomText(
                        widget.exitModel != null ? "Update Exit Record" : "Save Exit Record",
                        style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                sizedBoxHeight(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () => pop(context),
                    child: CustomText("Cancel", style: TextStyle(color: blackText1, fontSize: 14.sp, fontWeight: FontWeight.w600)),
                  ),
                ),
                sizedBoxHeight(height: 30),
              ],
            ),
          ),
        );
      }),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (selectedEmployeeId == null) {
        showToast(message: "Please select an employee", toastType: ToastType.error);
        return;
      }

      final body = {
        "employee_id": selectedEmployeeId,
        "resignation_date": resignationDateController.text,
        "notice_period_days": int.tryParse(noticePeriodController.text) ?? 0,
        "last_working_date": lastWorkingDateController.text,
        "exit_reason": exitReasonController.text,
        "clearance_status": selectedClearance,
        "fnf_status": selectedFnFStatus,
        "fnf_amount": double.tryParse(fnfAmountController.text) ?? 0.0,
        "fnf_settlement_date": settlementDateController.text,
        "status": selectedStatus,
        "remarks": remarksController.text,
        "feedback_notes": feedbackController.text, // Assuming this field exists or can be handled
      };

      if (widget.exitModel != null) {
        Get.find<ResignationExitController>().updateExitRecord(widget.exitModel!.id!, body).then((res) {
          if (res.isSuccess) {
            showToast(message: res.message, toastType: ToastType.success);
            pop(context);
          } else {
            showToast(message: res.message, toastType: ToastType.error);
          }
        });
      } else {
        Get.find<ResignationExitController>().createExitRecord(body).then((res) {
          if (res.isSuccess) {
            showToast(message: res.message, toastType: ToastType.success);
            pop(context);
          } else {
            showToast(message: res.message, toastType: ToastType.error);
          }
        });
      }
    }
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

  Widget _buildDropdown(String hint, String? value, List<DropdownMenuItem<String>> items, Function(String?) onChanged, {bool isRequired = false, String? hintText, bool enabled = true}) {
    String? validatedValue;
    if (value != null && items.any((item) => item.value == value)) {
      validatedValue = value;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                hint,
                style: Helper(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isRequired)
              Text(
                " *",
                style: Helper(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.red),
              ),
          ],
        ),
        SizedBox(height: 7.w),
        DropdownButtonFormField<String>(
          isExpanded: true,
          value: validatedValue,
          hint: hintText != null ? Text(hintText, style: Helper(context).textTheme.bodyMedium?.copyWith(fontSize: 13.sp, color: greyText)) : null,
          style: Helper(context).textTheme.bodyMedium?.copyWith(fontSize: 15.sp),
          decoration: CustomDecoration.inputDecoration(
            borderRadius: 12.0,
            bgColor: grey.withValues(alpha: 0.1),
            borderColor: grey.withValues(alpha: 0.5),
            borderWidth: 0.5,
            contentPadding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
          ),
          items: items,
          onChanged: enabled ? onChanged : null,
          validator: isRequired ? (v) => v == null ? "Required" : null : null,
        ),
      ],
    );
  }
}
