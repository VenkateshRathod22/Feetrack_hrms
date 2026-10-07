import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/commission_level_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/base/custom_button.dart';
import 'package:vlr/views/widget/text_box/app_text_box.dart';

class AddCommissionScreen extends StatefulWidget {
  final bool isEdit;
  final int? commissionId;
  const AddCommissionScreen({super.key, this.isEdit = false, this.commissionId});

  @override
  State<AddCommissionScreen> createState() => _AddCommissionScreenState();
}

class _AddCommissionScreenState extends State<AddCommissionScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        title: Text(widget.isEdit ? "Edit Commission" : "Add Commission"),
        backgroundColor: white,
        foregroundColor: black,
        elevation: 0,
      ),
      body: GetBuilder<CommissionLevelController>(builder: (commissionController) {
        return SingleChildScrollView(
          padding: AppConstants.screenPadding,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextFieldWithHeading(
                  heading: "Level Name",
                  hindText: "Enter level name (e.g. Junior)",
                  controller: commissionController.levelNameController,
                  isRequired: true,
                  validator: (val) => val == null || val.isEmpty ? "Required" : null,
                ),
                sizedBoxHeight(height: 16.h),
                AppTextFieldWithHeading(
                  heading: "Level Order",
                  hindText: "Enter order number (e.g. 1)",
                  controller: commissionController.levelOrderController,
                  isRequired: true,
                  keyboardType: TextInputType.number,
                  validator: (val) => val == null || val.isEmpty ? "Required" : null,
                ),
                sizedBoxHeight(height: 16.h),
                AppTextFieldWithHeading(
                  heading: "Commission Percent (%)",
                  hindText: "Enter percentage (e.g. 2.0)",
                  controller: commissionController.commissionPercentController,
                  isRequired: true,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  validator: (val) => val == null || val.isEmpty ? "Required" : null,
                ),
                sizedBoxHeight(height: 16.h),
                AppTextFieldWithHeading(
                  heading: "Description",
                  hindText: "Enter notes",
                  controller: commissionController.descriptionController,
                  maxLines: 3,
                ),
                sizedBoxHeight(height: 32.h),
                CustomButton(
                  title: widget.isEdit ? "Update Commission" : "Add Commission",
                  isLoading: commissionController.isLoading,
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      if (widget.isEdit) {
                        commissionController.updateCommissionLevel(widget.commissionId!).then((res) {
                          showToast(message: res.message, typeCheck: res.isSuccess);
                          if (res.isSuccess) pop(context);
                        });
                      } else {
                        commissionController.addCommissionLevel().then((res) {
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
      }),
    );
  }
}
