import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/auth_controller.dart';
import 'package:vlr/controllers/braches_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/base/shimmer.dart';
import 'package:vlr/views/screens/attendance/team_attendance_history/team_attendaance_history_screen/widget/appbar_and_searchbar.dart';
import 'package:vlr/views/screens/branches/create_branch_screen.dart';

class BranchesScreen extends StatefulWidget {
  const BranchesScreen({super.key});

  @override
  State<BranchesScreen> createState() => _BranchesScreenState();
}

class _BranchesScreenState extends State<BranchesScreen> {
  Timer? _debounce;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<BrachesController>().getBranchesList();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      builder: (authController) {
        return Scaffold(
          backgroundColor: white,

          floatingActionButton:
          authController.hasPermission("branch_create")
              ? FloatingActionButton(
            onPressed: () {
              Get.find<BrachesController>().clearControllers();

              navigate(
                context: context,
                page: const CreateBranchScreen(),
              );
            },
            backgroundColor: primaryColor,
            child: Icon(
              Icons.add,
              color: white,
            ),
          )
              : null,

          body: GetBuilder<BrachesController>(
            builder: (branchController) {
              return Column(
                children: [
                  /// App Bar + Search
                  AppBarAndSearchBar(
                    title: "Branch Management",
                    onChanged: (value) {
                      _debounce?.cancel();

                      _debounce = Timer(
                        const Duration(milliseconds: 500),
                            () {
                          branchController.getBranchesList(
                            search: value.trim(),
                          );
                        },
                      );
                    },
                  ),

                  /// Branch List
                  Expanded(
                    child: branchController.isLoading
                        ? ListView.separated(
                      padding: AppConstants.screenPadding,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return const CustomShimmer(
                          isLoading: true,
                          child: SizedBox(
                            height: 140,
                            width: double.infinity,
                          ),
                        );
                      },
                      separatorBuilder: (_, __) =>
                          sizedBoxHeight(height: 16.h),
                    )
                        : branchController.branchList.isEmpty
                        ? Center(
                      child: CustomText(
                        "No branches found",
                        style: Helper(context)
                            .textTheme
                            .titleMedium,
                      ),
                    )
                        : ListView.separated(
                      padding: AppConstants.screenPadding,
                      itemCount:
                      branchController.branchList.length,
                      separatorBuilder: (_, __) =>
                          sizedBoxHeight(height: 16.h),
                      itemBuilder: (context, index) {
                        final branch =
                        branchController.branchList[index];

                        return Container(
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                            color: white,
                            borderRadius:
                            BorderRadius.circular(20.r),
                            border: Border.all(
                              color: blueLight3,
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              /// Branch Details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    /// Branch Name
                                    CustomText(
                                      branch.name ?? "",
                                      style: Helper(context)
                                          .textTheme
                                          .titleMedium,
                                    ),

                                    sizedBoxHeight(
                                      height: 4.h,
                                    ),

                                    /// Address
                                    CustomText(
                                      branch.address ?? "",
                                      style: Helper(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                        color: grey,
                                      ),
                                      maxLines: 2,
                                    ),

                                    sizedBoxHeight(
                                      height: 6.h,
                                    ),

                                    /// Status
                                    CustomText(
                                      "Status: ${capitalize(branch.status ?? "")}",
                                      style: Helper(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                        color: branch.status ==
                                            'active'
                                            ? green2
                                            : red1,
                                        fontWeight:
                                        FontWeight.bold,
                                      ),
                                    ),

                                    sizedBoxHeight(
                                      height: 6.h,
                                    ),

                                    /// Latitude and Longitude
                                    CustomText(
                                      "Location: ${branch.lat ?? ""}, ${branch.lng ?? ""}",
                                      style: Helper(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                        color: grey,
                                      ),
                                    ),

                                    sizedBoxHeight(
                                      height: 4.h,
                                    ),

                                    /// Radius
                                    CustomText(
                                      "Radius: ${branch.radius ?? ""}",
                                      style: Helper(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                        color: grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              /// Edit Button
                              if (authController.hasPermission(
                                "branch_update",
                              ))
                                IconButton(
                                  onPressed: () {
                                    branchController
                                        .setEditData(branch);

                                    navigate(
                                      context: context,
                                      page: CreateBranchScreen(
                                        isEdit: true,
                                        branchId: branch.id,
                                      ),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.edit,
                                    color: primaryColor,
                                  ),
                                ),

                              /// Delete Button
                              if (authController.hasPermission(
                                "branch_delete",
                              ))
                                IconButton(
                                  onPressed: branch.id == null
                                      ? null
                                      : () {
                                    _showDeleteDialog(
                                      context,
                                      branch.id!,
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: red1,
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  void _showDeleteDialog(
      BuildContext context,
      int id,
      ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Branch"),
          content: const Text(
            "Are you sure you want to delete this branch?",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "Cancel",
              ),
            ),

            TextButton(
              onPressed: () {
                Get.find<BrachesController>()
                    .deleteBranch(id)
                    .then((value) {
                  showToast(
                    message: value.message,
                    typeCheck: value.isSuccess,
                  );

                  Navigator.pop(context);
                });
              },
              child: const Text(
                "Delete",
                style: TextStyle(
                  color: red1,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

