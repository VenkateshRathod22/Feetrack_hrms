import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/payslip_config_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/screens/settings/create_payslip_config_screen.dart';

import '../../../controllers/service_controller.dart';

class GetPayslipConfigScreen extends StatelessWidget {
  const GetPayslipConfigScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        title: const Text("Payslip Configuration"),
        backgroundColor: white,
        foregroundColor: black,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              navigate(context: context, page: const CreatePayslipConfigScreen());
            },
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: GetBuilder<PayslipConfigController>(builder: (controller) {
        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final config = controller.payslipConfig;
        if (config == null) {
          return const Center(child: CustomText("No configuration found"));
        }

        return SingleChildScrollView(
          padding: AppConstants.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildConfigItem("Company Name", config.companyName),
              _buildConfigItem("Company Address", config.companyAddress),
              _buildConfigItem("Authorized Signatory", config.authorizedSignatory),
              _buildConfigItem("Terms & Conditions", config.termsConditions),
              sizedBoxHeight(height: 20.h),
              Row(
                children: [
                  Expanded(child: _buildImageItem("Logo", config.logo)),
                  sizedBoxWidth(width: 16.w),
                  Expanded(child: _buildImageItem("Signature", config.signature)),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildConfigItem(String label, String? value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            label,
            style: TextStyle(
              color: grey,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          sizedBoxHeight(height: 4.h),
          CustomText(
            value ?? "Not set",
            style: TextStyle(
              color: black,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          Divider(color: grey.withValues(alpha: 0.2)),
        ],
      ),
    );
  }

  Widget _buildImageItem(String label, String? imageUrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          label,
          style: TextStyle(
            color: grey,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        sizedBoxHeight(height: 8.h),
        Container(
          height: 100.h,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: grey.withValues(alpha: 0.2)),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: imageUrl != null && imageUrl.isNotEmpty
              ? Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.image_not_supported)),
                )
              : const Center(child: Icon(Icons.image, color: Colors.grey)),
        ),
      ],
    );
  }
}

class CreatePayslipConfigScreen extends StatefulWidget {
  const CreatePayslipConfigScreen({super.key});

  @override
  State<CreatePayslipConfigScreen> createState() => _CreatePayslipConfigScreenState();
}

class _CreatePayslipConfigScreenState extends State<CreatePayslipConfigScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        title: const Text("Edit Payslip Config"),
        backgroundColor: white,
        foregroundColor: black,
        elevation: 0,
      ),
      body: GetBuilder<PayslipConfigController>(builder: (controller) {
        return SingleChildScrollView(
          padding: AppConstants.screenPadding,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField("Company Name", controller.companyNameController),
                _buildTextField("Company Address", controller.companyAddressController, maxLines: 3),
                _buildTextField("Authorized Signatory", controller.authorizedSignatoryController),
                _buildTextField("Terms & Conditions", controller.termsConditionsController, maxLines: 5),
                sizedBoxHeight(height: 20.h),
                Row(
                  children: [
                    Expanded(
                      child: _buildImagePicker(
                        "Company Logo",
                        controller.logoFile,
                        controller.payslipConfig?.logo,
                        controller.pickLogo,
                      ),
                    ),
                    sizedBoxWidth(width: 16.w),
                    Expanded(
                      child: _buildImagePicker(
                        "Signature",
                        controller.signatureFile,
                        controller.payslipConfig?.signature,
                        controller.pickSignature,
                      ),
                    ),
                  ],
                ),
                sizedBoxHeight(height: 40.h),
                ElevatedButton(
                  onPressed: controller.isLoading
                      ? null
                      : () {
                          if (_formKey.currentState!.validate()) {
                            controller.updatePayslipConfig().then((res) {
                              showToast(message: res.message, typeCheck: res.isSuccess);
                              if (res.isSuccess) pop(context);
                            });
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: white,
                    minimumSize: Size(double.infinity, 50.h),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                  ),
                  child: controller.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Save Configuration"),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {int maxLines = 1}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            label,
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
          ),
          sizedBoxHeight(height: 8.h),
          TextFormField(
            controller: controller,
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: "Enter $label",
              filled: true,
              fillColor: grey.withValues(alpha: 0.1),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide.none,
              ),
            ),
            validator: (val) => val == null || val.isEmpty ? "Required" : null,
          ),
        ],
      ),
    );
  }

  Widget _buildImagePicker(String label, XFile? localFile, String? remoteUrl, VoidCallback onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          label,
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
        ),
        sizedBoxHeight(height: 8.h),
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 100.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: grey.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: grey.withValues(alpha: 0.2)),
            ),
            child: localFile != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: Image.file(File(localFile.path), fit: BoxFit.contain),
                  )
                : remoteUrl != null && remoteUrl.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12.r),
                        child: Image.network(remoteUrl, fit: BoxFit.contain),
                      )
                    : const Icon(Icons.add_a_photo, color: Colors.grey),
          ),
        ),
      ],
    );
  }
}
