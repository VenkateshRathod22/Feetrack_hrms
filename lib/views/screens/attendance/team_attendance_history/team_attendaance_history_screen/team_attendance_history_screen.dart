import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/attendance_controller.dart';
import 'package:vlr/data/models/employee_model.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/views/base/shimmer.dart';
import 'package:vlr/views/screens/attendance/team_attendance_history/team_attendaance_history_screen/widget/appbar_and_searchbar.dart';
import 'package:vlr/views/screens/attendance/team_attendance_history/team_attendaance_history_screen/widget/employee_widget.dart';

class TeamAttendanceHistoryScreen extends StatefulWidget {
  const TeamAttendanceHistoryScreen({super.key});

  @override
  State<TeamAttendanceHistoryScreen> createState() =>
      _TeamAttendanceHistoryScreenState();
}

class _TeamAttendanceHistoryScreenState
    extends State<TeamAttendanceHistoryScreen> {
  late final ScrollController _scrollController;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<AttendanceController>().fetchTeamEmployeesListPagination();
    });

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final controller = Get.find<AttendanceController>();

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (!controller.employeesModelState.isMoreLoading &&
          controller.employeesModelState.canLoadMore) {
        controller.fetchTeamEmployeesListPagination(loadMore: true);
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AppBarAndSearchBar(
            title: "Team Attendance History",
            onChanged: (value) {
              _debounce?.cancel();

              _debounce = Timer(
                const Duration(milliseconds: 500),
                () {
                  final controller = Get.find<AttendanceController>();

                  controller.searchBarController.text = value.trim();

                  controller.fetchTeamEmployeesListPagination(
                    refresh: true,
                  );
                },
              );
            },
          ),
          Expanded(
            child: Padding(
              padding: AppConstants.screenPadding,
              child: GetBuilder<AttendanceController>(
                builder: (controller) {
                  // Uses the corrected non-conflicting getter
                  if (controller.isLoading &&
                      controller.employeesModelList.isEmpty) {
                    return ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemCount: 8,
                      separatorBuilder: (_, __) => sizedBoxHeight(height: 16.h),
                      itemBuilder: (_, __) {
                        return CustomShimmer(
                          isLoading: true,
                          child: EmployeeWidget(
                            employeesModel: EmployeesModel(),
                            isLoading: true,
                          ),
                        );
                      },
                    );
                  }

                  // Optional Empty State
                  if (controller.employeesModelList.isEmpty) {
                    return const Center(
                      child: Text("No records found"),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      await controller.fetchTeamEmployeesListPagination(
                        refresh: true,
                      );
                    },
                    child: ListView.separated(
                      controller: _scrollController,
                      padding: EdgeInsets.zero,
                      itemCount: controller.employeesModelList.length +
                          (controller.employeesModelState.isMoreLoading
                              ? 1
                              : 0),
                      separatorBuilder: (_, __) => sizedBoxHeight(height: 16.h),
                      itemBuilder: (context, index) {
                        if (index == controller.employeesModelList.length) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 20.h),
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        // Uses isInitialLoading to safely select model mock or real data
                        final model = controller.isLoading
                            ? EmployeesModel()
                            : controller.employeesModelList[index];

                        return EmployeeWidget(
                          employeesModel: model,
                          isLoading: controller.isLoading,
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
