import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:vlr/controllers/discipline_controller.dart';
import 'package:vlr/controllers/staff_contoller.dart';
import 'package:vlr/data/models/reports/grievance_discipline_report_model.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/base/custom_button.dart';
import 'package:vlr/views/widget/text_box/app_text_box.dart';

class AddGrievanceDisciplinedScreen extends StatefulWidget {
  final GrievanceModel? grievance;
  const AddGrievanceDisciplinedScreen({super.key, this.grievance});

  @override
  State<AddGrievanceDisciplinedScreen> createState() => _AddGrievanceDisciplinedScreenState();
}

class _AddGrievanceDisciplinedScreenState extends State<AddGrievanceDisciplinedScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController actionController = TextEditingController();
  final TextEditingController resolutionController = TextEditingController();

  String? selectedEmployeeId;
  String selectedType = 'warning';
  String selectedStatus = 'open';

  @override
  void initState() {
    super.initState();
    if (widget.grievance != null) {
      titleController.text = widget.grievance!.title ?? "";
      descriptionController.text = widget.grievance!.description ?? "";
      dateController.text = _formatInputDate(widget.grievance!.incidentDate ?? "");
      actionController.text = widget.grievance!.actionTaken ?? "";
      resolutionController.text = widget.grievance!.resolutionNotes ?? "";
      selectedEmployeeId = widget.grievance!.employeeId;
      selectedType = widget.grievance!.recordType ?? 'warning';
      selectedStatus = widget.grievance!.status ?? 'open';
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
        title: CustomText(widget.grievance != null ? "Edit Grievance" : "Report Incident", style: Helper(context).textTheme.titleMedium?.copyWith(fontSize: 18.sp)),
        centerTitle: true,
        backgroundColor: white,
        elevation: 0,
      ),
      body: GetBuilder<DisciplineController>(builder: (controller) {
        return SingleChildScrollView(
          padding: EdgeInsets.all(16.r),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle("Incident Basics"),
                GetBuilder<StaffController>(builder: (staff) {
                  return _buildDropdown(
                    "Concerned Employee",
                    selectedEmployeeId,
                    staff.employeeListing.map((e) => DropdownMenuItem(value: e.id, child: Text(e.name ?? ""))).toList(),
                    (v) => setState(() => selectedEmployeeId = v),
                    enabled: widget.grievance == null,
                  );
                }),
                sizedBoxHeight(height: 16),
                AppTextFieldWithHeading(
                  heading: "Title",
                  hindText: "e.g. Official Written Warning",
                  controller: titleController,
                  isRequired: true,
                  validator: (v) => v!.isEmpty ? "Required" : null,
                ),
                sizedBoxHeight(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildDropdown(
                        "Record Type",
                        selectedType,
                        ['warning', 'grievance', 'disciplinary_action', 'investigation'].map((e) => DropdownMenuItem(value: e, child: Text(capitalize(e.replaceAll("_", " "))))).toList(),
                        (v) => setState(() => selectedType = v!),
                      ),
                    ),
                    sizedBoxWidth(width: 12),
                    Expanded(
                      child: AppTextFieldWithHeading(
                        heading: "Incident Date",
                        hindText: "YYYY-MM-DD",
                        controller: dateController,
                        readOnly: true,
                        onTap: () => _selectDate(context, dateController),
                        isRequired: true,
                      ),
                    ),
                  ],
                ),
                sizedBoxHeight(height: 24),
                _buildSectionTitle("Description & Investigation"),
                AppTextFieldWithHeading(
                  heading: "Incident Description",
                  hindText: "Provide details of what happened...",
                  controller: descriptionController,
                  maxLines: 4,
                  isRequired: true,
                  validator: (v) => v!.isEmpty ? "Required" : null,
                ),
                sizedBoxHeight(height: 16),
                AppTextFieldWithHeading(
                  heading: "Action Taken",
                  hindText: "e.g. 1st written warning issued.",
                  controller: actionController,
                  maxLines: 2,
                ),
                sizedBoxHeight(height: 24),
                _buildSectionTitle("Resolution"),
                _buildDropdown(
                  "Status",
                  selectedStatus,
                  ['open', 'under_investigation', 'resolved', 'closed'].map((e) => DropdownMenuItem(value: e, child: Text(capitalize(e.replaceAll("_", " "))))).toList(),
                  (v) => setState(() => selectedStatus = v!),
                ),
                sizedBoxHeight(height: 16),
                AppTextFieldWithHeading(
                  heading: "Resolution Notes",
                  hindText: "Notes on how the incident was closed...",
                  controller: resolutionController,
                  maxLines: 3,
                ),
                sizedBoxHeight(height: 40),
                CustomButton(
                  title: widget.grievance != null ? "Update Record" : "Submit Report",
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
        "record_type": selectedType,
        "title": titleController.text,
        "description": descriptionController.text,
        "incident_date": dateController.text,
        "action_taken": actionController.text,
        "resolution_notes": resolutionController.text,
        "status": selectedStatus,
      };

      if (widget.grievance != null) {
        Get.find<DisciplineController>().updateGrievanceRecord(widget.grievance!.id!, body).then((res) {
          if (res.isSuccess) {
            showToast(message: res.message, toastType: ToastType.success);
            pop(context);
          } else {
            showToast(message: res.message, toastType: ToastType.error);
          }
        });
      } else {
        Get.find<DisciplineController>().createGrievanceRecord(body).then((res) {
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
      lastDate: DateTime.now(),
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
