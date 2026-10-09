import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/asset_controller.dart';
import 'package:vlr/controllers/braches_controller.dart';
import 'package:vlr/controllers/department_controller.dart';
import 'package:vlr/controllers/reports_controller.dart';
import 'package:vlr/data/models/asset_model.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/base/custom_dropdown.dart';
import 'package:vlr/views/screens/reports/widget/report_summary_widget.dart';
import 'package:vlr/views/screens/asset_managment/add_assets_screen.dart';
import 'package:vlr/views/widget/text_box/app_text_box.dart';
import 'package:collection/collection.dart';

class AssetScreen extends StatefulWidget {
  const AssetScreen({super.key});

  @override
  State<AssetScreen> createState() => _AssetScreenState();
}

class _AssetScreenState extends State<AssetScreen> {
  String? selectedCategory;
  String? selectedStatus;
  String? selectedCondition;
  String? selectedBranch;
  String? selectedDepartment;
  final TextEditingController searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  void _loadInitialData() {
    Get.find<AssetController>().getAssets();
    Get.find<BrachesController>().getBranchesList();
    Get.find<DepartmentController>().getDepartmentList();
  }

  Map<String, dynamic> _getFilterData() {
    Map<String, dynamic> filters = {};
    if (selectedCategory != null && selectedCategory != "All Categories") {
      filters['category'] = selectedCategory!.toLowerCase().replaceAll(" ", "_");
    }
    if (selectedStatus != null && selectedStatus != "All Statuses") {
      filters['status'] = selectedStatus!.toLowerCase();
    }
    if (selectedCondition != null && selectedCondition != "All Conditions") {
      filters['condition'] = selectedCondition!.toLowerCase();
    }
    if (selectedBranch != null && selectedBranch != "All Branches") {
      final branch = Get.find<BrachesController>().branchList.firstWhereOrNull((e) => e.name == selectedBranch);
      if (branch != null) filters['branch_id'] = branch.id.toString();
    }
    if (selectedDepartment != null && selectedDepartment != "All Departments") {
      final dept = Get.find<DepartmentController>().departmentList.firstWhereOrNull((e) => e.name == selectedDepartment);
      if (dept != null) filters['department_id'] = dept.id.toString();
    }
    if (searchController.text.isNotEmpty) {
      filters['search'] = searchController.text;
    }
    return filters;
  }

  void _fetchAssets() {
    Get.find<AssetController>().getAssets(query: _getFilterData());
  }

