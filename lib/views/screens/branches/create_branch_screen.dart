import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/braches_controller.dart';
import 'package:vlr/controllers/staff_contoller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/base/custom_button.dart';
import 'package:vlr/views/widget/text_box/app_text_box.dart';

class CreateBranchScreen extends StatefulWidget {
  final bool isEdit;
  final int? branchId;
  const CreateBranchScreen({super.key, this.isEdit = false, this.branchId});

  @override
  State<CreateBranchScreen> createState() => _CreateBranchScreenState();
}

class _CreateBranchScreenState extends State<CreateBranchScreen> {
  final _formKey = GlobalKey<FormState>();

  Future<void> _getCurrentLocation(BrachesController controller) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      showToast(message: 'Location services are disabled.');
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        showToast(message: 'Location permissions are denied');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      showToast(message: 'Location permissions are permanently denied.');
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      controller.latController.text = position.latitude.toString();
      controller.lngController.text = position.longitude.toString();
      showToast(message: "Location fetched successfully", typeCheck: true);
    } catch (e) {
      showToast(message: "Error fetching location: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<StaffController>().getEmployeesListing();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        title: Text(widget.isEdit ? "Edit Branch" : "Create Branch"),
        backgroundColor: white,
        foregroundColor: black,
        elevation: 0,
      ),
      body: GetBuilder<BrachesController>(builder: (branchController) {
        return GetBuilder<StaffController>(builder: (staffController) {
          return SingleChildScrollView(
            padding: AppConstants.screenPadding,
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  AppTextFieldWithHeading(
                    heading: "Branch Name",
                    hindText: "Enter name",
                    controller: branchController.nameController,
                    isRequired: true,
                    validator: (val) => val == null || val.isEmpty ? "Required" : null,
                  ),
                  sizedBoxHeight(height: 16.h),
                  AppTextFieldWithHeading(
                    heading: "Address",
                    hindText: "Enter address",
                    controller: branchController.addressController,
                    isRequired: true,
                    maxLines: 2,
                  ),
                  sizedBoxHeight(height: 16.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        "Location Coordinates",
                        style: Helper(context).textTheme.bodyMedium?.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w600),
                      ),
                      TextButton.icon(
                        onPressed: () => _getCurrentLocation(branchController),
                        icon: Icon(Icons.my_location, size: 18.sp, color: primaryColor),
                        label: CustomText(
                          "Get Current Location",
                          style: Helper(context).textTheme.bodySmall?.copyWith(color: primaryColor, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  sizedBoxHeight(height: 8.h),
                  Row(
                    children: [
                      Expanded(
                        child: AppTextFieldWithHeading(
                          heading: "Latitude",
                          hindText: "0.0",
                          controller: branchController.latController,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      sizedBoxWidth(width: 16.w),
                      Expanded(
                        child: AppTextFieldWithHeading(
                          heading: "Longitude",
                          hindText: "0.0",
                          controller: branchController.lngController,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  sizedBoxHeight(height: 16.h),
                  AppTextFieldWithHeading(
                    heading: "Radius (meters)",
                    hindText: "100",
                    controller: branchController.radiusController,
                    keyboardType: TextInputType.number,
                  ),
                  sizedBoxHeight(height: 16.h),
                  _buildDropdownManual(
                    "Manager",
                    branchController.selectedManagerId,
                    staffController.employeeListing
                        .map((e) => DropdownMenuItem(value: e.id.toString(), child: Text(e.name ?? "")))
                        .toList(),
                    (val) => setState(() => branchController.selectedManagerId = val),
                  ),
                  sizedBoxHeight(height: 16.h),
                  _buildDropdown(
                    "Status",
                    branchController.selectedStatus,
                    ['active', 'inactive'],
                    (val) => setState(() => branchController.selectedStatus = val),
                  ),
                  sizedBoxHeight(height: 32.h),
                  CustomButton(
                    title: widget.isEdit ? "Update Branch" : "Create Branch",
                    isLoading: branchController.isLoading,
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        if (widget.isEdit) {
                          branchController.updateBranch(widget.branchId!).then((res) {
                            showToast(message: res.message, typeCheck: res.isSuccess);
                            if (res.isSuccess) pop(context);
                          });
                        } else {
                          branchController.createBranch().then((res) {
                            showToast(message: res.message, typeCheck: res.isSuccess);
                            if (res.isSuccess) pop(context);
                          });
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        });
      }),
    );
  }

  Widget _buildDropdown(String hint, String? value, List<String> items, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          hint,
          style: Helper(context).textTheme.bodyMedium?.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w600),
        ),
        sizedBoxHeight(height: 7.h),
        DropdownButtonFormField<String>(
          isExpanded: true,
          dropdownColor: white,
          value: value,
          decoration: InputDecoration(
            filled: true,
            fillColor: grey.withValues(alpha: 0.1),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: grey.withValues(alpha: 0.5), width: 0.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: grey.withValues(alpha: 0.5), width: 0.5),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
          ),
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(capitalize(e)))).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildDropdownManual(String hint, String? value, List<DropdownMenuItem<String>> items, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          hint,
          style: Helper(context).textTheme.bodyMedium?.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w600),
        ),
        sizedBoxHeight(height: 7.h),
        DropdownButtonFormField<String>(
          isExpanded: true,
          dropdownColor: white,
          value: (value != null && items.any((item) => item.value == value)) ? value : null,
          decoration: InputDecoration(
            filled: true,
            fillColor: grey.withValues(alpha: 0.1),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: grey.withValues(alpha: 0.5), width: 0.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: grey.withValues(alpha: 0.5), width: 0.5),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
          ),
          items: items,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
