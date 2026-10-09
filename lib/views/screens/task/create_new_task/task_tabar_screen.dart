import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/auth_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/screens/task/create_new_task/create_new_task_screen.dart';
import 'package:vlr/views/screens/task/create_new_task/task_screen.dart';

class TaskTabarScreen extends StatelessWidget {
  const TaskTabarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (authController) {
      final bool canViewTask = authController.hasPermission("task_viewown") ||
          authController.hasPermission("task_viewany") ||
          authController.hasPermission("task_viewteam");
      final bool canCreateTask = authController.hasPermission("task_create");

      List<Widget> tabs = [];
      List<Widget> tabViews = [];

      if (canViewTask) {
        tabs.add(const Tab(text: "Tasks"));
        tabViews.add(const TaskScreen(isTab: true));
      }

      if (canCreateTask) {
        tabs.add(const Tab(text: "New Task"));
        tabViews.add(const CreateNewTaskScreen(isTab: true));
      }

      if (tabs.isEmpty) {
        return Scaffold(
          appBar: AppBar(title: Text("Task Management")),
          body: const Center(child: Text("You don't have permission to view tasks")),
        );
      }

      return DefaultTabController(
        length: tabs.length,
        child: Scaffold(
          backgroundColor: backgroundLight,
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            backgroundColor: white,
            surfaceTintColor: Colors.transparent,
            title: CustomText(
              "Task Management",
              style: Helper(context).textTheme.titleMedium?.copyWith(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(50.h),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: greyLight4.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: TabBar(
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  indicator: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(10.r),
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  labelColor: white,
                  unselectedLabelColor: greyDart,
                  labelStyle: Helper(context).textTheme.titleSmall?.copyWith(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                  unselectedLabelStyle: Helper(context).textTheme.titleSmall?.copyWith(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                  tabs: tabs,
                ),
              ),
            ),
          ),
          body: TabBarView(
            children: tabViews,
          ),
        ),
      );
    });
  }
}
