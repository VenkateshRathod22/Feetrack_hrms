import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/role_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/base/shimmer.dart';
import 'package:vlr/views/screens/attendance/team_attendance_history/team_attendaance_history_screen/widget/appbar_and_searchbar.dart';
import 'package:vlr/views/screens/role/create_role_screen.dart';
import 'package:vlr/views/screens/role/widget/role_widget.dart';

class RoleScreen extends StatefulWidget {
  const RoleScreen({super.key});

  @override
  State<RoleScreen> createState() => _RoleScreenState();
}

class _RoleScreenState extends State<RoleScreen> {
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<RoleController>().getRoles();
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
          Get.find<RoleController>().clearControllers();
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => const CreateRoleScreen(),
          );
        },
        backgroundColor: primaryColor,
        child: Icon(Icons.add, color: white),
      ),
      body: GetBuilder<RoleController>(builder: (roleController) {
        return Column(
          children: [
            AppBarAndSearchBar(
              title: "Role Management",
              onChanged: (value) {
                _debounce?.cancel();
                _debounce = Timer(const Duration(milliseconds: 500), () {
                  roleController.getRoles(search: value.trim());
                });
              },
            ),
            sizedBoxHeight(height: 16.h),
            Expanded(
              child: roleController.isLoading
                  ? ListView.separated(
                      padding: AppConstants.screenPadding,
                      itemBuilder: (context, index) => const CustomShimmer(
                        isLoading: true,
                        child: SizedBox(height: 100, width: double.infinity),
                      ),
                      separatorBuilder: (_, __) => sizedBoxHeight(height: 16.h),
                      itemCount: 5,
                    )
                  : roleController.roleList.isEmpty
                      ? Center(
                          child: CustomText(
                            "No roles found",
                            style: Helper(context).textTheme.titleMedium,
                          ),
                        )
                      : ListView.separated(
                          padding: AppConstants.screenPadding,
                          itemBuilder: (context, index) => RoleWidget(
                            role: roleController.roleList[index],
                          ),
                          separatorBuilder: (_, __) => sizedBoxHeight(height: 16.h),
                          itemCount: roleController.roleList.length,
                        ),
            ),
          ],
        );
      }),
    );
  }
}
