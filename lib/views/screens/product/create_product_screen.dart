import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/category_controller.dart';
import 'package:vlr/controllers/product_controller.dart';
import 'package:vlr/data/models/category_model.dart';
import 'package:vlr/data/models/product_model.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/base/custom_button.dart';
import 'package:vlr/views/base/custom_dropdown.dart';
import 'package:vlr/views/widget/text_box/app_text_box.dart';

class CreateProductScreen extends StatefulWidget {
  final bool isEdit;
  final ProductModel? product;
  const CreateProductScreen({super.key, this.isEdit = false, this.product});

  @override
  State<CreateProductScreen> createState() => _CreateProductScreenState();
}

class _CreateProductScreenState extends State<CreateProductScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<CategoryController>().getCategories();
      if (widget.isEdit && widget.product != null) {
        Get.find<ProductController>().setEditData(widget.product!);
      } else {
        Get.find<ProductController>().clearControllers();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundLight,
      appBar: AppBar(
        title: CustomText(
          widget.isEdit ? "Edit Product" : "Create Product",
          style: Helper(context).textTheme.titleMedium?.copyWith(fontSize: 18.sp),
        ),
        backgroundColor: white,
        foregroundColor: black,
        elevation: 0,
        centerTitle: true,
      ),
      body: GetBuilder<ProductController>(builder: (productController) {
        return SingleChildScrollView(
          padding: AppConstants.screenPadding,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(16.r),
                  decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.circular(16.r),
                    boxShadow: [
                      BoxShadow(
                        color: black.withValues(alpha: 0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      GetBuilder<CategoryController>(builder: (categoryController) {
                        return CustomDropDownList<CategoryModel>(
                          heading: "CATEGORY",
                          isRequired: true,
                          items: categoryController.categoryList,
                          value: productController.selectedCategory,
                          hintText: "Select Category",
                          onChanged: (val) {
                            productController.selectedCategory = val;
                            productController.update();
                          },
                        );
                      }),
                      sizedBoxHeight(height: 16),
                      AppTextFieldWithHeading(
                        heading: "PRODUCT NAME",
                        hindText: "Enter Product Name",
                        controller: productController.nameController,
                        isRequired: true,
                        validator: (value) => value == null || value.isEmpty ? "Name is required" : null,
                      ),
                      sizedBoxHeight(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: AppTextFieldWithHeading(
                              heading: "BASE PRICE",
                              hindText: "0.00",
                              controller: productController.priceController,
                              keyboardType: TextInputType.number,
                              isRequired: true,
                              validator: (value) => value == null || value.isEmpty ? "Price is required" : null,
                            ),
                          ),
                          sizedBoxWidth(width: 16),
                          Expanded(
                            child: CustomDropDownList<String>(
                              heading: "GST TYPE",
                              items: productController.gstTypeOptions,
                              value: productController.selectedGstType,
                              onChanged: (val) {
                                productController.selectedGstType = val!;
                                productController.update();
                              },
                            ),
                          ),
                        ],
                      ),
                      sizedBoxHeight(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: AppTextFieldWithHeading(
                              heading: "GST PERCENT (%)",
                              hindText: "0",
                              controller: productController.gstPercentController,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          sizedBoxWidth(width: 16),
                          Expanded(
                            child: CustomDropDownList<String>(
                              heading: "STATUS",
                              items: productController.statusOptions,
                              value: productController.selectedStatus,
                              onChanged: (val) {
                                productController.selectedStatus = val!;
                                productController.update();
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                sizedBoxHeight(height: 32),
                CustomButton(
                  title: widget.isEdit ? "Update Product" : "Create Product",
                  isLoading: productController.isLoading,
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      if (productController.selectedCategory == null) {
                        showToast(message: "Please select a category", toastType: ToastType.warning);
                        return;
                      }

                      final nav = Navigator.of(context);
                      if (widget.isEdit) {
                        productController.updateProduct(widget.product!.id!).then((response) {
                          if (response.isSuccess) {
                            showToast(message: response.message, toastType: ToastType.success);
                            nav.pop();
                          } else {
                            showToast(message: response.message, toastType: ToastType.error);
                          }
                        });
                      } else {
                        productController.createProduct().then((response) {
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