  @override
  void dispose() {
    _debounce?.cancel();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: CustomText("Asset Management", style: Helper(context).textTheme.titleMedium?.copyWith(fontSize: 18.sp)),
        centerTitle: true,
        backgroundColor: white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => Get.find<ReportsController>().exportReport(
              uri: AppConstants.assetExport,
              search: _getFilterData(),
            ),
            icon:  Icon(Icons.download_rounded, color: primaryColor),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => navigate(context: context, page: const AddAssetsScreen()),
        backgroundColor: primaryColor,
        icon:  Icon(Icons.add_rounded, color: white),
        label: CustomText("Register Asset", style: TextStyle(color: white, fontWeight: FontWeight.bold, fontSize: 14.sp)),
      ),
      body: GetBuilder<AssetController>(builder: (controller) {
        return RefreshIndicator(
          onRefresh: () async {
            _fetchAssets();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                _buildFilterSection(),
                if (controller.isLoading && controller.assetList.isEmpty)
                  Padding(
                    padding: EdgeInsets.only(top: 100.h),
                    child: const Center(child: CircularProgressIndicator()),
                  )
                else ...[
                  if (controller.summary != null)
                    ReportSummaryWidget(
                      items: [
                        ReportSummaryItemModel(label: "Total Assets", value: controller.summary!.totalAssets.toString(), icon: Icons.inventory_2_rounded),
                        ReportSummaryItemModel(label: "Available", value: controller.summary!.availableAssets.toString(), icon: Icons.check_circle_rounded),
                        ReportSummaryItemModel(label: "Issued", value: controller.summary!.issuedAssets.toString(), icon: Icons.person_pin_rounded),
                        ReportSummaryItemModel(label: "Value", value: PriceConverter.convertToNumberFormat(controller.summary!.totalAssetValue ?? 0), icon: Icons.payments_rounded),
                      ],
                    ),
                  
                  _buildCategoryBreakdown(controller),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    child: Row(
                      children: [
                        CustomText("Asset Inventory", style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: blackText1)),
                      ],
                    ),
                  ),

                  if (controller.assetList.isEmpty)
                    const Center(child: Padding(padding: EdgeInsets.all(20.0), child: Text("No assets found")))
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
                      itemCount: controller.assetList.length,
                      separatorBuilder: (_, __) => sizedBoxHeight(height: 12.h),
                      itemBuilder: (context, index) {
                        return _buildAssetCard(context, controller.assetList[index]);
                      },
                    ),
                ],
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      margin: EdgeInsets.all(16.r),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: CustomDropDownList<String>(
                  heading: "Category",
                  items: const ["All Categories", "Laptop", "Mobile", "Sim", "Id Card", "Other"],
                  value: selectedCategory ?? "All Categories",
                  onChanged: (val) {
                    setState(() => selectedCategory = val == "All Categories" ? null : val);
                    _fetchAssets();
                  },
                ),
              ),
              sizedBoxWidth(width: 12),
              Expanded(
                child: CustomDropDownList<String>(
                  heading: "Status",
                  items: const ["All Statuses", "Available", "Issued", "Damaged", "Lost"],
                  value: selectedStatus ?? "All Statuses",
                  onChanged: (val) {
                    setState(() => selectedStatus = val == "All Statuses" ? null : val);
                    _fetchAssets();
                  },
                ),
              ),
            ],
          ),
          sizedBoxHeight(height: 12),
          Row(
            children: [
              Expanded(
                child: CustomDropDownList<String>(
                  heading: "Condition",
                  items: const ["All Conditions", "New", "Good", "Fair", "Damaged", "Obsolete"],
                  value: selectedCondition ?? "All Conditions",
                  onChanged: (val) {
                    setState(() => selectedCondition = val == "All Conditions" ? null : val);
                    _fetchAssets();
                  },
                ),
              ),
              sizedBoxWidth(width: 12),
              Expanded(
                child: GetBuilder<BrachesController>(builder: (branchController) {
                  return CustomDropDownList<String>(
                    heading: "Branch",
                    items: ["All Branches", ...branchController.branchList.map((e) => e.name ?? "")],
                    value: selectedBranch ?? "All Branches",
                    onChanged: (val) {
                      setState(() => selectedBranch = val == "All Branches" ? null : val);
                      _fetchAssets();
                    },
                  );
                }),
              ),
            ],
          ),
          sizedBoxHeight(height: 12),
          GetBuilder<DepartmentController>(builder: (deptController) {
            return CustomDropDownList<String>(
              heading: "Department",
              items: ["All Departments", ...deptController.departmentList.map((e) => e.name ?? "")],
              value: selectedDepartment ?? "All Departments",
              onChanged: (val) {
                setState(() => selectedDepartment = val == "All Departments" ? null : val);
                _fetchAssets();
              },
            );
          }),
          sizedBoxHeight(height: 12),
          AppTextFieldWithHeading(
            controller: searchController,
            heading: "Search",
            hindText: "Search asset by name, code...",
            onChanged: (val) {
              if (_debounce?.isActive ?? false) _debounce!.cancel();
              _debounce = Timer(const Duration(milliseconds: 500), () {
                _fetchAssets();
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryBreakdown(AssetController controller) {
    if (controller.categoryBreakdown.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: EdgeInsets.all(16.r),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(color: white, borderRadius: BorderRadius.circular(16.r)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText("Category Breakdown", style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: blackText1)),
          sizedBoxHeight(height: 16),
          Wrap(
            spacing: 12.w,
            runSpacing: 12.h,
            children: controller.categoryBreakdown.map((cat) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: greyLight1,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomText("${cat.label}: ", style: TextStyle(fontSize: 11.sp, color: greyText)),
                    CustomText("${cat.total}", style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color: primaryColor)),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAssetCard(BuildContext context, AssetModel asset) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(color: white, borderRadius: BorderRadius.circular(16.r)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(asset.name ?? "N/A", style: const TextStyle(fontWeight: FontWeight.bold)),
                    CustomText(asset.assetCode ?? "N/A", style: TextStyle(fontSize: 11.sp, color: primaryColor, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              _buildBadge(asset.status),
              _buildActionMenu(context, asset),
            ],
          ),
          sizedBoxHeight(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _infoItem("Category", capitalize(asset.category)),
              _infoItem("Condition", capitalize(asset.condition)),
              _infoItem("Cost", PriceConverter.convertToNumberFormat(num.tryParse(asset.purchaseCost ?? "0") ?? 0)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(label, style: TextStyle(fontSize: 9.sp, color: greyText)),
        CustomText(value, style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.bold, color: blackText1)),
      ],
    );
  }

  Widget _buildBadge(String? text) {
    Color color = text == 'available' ? Colors.green : Colors.orange;
    if (text == 'damaged' || text == 'lost') color = Colors.red;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4.r)),
      child: CustomText(capitalize(text), style: TextStyle(fontSize: 10.sp, color: color, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildActionMenu(BuildContext context, AssetModel asset) {
    return PopupMenuButton<String>(
      padding: EdgeInsets.zero,
      icon: Icon(Icons.more_vert_rounded, size: 20, color: greyDart2),
      onSelected: (val) {
        if (val == 'edit') {
          navigate(context: context, page: AddAssetsScreen(asset: asset));
        } else if (val == 'delete') {
          _confirmDelete(context, asset);
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(value: 'edit', child: Row(children: [Icon(Icons.edit_rounded, size: 18, color: Colors.blue), SizedBox(width: 8), Text("Edit")])),
        const PopupMenuItem(value: 'delete', child: Row(children: [Icon(Icons.delete_rounded, size: 18, color: Colors.red), SizedBox(width: 8), Text("Delete")])),
      ],
    );
  }

  void _confirmDelete(BuildContext context, AssetModel asset) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Asset?"),
        content: Text("Are you sure you want to delete '${asset.name}'?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Get.find<AssetController>().deleteAsset(asset.id!).then((res) {
                showToast(message: res.message, toastType: res.isSuccess ? ToastType.success : ToastType.error);
              });
            },
            child: Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
