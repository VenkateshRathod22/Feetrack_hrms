import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/reports_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/screens/reports/widget/report_summary_widget.dart';

class ProductCategoryReportScreen extends StatefulWidget {
  const ProductCategoryReportScreen({super.key});

  @override
  State<ProductCategoryReportScreen> createState() => _ProductCategoryReportScreenState();
}

class _ProductCategoryReportScreenState extends State<ProductCategoryReportScreen> {
  String search = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchReport();
    });
  }

  void _fetchReport() {
    Get.find<ReportsController>().getProductCategoryReport(search: _getSearchMap());
  }

  Map<String, dynamic> _getSearchMap() {
    return {
      if (search.isNotEmpty) "search": search,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundLight,
      appBar: AppBar(
        title: CustomText(
          "Category Report",
          style: Helper(context).textTheme.titleMedium?.copyWith(fontSize: 18.sp),
        ),
        centerTitle: true,
        backgroundColor: white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () {
              Get.find<ReportsController>().exportReport(
                uri: AppConstants.productCategoryExport,
                search: _getSearchMap(),
              );
            },
            icon:  Icon(Icons.download_rounded, color: primaryColor),
          ),
        ],
      ),
      body: GetBuilder<ReportsController>(builder: (reportsController) {
        return SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search categories...",
                    prefixIcon: Icon(Icons.search_rounded),
                    filled: true,
                    fillColor: white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (v) {
                    setState(() => search = v);
                    _fetchReport();
                  },
                ),
              ),
              if (reportsController.isLoading && reportsController.productCategoryReportList.isEmpty)
                Padding(
                  padding: EdgeInsets.only(top: 100.h),
                  child: const Center(child: CircularProgressIndicator()),
                )
              else ...[
                if (reportsController.productCategoryReportSummary != null)
                  ReportSummaryWidget(
                    items: [
                      ReportSummaryItemModel(
                        label: "Total Categories",
                        value: reportsController.productCategoryReportSummary!.totalCategories.toString(),
                        icon: Icons.category_rounded,
                      ),
                      ReportSummaryItemModel(
                        label: "Active",
                        value: reportsController.productCategoryReportSummary!.active.toString(),
                        icon: Icons.check_circle_rounded,
                      ),
                      ReportSummaryItemModel(
                        label: "Inactive",
                        value: reportsController.productCategoryReportSummary!.inactive.toString(),
                        icon: Icons.cancel_rounded,
                      ),
                    ],
                  ),
                if (reportsController.productCategoryReportList.isEmpty)
                  Padding(
                    padding: EdgeInsets.only(top: 100.h),
                    child: const Center(child: Text("No data found")),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
                    itemCount: reportsController.productCategoryReportList.length,
                    separatorBuilder: (_, __) => sizedBoxHeight(height: 12.h),
                    itemBuilder: (context, index) {
                      final category = reportsController.productCategoryReportList[index];
                      return _buildCategoryCard(context, category);
                    },
                  ),
              ],
            ],
          ),
        );
      }),
    );
  }

  Widget _buildCategoryCard(BuildContext context, category) {
    return Container(
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  category.name ?? "N/A",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp, color: blackText1),
                ),
                sizedBoxHeight(height: 4),
                Row(
                  children: [
                    Icon(Icons.calendar_today_rounded, size: 12.sp, color: grey),
                    sizedBoxWidth(width: 4),
                    CustomText(
                      "Created: ${category.createdAt?.split(" ")[0] ?? "N/A"}",
                      style: TextStyle(fontSize: 11.sp, color: greyText),
                    ),
                  ],
                ),
              ],
            ),
            _buildStatusBadge(category.status),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String? status) {
    bool isActive = status?.toLowerCase() == 'active';
    Color color = isActive ? Colors.green : Colors.red;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: CustomText(
        capitalize(status),
        style: TextStyle(fontSize: 10.sp, color: color, fontWeight: FontWeight.bold),
      ),
    );
  }
}
