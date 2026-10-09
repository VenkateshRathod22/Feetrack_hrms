import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/product_controller.dart';
import 'package:vlr/data/models/product_model.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/screens/product/create_product_screen.dart';

class ProductWidget extends StatelessWidget {
  final ProductModel product;
  const ProductWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        color: white,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 4),
            blurRadius: 10,
            spreadRadius: 0,
            color: black.withValues(alpha: 0.05),
          )
        ],
        border: Border.all(color: greyLight1, width: 1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: CustomText(
                                product.name ?? "Unknown Product",
                                style: Helper(context).textTheme.titleMedium?.copyWith(
                                      fontSize: 16.sp,
                                      color: blackText3,
                                      fontWeight: FontWeight.bold,
                                    ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            _StatusBadge(status: product.status),
                          ],
                        ),
                        sizedBoxHeight(height: 4.h),
                        Row(
                          children: [
                            Icon(Icons.category_outlined, size: 14.sp, color: greyText),
                            sizedBoxWidth(width: 4.w),
                            CustomText(
                              product.categoryName ?? product.category?.name ?? "No Category",
                              style: Helper(context).textTheme.bodySmall?.copyWith(
                                    color: greyText,
                                    fontSize: 12.sp,
                                  ),
                            ),
                          ],
                        ),
                        sizedBoxHeight(height: 12.h),
                        Row(
                          children: [
                            _priceInfo(context, "Base Price", PriceConverter.convertToNumberFormat(double.tryParse(product.amount ?? "0") ?? 0)),
                            sizedBoxWidth(width: 24.w),
                            _priceInfo(
                              context,
                              "GST (${product.gstPercent ?? 0}%)",
                              PriceConverter.convertToNumberFormat(product.gstAmount ?? 0),
                              subtitle: product.gstType == "include" ? "Included" : "Excluded",
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: grey.withValues(alpha: 0.03),
                border: Border(top: BorderSide(color: greyLight1.withValues(alpha: 0.5))),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        "TOTAL PRICE",
                        style: TextStyle(fontSize: 9.sp, fontWeight: FontWeight.bold, color: greyText, letterSpacing: 0.5),
                      ),
                      CustomText(
                        PriceConverter.convertToNumberFormat(product.totalPrice ?? 0),
                        style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w800, color: primaryColor),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      _ActionButton(
                        icon: Icons.edit_outlined,
                        color: primaryColor,
                        onPressed: () {
                          Get.find<ProductController>().setEditData(product);
                          navigate(context: context, page: CreateProductScreen(product: product, isEdit: true));
                        },
                      ),
                      sizedBoxWidth(width: 8.w),
                      _ActionButton(
                        icon: Icons.delete_outline,
                        color: red1,
                        onPressed: () => _showDeleteDialog(context),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _priceInfo(BuildContext context, String label, String value, {String? subtitle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(label, style: TextStyle(fontSize: 10.sp, color: greyText, fontWeight: FontWeight.w500)),
        CustomText(value, style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold, color: blackText2)),
        if (subtitle != null)
          CustomText(subtitle, style: TextStyle(fontSize: 9.sp, color: primaryColor.withValues(alpha: 0.7), fontWeight: FontWeight.w600)),
      ],
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Product"),
        content: Text("Are you sure you want to delete this product?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              final nav = Navigator.of(context);
              Get.find<ProductController>().deleteProduct(product.id!).then((response) {
                if (response.isSuccess) {
                  showToast(message: response.message, toastType: ToastType.success);
                } else {
                  showToast(message: response.message, toastType: ToastType.error);
                }
                nav.pop();
              });
            },
            child:  Text("Delete", style: TextStyle(color: red1)),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String? status;
  const _StatusBadge({this.status});

  @override
  Widget build(BuildContext context) {
    bool isActive = status?.toLowerCase() == "active";
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: (isActive ? green2 : red1).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: CustomText(
        capitalize(status ?? "N/A"),
        style: TextStyle(
          fontSize: 10.sp,
          color: isActive ? green2 : red1,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8.r),
        child: Container(
          padding: EdgeInsets.all(6.r),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
          ),
          child: Icon(icon, size: 18.sp, color: color),
        ),
      ),
    );
  }
}
