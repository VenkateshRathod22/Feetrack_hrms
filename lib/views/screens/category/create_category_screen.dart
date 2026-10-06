import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/category_controller.dart';
import 'package:vlr/data/models/category_model.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/base/custom_button.dart';
import 'package:vlr/views/widget/text_box/app_text_box.dart';

class CreateCategoryScreen extends StatefulWidget {
  final bool isEdit;
  final CategoryModel? category;
  const CreateCategoryScreen({super.key, this.isEdit = false, this.category});

  @override
  State<CreateCategoryScreen> createState() => _CreateCategoryScreenState();
}

class _CreateCategoryScreenState extends State<CreateCategoryScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        title: Text(widget.isEdit ? "Edit Category" : "Create Category"),
        backgroundColor: white,
        foregroundColor: black,
        elevation: 0,
      ),
      body: GetBuilder<CategoryController>(builder: (categoryController) {
        return SingleChildScrollView(
          padding: AppConstants.screenPadding,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextFieldWithHeading(
                  heading: "Category Name",
                  hindText: "Enter Category Name",
                  controller: categoryController.nameController,
                  keyboardType: TextInputType.name,
                  isRequired: true,
                  validator: (value) => value == null || value.isEmpty ? "Name is required" : null,
                ),
                sizedBoxHeight(height: 32.h),
                CustomButton(
                  title: widget.isEdit ? "Update Category" : "Create Category",
                  isLoading: categoryController.isLoading,
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      final nav = Navigator.of(context);
                      if (widget.isEdit) {
                        categoryController.updateCategory(widget.category!.id!).then((response) {
                          if (response.isSuccess) {
                            showToast(message: response.message, toastType: ToastType.success);
                            nav.pop();
                          } else {
                            showToast(message: response.message, toastType: ToastType.error);
                          }
                        });
                      } else {
                        categoryController.createCategory().then((response) {
                          if (response.isSuccess) {
                            showToast(message: response.message, toastType: ToastType.success);
                            nav.pop();
                          } else {
                            showToast(message: response.message, toastType: ToastType.error);
                          }
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
