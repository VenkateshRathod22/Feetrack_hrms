import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:vlr/controllers/department_controller.dart';
import 'package:vlr/controllers/recruitment_controller.dart';
import 'package:vlr/controllers/staff_contoller.dart';
import 'package:vlr/data/models/reports/recruitment_report_model.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/input_decoration.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/base/custom_button.dart';
import 'package:vlr/views/widget/text_box/app_text_box.dart';

class AddRequirementScreen extends StatefulWidget {
  final RecruitmentModel? recruitmentModel;
  const AddRequirementScreen({super.key, this.recruitmentModel});

  @override
  State<AddRequirementScreen> createState() => _AddRequirementScreenState();
}

class _AddRequirementScreenState extends State<AddRequirementScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController jobTitleController = TextEditingController();
  final TextEditingController vacanciesController = TextEditingController();
  final TextEditingController candidateNameController = TextEditingController();
  final TextEditingController candidateEmailController = TextEditingController();
  final TextEditingController candidatePhoneController = TextEditingController();
  final TextEditingController costController = TextEditingController();
  final TextEditingController interviewDateController = TextEditingController();
  final TextEditingController remarksController = TextEditingController();

  String? selectedEmployeeId;
  String? selectedDeptId;
  String selectedStage = 'applied';
  String selectedStatus = 'under_review';
  String selectedOfferStatus = 'pending';
  String selectedJoiningStatus = 'pending';

  final List<Map<String, String>> _interviewStages = [
    {'value': 'applied', 'label': 'Applied'},
    {'value': 'screening', 'label': 'Screening'},
    {'value': 'technical_round', 'label': 'Technical Round'},
    {'value': 'hr_round', 'label': 'Hr Round'},
    {'value': 'final_round', 'label': 'Final Round'},
  ];

  final List<Map<String, String>> _selectionStatuses = [
    {'value': 'under_review', 'label': 'Under Review'},
    {'value': 'selected', 'label': 'Selected'},
    {'value': 'rejected', 'label': 'Rejected'},
    {'value': 'on_hold', 'label': 'On Hold'},
  ];

  final List<Map<String, String>> _offerStatuses = [
    {'value': 'pending', 'label': 'Pending'},
    {'value': 'offered', 'label': 'Offered'},
    {'value': 'offer_accepted', 'label': 'Offer Accepted'},
    {'value': 'offer_rejected', 'label': 'Offer Rejected'},
  ];

  final List<Map<String, String>> _joiningStatuses = [
    {'value': 'pending', 'label': 'Pending'},
    {'value': 'joined', 'label': 'Joined'},
    {'value': 'not_joined', 'label': 'Not Joined'},
  ];

  @override
  void initState() {
    super.initState();
    if (widget.recruitmentModel != null) {
      jobTitleController.text = widget.recruitmentModel!.jobTitle ?? "";
      vacanciesController.text = widget.recruitmentModel!.vacanciesCount?.toString() ?? "";
      candidateNameController.text = widget.recruitmentModel!.candidateName ?? "";
      candidateEmailController.text = widget.recruitmentModel!.candidateEmail ?? "";
      candidatePhoneController.text = widget.recruitmentModel!.candidatePhone ?? "";
      costController.text = widget.recruitmentModel!.costPerHire ?? "";
      interviewDateController.text = _formatInputDate(widget.recruitmentModel!.interviewDate ?? "");
      remarksController.text = widget.recruitmentModel!.remarks ?? "";
      selectedEmployeeId = widget.recruitmentModel!.employeeId;
      selectedDeptId = widget.recruitmentModel!.departmentId?.toString();
      selectedStage = widget.recruitmentModel!.interviewStage ?? 'applied';
      selectedStatus = widget.recruitmentModel!.status ?? 'under_review';
      selectedOfferStatus = widget.recruitmentModel!.offerStatus ?? 'pending';
      selectedJoiningStatus = widget.recruitmentModel!.joiningStatus ?? 'pending';
    }
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<StaffController>().getEmployeesListing();
      Get.find<DepartmentController>().getDepartmentList();
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
        title: CustomText(widget.recruitmentModel != null ? "Edit Recruitment" : "Add Candidate / Job Vacancy", 
          style: Helper(context).textTheme.titleMedium?.copyWith(fontSize: 18.sp)),
        centerTitle: true,
        backgroundColor: white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => pop(context),
            icon:  Icon(Icons.close, color: greyText),
          )
        ],
      ),
      body: GetBuilder<RecruitmentController>(builder: (controller) {
        return SingleChildScrollView(
          padding: EdgeInsets.all(20.r),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextFieldWithHeading(
                  heading: "Job Vacancy / Position Title",
                  hindText: "e.g. Senior Software Engineer, Fitness Coach",
                  controller: jobTitleController,
                  isRequired: true,
                  validator: (v) => v!.isEmpty ? "Required" : null,
                ),
                sizedBoxHeight(height: 20),
                AppTextFieldWithHeading(
                  heading: "Vacancies Count",
                  hindText: "1",
                  controller: vacanciesController,
                  keyboardType: TextInputType.number,
                  isRequired: true,
                ),
                sizedBoxHeight(height: 20),
                GetBuilder<StaffController>(builder: (staff) {
                  return _buildDropdown(
                    "Select Candidate / Employee",
                    selectedEmployeeId,
                    staff.employeeListing.map((e) => DropdownMenuItem(value: e.id, child: Text(e.name ?? ""))).toList(),
                    (v) => setState(() => selectedEmployeeId = v),
                    hintText: "Select Existing Candidate / Staff...",
                  );
                }),
                sizedBoxHeight(height: 20),
                AppTextFieldWithHeading(
                  heading: "Candidate Name",
                  hindText: "Full candidate name",
                  controller: candidateNameController,
                  isRequired: true,
                  validator: (v) => v!.isEmpty ? "Required" : null,
                ),
                sizedBoxHeight(height: 20),
                AppTextFieldWithHeading(
                  heading: "Candidate Email",
                  hindText: "candidate@example.com",
                  controller: candidateEmailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                sizedBoxHeight(height: 20),
                AppTextFieldWithHeading(
                  heading: "Candidate Phone",
                  hindText: "+91 9876543210",
                  controller: candidatePhoneController,
                  keyboardType: TextInputType.phone,
                ),
                sizedBoxHeight(height: 20),
                GetBuilder<DepartmentController>(builder: (dept) {
                  return _buildDropdown(
                    "Department",
                    selectedDeptId,
                    dept.departmentList.map((e) => DropdownMenuItem(value: e.id.toString(), child: Text(e.name ?? ""))).toList(),
                    (v) => setState(() => selectedDeptId = v),
                    hintText: "Select Department...",
                  );
                }),
                sizedBoxHeight(height: 20),
                AppTextFieldWithHeading(
                  heading: "Interview Date",
                  hindText: "YYYY-MM-DD",
                  controller: interviewDateController,
                  readOnly: true,
                  onTap: () => _selectDate(context, interviewDateController),
                  suffix: Icon(Icons.calendar_today_outlined, size: 18),
                ),
                sizedBoxHeight(height: 20),
                _buildDropdown(
                  "Interview Stage",
                  selectedStage,
                  _interviewStages.map((e) => DropdownMenuItem(value: e['value']!, child: Text(e['label']!))).toList(),
                  (v) => setState(() => selectedStage = v!),
                  isRequired: true,
                ),
                sizedBoxHeight(height: 20),
                _buildDropdown(
                  "Selection Result / Status",
                  selectedStatus,
                  _selectionStatuses.map((e) => DropdownMenuItem(value: e['value']!, child: Text(e['label']!))).toList(),
                  (v) => setState(() => selectedStatus = v!),
                  isRequired: true,
                ),
                sizedBoxHeight(height: 20),
                _buildDropdown(
                  "Offer Status",
                  selectedOfferStatus,
                  _offerStatuses.map((e) => DropdownMenuItem(value: e['value']!, child: Text(e['label']!))).toList(),
                  (v) => setState(() => selectedOfferStatus = v!),
                  isRequired: true,
                ),
                sizedBoxHeight(height: 20),
                _buildDropdown(
                  "Joining Status",
                  selectedJoiningStatus,
                  _joiningStatuses.map((e) => DropdownMenuItem(value: e['value']!, child: Text(e['label']!))).toList(),
                  (v) => setState(() => selectedJoiningStatus = v!),
                  isRequired: true,
                ),
                sizedBoxHeight(height: 20),
                AppTextFieldWithHeading(
                  heading: "Cost Per Hire (₹)",
                  hindText: "0",
                  controller: costController,
                  keyboardType: TextInputType.number,
                  isRequired: true,
                ),
                sizedBoxHeight(height: 20),
                AppTextFieldWithHeading(
                  heading: "Evaluation Notes & Remarks",
                  hindText: "Notes on candidate skill set, interview feedback, salary negotiations...",
                  controller: remarksController,
                  maxLines: 4,
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
                        "Save Recruitment Record",
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
        "job_title": jobTitleController.text,
        "vacancies_count": int.tryParse(vacanciesController.text) ?? 0,
        "candidate_name": candidateNameController.text,
        "candidate_email": candidateEmailController.text,
        "candidate_phone": candidatePhoneController.text,
        "employee_id": selectedEmployeeId,
        "department_id": int.tryParse(selectedDeptId ?? ""),
        "interview_stage": selectedStage,
        "status": selectedStatus,
        "offer_status": selectedOfferStatus,
        "joining_status": selectedJoiningStatus,
        "cost_per_hire": double.tryParse(costController.text) ?? 0.0,
        "interview_date": interviewDateController.text,
        "remarks": remarksController.text,
      };

      if (widget.recruitmentModel != null) {
        Get.find<RecruitmentController>().updateRecruitmentRecord(widget.recruitmentModel!.id!, body).then((res) {
          if (res.isSuccess) {
            showToast(message: res.message, toastType: ToastType.success);
            pop(context);
          } else {
            showToast(message: res.message, toastType: ToastType.error);
          }
        });
      } else {
        Get.find<RecruitmentController>().createRecruitmentRecord(body).then((res) {
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

  Widget _buildDropdown(String hint, String? value, List<DropdownMenuItem<String>> items, Function(String?) onChanged, {bool isRequired = false, String? hintText}) {
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
          onChanged: onChanged,
          validator: isRequired ? (v) => v == null ? "Required" : null : null,
        ),
      ],
    );
  }
}
