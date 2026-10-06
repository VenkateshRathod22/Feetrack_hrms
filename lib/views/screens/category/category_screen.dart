import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/category_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/base/shimmer.dart';
import 'package:vlr/views/screens/attendance/team_attendance_history/team_attendaance_history_screen/widget/appbar_and_searchbar.dart';
import 'package:vlr/views/screens/category/create_category_screen.dart';
import 'package:vlr/views/screens/category/widget/category_widget.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<CategoryController>().getCategories();
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
          Get.find<CategoryController>().clearControllers();
          navigate(context: context, page: const CreateCategoryScreen());
        },
        backgroundColor: primaryColor,
        child: Icon(Icons.add, color: white),
      ),
      body: GetBuilder<CategoryController>(builder: (categoryController) {
        return Column(
          children: [
            AppBarAndSearchBar(
              title: "Category Management",
              onChanged: (value) {
                _debounce?.cancel();
                _debounce = Timer(const Duration(milliseconds: 500), () {
                  categoryController.getCategories(search: value.trim());
                });
              },
            ),
            sizedBoxHeight(height: 16.h),
            Expanded(
              child: categoryController.isLoading
                  ? ListView.separated(
                      padding: AppConstants.screenPadding,
                      itemBuilder: (context, index) => const CustomShimmer(
                        isLoading: true,
                        child: SizedBox(height: 80, width: double.infinity),
                      ),
                      separatorBuilder: (_, __) => sizedBoxHeight(height: 16.h),
                      itemCount: 5,
                    )
                  : categoryController.categoryList.isEmpty
                      ? Center(
                          child: CustomText(
                            "No categories found",
                            style: Helper(context).textTheme.titleMedium,
                          ),
                        )
                      : ListView.separated(
                          padding: AppConstants.screenPadding,
                          itemBuilder: (context, index) => CategoryWidget(
                            category: categoryController.categoryList[index],
                          ),
                          separatorBuilder: (_, __) => sizedBoxHeight(height: 16.h),
                          itemCount: categoryController.categoryList.length,
                        ),
            ),
          ],
        );
      }),
    );
  }
}
