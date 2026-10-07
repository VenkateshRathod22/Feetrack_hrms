import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:vlr/controllers/probation_controller.dart';
import 'package:vlr/controllers/staff_contoller.dart';
import 'package:vlr/data/models/reports/probation_report_model.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/base/custom_button.dart';
import 'package:vlr/views/widget/text_box/app_text_box.dart';

class AddProbotaionScreen extends StatefulWidget {
  final ProbationModel? probationModel;
  const AddProbotaionScreen({super.key, this.probationModel});

  @override
  State<AddProbotaionScreen> createState() => _AddProbotaionScreenState();
}

class _AddProbotaionScreenState extends State<AddProbotaionScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController startController = TextEditingController();
  final TextEditingController dueController = TextEditingController();
  final TextEditingController assetController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final TextEditingController confirmationDateController = TextEditingController();
  final TextEditingController extendedDueController = TextEditingController();

  String? selectedEmployeeId;
  String selectedStatus = 'on_probation';
  bool isExtended = false;

  @override
  void initState() {
    super.initState();
    if (widget.probationModel != null) {
      startController.text = _formatInputDate(widget.probationModel!.startDate ?? "");
      dueController.text = _formatInputDate(widget.probationModel!.confirmationDueDate ?? "");
      assetController.text = widget.probationModel!.assetAllocation ?? "";
      notesController.text = widget.probationModel!.evaluationNotes ?? "";
      confirmationDateController.text = _formatInputDate(widget.probationModel!.confirmationDate ?? "");
      extendedDueController.text = _formatInputDate(widget.probationModel!.extendedDueDate ?? "");
      selectedEmployeeId = widget.probationModel!.employeeId;
      selectedStatus = widget.probationModel!.status ?? 'on_probation';
      isExtended = widget.probationModel!.isExtended ?? false;
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
        title: CustomText(widget.probationModel != null ? "Edit Probation" : "Add Probation", style: Helper(context).textTheme.titleMedium?.copyWith(fontSize: 18.sp)),
        centerTitle: true,
        backgroundColor: white,
        elevation: 0,
      ),
      body: GetBuilder<ProbationController>(builder: (controller) {
        return SingleChildScrollView(
          padding: EdgeInsets.all(16.r),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle("Employee & Status"),
                GetBuilder<StaffController>(builder: (staff) {
                  return _buildDropdown(
                    "Select Employee",
                    selectedEmployeeId,
                    staff.employeeListing.map((e) => DropdownMenuItem(value: e.id, child: Text(e.name ?? ""))).toList(),
                    (v) => setState(() => selectedEmployeeId = v),
                    enabled: widget.probationModel == null,
                  );
                }),
                sizedBoxHeight(height: 16),
                _buildDropdown(
                  "Current Status",
                  selectedStatus,
                  [
                    DropdownMenuItem(value: 'on_probation', child: Text("On Probation")),
                    DropdownMenuItem(value: 'extended_probation', child: Text("Extended Probation")),
                    DropdownMenuItem(value: 'confirmed_employee', child: Text("Confirmed Employee")),
                    DropdownMenuItem(value: 'rejected', child: Text("Rejected")),
                  ],
                  (v) => setState(() => selectedStatus = v!),
                ),
                sizedBoxHeight(height: 24),
                _buildSectionTitle("Timeline"),
                Row(
                  children: [
                    Expanded(
                      child: AppTextFieldWithHeading(
                        heading: "Start Date",
                        hindText: "YYYY-MM-DD",
                        controller: startController,
                        readOnly: true,
                        onTap: () => _selectDate(context, startController),
                        isRequired: true,
                      ),
                    ),
                    sizedBoxWidth(width: 12),
                    Expanded(
                      child: AppTextFieldWithHeading(
                        heading: "Due Date",
                        hindText: "YYYY-MM-DD",
                        controller: dueController,
                        readOnly: true,
                        onTap: () => _selectDate(context, dueController),
                        isRequired: true,
                      ),
                    ),
                  ],
                ),
                sizedBoxHeight(height: 16),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: CustomText("Extend Probation Period", style: Helper(context).textTheme.bodyMedium),
                  value: isExtended,
                  activeColor: primaryColor,
                  onChanged: (v) => setState(() {
                    isExtended = v!;
                    if (isExtended) {
                      selectedStatus = 'extended_probation';
                    }
                  }),
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                if (isExtended) ...[
                  sizedBoxHeight(height: 8),
                  AppTextFieldWithHeading(
                    heading: "Extended Due Date",
                    hindText: "YYYY-MM-DD",
                    controller: extendedDueController,
                    readOnly: true,
                    onTap: () => _selectDate(context, extendedDueController),
                    isRequired: true,
                  ),
                ],
                if (selectedStatus == 'confirmed_employee') ...[
                  sizedBoxHeight(height: 16),
                  AppTextFieldWithHeading(
                    heading: "Actual Confirmation Date",
                    hindText: "YYYY-MM-DD",
                    controller: confirmationDateController,
                    readOnly: true,
                    onTap: () => _selectDate(context, confirmationDateController),
                    isRequired: true,
                  ),
                ],
                sizedBoxHeight(height: 24),
                _buildSectionTitle("Allocations & Notes"),
                AppTextFieldWithHeading(
                  heading: "Asset Allocation",
                  hindText: "e.g. Laptop, ID Card, Sim",
                  controller: assetController,
                  maxLines: 2,
                ),
                sizedBoxHeight(height: 16),
                AppTextFieldWithHeading(
                  heading: "Evaluation Notes",
                  hindText: "Performance feedback...",
                  controller: notesController,
                  maxLines: 3,
                ),
                sizedBoxHeight(height: 40),
                CustomButton(
                  title: widget.probationModel != null ? "Update Record" : "Add Record",
                  isLoading: controller.isLoading,
                  onTap: _submitForm,
                ),
                sizedBoxHeight(height: 20),
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
        "start_date": startController.text,
        "confirmation_due_date": dueController.text,
        "asset_allocation": assetController.text,
        "status": selectedStatus,
        "evaluation_notes": notesController.text,
        "is_extended": isExtended,
        if (isExtended) "extended_due_date": extendedDueController.text,
        if (selectedStatus == 'confirmed_employee') "confirmation_date": confirmationDateController.text,
      };

      if (widget.probationModel != null) {
        Get.find<ProbationController>().updateProbationRecord(widget.probationModel!.id!, body).then((res) {
          if (res.isSuccess) {
            showToast(message: res.message, toastType: ToastType.success);
            pop(context);
          } else {
            showToast(message: res.message, toastType: ToastType.error);
          }
        });
      } else {
        Get.find<ProbationController>().createProbationRecord(body).then((res) {
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

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: CustomText(title, style: Helper(context).textTheme.titleSmall?.copyWith(color: primaryColor)),
    );
  }

  Widget _buildDropdown(String hint, String? value, List<DropdownMenuItem<String>> items, Function(String?) onChanged, {bool enabled = true}) {
    String? validatedValue;
    if (value != null && items.any((item) => item.value == value)) {
      validatedValue = value;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(hint, style: Helper(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold)),
        sizedBoxHeight(height: 4),
        DropdownButtonFormField<String>(
          isExpanded: true,
          value: validatedValue,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r), borderSide: BorderSide(color: greyLight1)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r), borderSide: BorderSide(color: greyLight1)),
            enabled: enabled,
          ),
          items: items,
          onChanged: enabled ? onChanged : null,
        ),
      ],
    );
  }
}
