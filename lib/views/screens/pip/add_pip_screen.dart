import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:vlr/controllers/pip_controller.dart';
import 'package:vlr/controllers/staff_contoller.dart';
import 'package:vlr/data/models/reports/pip_report_model.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/input_decoration.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/base/custom_button.dart';
import 'package:vlr/views/widget/text_box/app_text_box.dart';

class AddPipScreen extends StatefulWidget {
  final PipModel? pipModel;
  const AddPipScreen({super.key, this.pipModel});

  @override
  State<AddPipScreen> createState() => _AddPipScreenState();
}

class _AddPipScreenState extends State<AddPipScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController reasonController = TextEditingController();
  final TextEditingController startController = TextEditingController();
  final TextEditingController endController = TextEditingController();
  final TextEditingController targetsController = TextEditingController();
  final TextEditingController remarksController = TextEditingController();
  final TextEditingController reviewController = TextEditingController();

  String? selectedEmployeeId;
  String selectedStatus = 'active_pip';

  final List<Map<String, String>> _pipStatuses = [
    {'value': 'active_pip', 'label': 'Active PIP'},
    {'value': 'under_review', 'label': 'Under Review'},
    {'value': 'completed_passed', 'label': 'Completed - Passed'},
    {'value': 'completed_failed', 'label': 'Completed - Failed'},
    {'value': 'cancelled', 'label': 'Cancelled'},
  ];

  @override
  void initState() {
    super.initState();
    if (widget.pipModel != null) {
      reasonController.text = widget.pipModel!.reason ?? "";
      startController.text = _formatInputDate(widget.pipModel!.startDate ?? "");
      endController.text = _formatInputDate(widget.pipModel!.endDate ?? "");
      targetsController.text = widget.pipModel!.improvementTargets ?? "";
      remarksController.text = widget.pipModel!.remarks ?? "";
      reviewController.text = widget.pipModel!.reviewResult ?? "";
      selectedEmployeeId = widget.pipModel!.employeeId;
      selectedStatus = widget.pipModel!.status ?? 'active_pip';
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
        title: CustomText(widget.pipModel != null ? "Edit PIP Plan" : "New PIP Plan", 
          style: Helper(context).textTheme.titleMedium?.copyWith(fontSize: 18.sp)),
        centerTitle: true,
        backgroundColor: white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => pop(context),
            icon: Icon(Icons.close, color: greyText),
          )
        ],
      ),
      body: GetBuilder<PipController>(builder: (controller) {
        return SingleChildScrollView(
          padding: EdgeInsets.all(20.r),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GetBuilder<StaffController>(builder: (staff) {
                  return _buildDropdown(
                    "Select Employee",
                    selectedEmployeeId,
                    staff.employeeListing.map((e) => DropdownMenuItem(value: e.id, child: Text(e.name ?? ""))).toList(),
                    (v) => setState(() => selectedEmployeeId = v),
                    isRequired: true,
                    hintText: "Select Employee...",
                    enabled: widget.pipModel == null,
                  );
                }),
                sizedBoxHeight(height: 20),
                AppTextFieldWithHeading(
                  heading: "Reason for PIP",
                  hindText: "e.g. Sales Target shortfall in Q3",
                  controller: reasonController,
                  isRequired: true,
                  validator: (v) => v!.isEmpty ? "Required" : null,
                ),
                sizedBoxHeight(height: 20),
                AppTextFieldWithHeading(
                  heading: "Improvement Targets",
                  hindText: "Enter goals and metrics...",
                  controller: targetsController,
                  maxLines: 4,
                  isRequired: true,
                  validator: (v) => v!.isEmpty ? "Required" : null,
                ),
                sizedBoxHeight(height: 20),
                AppTextFieldWithHeading(
                  heading: "Start Date",
                  hindText: "YYYY-MM-DD",
                  controller: startController,
                  readOnly: true,
                  onTap: () => _selectDate(context, startController),
                  isRequired: true,
                  suffix: Icon(Icons.calendar_today_outlined, size: 18),
                ),
                sizedBoxHeight(height: 20),
                AppTextFieldWithHeading(
                  heading: "End Date",
                  hindText: "YYYY-MM-DD",
                  controller: endController,
                  readOnly: true,
                  onTap: () => _selectDate(context, endController),
                  isRequired: true,
                  suffix: Icon(Icons.calendar_today_outlined, size: 18),
                ),
                sizedBoxHeight(height: 20),
                _buildDropdown(
                  "Status",
                  selectedStatus,
                  _pipStatuses.map((e) => DropdownMenuItem(value: e['value']!, child: Text(e['label']!))).toList(),
                  (v) => setState(() => selectedStatus = v!),
                  isRequired: true,
                ),
                sizedBoxHeight(height: 20),
                AppTextFieldWithHeading(
                  heading: "Review Result (Optional)",
                  hindText: "e.g. PASSED or FAILED",
                  controller: reviewController,
                ),
                sizedBoxHeight(height: 20),
                AppTextFieldWithHeading(
                  heading: "Remarks",
                  hindText: "Internal notes...",
                  controller: remarksController,
                  maxLines: 3,
                ),
                sizedBoxHeight(height: 40),
                CustomButton(
                  onTap: _submitForm,
                  isLoading: controller.isLoading,
                  radius: 8,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_rounded, color: Colors.white, size: 20),
                      sizedBoxWidth(width: 8),
                      CustomText(
                        widget.pipModel != null ? "Update PIP Plan" : "Initiate PIP Plan",
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
        "reason": reasonController.text,
        "start_date": startController.text,
        "end_date": endController.text,
        "improvement_targets": targetsController.text,
        "status": selectedStatus,
        "remarks": remarksController.text,
        if (reviewController.text.isNotEmpty) "review_result": reviewController.text,
      };

      if (widget.pipModel != null) {
        Get.find<PipController>().updatePipRecord(widget.pipModel!.id!, body).then((res) {
          if (res.isSuccess) {
            showToast(message: res.message, toastType: ToastType.success);
            pop(context);
          } else {
            showToast(message: res.message, toastType: ToastType.error);
          }
        });
      } else {
        Get.find<PipController>().createPipRecord(body).then((res) {
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
