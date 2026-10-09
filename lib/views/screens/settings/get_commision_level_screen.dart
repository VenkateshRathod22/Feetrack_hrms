import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/commission_level_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/screens/settings/add_commission_screen.dart';

class GetCommisionLevelScreen extends StatefulWidget {
  const GetCommisionLevelScreen({super.key});

  @override
  State<GetCommisionLevelScreen> createState() => _GetCommisionLevelScreenState();
}

class _GetCommisionLevelScreenState extends State<GetCommisionLevelScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<CommissionLevelController>().getCommissionLevelList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        title: Text("Commission Levels"),
        backgroundColor: white,
        foregroundColor: black,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.find<CommissionLevelController>().clearControllers();
          navigate(context: context, page: const AddCommissionScreen());
        },
        backgroundColor: primaryColor,
        child:  Icon(Icons.add, color: white),
      ),
      body: GetBuilder<CommissionLevelController>(builder: (commissionController) {
        return Column(
          children: [
            Padding(
              padding: AppConstants.screenPadding.copyWith(bottom: 0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Search levels...",
                  prefixIcon: Icon(Icons.search),
                  filled: true,
                  fillColor: grey.withValues(alpha: 0.1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (val) {
                  commissionController.getCommissionLevelList(search: val);
                },
              ),
            ),
            Expanded(
              child: commissionController.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : commissionController.commissionLevelList.isEmpty
                      ? const Center(child: CustomText("No commission levels found"))
                      : ListView.builder(
                          padding: AppConstants.screenPadding,
                          itemCount: commissionController.commissionLevelList.length,
                          itemBuilder: (context, index) {
                            final level = commissionController.commissionLevelList[index];
                            return Container(
                              margin: EdgeInsets.only(bottom: 16.h),
                              padding: EdgeInsets.all(16.w),
                              decoration: BoxDecoration(
                                color: white,
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(color: grey.withValues(alpha: 0.2)),
                                boxShadow: [
                                  BoxShadow(
                                    color: black.withValues(alpha: 0.05),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: primaryColor.withValues(alpha: 0.1),
                                    child: CustomText(
                                      level.levelOrder?.toString() ?? "",
                                      style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  sizedBoxWidth(width: 16.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        CustomText(
                                          level.levelName ?? "",
                                          style: Helper(context).textTheme.titleMedium?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                        sizedBoxHeight(height: 4.h),
                                        Row(
                                          children: [
                                            Icon(Icons.percent, size: 14.sp, color: grey),
                                            sizedBoxWidth(width: 4.w),
                                            CustomText(
                                              "${level.commissionPercent}%",
                                              style: Helper(context).textTheme.bodySmall?.copyWith(color: grey),
                                            ),
                                          ],
                                        ),
                                        if (level.description != null && level.description!.isNotEmpty) ...[
                                          sizedBoxHeight(height: 4.h),
                                          CustomText(
                                            level.description!,
                                            style: Helper(context).textTheme.bodySmall?.copyWith(color: grey),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      commissionController.setEditData(level);
                                      navigate(
                                        context: context,
                                        page: AddCommissionScreen(isEdit: true, commissionId: level.id),
                                      );
                                    },
                                    icon: Icon(Icons.edit, color: Colors.blue),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      _showDeleteDialog(context, commissionController, level.id!);
                                    },
                                    icon: Icon(Icons.delete, color: Colors.red),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
            ),
          ],
        );
      }),
    );
  }

  void _showDeleteDialog(BuildContext context, CommissionLevelController controller, int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Commission Level"),
        content: Text("Are you sure you want to remove this commission level?"),
        actions: [
          TextButton(
            onPressed: () => pop(context),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              controller.deleteCommissionLevel(id).then((res) {
                showToast(message: res.message, typeCheck: res.isSuccess);
                pop(context);
              });
            },
            child: Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
