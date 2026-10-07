import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:vlr/controllers/training_report_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/input_decoration.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/base/custom_button.dart';
import 'package:vlr/views/widget/text_box/app_text_box.dart';

import '../../../data/models/reports/training_report_model.dart';

class AddTrainingProgramScreen extends StatefulWidget {
  final TrainingProgramModel? program;
  const AddTrainingProgramScreen({super.key, this.program});

  @override
  State<AddTrainingProgramScreen> createState() => _AddTrainingProgramScreenState();
}

class _AddTrainingProgramScreenState extends State<AddTrainingProgramScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController trainerController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  final TextEditingController scoreController = TextEditingController();

  String selectedType = 'classroom';
  String selectedStatus = 'scheduled';

  final List<Map<String, String>> _trainingTypes = [
    {'value': 'classroom', 'label': 'Classroom'},
    {'value': 'online', 'label': 'Online'},
    {'value': 'on_the_job', 'label': 'On-The-Job'},
    {'value': 'workshop', 'label': 'Workshop'},
    {'value': 'certification', 'label': 'Certification'},
  ];

  final List<Map<String, String>> _statuses = [
    {'value': 'scheduled', 'label': 'Scheduled'},
    {'value': 'active', 'label': 'Active'},
    {'value': 'completed', 'label': 'Completed'},
    {'value': 'cancelled', 'label': 'Cancelled'},
  ];

  @override
  void initState() {
    super.initState();
    if (widget.program != null) {
      titleController.text = widget.program!.title ?? "";
      descriptionController.text = widget.program!.description ?? "";
      trainerController.text = widget.program!.trainer ?? "";
      startDateController.text = _formatInputDate(widget.program!.startDate ?? "");
      endDateController.text = _formatInputDate(widget.program!.endDate ?? "");
      durationController.text = widget.program!.duration?.toString() ?? "";
      scoreController.text = widget.program!.passingScore?.toString() ?? "";
      selectedType = widget.program!.trainingType ?? 'classroom';
      selectedStatus = widget.program!.status ?? 'scheduled';
    }
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
        title: CustomText(widget.program != null ? "Edit Training Program" : "Add Training Program", 
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
      body: GetBuilder<TrainingReportController>(builder: (controller) {
        return SingleChildScrollView(
          padding: EdgeInsets.all(20.r),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextFieldWithHeading(
                  heading: "Training Title",
                  hindText: "e.g. Leadership Development Program",
                  controller: titleController,
                  isRequired: true,
                  validator: (v) => v!.isEmpty ? "Required" : null,
                ),
                sizedBoxHeight(height: 20),
                AppTextFieldWithHeading(
                  heading: "Trainer Name",
                  hindText: "Trainer or Agency name",
                  controller: trainerController,
                ),
                sizedBoxHeight(height: 20),
                _buildDropdown(
                  "Training Type",
                  selectedType,
                  _trainingTypes.map((e) => DropdownMenuItem(value: e['value']!, child: Text(e['label']!))).toList(),
                  (v) => setState(() => selectedType = v!),
                  isRequired: true,
                ),
                sizedBoxHeight(height: 20),
                AppTextFieldWithHeading(
                  heading: "Duration (Days/Hours)",
                  hindText: "1",
                  controller: durationController,
                  keyboardType: TextInputType.number,
                ),
                sizedBoxHeight(height: 20),
                AppTextFieldWithHeading(
                  heading: "Start Date",
                  hindText: "YYYY-MM-DD",
                  controller: startDateController,
                  readOnly: true,
                  onTap: () => _selectDate(context, startDateController),
                  isRequired: true,
                  suffix: const Icon(Icons.calendar_today_outlined, size: 18),
                ),
                sizedBoxHeight(height: 20),
                AppTextFieldWithHeading(
                  heading: "End Date",
                  hindText: "YYYY-MM-DD",
                  controller: endDateController,
                  readOnly: true,
                  onTap: () => _selectDate(context, endDateController),
                  suffix: const Icon(Icons.calendar_today_outlined, size: 18),
                ),
                sizedBoxHeight(height: 20),
                AppTextFieldWithHeading(
                  heading: "Passing Score %",
                  hindText: "60",
                  controller: scoreController,
                  keyboardType: TextInputType.number,
                ),
                sizedBoxHeight(height: 20),
                _buildDropdown(
                  "Status",
                  selectedStatus,
                  _statuses.map((e) => DropdownMenuItem(value: e['value']!, child: Text(e['label']!))).toList(),
                  (v) => setState(() => selectedStatus = v!),
                  isRequired: true,
                ),
                sizedBoxHeight(height: 20),
                AppTextFieldWithHeading(
                  heading: "Description",
                  hindText: "Enter program details...",
                  controller: descriptionController,
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
                      const Icon(Icons.check_rounded, color: Colors.white, size: 20),
                      sizedBoxWidth(width: 8),
                      CustomText(
                        widget.program != null ? "Update Program" : "Create Program",
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
      final body = {
        "title": titleController.text,
        "description": descriptionController.text,
        "trainer": trainerController.text,
        "training_type": selectedType,
        "start_date": startDateController.text,
        "end_date": endDateController.text,
        "duration": int.tryParse(durationController.text) ?? 0,
        "passing_score": double.tryParse(scoreController.text) ?? 0.0,
        "status": selectedStatus,
      };

      if (widget.program != null) {
        Get.find<TrainingReportController>().updateTrainingProgram(widget.program!.id!, body).then((res) {
          if (res.isSuccess) {
            showToast(message: res.message, toastType: ToastType.success);
            pop(context);
          } else {
            showToast(message: res.message, toastType: ToastType.error);
          }
        });
      } else {
        Get.find<TrainingReportController>().createTrainingProgram(body).then((res) {
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

  Widget _buildDropdown(String hint, String? value, List<DropdownMenuItem<String>> items, Function(String?) onChanged, {bool isRequired = false}) {
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
          style: Helper(context).textTheme.bodyMedium?.copyWith(fontSize: 15.sp),
          decoration: CustomDecoration.inputDecoration(
            borderRadius: 12.0,
            bgColor: grey.withValues(alpha: 0.1),
            borderColor: grey.withValues(alpha: 0.5),
            borderWidth: 0.5,
            contentPadding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
          ),
          items: items,
          onChanged: onChanged,
          validator: isRequired ? (v) => v == null ? "Required" : null : null,
        ),
      ],
    );
  }
}
