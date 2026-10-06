import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/salary_controller.dart';
import 'package:vlr/data/models/employee_salary_list_model.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/services/permission_helper.dart';
import 'package:vlr/views/base/shimmer.dart';
import 'package:vlr/views/screens/salary_management/employee_salary_structure.dart';
import 'package:vlr/views/screens/salary_management/update_salary_stucture_screen.dart';
import 'package:vlr/views/widget/text_box/app_text_box.dart';

class SalaryScreen extends StatefulWidget {
  const SalaryScreen({super.key});

  @override
  State<SalaryScreen> createState() => _SalaryScreenState();
}

class _SalaryScreenState extends State<SalaryScreen> {
  Timer? _debounce;

  final TextEditingController _searchController =
  TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchSalaries();
    });
  }

  void _fetchSalaries() {
    final salaryController = Get.find<SalaryController>();

    salaryController.getSalaryStructuresList(
      search: _searchController.text.trim(),
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: backgroundLight,
      body: GetBuilder<SalaryController>(
        builder: (salaryController) {
          return Column(
            children: [
              _buildHeader(
                context,
                salaryController,
              ),

              Expanded(
                child: salaryController.isLoading
                    ? _buildShimmerList()
                    : salaryController
                    .salaryStructuresList
                    .isEmpty
                    ? _buildEmptyState(context)
                    : _buildSalaryList(
                  salaryController,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ===========================================================================
  // HEADER
  // ===========================================================================

  Widget _buildHeader(
      BuildContext context,
      SalaryController salaryController,
      ) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 10.h,
        bottom: 20.h,
      ),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30.r),
          bottomRight: Radius.circular(30.r),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20.w,
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: white,
                    size: 20.sp,
                  ),
                ),

                Expanded(
                  child: CustomText(
                    "Salary Management",
                    style: Helper(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(
                      color: white,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          sizedBoxHeight(height: 16),

          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20.w,
            ),
            child: AppTextFieldWithHeading(
              controller: _searchController,
              bgColor: white,
              hindText:
              "Search employee by name, code...",
              onChanged: (value) {
                _debounce?.cancel();

                _debounce = Timer(
                  const Duration(
                    milliseconds: 500,
                  ),
                      () {
                    _fetchSalaries();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // SALARY LIST
  // ===========================================================================

  Widget _buildSalaryList(
      SalaryController salaryController,
      ) {
    return RefreshIndicator(
      onRefresh: () async {
        _fetchSalaries();
      },
      child: ListView.separated(
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 20.h,
        ),
        itemBuilder: (context, index) {
          final staff =
          salaryController.salaryStructuresList[index];

          return _buildSalaryCard(
            context,
            staff,
            salaryController,
          );
        },
        separatorBuilder: (_, __) {
          return sizedBoxHeight(height: 16.h);
        },
        itemCount:
        salaryController.salaryStructuresList.length,
      ),
    );
  }

  // ===========================================================================
  // SALARY CARD
  // ===========================================================================

  Widget _buildSalaryCard(
      BuildContext context,
      EmployeeSalaryListModel staff,
      SalaryController salaryController,
      ) {
    return Container(
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: Column(
          children: [
            // -----------------------------------------------------------------
            // EMPLOYEE HEADER
            // -----------------------------------------------------------------

            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: greyLight7,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  // Employee Avatar
                  CircleAvatar(
                    radius: 24.r,
                    backgroundColor:
                    primaryColor.withValues(
                      alpha: 0.1,
                    ),
                    child: CustomText(
                      staff.name?.isNotEmpty == true
                          ? staff.name![0].toUpperCase()
                          : "E",
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.sp,
                      ),
                    ),
                  ),

                  sizedBoxWidth(width: 12),

                  // Employee Information
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          staff.name ?? "N/A",
                          maxLines: 1,
                          overflow:
                          TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: blackText1,
                          ),
                        ),

                        sizedBoxHeight(height: 3),

                        CustomText(
                          "${staff.employeeCode ?? "EMP-ID"} • ${staff.department?.name ?? "N/A"}",
                          maxLines: 1,
                          overflow:
                          TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: greyDart2,
                          ),
                        ),
                      ],
                    ),
                  ),

                  sizedBoxWidth(width: 8),

                  // Net Salary
                  Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.end,
                    children: [
                      CustomText(
                        PriceConverter
                            .convertToNumberFormat(
                          staff.netSalary ?? 0,
                        ),
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w800,
                          color: secondaryColor,
                        ),
                      ),

                      CustomText(
                        "Net Salary",
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: greyLight8,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // -----------------------------------------------------------------
            // SALARY DETAILS
            // -----------------------------------------------------------------

            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      _buildMiniStat(
                        context,
                        "Basic",
                        PriceConverter
                            .convertToNumberFormat(
                          staff.basicSalary ?? 0,
                        ),
                        Icons
                            .account_balance_wallet_outlined,
                      ),

                      _buildMiniStat(
                        context,
                        "Allowances",
                        PriceConverter
                            .convertToNumberFormat(
                          staff.totalAllowances ?? 0,
                        ),
                        Icons.add_circle_outline,
                      ),

                      _buildMiniStat(
                        context,
                        "Deductions",
                        PriceConverter
                            .convertToNumberFormat(
                          staff.totalDeductions ?? 0,
                        ),
                        Icons.remove_circle_outline,
                      ),
                    ],
                  ),

                  // Incentive
                  if (staff.incentiveAmount != null &&
                      staff.incentiveAmount! > 0) ...[
                    sizedBoxHeight(height: 12),

                    Container(
                      padding:
                      EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        color: green.withValues(
                          alpha: 0.05,
                        ),
                        borderRadius:
                        BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.stars_rounded,
                            color: green,
                            size: 16.sp,
                          ),

                          sizedBoxWidth(width: 8),

                          Expanded(
                            child: CustomText(
                              staff.incentiveText ??
                                  "Incentives applied",
                              maxLines: 1,
                              overflow:
                              TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: green,
                                fontWeight:
                                FontWeight.w600,
                              ),
                            ),
                          ),

                          sizedBoxWidth(width: 8),

                          CustomText(
                            PriceConverter
                                .convertToNumberFormat(
                              staff.incentiveAmount ?? 0,
                            ),
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: green,
                              fontWeight:
                              FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // -----------------------------------------------------------------
            // VIEW + MANAGE BUTTONS
            // -----------------------------------------------------------------

            Padding(
              padding: EdgeInsets.fromLTRB(
                16.w,
                0,
                16.w,
                16.h,
              ),
              child: Row(
                children: [
                  // ===========================================================
                  // VIEW STRUCTURE
                  // ===========================================================

                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        if (staff.id == null) {
                          return;
                        }

                        // Load salary structure
                        salaryController
                            .getSalaryStructure(
                          staff.id!,
                        );

                        // Open View screen
                        navigate(
                          context: context,
                          page: EmployeeSalaryStructure(
                            staffId: staff.id!,
                            staffName:
                            staff.name ?? "",
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: primaryColor,
                        side: BorderSide(
                          color: primaryColor,
                          width: 1.2,
                        ),
                        padding:
                        EdgeInsets.symmetric(
                          vertical: 13.h,
                        ),
                        elevation: 0,
                        shape:
                        RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(
                            12.r,
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons
                                .visibility_outlined,
                            color: primaryColor,
                            size: 17.sp,
                          ),

                          sizedBoxWidth(width: 6),

                          Flexible(
                            child: CustomText(
                              "View",
                              maxLines: 1,
                              overflow:
                              TextOverflow.ellipsis,
                              style: TextStyle(
                                color: primaryColor,
                                fontWeight:
                                FontWeight.w600,
                                fontSize: 12.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  sizedBoxWidth(width: 10),

                  // ===========================================================
                  // MANAGE STRUCTURE
                  // ===========================================================

                  PermissionWrapper(
                    permission: 'salary_viewany',
                    child: Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (staff.id == null) {
                            return;
                          }

                          // First load the salary structure
                          salaryController
                              .getSalaryStructure(
                            staff.id!,
                          );

                          // Set data for update screen
                          salaryController
                              .setUpdateDataFromListModel(staff);

                          // Open Manage / Update screen
                          navigate(
                            context: context,
                            page:
                            UpdateSalaryStuctureScreen(
                              employeeId: staff.id!,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                          primaryColor,
                          foregroundColor: white,
                          padding:
                          EdgeInsets.symmetric(
                            vertical: 13.h,
                          ),
                          elevation: 0,
                          shape:
                          RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(
                              12.r,
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons
                                  .settings_outlined,
                              color: white,
                              size: 17.sp,
                            ),

                            sizedBoxWidth(width: 6),

                            Flexible(
                              child: CustomText(
                                "Manage",
                                maxLines: 1,
                                overflow:
                                TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: white,
                                  fontWeight:
                                  FontWeight.w600,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // MINI STAT
  // ===========================================================================

  Widget _buildMiniStat(
      BuildContext context,
      String label,
      String value,
      IconData icon,
      ) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 12.sp,
              color: greyLight5,
            ),

            sizedBoxWidth(width: 4),

            CustomText(
              label,
              style: TextStyle(
                fontSize: 10.sp,
                color: greyLight8,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),

        sizedBoxHeight(height: 4),

        CustomText(
          value,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w700,
            color: blackText2,
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // SHIMMER
  // ===========================================================================

  Widget _buildShimmerList() {
    return ListView.separated(
      padding: EdgeInsets.all(16.w),
      itemBuilder: (context, index) {
        return CustomShimmer(
          isLoading: true,
          child: Container(
            height: 210.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: white,
              borderRadius:
              BorderRadius.circular(20.r),
            ),
          ),
        );
      },
      separatorBuilder: (_, __) {
        return sizedBoxHeight(height: 16.h);
      },
      itemCount: 5,
    );
  }

  // ===========================================================================
  // EMPTY STATE
  // ===========================================================================

  Widget _buildEmptyState(
      BuildContext context,
      ) {
    return Center(
      child: Column(
        mainAxisAlignment:
        MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_off_outlined,
            size: 64.sp,
            color: greyLight2,
          ),

          sizedBoxHeight(height: 16),

          CustomText(
            "No staff found",
            style: Helper(context)
                .textTheme
                .titleMedium
                ?.copyWith(
              color: greyLight8,
            ),
          ),
        ],
      ),
    );
  }
}
