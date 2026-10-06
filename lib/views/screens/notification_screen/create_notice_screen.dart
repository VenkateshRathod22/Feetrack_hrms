import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/notice_controller.dart';
import 'package:vlr/data/models/notice_model.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/base/custom_button.dart';
import 'package:vlr/views/widget/text_box/app_text_box.dart';

class CreateNoticeScreen extends StatefulWidget {
  final bool isEdit;
  final NoticeModel? noticeModel;
  const CreateNoticeScreen({super.key, this.isEdit = false, this.noticeModel});

  @override
  State<CreateNoticeScreen> createState() => _CreateNoticeScreenState();
}

class _CreateNoticeScreenState extends State<CreateNoticeScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.isEdit && widget.noticeModel != null) {
      Get.find<NoticeController>().setEditData(widget.noticeModel!);
    } else {
      Get.find<NoticeController>().clearControllers();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        title: Text(widget.isEdit ? "Update Notice" : "Create Notice"),
        elevation: 2,
      ),
      body: GetBuilder<NoticeController>(builder: (noticeController) {
        return SingleChildScrollView(
          padding: AppConstants.screenPadding,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextFieldWithHeading(
                  heading: "Title",
                  hindText: "Enter notice title",
                  controller: noticeController.titleController,
                  isRequired: true,
                  validator: (val) => val == null || val.isEmpty ? "Required" : null,
                ),
                sizedBoxHeight(height: 16.h),
                AppTextFieldWithHeading(
                  heading: "Content",
                  hindText: "Enter notice content",
                  controller: noticeController.contentController,
                  isRequired: true,
                  maxLines: 4,
                  validator: (val) => val == null || val.isEmpty ? "Required" : null,
                ),
                sizedBoxHeight(height: 16.h),
                CustomText("Notice Type", style: Helper(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
                sizedBoxHeight(height: 8.h),
                DropdownButtonFormField<String>(
                  value: noticeController.selectedType,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: grey.withValues(alpha: 0.1),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide.none),
                  ),
                  items: ['global', 'specific_users', 'branch', 'department'].map((e) {
                    return DropdownMenuItem(value: e, child: Text(e.capitalizeFirst!));
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        noticeController.selectedType = val;
                      });
                    }
                  },
                ),
                sizedBoxHeight(height: 16.h),
                Row(
                  children: [
                    Expanded(
                      child: AppTextFieldWithHeading(
                        heading: "Start Date",
                        hindText: "YYYY-MM-DD",
                        controller: noticeController.startDateController,
                        isRequired: true,
                        readOnly: true,
                        suffix: const Icon(Icons.calendar_today),
                        onTap: () async {
                          DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) {
                            noticeController.startDateController.text = picked.toString().split(' ')[0];
                          }
                        },
                      ),
                    ),
                    sizedBoxWidth(width: 16.w),
                    Expanded(
                      child: AppTextFieldWithHeading(
                        heading: "End Date",
                        hindText: "YYYY-MM-DD",
                        controller: noticeController.endDateController,
                        isRequired: true,
                        readOnly: true,
                        suffix: const Icon(Icons.calendar_today),
                        onTap: () async {
                          DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) {
                            noticeController.endDateController.text = picked.toString().split(' ')[0];
                          }
                        },
                      ),
                    ),
                  ],
                ),
                sizedBoxHeight(height: 16.h),
                AppTextFieldWithHeading(
                  heading: "Action Link (Optional)",
                  hindText: "https://example.com",
                  controller: noticeController.actionLinkController,
                ),
                sizedBoxHeight(height: 16.h),
                AppTextFieldWithHeading(
                  heading: "Action Text (Optional)",
                  hindText: "Read more",
                  controller: noticeController.actionTextController,
                ),
                sizedBoxHeight(height: 32.h),
                CustomButton(
                  title: widget.isEdit ? "Update" : "Create",
                  isLoading: noticeController.isLoading,
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      if (widget.isEdit) {
                        noticeController.updateNotice(widget.noticeModel!.id!).then((res) {
                          showToast(message: res.message, typeCheck: res.isSuccess);
                          if (res.isSuccess) pop(context);
                        });
                      } else {
                        noticeController.createNotice().then((res) {
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
