import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/product_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/base/shimmer.dart';
import 'package:vlr/views/screens/attendance/team_attendance_history/team_attendaance_history_screen/widget/appbar_and_searchbar.dart';
import 'package:vlr/views/screens/product/create_product_screen.dart';
import 'package:vlr/views/screens/product/widget/product_widget.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<ProductController>().getProducts();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.find<ProductController>().clearControllers();
          navigate(context: context, page: const CreateProductScreen());
        },
        backgroundColor: primaryColor,
        child: Icon(Icons.add, color: white),
      ),
      body: GetBuilder<ProductController>(builder: (productController) {
        return Column(
          children: [
            AppBarAndSearchBar(
              title: "Product Management",
              onChanged: (value) {
                _debounce?.cancel();
                _debounce = Timer(const Duration(milliseconds: 500), () {
                  productController.getProducts(search: value.trim());
                });
              },
            ),
            sizedBoxHeight(height: 16.h),
            Expanded(
              child: productController.isLoading
                  ? ListView.separated(
                      padding: AppConstants.screenPadding,
                      itemBuilder: (context, index) => const CustomShimmer(
                        isLoading: true,
                        child: SizedBox(height: 100, width: double.infinity),
                      ),
                      separatorBuilder: (_, __) => sizedBoxHeight(height: 16.h),
                      itemCount: 5,
                    )
                  : productController.productList.isEmpty
                      ? Center(
                          child: CustomText(
                            "No products found",
                            style: Helper(context).textTheme.titleMedium,
                          ),
                        )
                      : ListView.separated(
                          padding: AppConstants.screenPadding,
                          itemBuilder: (context, index) => ProductWidget(
                            product: productController.productList[index],
                          ),
                          separatorBuilder: (_, __) => sizedBoxHeight(height: 16.h),
                          itemCount: productController.productList.length,
                        ),
            ),
          ],
        );
      }),
    );
  }
}
