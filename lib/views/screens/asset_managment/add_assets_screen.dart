import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:vlr/controllers/asset_controller.dart';
import 'package:vlr/controllers/braches_controller.dart';
import 'package:vlr/controllers/department_controller.dart';
import 'package:vlr/data/models/asset_model.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/base/custom_button.dart';
import 'package:vlr/views/widget/text_box/app_text_box.dart';

class AddAssetsScreen extends StatefulWidget {
  final AssetModel? asset;
  const AddAssetsScreen({super.key, this.asset});

  @override
  State<AddAssetsScreen> createState() => _AddAssetsScreenState();
}

class _AddAssetsScreenState extends State<AddAssetsScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController brandController = TextEditingController();
  final TextEditingController modelController = TextEditingController();
  final TextEditingController assetCodeController = TextEditingController();
  final TextEditingController serialController = TextEditingController();
  final TextEditingController imeiController = TextEditingController();
  final TextEditingController costController = TextEditingController();
  final TextEditingController purchaseDateController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  String selectedCategory = 'laptop';
  String selectedCondition = 'new';
  String selectedStatus = 'available';
  String? selectedBranchId;
  String? selectedDeptId;

  @override
  void initState() {
    super.initState();
    if (widget.asset != null) {
      nameController.text = widget.asset!.name ?? "";
      brandController.text = widget.asset!.brand ?? "";
      modelController.text = widget.asset!.model ?? "";
      assetCodeController.text = widget.asset!.assetCode ?? "";
      serialController.text = widget.asset!.serialNumber ?? "";
      imeiController.text = widget.asset!.imeiNumber ?? "";
      costController.text = widget.asset!.purchaseCost ?? "";
      purchaseDateController.text = _formatInputDate(widget.asset!.purchaseDate ?? "");
      descriptionController.text = widget.asset!.description ?? "";
      selectedCategory = widget.asset!.category ?? 'laptop';
      selectedCondition = widget.asset!.condition ?? 'new';
      selectedStatus = widget.asset!.status ?? 'available';
      selectedBranchId = widget.asset!.branchId?.toString();
      selectedDeptId = widget.asset!.departmentId?.toString();
    } else {
      _generateCode();
    }
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<BrachesController>().getBranchesList();
      Get.find<DepartmentController>().getDepartmentList();
    });
  }

  void _generateCode() async {
    final code = await Get.find<AssetController>().generateCode();
    if (code != null) {
      setState(() {
        assetCodeController.text = code;
      });
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
        title: CustomText(widget.asset != null ? "Edit Asset" : "Register Asset", style: Helper(context).textTheme.titleMedium?.copyWith(fontSize: 18.sp)),
        centerTitle: true,
        backgroundColor: white,
        elevation: 0,
      ),
      body: GetBuilder<AssetController>(builder: (controller) {
        return SingleChildScrollView(
          padding: EdgeInsets.all(16.r),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle("General Information"),
                AppTextFieldWithHeading(
                  heading: "Asset Name",
                  hindText: "e.g. Dell Latitude 5420",
                  controller: nameController,
                  isRequired: true,
                  validator: (v) => v!.isEmpty ? "Required" : null,
                ),
                sizedBoxHeight(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: AppTextFieldWithHeading(
                        heading: "Brand",
                        hindText: "e.g. Dell",
                        controller: brandController,
                      ),
                    ),
                    sizedBoxWidth(width: 12),
                    Expanded(
                      child: AppTextFieldWithHeading(
                        heading: "Model",
                        hindText: "e.g. Latitude 5420",
                        controller: modelController,
                      ),
                    ),
                  ],
                ),
                sizedBoxHeight(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: AppTextFieldWithHeading(
                        heading: "Asset Code",
                        hindText: "Generating...",
                        controller: assetCodeController,
                        readOnly: true,
                      ),
                    ),
                    sizedBoxWidth(width: 12),
                    Expanded(
                      child: _buildDropdown(
                        "Category",
                        selectedCategory,
                        ['laptop', 'mobile', 'sim', 'id_card', 'other'].map((e) => DropdownMenuItem(value: e, child: Text(capitalize(e.replaceAll("_", " "))))).toList(),
                        (v) => setState(() => selectedCategory = v!),
                      ),
                    ),
                  ],
                ),
                sizedBoxHeight(height: 24),
                _buildSectionTitle("Identifiers & Cost"),
                Row(
                  children: [
                    Expanded(
                      child: AppTextFieldWithHeading(
                        heading: "Serial Number",
                        hindText: "SN-987654321",
                        controller: serialController,
                      ),
                    ),
                    sizedBoxWidth(width: 12),
                    Expanded(
                      child: AppTextFieldWithHeading(
                        heading: "IMEI (Optional)",
                        hindText: "IMEI-XXXXX",
                        controller: imeiController,
                      ),
                    ),
                  ],
                ),
                sizedBoxHeight(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: AppTextFieldWithHeading(
                        heading: "Purchase Cost",
                        hindText: "0.00",
                        controller: costController,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    sizedBoxWidth(width: 12),
                    Expanded(
                      child: AppTextFieldWithHeading(
                        heading: "Purchase Date",
                        hindText: "YYYY-MM-DD",
                        controller: purchaseDateController,
                        readOnly: true,
                        onTap: () => _selectDate(context, purchaseDateController),
                      ),
                    ),
                  ],
                ),
                sizedBoxHeight(height: 24),
                _buildSectionTitle("Condition & Location"),
                Row(
                  children: [
                    Expanded(
                      child: _buildDropdown(
                        "Condition",
                        selectedCondition,
                        ['new', 'good', 'fair', 'damaged', 'obsolete'].map((e) => DropdownMenuItem(value: e, child: Text(capitalize(e)))).toList(),
                        (v) => setState(() => selectedCondition = v!),
                      ),
                    ),
                    sizedBoxWidth(width: 12),
                    Expanded(
                      child: _buildDropdown(
                        "Status",
                        selectedStatus,
                        ['available', 'issued', 'damaged', 'lost'].map((e) => DropdownMenuItem(value: e, child: Text(capitalize(e)))).toList(),
                        (v) => setState(() => selectedStatus = v!),
                      ),
                    ),
                  ],
                ),
                sizedBoxHeight(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: GetBuilder<BrachesController>(builder: (b) {
                        return _buildDropdown(
                          "Branch",
                          selectedBranchId,
                          b.branchList.map((e) => DropdownMenuItem(value: e.id.toString(), child: Text(e.name ?? ""))).toList(),
                          (v) => setState(() => selectedBranchId = v),
                        );
                      }),
                    ),
                    sizedBoxWidth(width: 12),
                    Expanded(
                      child: GetBuilder<DepartmentController>(builder: (d) {
                        return _buildDropdown(
                          "Dept",
                          selectedDeptId,
                          d.departmentList.map((e) => DropdownMenuItem(value: e.id.toString(), child: Text(e.name ?? ""))).toList(),
                          (v) => setState(() => selectedDeptId = v),
                        );
                      }),
                    ),
                  ],
                ),
                sizedBoxHeight(height: 16),
                AppTextFieldWithHeading(
                  heading: "Description",
                  hindText: "Enter additional notes...",
                  controller: descriptionController,
                  maxLines: 3,
                ),
                sizedBoxHeight(height: 40),
                CustomButton(
                  title: widget.asset != null ? "Update Asset" : "Register Asset",
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
      final body = {
        "asset_code": assetCodeController.text,
        "category": selectedCategory,
        "name": nameController.text,
        "brand": brandController.text,
        "model": modelController.text,
        "serial_number": serialController.text,
        "imei_number": imeiController.text,
        "mobile_number": "",
        "sim_number": "",
        "card_number": "",
        "purchase_date": purchaseDateController.text,
        "purchase_cost": double.tryParse(costController.text) ?? 0.0,
        "condition": selectedCondition,
        "status": selectedStatus,
        "branch_id": int.tryParse(selectedBranchId ?? ""),
        "department_id": int.tryParse(selectedDeptId ?? ""),
        "description": descriptionController.text,
      };

      if (widget.asset != null) {
        Get.find<AssetController>().updateAsset(widget.asset!.id!, body).then((res) {
          if (res.isSuccess) {
            showToast(message: res.message, toastType: ToastType.success);
            pop(context);
          } else {
            showToast(message: res.message, toastType: ToastType.error);
          }
        });
      } else {
        Get.find<AssetController>().createAsset(body).then((res) {
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

  Widget _buildDropdown(String hint, String? value, List<DropdownMenuItem<String>> items, Function(String?) onChanged) {
    // Validate that the current 'value' exists in the 'items' list to avoid assertion errors
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
          ),
          items: items,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
