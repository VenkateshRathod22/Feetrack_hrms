import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:vlr/controllers/document_controller.dart';
import 'package:vlr/controllers/staff_contoller.dart';
import 'package:vlr/data/models/reports/document_report_model.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/input_decoration.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/base/custom_button.dart';
import 'package:vlr/views/widget/text_box/app_text_box.dart';

class AddDocumentScreen extends StatefulWidget {
  final DocumentModel? document;
  const AddDocumentScreen({super.key, this.document});

  @override
  State<AddDocumentScreen> createState() => _AddDocumentScreenState();
}

class _AddDocumentScreenState extends State<AddDocumentScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController docNumberController = TextEditingController();
  final TextEditingController issueDateController = TextEditingController();
  final TextEditingController expiryDateController = TextEditingController();
  final TextEditingController remarksController = TextEditingController();

  String? selectedEmployeeId;
  String selectedCategory = 'kyc';
  String selectedType = 'aadhaar';
  String selectedStatus = 'pending';
  XFile? pickedFile;

  final List<Map<String, String>> _categories = [
    {'value': 'kyc', 'label': 'Aadhaar / PAN / Bank / KYC'},
    {'value': 'offer_letter', 'label': 'Offer Letter'},
    {'value': 'appointment_letter', 'label': 'Appointment Letter'},
    {'value': 'agreement_contract', 'label': 'Agreement / Contract'},
    {'value': 'other_document', 'label': 'Other Document'},
  ];

  final List<Map<String, String>> _documentTypes = [
    {'value': 'aadhaar', 'label': 'Aadhaar Card'},
    {'value': 'pan', 'label': 'PAN Card'},
    {'value': 'bank_passbook', 'label': 'Bank Passbook / Cancelled Cheque'},
    {'value': 'general_kyc', 'label': 'General KYC'},
    {'value': 'offer_letter', 'label': 'Offer Letter'},
    {'value': 'appointment_letter', 'label': 'Appointment Letter'},
    {'value': 'employment_agreement', 'label': 'Employment Agreement / NDA'},
    {'value': 'other_file', 'label': 'Other File'},
  ];

  final List<Map<String, String>> _verificationStatuses = [
    {'value': 'pending', 'label': 'Pending Verification'},
    {'value': 'verified', 'label': 'Verified'},
    {'value': 'rejected', 'label': 'Rejected'},
    {'value': 'expired', 'label': 'Expired'},
  ];

  @override
  void initState() {
    super.initState();
    if (widget.document != null) {
      titleController.text = widget.document!.title ?? "";
      docNumberController.text = widget.document!.documentNumber ?? "";
      issueDateController.text = _formatInputDate(widget.document!.issueDate ?? "");
      expiryDateController.text = _formatInputDate(widget.document!.expiryDate ?? "");
      remarksController.text = widget.document!.remarks ?? "";
      selectedEmployeeId = widget.document!.employeeId;
      selectedCategory = widget.document!.documentCategory ?? 'kyc';
      selectedType = widget.document!.documentType ?? 'aadhaar';
      selectedStatus = widget.document!.status ?? 'pending';
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
        title: CustomText(widget.document != null ? "Edit Document" : "Upload Document", 
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
      body: GetBuilder<DocumentController>(builder: (controller) {
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
                    enabled: widget.document == null,
                  );
                }),
                sizedBoxHeight(height: 20),
                _buildDropdown(
                  "Document Category",
                  selectedCategory,
                  _categories.map((e) => DropdownMenuItem(value: e['value']!, child: Text(e['label']!))).toList(),
                  (v) => setState(() => selectedCategory = v!),
                  isRequired: true,
                ),
                sizedBoxHeight(height: 20),
                _buildDropdown(
                  "Document Type / Sub-Category",
                  selectedType,
                  _documentTypes.map((e) => DropdownMenuItem(value: e['value']!, child: Text(e['label']!))).toList(),
                  (v) => setState(() => selectedType = v!),
                  isRequired: true,
                ),
                sizedBoxHeight(height: 20),
                AppTextFieldWithHeading(
                  heading: "Document Title",
                  hindText: "e.g. Employee Signed Offer Letter 2026",
                  controller: titleController,
                  isRequired: true,
                  validator: (v) => v!.isEmpty ? "Required" : null,
                ),
                sizedBoxHeight(height: 20),
                AppTextFieldWithHeading(
                  heading: "Document / Reference Number",
                  hindText: "e.g. 1234-5678-9012 or PAN ID",
                  controller: docNumberController,
                ),
                sizedBoxHeight(height: 20),
                _buildDropdown(
                  "Verification Status",
                  selectedStatus,
                  _verificationStatuses.map((e) => DropdownMenuItem(value: e['value']!, child: Text(e['label']!))).toList(),
                  (v) => setState(() => selectedStatus = v!),
                  isRequired: true,
                ),
                sizedBoxHeight(height: 20),
                AppTextFieldWithHeading(
                  heading: "Issue Date",
                  hindText: "YYYY-MM-DD",
                  controller: issueDateController,
                  readOnly: true,
                  onTap: () => _selectDate(context, issueDateController),
                  suffix: Icon(Icons.calendar_today_outlined, size: 18),
                ),
                sizedBoxHeight(height: 20),
                AppTextFieldWithHeading(
                  heading: "Expiry Date (If applicable)",
                  hindText: "YYYY-MM-DD",
                  controller: expiryDateController,
                  readOnly: true,
                  onTap: () => _selectDate(context, expiryDateController),
                  suffix: Icon(Icons.calendar_today_outlined, size: 18),
                ),
                sizedBoxHeight(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Document File (PDF / Image / Doc)",
                        style: Helper(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Text(
                      " *",
                      style: Helper(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.red),
                    ),
                  ],
                ),
                sizedBoxHeight(height: 7),
                GestureDetector(
                  onTap: _pickFile,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
                    decoration: BoxDecoration(
                      color: grey.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: grey.withValues(alpha: 0.5), width: 0.5),
                    ),
                    child: Row(
                      children: [
                         Icon(Icons.cloud_upload_outlined, color: primaryColor),
                        sizedBoxWidth(width: 12),
                        Expanded(
                          child: CustomText(
                            pickedFile != null ? pickedFile!.name : (widget.document?.filePath != null ? "Change Document File" : "No file chosen"),
                            style: Helper(context).textTheme.bodyMedium?.copyWith(color: pickedFile != null ? black : greyText),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                sizedBoxHeight(height: 20),
                AppTextFieldWithHeading(
                  heading: "Remarks / Verification Notes",
                  hindText: "Enter notes...",
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
                        widget.document != null ? "Update Record" : "Upload Document",
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

      if (widget.document == null && pickedFile == null) {
        showToast(message: "Please select a document file", toastType: ToastType.error);
        return;
      }

      final Map<String, dynamic> fields = {
        "employee_id": selectedEmployeeId,
        "document_category": selectedCategory,
        "document_type": selectedType,
        "title": titleController.text,
        "document_number": docNumberController.text,
        "issue_date": issueDateController.text,
        "expiry_date": expiryDateController.text,
        "status": selectedStatus,
        "remarks": remarksController.text,
      };

      dynamic body;
      if (pickedFile != null) {
        body = FormData({
          ...fields,
          "file": MultipartFile(File(pickedFile!.path), filename: pickedFile!.name),
        });
      } else {
        body = fields;
      }

      if (widget.document != null) {
        Get.find<DocumentController>().updateDocumentRecord(widget.document!.id!, body).then((res) {
          if (res.isSuccess) {
            showToast(message: res.message, toastType: ToastType.success);
            pop(context);
          } else {
            showToast(message: res.message, toastType: ToastType.error);
          }
        });
      } else {
        Get.find<DocumentController>().createDocumentRecord(body).then((res) {
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

  Future<void> _pickFile() async {
    final ImagePicker picker = ImagePicker();
    final XFile? file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() {
        pickedFile = file;
      });
    }
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
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
